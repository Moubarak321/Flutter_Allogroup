// import 'package:allogroup/screens/office/widgets/big_text.dart';
import 'package:flutter/material.dart';




class Utilisateur extends StatefulWidget {
  const Utilisateur({super.key});

  @override
  State<Utilisateur> createState() => _UtilisateurState();
}

class _UtilisateurState extends State<Utilisateur> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text("Utilisateur")),
    );
  }
}