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
                leadingWidth: 90,
                leading: inkWellWidget(),
                title: textWidget(),
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

    Widget inkWellWidget() => InkWell(
        onTap: () => Navigator.pop(context),
        child: Row(
            children: [
                const Padding(
                    padding: EdgeInsets.only(left: 8), 
                    child: Icon(Icons.arrow_back, size: 24)
                ),
                FutureBuilder<Utilisateur>(
                    future: friend,
                    builder: (context, snapshot) {
                        if (snapshot.hasData) {
                            final friend = snapshot.data!;

                            return Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: CircleAvatar(
                                    radius: 20,
                                    backgroundImage: friend.avatar != null
                                        ? NetworkImage(friend.avatar ?? "") 
                                        : const NetworkImage("https://firebasestorage.googleapis.com/v0/b/whatsapp-like-113a1.appspot.com/o/avatars%2Favatar.png?alt=media&token=c58ad181-b9b8-460a-b310-985f198e4e79")
                                )
                            );
                        } else if (snapshot.hasError) {
                            return Text('Error loading friend data: ${snapshot.error}');
                        } else {
                            return const Icon(Icons.account_circle);
                        }
                    },
                ),
            ]
        )
    );

    Widget textWidget() => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            FutureBuilder<Utilisateur>(
                future: friend,
                builder: (context, snapshot) {
                    if (snapshot.hasData) {
                        final friend = snapshot.data!;

                        return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Text(
                                    "${friend.firstname} ${friend.lastname}",
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(fontSize: 24)
                                ),
                                Text(
                                    friend.phonenumber ?? "",
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(fontSize: 14)
                                ),
                            ],
                        );
                    } else if (snapshot.hasError) {
                        return Text('Error loading friend data: ${snapshot.error}');
                    } else {
                        return const CircularProgressIndicator();
                    }
                },
            ),
        ]
    );
}