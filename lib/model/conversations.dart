import 'package:cloud_firestore/cloud_firestore.dart';

class Utilisateur {
  late String uid;
  late String email;
  late List<String>? friends;
  late List<String>? conversations;

  DateTime? birthday;

  String? pseudo;
  String? lastname;
  String? firstname;
  String? phonenumber;
  String? avatar;

  Utilisateur.empty() {
    uid = "";
    email = "";
    friends = [];
    conversations = [];
  }

  Utilisateur(DocumentSnapshot snapshot) {
    uid = snapshot.id;
    Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;

    Timestamp? timestamp = map["birthday"];
    birthday = timestamp?.toDate();

    pseudo = map["pseudo"];
    email = map["email"];
    lastname = map["lastname"];
    firstname = map["firstname"];
    avatar = map["avatar"];
    phonenumber = map["phonenumber"];
    conversations = map["conversations"];
    friends = map["friends"];
  }

  Future<void> addFriend(String uid) async {
    if (friends != null && friends?.indexOf(uid) != -1) {
      throw Future.error("Already a friend !");
    }
    friends ??= [];
    friends?.add(uid);
    await FirebaseFirestore.instance
        .collection("users")
        .doc(this.uid)
        .update({"friends": friends});
  }
}
