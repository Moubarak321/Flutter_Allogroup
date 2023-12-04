import 'package:flutter/material.dart';
import '../singnUpScreen/singUpScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../home.dart';
import '../forgotpassword/forgotpassword.dart';
import 'package:get/get.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _passwordErrorText;
  bool _isLoading = false;
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

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;

      try {
        // Authentification de l'utilisateur avec Firebase
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Vérifiez si l'authentification a réussi
        if (userCredential.user != null) {
          // L'authentification a réussi, redirigez l'utilisateur vers la page des services.
          // Par exemple, vous pouvez utiliser Navigator pour naviguer vers la page des services.
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => Home(), // Remplacez par la page des services.
          ));
        }
      } catch (e) {
        // Une erreur s'est produite lors de l'authentification, affichez un message d'erreur.
        _showErrorDialog(
            "Vous avez défini un mauvais email ou un mauvais mot de passe !!! ");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(10, 80, 137, 0.8), // Arrière-plan bleu
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            // child: Expanded(
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
                              
                              ),
                          child: Image.asset(
                            "assets/images/Home.png", // Remplacez par le chemin de votre logo
                            height: 250,
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
                            color: Color.fromRGBO(255, 109, 0, 1).withOpacity(0.7)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              // BorderSide(color: Color.fromRGBO(255, 109, 0, 1)),
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
                            color: Color.fromRGBO(255, 109, 0, 1).withOpacity(0.7)),
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
                      onPressed: () async {
                        setState(() {
                          _isLoading = true; // Démarrez l'indicateur de chargement
                        });
                        _handleSubmit();
                      },
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                        minimumSize: MaterialStateProperty.all(
                          Size(double.infinity, 48),
                        ),
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator(
                              // Affiche l'indicateur de chargement
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : Text("Connexion"),
                    ),
                    SizedBox(height: 20),
                    // Lien "Pas encore de compte, Inscrivez-vous"
                    GestureDetector(
                      onTap: () {
                        // Ajoutez ici la navigation vers la page d'inscription
                        // par exemple :
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SignUp(),
                        ));
                      },
                      child: Text(
                        "Pas encore de compte ? Inscrivez-vous",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Lien "Mot de passe oublié"
                    GestureDetector(
                      onTap: () {
                        // Ajoutez ici la navigation vers la réinitialisation du mot de passe
                        // par exemple :
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ForgotPasswordPage(),
                        ));
                      },
                      child: Text(
                        "Mot de passe oublié ?",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            // ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}


