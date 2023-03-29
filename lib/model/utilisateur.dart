import 'package:cloud_firestore/cloud_firestore.dart';

class Utilisateur {
    late String uid;
    late String email;

    String? lastname;
    String? firstname;
    String? phonenumber;
    String? avatar;

    Utilisateur.empty(){
        uid = "";
        email = "";
    }

    Utilisateur(DocumentSnapshot snapshot){
        uid = snapshot.id;
        Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;

        email = map["email"];
        lastname = map["lastname"];
        firstname = map["firstname"];
        phonenumber = map["phonenumber"];
        avatar = map["avatar"];
    }
}
