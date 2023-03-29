import 'package:cloud_firestore/cloud_firestore.dart';

class Utilisateur {
  late String uid;
  late String email;

  DateTime? birthday;
  
  String? pseudo;
  String? lastname;
  String? firstname;
  String? avatar;

  Utilisateur.empty(){
    uid = "";
    email = "";
  }

  Utilisateur(DocumentSnapshot snapshot){
    uid = snapshot.id;
    Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;

    Timestamp? timestamp = map["birthday"];
    birthday = timestamp?.toDate();

    pseudo = map["pseudo"];
    email = map["email"];
    lastname = map["lastname"];
    firstname = map["firstname"];
    avatar = map["avatar"];
  }
}
