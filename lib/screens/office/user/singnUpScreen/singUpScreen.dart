import 'package:flutter/material.dart';

import 'package:intl_phone_field/intl_phone_field.dart';
import '../signInScreen/signInScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../confirmation/verification_otp.dart';

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

  String? _passwordErrorText;

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

// envoi mail
  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;

      try {

        // Créez un utilisateur Firebase Auth
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        print(userCredential);
        
      } catch (e) {

        // Gérez les erreurs d'inscription ici
        print("Erreur d'inscription : $e");
      }
    }
  }

// auth OTP qui fonctionne
  void sendOtpCode() async {
    if (_formKey.currentState!.validate()) {
      final phoneNumber = this.phoneNumber;

      if (phoneNumber.isNotEmpty) {
        _handleSubmit();
        // Vous pouvez vérifier ici si le numéro de téléphone est valide

        // Commencez le processus d'authentification par numéro de téléphone
        try {
          await FirebaseAuth.instance.verifyPhoneNumber(
            phoneNumber: phoneNumber,
            timeout: const Duration(minutes: 2),
            verificationCompleted: (AuthCredential authCredential) async {
              // Ce callback est appelé lorsque Firebase vérifie automatiquement le code.
              // Vous pouvez ignorer cette partie si vous le souhaitez.
            },
            verificationFailed: (FirebaseAuthException e) {
              // Gérez les erreurs de vérification ici
              print("Erreur de vérification : ${e.message}");
            },
            codeSent: (String verificationId, int? resendToken) {
              // Lorsque le code est envoyé avec succès, naviguez vers l'écran de vérification OTP
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => VerificationOtp(
                  verificationId: verificationId,
                  phoneNumber: phoneNumber,
                ),
              ));
            },
            codeAutoRetrievalTimeout: (String verificationId) {
              // Gérez le cas où le code de vérification a expiré ici.
            },
          );
        } catch (e) {
          print("Erreur lors de l'envoi du code de vérification : $e");
        }
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
                        decoration: BoxDecoration(
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: Color.fromRGBO(
                            //         10, 80, 137, 1), // Couleur de l'ombre
                            //     blurRadius: 10, // Rayon du flou de l'ombre
                            //     spreadRadius: 2, // Écart de l'ombre
                            //   ),
                            // ],
                            ),
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
                    onPressed: sendOtpCode,
                    child: Text("Inscription"),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                      minimumSize:
                          MaterialStateProperty.all(Size(double.infinity, 48)),
                    ),
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
    super.dispose();
  }
}
