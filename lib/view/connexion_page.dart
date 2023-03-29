import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';

import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

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

    // Controllers for each input
    final TextEditingController _firstname = TextEditingController();
    final TextEditingController _lastname = TextEditingController();
    final TextEditingController _phonenumber = TextEditingController();
    final TextEditingController _email = TextEditingController();
    final TextEditingController _password = TextEditingController();

    // Boolean to check if input is dirty for validation
    Map<String, dynamic> formFieldsDirty = {
        "firstname": false,
        "lastname": false,
        "phonenumber": false,
        "email": false,
        "password": false,
    };

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
        _firstname.dispose();
        _lastname.dispose();
        _phonenumber.dispose();
        _email.dispose();
        _password.dispose();
        super.dispose();
    }

    // Clear inputs while switching page
    void clearInputs() {
        _firstname.clear();
        _lastname.clear();
        _phonenumber.clear();
        image = null;
        _email.clear();
        _password.clear();

        formFieldsDirty = {
            "firstname": false,
            "lastname": false,
            "phonenumber": false,
            "email": false,
            "password": false,
        };
    }

    // Validators for each input
    String? validator(String? value, String key) {
        if (emptyValidator(value!)) return "Veuillez renseigner ce champ";
        if (key == "phonenumber" && phoneNumberValidator(value)) return "Veuillez entrer un numéro de téléphone valide";
        if (key == "email" && emailValidator(value)) return "Veuillez entrer une adresse email valide";
        if (key == "password" && passwordValidator(value)) return "Le mot de passe doit faire au moins 6 caractères";
        
        return null;
    }

    // Popin to upload avatar
    void popinUploadAvatar() {
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                title: const Text("Choisir le média pour votre avatar: "),
                content: SizedBox(
                    height: MediaQuery.of(context).size.height / 9,
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

    // Popin error
    void popinError() {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
                if (defaultTargetPlatform == TargetPlatform.iOS) {
                    return CupertinoAlertDialog(
                        title: const Text("Erreur lors de la connexion !"),
                        content: Lottie.asset("assets/error.json", width: 75, height: 75),
                        actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Ok")
                            )
                        ],
                    );
                } else {
                    return AlertDialog(
                        title: const Text("Erreur lors de la connexion !"),
                        content: Lottie.asset("assets/error.json", width: 75, height: 75),
                        actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Ok")
                            )
                        ],
                    );
                }
            }
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
                    textFieldWidget(
                        _email,
                        false,
                        false,
                        const Icon(Icons.email),
                        "Entrez votre email",
                        "Email",
                        "email"
                    ),
                    sizedBoxWidget(16),
                    textFieldWidget(
                        _password,
                        true,
                        true,
                        const Icon(Icons.lock),
                        "Entrez votre mot de passe",
                        "Mot de passe",
                        "password"
                    ),
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
            textFieldWidget(
                _firstname,
                false,
                false,
                const Icon(Icons.person),
                "Entrez votre prénom",
                "Prénom",
                "firstname"
            ),
            sizedBoxWidget(16),
            textFieldWidget(
                _lastname,
                false,
                false,
                const Icon(Icons.person),
                "Entrez votre nom",
                "Nom",
                "lastname"
            ),
            sizedBoxWidget(16),
            textFieldWidget(
                _phonenumber,
                false,
                false,
                const Icon(Icons.phone),
                "Entrez votre numéro de téléphone",
                "Numéro de téléphone",
                "phonenumber"
            ),
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
        String inputLabel,
        String key
    ) => SizedBox(
        width: 350,
        child: TextField(
            controller: controller,
            obscureText: isObscure && !passwordVisible,
            onChanged: (_) => setState(() => formFieldsDirty[key] = true),
            decoration: InputDecoration(
                prefixIcon: icon,
                labelText: inputLabel,
                errorText: formFieldsDirty[key] && validator(controller.text, key) != null 
                    ? validator(controller.text, key)
                    : null,
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
                .connect(_email.text, _password.text)
                .then((value) {
                    setState(() => myUser = value);
                    Navigator.push(
                        context, 
                        MaterialPageRoute(
                            builder: (context) => const ContactPage()
                        )
                    );
                }).catchError((onError) {
                    popinError();
                })
            : FirebaseManager()
                .subscribe(_firstname.text, _lastname.text, _email.text, _password.text, _phonenumber.text)
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

    // Empty validator
    bool emptyValidator(String value) => value.isEmpty;

    // Password validator
    bool passwordValidator(String value) => value.length < 6;

    // Phonenumber validator
    bool phoneNumberValidator(String value) {
        const pattern = r"^(?:(?:\+|00)33|0)\s*[1-9](?:[\s.-]*\d{2}){4}$";
        final RegExp regex = RegExp(pattern);

        return !regex.hasMatch(value);
    }

    // Email validator
    bool emailValidator(String value) {
        const String emailPattern =
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
            r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}"
            r"[a-zA-Z0-9])?)*$";
        final RegExp regex = RegExp(emailPattern);

        return !regex.hasMatch(value);
    }
}