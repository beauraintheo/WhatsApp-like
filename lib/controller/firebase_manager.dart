import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:whatsapp_like/model/utilisateur.dart';

class FirebaseManager {
  final auth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;
  final cloudMessages = FirebaseFirestore.instance.collection("messages");
  final cloudUsers = FirebaseFirestore.instance.collection("users");
  final cloudConversations =
      FirebaseFirestore.instance.collection("conversations");

  // Create an user
  Future<Utilisateur> subscribe(String firstname, String lastname, String email,
      String password, String phonenumber) async {
    UserCredential authResult = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    String? uid = authResult.user?.uid;

    if (uid == null) {
      return Future.error(("No uid returned !"));
    } else {
      Map<String, dynamic> map = {
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "phonenumber": phonenumber,
      };

      addUser(uid, map);
      return getUser(uid);
    }
  }

  // Add an user
  addUser(String uid, Map<String, dynamic> map) {
    cloudUsers.doc(uid).set(map);
  }

  // Get an user by uid
  Future<Utilisateur> getUser(String uid) async {
    DocumentSnapshot snapshot = await cloudUsers.doc(uid).get();

    return Utilisateur(snapshot);
  }

  Future<Utilisateur> getUserByEmail(String email) async {
    QuerySnapshot snapshot =
        await cloudUsers.where("email", isEqualTo: email).get();
    List<QueryDocumentSnapshot> docs = snapshot.docs;

    if (docs.isEmpty) {
      return Future.error(("No user found !"));
    } else {
      return Utilisateur(docs[0]);
    }
  }

  // Connect an user
  Future<Utilisateur> connect(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      String? uid = userCredential.user?.uid;

      return uid == null
          ? Future.error(("Connection problem !"))
          : getUser(uid);
    } catch (e) {
      print(e.toString());
      return Future.error(("Connection problem !"));
    }
  }

  // Create a conversation
  Future<void> createConversation(String uid1, String uid2) async {
    final Map<String, dynamic> map = {
      "users": [uid1, uid2],
      "messages": [],
    };

    // Add the conversation to Firestore with an auto-generated ID
    DocumentReference conversationRef = await cloudConversations.add(map);

    // Get the ID of the conversation
    String conversationId = conversationRef.id;

    // Store the conversation ID in each user's document
    await cloudUsers.doc(uid1).update({
      "conversations": FieldValue.arrayUnion([conversationId])
    });
    await cloudUsers.doc(uid2).update({
      "conversations": FieldValue.arrayUnion([conversationId])
    });
  }
}
