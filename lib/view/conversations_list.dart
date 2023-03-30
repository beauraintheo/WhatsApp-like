import 'package:flutter/material.dart';
import 'package:whatsapp_like/controller/firebase_manager.dart';
import 'package:whatsapp_like/controller/global.dart';
import 'package:whatsapp_like/view/contacts_pages.dart';

class ConversationsPage extends StatefulWidget {
  const ConversationsPage({Key? key}) : super(key: key);

  @override
  State<ConversationsPage> createState() => _ConversationPage();
}

class _ConversationPage extends State<ConversationsPage> {
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

  Widget TextFieldWidget(TextEditingController controller, bool obscure) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
          border: OutlineInputBorder(), labelText: controller.text),
    );
  }

  Widget addFriend() {
    TextEditingController email = TextEditingController();
    return Center(
        child: Row(
      children: [
        TextFieldWidget(email, false),
        ElevatedButton(
            onPressed: () async {
              print("hello");
              /* Utilisateur? user =
                  await FirebaseManager().getUserByEmail(email.text);
              if (user != null) {
                FirebaseManager().addFriend(user.uid);
              } */
            },
            child: Text("Add friend"))
      ],
    ));
  }
}
