import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../newpassword/newpassword.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;

      try {
        // Envoyer un email de réinitialisation de mot de passe
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.blue, // Couleur de fond bleue
          content: Text(
            "Un email de réinitialisation de mot de passe a été envoyé à : $email",
            style: TextStyle(color: Colors.white), // Couleur du texte en blanc
          ),
        ));

        // Utilisez la navigation pour aller à la page de changement de mot de passe
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NewPasswordPage()), // Remplacez par le nom de votre page de changement de mot de passe
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red, // Couleur de fond rouge
          content: Text(
            "Une erreur s'est produite. Veuillez vérifier l'adresse email et réessayer.",
            style: TextStyle(color: Colors.white), // Couleur du texte en blanc
          ),
        ));
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    // Récupérer l'utilisateur connecté
      User? user = FirebaseAuth.instance.currentUser;

      // Préremplir l'email si l'utilisateur est connecté
      if (user != null) {
        _emailController.text = user.email ?? "";
      }
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
                  labelStyle: TextStyle(color: Color.fromRGBO(255, 109, 0, 1).withOpacity(0.7)),
                  enabledBorder: OutlineInputBorder(                    
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(50.0),
                    
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromRGBO(255, 109, 0, 1)),
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
                style: TextStyle(color: Color.fromRGBO(255, 109, 0, 1), ), 
              ),
              SizedBox(height: 16),
              Text(
                "Combien font 1 + 1 ?",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "  Résultat",
                  labelStyle: TextStyle(color: Color.fromRGBO(255, 109, 0, 1).withOpacity(0.7)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromRGBO(255, 109, 0, 1)),
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
                      Icons.lock,
                      color: Color.fromRGBO(255, 109, 0, 1),
                      size: 30.0,
                    ),
                  ),
                ),
                obscureText: false,
                style: TextStyle(color: Color.fromRGBO(255, 109, 0, 1)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer le résultat correct.";
                  } else if (value != "2") {
                    // Vérifiez si la réponse est égale à "2".
                    return "La réponse est incorrecte.";
                  }
                  return null;
                },
              ),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _handleSubmit,
                child: Text("Validation"),
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
              ),
            ],
          ),
        ),
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
