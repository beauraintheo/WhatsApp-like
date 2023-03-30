import 'package:flutter/material.dart';
import 'package:whatsapp_like/controller/firebase_manager.dart';
import 'package:whatsapp_like/model/conversations.dart';
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
        padding: const EdgeInsets.only(top: 60.0, left: 16, right: 16),
        child: bodyPage(),
      ),
    );
  }

  Widget bodyPage() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          addFriend(),
          const SizedBox(height: 16),
          const Text("démarrer une nouvelle conversation"),
          friendsList(),
          const SizedBox(height: 16),
          conversationsList(),
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
      // shrinkWrap: true,
      itemCount: myUser.conversations?.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(myUser.conversations![index]),
              ElevatedButton(
                onPressed: () async {
                  Conversation c = await Conversation.getConversation(
                      myUser.conversations![index]);
                  await c.sendMessage("coucou", myUser.uid);
                },
                child: const Text('envoyer un message'),
              ),
            ],
          ),
        );
      },
    );
  }

  final Future<List<Utilisateur>> _calculation = Future.wait(
      myUser.friends?.map((id) => FirebaseManager().getUser(id)) ?? []);

  Widget friendsList() {
    return FutureBuilder(
      future: _calculation,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<Utilisateur> userList = snapshot.data!;
          return ListView.builder(
              shrinkWrap: true,
              itemCount: myUser.friends?.length,
              itemBuilder: (context, index) {
                String friendId = myUser.friends![index];
                Utilisateur friend =
                    userList.firstWhere((element) => element.uid == friendId);
                return ListTile(
                  title: Row(
                    children: [
                      Text(friend.firstname ?? ""),
                      ElevatedButton(
                        onPressed: () {
                          FirebaseManager()
                              .createConversation(myUser.uid, friendId);
                        },
                        child: const Text('+'),
                      ),
                    ],
                  ),
                );
              });
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
