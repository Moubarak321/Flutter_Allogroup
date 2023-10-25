import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
// import 'package:intl_phone_field/phone_number.dart';
import '../signInScreen/signInScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import '../confirmation/verification_otp.dart';
import 'package:get/get.dart';
// import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_libphonenumber/flutter_libphonenumber.dart'; =========

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  // final phoneNumber = phoneNumber;

  String? _passwordErrorText;
  bool _isLoading = false;
  // Expresion réguliere pour la gestion de email
  bool isEmailValid(String email) {
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegex.hasMatch(email);
  }

  bool _isPasswordValid(String value) {
    if (value.length < 6) {
      setState(() {
        _passwordErrorText =
            "Le mot de passe doit contenir au moins 6 caractères.";
      });
      return false;
    } else {
      setState(() {
        _passwordErrorText = null;
      });
      return true;
    }
  }

  bool _isPasswordMatch(String value) {
    return value == _passwordController.text;
  }

  bool loading = false;
  String phoneNumber = '';
  String countryCode = '';

  //Vérification mail invalide
  void _showErrorDialog(String errorMessage) {
    Get.defaultDialog(
      title: "Attention !!!",
      titleStyle: TextStyle(fontSize: 20, color: Colors.red), // Style du titre
      content: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0),
        child: Text(
          errorMessage,
          style: TextStyle(
            fontSize: 16, // Taille de police du texte du contenu
            color: Colors.black, // Couleur du texte du contenu
          ),
        ),
      ),
      confirm: ElevatedButton(
        onPressed: () {
          Get.back(); // Ferme le dialogue
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red, // Couleur du bouton "OK"
          side: BorderSide.none,
        ),
        child: Text(
          "OK",
          style: TextStyle(
            fontSize: 16, // Taille de police du texte du bouton
            color: Colors.white, // Couleur du texte du bouton
          ),
        ),
      ),
    );
    setState(() {
      _isLoading = false; // Mettre fin à l'indicateur de chargement
    });
  }
//======================================== test num handle=====================================

  // void _handleSubmit() async {
  //   if (_formKey.currentState!.validate()) {
  //     final email = _emailController.text;
  //     final password = _passwordController.text;
  //     final phoneNumber = _phoneNumberController.text;

  //     try {
  //       final phoneNumberUtil = FormatPhoneResult(
  //           e164: phoneNumber, formattedNumber: phoneNumber); // Créez une instance de PhoneNumberUtil

  //       final phoneNumberFormatted = await phoneNumberUtil.parseAndFormat(
  //         phoneNumber,
  //         'BJ', // Remplacez 'BJ' par le code ISO du pays de l'utilisateur
  //         PhoneNumberType.mobile,
  //       );
  //       // Créez un utilisateur Firebase Auth
  //       UserCredential userCredential =
  //           await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //         email: email,
  //         password: password,
  //       );

  //       // Si l'utilisateur Firebase Auth est créé avec succès, enregistrez les données dans Firebase Firestore
  //       if (userCredential.user != null) {
  //         String userId = userCredential.user!.uid;

  //         // Créez une référence à la collection "users" dans Firestore
  //         CollectionReference usersCollection =
  //             FirebaseFirestore.instance.collection('users');

  //         // Enregistrez l'utilisateur dans Firestore avec l'e-mail, le mot de passe et le numéro de téléphone
  //         await usersCollection.doc(userId).set({
  //           'phoneNumber': phoneNumberFormatted,
  //         });

  //         print("Utilisateur enregistré dans Firebase Firestore avec succès.");
  //         Navigator.of(context).push(MaterialPageRoute(
  //           builder: (context) => SignIn(),
  //         ));
  //       } else {
  //         print("L'utilisateur Firebase Auth n'a pas été créé avec succès.");
  //       }
  //     } catch (e) {
  //       // Gérez les erreurs d'inscription ici
  //       print("Erreur d'inscription : $e");
  //     }
  //   }
  // }

