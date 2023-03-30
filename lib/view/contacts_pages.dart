import 'package:flutter/material.dart';
import 'package:whatsapp_like/controller/firebase_manager.dart';
import 'package:whatsapp_like/model/conversations.dart';
import 'package:whatsapp_like/model/utilisateur.dart';
import 'package:whatsapp_like/controller/global.dart';
import 'package:whatsapp_like/view/conversation_page.dart';

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
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          addFriend(),
          const SizedBox(height: 16),
          const Text("DÃ©marrer une nouvelle conversation"),
          friendsList(),
          const SizedBox(height: 16),
          const Text("Mes conversations"),
          SizedBox(
            height: 600,
            child: conversationsList(),
          )
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

  final Future<List<Conversation>> _calculation2 = Future.wait(
      myUser.conversations?.map((id) => Conversation.getConversation(id)) ??
          []);

  Widget conversationsList() {
    return FutureBuilder(
        future: _calculation2,
        builder: (context, AsyncSnapshot snapshot) {
            print(snapshot.data);
          if (snapshot.hasData && snapshot.data.isEmpty) {
            return Text("Vous n'avez pas encore de conversations active");
          } else if (snapshot.hasData) {
            return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    for (dynamic index = 0;
                        index < myUser.conversations?.length ?? 0;
                        index++)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FutureBuilder(
                                future: FirebaseManager().getUser(
                                    snapshot.data![index].users[0] == myUser.uid
                                        ? snapshot.data![index].users[1]
                                        : snapshot.data![index].users[0]),
                                builder: (context,
                                    AsyncSnapshot<Utilisateur?> userSnapshot) {
                                  if (userSnapshot.hasData) {
                                    return Text(
                                        userSnapshot.data!.firstname ?? '');
                                  } else {
                                    return const CircularProgressIndicator();
                                  }
                                }),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ConversationPage(
                                            myUser.uid,
                                            snapshot.data![index].users[0] ==
                                                    myUser.uid
                                                ? snapshot.data![index].users[1]
                                                : snapshot
                                                    .data![index].users[0],
                                            myUser.conversations![index])));
                              },
                              child: const Text('Go to Conversation'),
                            ),
                          ],
                        ),
                      ),
                  ],
                ));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  final Future<List<Utilisateur>> _calculation = Future.wait(
      myUser.friends?.map((id) => FirebaseManager().getUser(id)) ?? []);

  Widget friendsList() {
    return FutureBuilder(
      future: _calculation,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData && snapshot.data.isEmpty) {
          return Text("Vous n'avez pas encore d'amis");
        } else if (snapshot.hasData) {
          List<Utilisateur> userList = snapshot.data!;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (dynamic index = 0;
                    index < myUser.friends?.length ?? 0;
                    index++)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Text(userList
                                .firstWhere((element) =>
                                    element.uid == myUser.friends![index])
                                .firstname ??
                            ""),
                        ElevatedButton(
                          onPressed: () {
                            FirebaseManager().createConversation(
                                myUser.uid, myUser.friends![index]);
                          },
                          child: const Text('+'),
                          style: ButtonStyle(
                            minimumSize:
                                MaterialStateProperty.all<Size>(Size(24, 24)),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}