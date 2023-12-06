import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../signInScreen/signInScreen.dart';

class Confirmation extends StatefulWidget {
  @override
  _ConfirmationState createState() => _ConfirmationState();
}

class _ConfirmationState extends State<Confirmation> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _passwordErrorText;

  bool _isPasswordValid(String value) {
    if (value.length < 6) {
      setState(() {
        _passwordErrorText =
            "Le code doit contenir au moins 6 caractères numériques.";
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
      final email = _emailController.text;
      final code = _passwordController.text;

      try {
        // Vérifier l'email et le code de validation avec Firebase
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: code,
        );

        // La vérification a réussi, redirigez l'utilisateur vers une autre page.
        // Par exemple, vous pouvez le rediriger vers la page d'accueil de l'application.
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => SignIn(), // Remplacez par votre écran d'accueil
        ));
      } catch (e) {
        // Une erreur s'est produite lors de la vérification, vous pouvez afficher un message d'erreur.
        // print("Erreur de vérification : $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(10, 80, 137, 0.8),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Color.fromRGBO(10, 80, 137, 1),
                      //     blurRadius: 10,
                      //     spreadRadius: 2,
                      //   ),
                      // ],
                    ),
                    child: Image.asset(
                      "assets/images/Home.png",
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
              _buildInputField(
                controller: _emailController,
                labelText: "  Email",
                
                prefixIcon: Icons.email,
              ),
              SizedBox(height: 16),
              _buildInputField(
                controller: _passwordController,
                labelText: "  Code de Validation",
                
                prefixIcon: Icons.lock,
                isPassword: true,
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
                  minimumSize: MaterialStateProperty.all(
                    Size(double.infinity, 48),
                  ),
                ),
                child: Text("Validation"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String labelText,
    required IconData prefixIcon,
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        // labelStyle: TextStyle(color: Color.fromRGBO(255, 109, 0, 1).withOpacity(0.7),),

        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(50.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(255, 109, 0, 1)),
          borderRadius: BorderRadius.circular(50.0),
        ),
        filled: true,
        fillColor: Color.fromRGBO(10, 80, 137, 0.8),
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
            prefixIcon,
            color: Color.fromRGBO(255, 109, 0, 1),
            size: 30.0,
          ),
        ),
        errorText: isPassword ? _passwordErrorText : null,
      ),
      obscureText: isPassword,
      style: TextStyle(color: Color.fromRGBO(255, 109, 0, 1)),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return isPassword
              ? "Veuillez entrer votre code de validation."
              : "Veuillez entrer votre email.";
        }
        return null;
      },
      onChanged: isPassword ? _isPasswordValid : null,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
