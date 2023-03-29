import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:whatsapp_like/model/utilisateur.dart';

class FirebaseManager {
    final auth = FirebaseAuth.instance;
    final storage = FirebaseStorage.instance;
    final cloudMessages = FirebaseFirestore.instance.collection("messages");
    final cloudUsers = FirebaseFirestore.instance.collection("users");

    // Create an user
    Future<Utilisateur> subscribe(
        String firstname,
        String lastname,
        String email,
        String password
    ) async {
        UserCredential authResult = await auth.createUserWithEmailAndPassword(
            email: email,
            password: password
        );
        String? uid = authResult.user?.uid;

        if (uid == null) {
            return Future.error(("No uid returned !"));
        } else {
            Map<String,dynamic> map = { 
                "firstname": firstname,
                "lastname": lastname,
                "email": email
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
  
    // Connect an user
    Future<Utilisateur> connect(String email, String password) async {
        UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
        String? uid = userCredential.user?.uid;

        return uid == null 
            ? Future.error(("Connection problem !"))
            : getUser(uid);
    }

    // Update an user
    updateUser(String uid, Map<String, dynamic> map){
        cloudUsers.doc(uid).update(map);
    }
}