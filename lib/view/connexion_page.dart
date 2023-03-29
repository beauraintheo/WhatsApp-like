import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp_like/controller/firebase_manager.dart';
import 'package:whatsapp_like/controller/global.dart';
import 'package:whatsapp_like/view/contacts_pages.dart';

class LoginPage extends StatefulWidget {
    const LoginPage({ Key? key }) : super(key: key);

    @override
    State<LoginPage> createState() => _LoginPageState();
}

// TODO : Add verification email
// TODO : Check if mdp is good
// TODO ? Add popin error
// TODO : Add lottie animation
class _LoginPageState extends State<LoginPage> {
    List<bool> selection = [ true, false ];

    TextEditingController firstname = TextEditingController();
    TextEditingController lastname = TextEditingController();
    TextEditingController phonenumber = TextEditingController();
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();
    
    XFile? image;
    late bool passwordVisible;

    final ImagePicker picker = ImagePicker();

    @override
    void initState() {
        passwordVisible = false;
        image = null;
        super.initState();
    }

    @override
    void dispose() {
        firstname.dispose();
        lastname.dispose();
        phonenumber.dispose();
        email.dispose();
        password.dispose();
        super.dispose();
    }

    // Clear inputs while switching page
    void clearInputs() {
        firstname.clear();
        lastname.clear();
        phonenumber.clear();
        image = null;
        email.clear();
        password.clear();
    }

    // Popin to upload avatar
    void popinUploadAvatar() {
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                title: const Text("Choix du média pour upload l'avatar: "),
                content: SizedBox(
                    height: MediaQuery.of(context).size.height / 8,
                    child: Column(
                        children: [
                            ElevatedButton(
                                onPressed: () {
                                    Navigator.pop(context);
                                    getImage(ImageSource.gallery);
                                },
                                child: Row(
                                    children: const [
                                        Icon(Icons.image),
                                        Padding(
                                            padding: EdgeInsets.only(left: 16.0),
                                            child: Text("Depuis la galerie"),
                                        ),
                                    ],
                                ),
                            ),
                            popinButton(ImageSource.gallery, "Depuis la caméra"),
                        ],
                    ),
                )
            )
        );
    }

    // Get image from gallery
    Future getImage(ImageSource media) async {
        var img = await picker.pickImage(source: media);
        setState(() => image = img);
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

    // Page container
    Widget bodyPage() {
        return Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    appLogo(),
                    buttons(),
                    sizedBoxWidget(36),
                    selection[1] ? additionalsElements() : const SizedBox.shrink(),
                    textFieldWidget(email, false, false, const Icon(Icons.email), "Entrez votre email", "Email"),
                    sizedBoxWidget(16),
                    textFieldWidget(password, true, true, const Icon(Icons.lock), "Entrez votre mot de passe", "Mot de passe"),
                    sizedBoxWidget(24),
                    button()
                ],
            ),
        );
    }

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

    // Spacing widget to separate elements
    Widget sizedBoxWidget(double height) => SizedBox(height: height);

    // ToggleButtons widget
    Widget buttons() => ToggleButtons(
        onPressed: (value) => {
            FocusScope.of(context).unfocus(),
            clearInputs(),
            setState(() {
                selection[0] = value == 0;
                selection[1] = value == 1;
            })
        },
        borderRadius: BorderRadius.circular(8),
        isSelected: selection,
        children: [
            paddingButtonWidget(16, 8, "Connexion"),
            paddingButtonWidget(16, 8, "Inscription")
        ]
    );

    // Text widget for toggleButtons
    Widget paddingButtonWidget(double paddingX, double paddingY, String text) => Padding(
        padding: EdgeInsets.symmetric(horizontal: paddingX, vertical: paddingY),
        child: Text(text),
    );

    // Additional elements for subscription
    Widget additionalsElements() => Column(
        children: [
            textFieldWidget(firstname, false, false, const Icon(Icons.person), "Entrez votre prénom", "Prénom"),
            sizedBoxWidget(16),
            textFieldWidget(lastname, false, false, const Icon(Icons.person), "Entrez votre nom", "Nom"),
            sizedBoxWidget(16),
            textFieldWidget(lastname, false, false, const Icon(Icons.person), "Entrez votre numéro de téléphone", "Numéro de téléphone"),
            sizedBoxWidget(16),
            image != null ? avatarWidget(image) : SizedBox(width: 350, child: uploadAvatar("Choisir un avatar")),
            sizedBoxWidget(16),
        ],
    );

    // TextField widget
    Widget textFieldWidget(
        TextEditingController controller, 
        bool isObscure,
        bool isPassword,
        Icon icon,
        String placeholder,
        String inputLabel
    ) => SizedBox(
        width: 350,
        child: TextField(
            controller: controller,
            obscureText: isObscure && !passwordVisible,
            decoration: InputDecoration(
                prefixIcon: icon,
                labelText: inputLabel,
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

    // Avatar widget
    Widget avatarWidget(image) => Align(
        alignment: Alignment.center,
        child: SizedBox(
            width: 350,
            child: Row(
                children: [
                    Padding(
                        padding: const EdgeInsets.only(right: 24),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(32),
                            child: Image.file(
                                File(image!.path),
                                fit: BoxFit.cover,
                                width: 60,
                                height: 60,
                            )
                        )
                    ),
                    SizedBox(width: 266, child: uploadAvatar("Changer d'avatar"))
                ],
            )
        )
    );

    // Avatar upload widget
    Widget uploadAvatar(String label) => ElevatedButton(
        onPressed: popinUploadAvatar,
        child: Text(label)
    );

    // ElevatedButton widget
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
                .subscribe(firstname.text, lastname.text, email.text, password.text, phonenumber.text)
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

    Widget popinButton(imageSource, label) => ElevatedButton(
        onPressed: () {
            Navigator.pop(context);
            getImage(imageSource);
        },
        child: Row(
            children: [
                const Icon(Icons.image),
                Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(label),
                ),
            ],
        ),
    );
}