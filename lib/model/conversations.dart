import 'package:cloud_firestore/cloud_firestore.dart';

class Conversation {
    late String id;
    late List<String>? users;
    late List<dynamic>? messages;

    Conversation.empty() {
        id = "";
        users = [];
        messages = [];
    }

    Conversation(DocumentSnapshot snapshot) {
        id = snapshot.id;
        Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;

        users = map["users"]?.cast<String>();
        messages = (map["messages"] as List<dynamic>?);
    }

    static getConversation(String id) {
        return FirebaseFirestore.instance
            .collection("conversations")
            .doc(id)
            .get()
            .then((value) => Conversation(value));
    }

    getConversations() {
        return FirebaseFirestore.instance
            .collection("conversations")
            .orderBy("timestamp", descending: true)
            .get()
            .then((value) => value.docs.map((e) => Conversation(e)).toList());
    }

    sendMessage(message, sender) {
        return FirebaseFirestore.instance
            .collection("conversations")
            .doc(id)
            .update({
        "messages": FieldValue.arrayUnion([
            {
            "message": message,
            "sender": sender,
            "time": DateTime.now().toString()
            }
        ])
        });
    }
}