//======================================== old handle=====================================
  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;
      final phoneNumber = _phoneNumberController.text;
      //// Utilisez le contrôleur _phoneNumberController

      try {
        // Créez un utilisateur Firebase Auth
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        print(
            "==================================user created auth==================================");
        // Si l'utilisateur Firebase Auth est créé avec succès, enregistrez les données dans Firebase Firestore
        if (userCredential.user != null) {
          String userId = userCredential.user!.uid;
          print(
              "==================================ajout base et crea firestore==================================");

          // Créez une référence à la collection "users" dans Firestore
          CollectionReference usersCollection =
              FirebaseFirestore.instance.collection('users');

          // Enregistrez l'utilisateur dans Firestore avec l'e-mail, le mot de passe et le numéro de téléphone
          await usersCollection.doc(userId).set({
            // 'email': email,
            'phoneNumber': "229$phoneNumber",
          });

          print("Utilisateur enregistré dans Firebase Firestore avec succès.");
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SignIn(),
          ));
        } else {
          print("L'utilisateur Firebase Auth n'a pas été créé avec succès.");
        }
      } catch (e) {
        // Gérez les erreurs d'inscription ici
        print("Erreur d'inscription : $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(10, 80, 137, 0.8), // Arrière-plan bleu
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Logo et texte en bas
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(),
                        child: Image.asset(
                          "assets/images/Home.png", // Remplacez par le chemin de votre logo
                          height: 150,
                          width: 200,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Avec Allô Group, c'est le sens de l'engagement",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: "  Email",
                      labelStyle: TextStyle(
                          color:
                              Color.fromRGBO(255, 109, 0, 1).withOpacity(0.7)),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromRGBO(255, 109, 0, 1)),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      filled: true,
                      // fillColor: Color.fromRGBO(10, 80, 137, 0.8),
                      fillColor: Colors.white,

                      prefixIcon: Container(
                        width: 50.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 2,
                              spreadRadius: 0,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.email,
                          color: Color.fromRGBO(255, 109, 0, 1),
                          size: 30.0,
                        ),
                      ),
                    ),
                    style: TextStyle(
                      color: Color.fromRGBO(255, 109, 0, 1),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez entrer votre email.";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: "  Mot de passe",
                      labelStyle: TextStyle(
                          color:
                              Color.fromRGBO(255, 109, 0, 1).withOpacity(0.7)),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromRGBO(255, 109, 0, 1)),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      filled: true,
                      // fillColor: Color.fromRGBO(10, 80, 137, 0.8),
                      fillColor: Colors.white,

                      prefixIcon: Container(
                        width: 50.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 2,
                              spreadRadius: 0,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.lock,
                          color: Color.fromRGBO(255, 109, 0, 1),
                          size: 30.0,
                        ),
                      ),
                      errorText: _passwordErrorText,
                    ),
                    style: TextStyle(
                      color: Color.fromRGBO(255, 109, 0, 1),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez entrer votre mot de passe.";
                      }
                      if (value.length < 6) {
                        return "Le mot de passe doit contenir au moins 6 caractères.";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _isPasswordValid(value);
                      // Vérifiez également si les mots de passe correspondent lors de la saisie.
                      if (!_isPasswordMatch(value)) {
                        setState(() {
                          _passwordErrorText =
                              "Les mots de passe ne correspondent pas.";
                        });
                      } else {
                        setState(() {
                          _passwordErrorText = null;
                        });
                      }
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: "  Confirmez le mot de passe",
                      labelStyle: TextStyle(
                          color:
                              Color.fromRGBO(255, 109, 0, 1).withOpacity(0.7)),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromRGBO(255, 109, 0, 1)),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      filled: true,
                      // fillColor: Color.fromRGBO(10, 80, 137, 0.8),
                      fillColor: Colors.white,

                      prefixIcon: Container(
                        width: 50.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 2,
                              spreadRadius: 0,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.lock,
                          color: Color.fromRGBO(255, 109, 0, 1),
                          size: 30.0,
                        ),
                      ),
                      errorText: _passwordErrorText,
                    ),
                    obscureText: true,
                    style: TextStyle(
                      color: Color.fromRGBO(255, 109, 0, 1),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez confirmer votre mot de passe.";
                      }
                      if (value.length < 6) {
                        return "Le mot de passe doit contenir au moins 6 caractères.";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      // Vérifiez si les mots de passe correspondent lors de la saisie.
                      if (!_isPasswordMatch(value)) {
                        setState(() {
                          _passwordErrorText =
                              "Les mots de passe ne correspondent pas.";
                        });
                      } else {
                        setState(() {
                          _passwordErrorText = null;
                        });
                      }
                    },
                  ),
                  SizedBox(height: 20),

                  IntlPhoneField(
                    controller: _phoneNumberController,
                    flagsButtonPadding: const EdgeInsets.all(5),
                    dropdownIconPosition: IconPosition.trailing,
                    initialCountryCode: 'BJ',
                    decoration: const InputDecoration(
                      labelText: 'Numéro de téléphone',
                      labelStyle:
                          TextStyle(color: Color.fromRGBO(250, 153, 78, 1)),
                      filled: true,
                      fillColor: Colors.white,
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                        borderRadius: BorderRadius.all(Radius.circular(35)),
                      ),
                    ),
                    onChanged: (value) {
                      phoneNumber = value.completeNumber;
                    },
                    keyboardType: TextInputType.number,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _isLoading =
                            true; // Démarrez l'indicateur de chargement
                      });
                      _handleSubmit();
                    }, // Affiche le texte du bouton
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                      minimumSize:
                          MaterialStateProperty.all(Size(double.infinity, 48)),
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(
                            // Affiche l'indicateur de chargement
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : Text("Inscription"),
                  ),

                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SignIn(),
                      ));
                    },
                    child: Text(
                      "J'ai déjà un compte ?",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }
}
