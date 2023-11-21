import 'package:flutter/material.dart';



class EnCoursDeTraitement extends StatefulWidget {
  const EnCoursDeTraitement({super.key});

  @override
  State<EnCoursDeTraitement> createState() => _EnCoursDeTraitementState();
}

class _EnCoursDeTraitementState extends State<EnCoursDeTraitement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Traitement'),
      ),
    );
  }
}