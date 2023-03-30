import 'dart:io';

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
        String password,
        String phonenumber,
        String? avatar
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
                "email": email,
                "phonenumber": phonenumber
            };

            addUser(uid, map);

            if (avatar != null) {
                String filename = avatar.split("/").last;
                TaskSnapshot snapshot = await storage.ref("avatars/$filename").putFile(File(avatar));
                String url = await snapshot.ref.getDownloadURL();

                updateUser(uid, { "avatar": filename });
            }

            return getUser(uid);
        }
    }

    // Add an user
    addUser(String uid, Map<String, dynamic> map) {
        cloudUsers.doc(uid).set(map);
    }

    // Update an user
    updateUser(String uid, Map<String, dynamic> map){
        cloudUsers.doc(uid).update(map);
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
        UserCredential userCredential =
            await auth.signInWithEmailAndPassword(email: email, password: password);
        String? uid = userCredential.user?.uid;

        return uid == null ? Future.error(("Connection problem !")) : getUser(uid);
      }
}
