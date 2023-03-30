import 'package:flutter/material.dart';
import 'package:whatsapp_like/controller/firebase_manager.dart';
import 'package:whatsapp_like/model/utilisateur.dart';
import 'package:whatsapp_like/controller/global.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  State<ContactPage> createState() => _ConversationPage();
}

class _ConversationPage extends State<ContactPage> {
  TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: bodyPage(),
      ),
    );
  }

  Widget bodyPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          addFriend(),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: friendsList(),
          ),
        ],
      ),
    );
  }

  Widget textFieldWidget(TextEditingController controller, bool obscure) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: const InputDecoration(
          border: OutlineInputBorder(), labelText: "email de l'ami"),
    );
  }

  Widget addFriend() {
    return Column(
      children: [
        textFieldWidget(email, false),
        ElevatedButton(
          onPressed: () async {
            Utilisateur? user =
                await FirebaseManager().getUserByEmail(email.text);

            myUser.addFriend(user.uid);
            user.addFriend(myUser.uid);
          },
          child: const Text("Add friend"),
        ),
      ],
    );
  }

  Widget conversationsList() {
    return ListView.builder(
      itemCount: myUser.conversations?.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(myUser.conversations?[index] ?? ""),
        );
      },
    );
  }

  Widget friendsList() {
    return ListView.builder(
      itemCount: myUser.friends?.length,
      itemBuilder: (context, index) {
        String friendId = myUser.friends![index];
        return ListTile(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(friendId),
              ElevatedButton(
                onPressed: () {
                  FirebaseManager().createConversation(myUser.uid, friendId);
                },
                child: const Text('Create Conversation'),
              ),
            ],
          ),
        );
      },
    );
  }
}
