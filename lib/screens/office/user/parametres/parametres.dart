// import 'package:allogroup/screens/office/widgets/big_text.dart';
import 'package:flutter/material.dart';




class Parametres extends StatefulWidget {
  const Parametres({super.key});

  @override
  State<Parametres> createState() => _ParametresState();
}

class _ParametresState extends State<Parametres> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text("Paramètres")),
    );
  }
}