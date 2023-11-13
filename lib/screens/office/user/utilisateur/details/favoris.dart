import 'package:flutter/material.dart';



class Favoris extends StatefulWidget {
  const Favoris({super.key});

  @override
  State<Favoris> createState() => _FavorisState();
}

class _FavorisState extends State<Favoris> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(title: Text("Vos Favoris")),
       
    );
  }
}