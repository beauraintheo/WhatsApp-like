import 'package:flutter/material.dart';
import 'package:whatsapp_like/controller/firebase_manager.dart';
import 'package:whatsapp_like/controller/global.dart';
import 'package:whatsapp_like/view/contacts_pages.dart';

class LoginPage extends StatefulWidget {
    const LoginPage({ Key? key }) : super(key: key);

    @override
    State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
    List<bool> selection = [ true, false ];

    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();

    late bool passwordVisible;

    @override
    void initState() {
        passwordVisible = false;
        super.initState();
    }

    @override
    void dispose() {
        email.dispose();
        password.dispose();
        super.dispose();
    }

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
                    appLogo(),
                    buttons(),
                    sizedBoxWidget(36),
                    textFieldWidget(
                        email,
                        false,
                        false,
                        const Icon(Icons.email),
                        "Entrez votre email"
                    ),
                    sizedBoxWidget(16),
                    textFieldWidget(
                        password, 
                        true,
                        true,
                        const Icon(Icons.lock),
                        "Entrez votre mot de passe"
                    ),
                    sizedBoxWidget(24),
                    button()
                ],
            ),
        );
    }

    // Spacing widget to separate elements
    Widget sizedBoxWidget(double height) => SizedBox(height: height);

    // Text widget for toggleButtons
    Widget buttonTextWidget(double paddingX, double paddingY, String text) => Padding(
        padding: EdgeInsets.symmetric(horizontal: paddingX, vertical: paddingY),
        child: Text(text),
    );

    // Application logo widget
    Widget appLogo() => Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            image: const DecorationImage(
                image: AssetImage("assets/danganronpa.png"),
                fit: BoxFit.fill
            )
        )
    );

    // ToggleButtons widget
    Widget buttons() => ToggleButtons(
        onPressed: (value) => setState(() {
            selection[0] = value == 0;
            selection[1] = value == 1;
        }),
        borderRadius: BorderRadius.circular(8),
        isSelected: selection,
        children: [
            buttonTextWidget(16, 8, "Connexion"),
            buttonTextWidget(16, 8, "Inscription")
        ]
    );

    Widget textFieldWidget(
        TextEditingController controller, 
        bool isObscure,
        bool isPassword,
        Icon icon,
        String placeholder
    ) => SizedBox(
        width: 350,
        child: TextField(
            controller: controller,
            obscureText: isObscure && !passwordVisible,
            decoration: InputDecoration(
                prefixIcon: icon,
                hintText: placeholder,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                suffixIcon: isPassword 
                    ? IconButton(
                        icon: Icon(passwordVisible
                            ? Icons.visibility 
                            : Icons.visibility_off
                        ),
                        onPressed: () => setState(() => passwordVisible = !passwordVisible)
                    )
                    : null
            ),
        )
    );

    Widget button() => ElevatedButton(
        onPressed: () => selection[0]
            ? FirebaseManager()
                .connect(email.text, password.text)
                .then((value) {
                    setState(() => myUser = value);
                    Navigator.push(
                        context, 
                        MaterialPageRoute(
                            builder: (context) => const ContactPage()
                        )
                    );
                }).catchError((onError) {
                  // PopError();
                })
            : FirebaseManager()
                .subscribe(email.text, password.text)
                .then((value) {
                    setState(() => myUser = value);
                    Navigator.push(
                        context, 
                        MaterialPageRoute(
                            builder: (context) => const ContactPage()
                        )
                    );
                }).catchError((onError) {
                // PopError();
                }
        ),
        child: Text(selection[0] ? "Connexion" : "Inscription")
    );
}