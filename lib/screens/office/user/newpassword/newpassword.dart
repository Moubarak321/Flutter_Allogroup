import 'package:flutter/material.dart';
import '../signInScreen/signInScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:pinput/pinput.dart';
import 'package:get/get.dart';

class NewPasswordPage extends StatefulWidget {
  @override
  _NewPasswordPageState createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _verificationCodeController =
      TextEditingController();
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
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  if (_passwordController.text != _confirmPasswordController.text) {
    print("Les mots de passe ne correspondent pas.");
    return;
  }

  try {
    User? user = FirebaseAuth.instance.currentUser;

    // Vérifiez si l'utilisateur a confirmé la réinitialisation du mot de passe
    if (user != null && user.emailVerified) {
      // L'utilisateur a cliqué sur le lien de vérification de l'e-mail
      await user.updatePassword(_passwordController.text);
      print("Mot de passe mis à jour avec succès.");
      _showSuccesDialog("Votre mot de passe a été mis à jour avec succès.");
    } else {
      // L'utilisateur n'a pas confirmé la réinitialisation du mot de passe
      print("L'utilisateur n'a pas confirmé la réinitialisation du mot de passe.");
      // Vous pouvez afficher un message d'erreur approprié ici.
    }
  } catch (e) {
    print("Erreur lors de la mise à jour du mot de passe : $e");
    // Gérez les erreurs de mise à jour du mot de passe
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
          // Get.back(); // Ferme le dialogue
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    SignIn()), // Remplacez par le nom de votre page de changement de mot de passe
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
                  
        
                  SizedBox(height: 16),
        
                  TextFormField(
                    cursorColor: Colors.black,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: "  Nouveau mot de passe",
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
        
                  SizedBox(height: 16),
        
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: "  Confirmez votre mot de passe",
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
                    onPressed: _handleSubmit,
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                      minimumSize:
                          MaterialStateProperty.all(Size(double.infinity, 48)),
                    ),
                    child: Text("Changez"),
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
    _verificationCodeController.dispose();
    super.dispose();
  }
}
