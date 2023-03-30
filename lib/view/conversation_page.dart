import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:whatsapp_like/controller/firebase_manager.dart';
import 'package:whatsapp_like/model/utilisateur.dart';

class ConversationPage extends StatefulWidget {
    final String myUserId;
    final String friendId;

    const ConversationPage(this.myUserId, this.friendId, { super.key });

    @override
    State<ConversationPage> createState() => _ConversationPage();
}

class _ConversationPage extends State<ConversationPage> {  
    final FirebaseManager firebaseManager = FirebaseManager();

    late final Future<Utilisateur> friend;

    @override
    void initState() {
        friend = firebaseManager.getUser(widget.friendId);
        super.initState();
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.blue,
                elevation: 0,
                leadingWidth: 70,
                // leading: 
                //         ],
                //     ),
                // ),
                title: const Text('Chat'),
                actions: [
                    IconButton(
                        icon: const Icon(Icons.call),
                        onPressed: () {
                        },
                    ),
                    IconButton(
                        icon: const Icon(Icons.videocam),
                        onPressed: () {
                        },
                    ),
                    IconButton(
                        icon: const Icon(Icons.info),
                        onPressed: () {
                        },
                    ),
                ],
            ),
            body: bodyPage(),
            );
    }

    Widget bodyPage() {
        return Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    Text(widget.myUserId),
                    Text(widget.friendId),
                    FutureBuilder<Utilisateur>(
                        future: friend,
                        builder: (context, snapshot) {
                            if (snapshot.hasData) {
                                final friend = snapshot.data!;

                                return Column(
                                    children: [
                                        Text(friend.firstname ?? ""),
                                        Text(friend.email),
                                        Text(friend.avatar ?? "")
                                    ],
                                );
                            } else if (snapshot.hasError) {
                                return Text('Error loading friend data: ${snapshot.error}');
                            } else {
                                return CircularProgressIndicator();
                            }
                        },
        ),
                ],
            ),
        );
    }
}