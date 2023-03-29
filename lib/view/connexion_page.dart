import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_like/controller/firebase_manager.dart';
import 'package:whatsapp_like/controller/global.dart';
import 'package:flutter/foundation.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  List<bool> selection = [true, false];

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

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
          Container(
            width: 300,
            height: 150,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                image: const DecorationImage(
                    image: AssetImage("assets/zelda.png"), 
                    fit: BoxFit.fill
                  )
                ),
          ),
          const SizedBox(height: 16),
          ToggleButtons(
            onPressed: (value) => setState(() {
              selection[0] = value == 0;
              selection[1] = value == 1;
            }),
            isSelected: selection,
            children: const [ Text("Connexion"), Text("Inscription") ]
          ),
          const SizedBox(height: 10),
          TextField(
            controller: email,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.mail),
              hintText: "Entrer votre adresse mail",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24)
              )
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: password,
            obscureText: true,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock),
              hintText: "Entrer votre mot de passe",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24)
              )
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (selection[0]) {
                FirebaseManager()
                    .connect(email.text, password.text)
                    .then((value) {
                  setState(() => myUser = value);

                  // Navigator.push(context, MaterialPageRoute(
                  //   builder: (context) => const DashBoard();
                  // );
                }).catchError((onError) {
                  // PopError();
                });
              } else {
                FirebaseManager()
                  .subscribe(email.text, password.text)
                  .then((value) => setState(() {
                    myUser = value;
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) {
                    //     return const DashBoard();
                    // }));
                  })).catchError((onError) {
                  // PopError();
                });
              }
            },
            child: Text(selection[0] ? "Connexion" : "Inscription")
          )
        ],
      ),
    );
  }
}
