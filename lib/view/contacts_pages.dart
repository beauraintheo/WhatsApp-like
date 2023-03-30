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
        children: [addFriend()],
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
    return Center(
        child: Column(
      children: [
        textFieldWidget(email, false),
        ElevatedButton(
            onPressed: () async {
              Utilisateur? user =
                  await FirebaseManager().getUserByEmail(email.text);

              myUser.addFriend(user.uid);
              user.addFriend(myUser.uid);
            },
            child: const Text("Add friend"))
      ],
    ));
  }

  Widget conversationsList() {
    return ListView.builder(
        itemCount: myUser.friends?.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(myUser.friends?[index] ?? ""),
          );
        });
  }
}
