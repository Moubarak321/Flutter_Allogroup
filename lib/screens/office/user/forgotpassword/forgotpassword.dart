import 'package:allogroup/screens/office/user/signInScreen/signInScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import '../newpassword/newpassword.dart';
import 'package:get/get.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      
      try {
        // Envoyer un email de réinitialisation de mot de passe
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        _showSuccesDialog(
            "Veuillez cliquer sur le lien envoyé à votre adresse $email pour changer votre mot de passe");
        

        // Utilisez la navigation pour aller à la page de changement de mot de passe
      } catch (e) {
        _showSuccesDialog(
            "Une erreur s'est produite. Veuillez vérifier l'adresse email et réessayer.");
        
      }
    }
  }

  void _showSuccesDialog(String succesMessage) {
    Get.defaultDialog(
      title: "Super !!!",
      titleStyle: TextStyle(
          fontSize: 20,
          color: Color.fromARGB(255, 65, 238, 137)), // Style du titre
      content: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0),
        child: Text(
          succesMessage,
          style: TextStyle(
            fontSize: 16, // Taille de police du texte du contenu
            color: Colors.black, // Couleur du texte du contenu
          ),
        ),
      ),
      confirm: ElevatedButton(
        onPressed: () {
          setState(() {
            _isLoading = true; // Démarrez l'indicateur de chargement
          });
          Get.back(); // Fermez la boîte de dialogue

          Future.delayed(
            Duration(seconds: 5),
            () {
              // Après 5 secondes, effectuez l'action que vous souhaitez ici
              // Par exemple, naviguez vers une autre page
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SignIn()), // Remplacez par le nom de votre page de changement de mot de passe
              );
            },
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:
              Color.fromARGB(255, 38, 152, 245), // Couleur du bouton "OK"
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
                    // onPressed: _handleSubmit,
                    onPressed: () async {
                      setState(() {
                        _isLoading =
                            true; // Démarrez l'indicateur de chargement
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
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : Text("Changez votre mot de passe"),
                    // child: Text("Changez votre mot de passe"),
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
    super.dispose();
  }
}
