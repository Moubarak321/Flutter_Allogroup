// import 'package:allogroup/screens/office/widgets/big_text.dart';
import 'package:flutter/material.dart';




class Informations extends StatefulWidget {
  const Informations({super.key});

  @override
  State<Informations> createState() => _InformationsState();
}

class _InformationsState extends State<Informations> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text("Informations")),
    );
  }
}