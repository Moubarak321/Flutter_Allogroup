import 'package:flutter/material.dart';
import '../signInScreen/signInScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewPasswordPage extends StatefulWidget {
  @override
  _NewPasswordPageState createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _verificationCodeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final verificationCode = _verificationCodeController.text;

      try {
        // Vérifiez le code de vérification ici
        bool isCodeValid = await _checkVerificationCode(verificationCode);

        if (isCodeValid) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => SignIn(), // Page de connexion
          ));
        } else {
          // Le code de vérification n'est pas valide, vous pouvez afficher un message d'erreur ici.
          print("Le code de vérification n'est pas valide.");
        }
      } catch (e) {
        // Une erreur s'est produite lors de la vérification du code, vous pouvez afficher un message d'erreur.
        print("Erreur lors de la vérification du code : $e");
      }
    }
  }

  Future<bool> _checkVerificationCode(String code) async {
    // Mettez ici votre logique pour vérifier le code de vérification.
    // Si le code est correct, retournez true, sinon, retournez false.
    // Vous pouvez utiliser Firebase ou une autre source de données pour effectuer cette vérification.

    // Par exemple, vérifier si l'utilisateur a confirmé son email via Firebase :
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && user.emailVerified) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(10, 80, 137, 0.8), // Arrière-plan bleu
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
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
                      height: 200,
                      width: 200,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Avec Allô Group, c'est le sens de l'engagement",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.orange,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _verificationCodeController,
                decoration: InputDecoration(
                  labelText: "  Code de vérification",
                  labelStyle: TextStyle(color: Color.fromRGBO(255, 109, 0, 1).withOpacity(0.7)),

                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromRGBO(255, 109, 0, 1)),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  filled: true,
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
                style: TextStyle(color: Color.fromRGBO(255, 109, 0, 1)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer le code de vérification.";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              TextFormField(
                cursorColor: Colors.black,

                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "  Nouveau mot de passe",
                  labelStyle: TextStyle(color: Color.fromRGBO(255, 109, 0, 1).withOpacity(0.7)),
                  
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
                  fillColor: Colors.white,
                  // fillColor: Color.fromRGBO(245, 247, 248, 0.8),
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
                  errorStyle: TextStyle(color: Color.fromRGBO(255, 0, 0, 1)),
                ),
                obscureText: true,
                style: TextStyle(
                  color: Color.fromRGBO(255, 109, 0, 1),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer votre mot de passe.";
                  }
                  return null;
                },
                onChanged: _isPasswordValid,
              ),

              SizedBox(height: 16),

              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "  Confirmez votre mot de passe",
                  labelStyle: TextStyle(color: Color.fromRGBO(255, 109, 0, 1).withOpacity(0.7)),
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
                  fillColor: Colors.white,
                  // fillColor: Color.fromRGBO(245, 247, 248, 0.8),
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
                  errorStyle: TextStyle(color: Color.fromRGBO(255, 0, 0, 1)),
                ),
                obscureText: true,
                style: TextStyle(
                  color: Color.fromRGBO(255, 109, 0, 1),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer votre mot de passe.";
                  }
                  return null;
                },
                onChanged: _isPasswordValid,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _handleSubmit,
                child: Text("Validez"),
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
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _verificationCodeController.dispose();
    super.dispose();
  }
}
