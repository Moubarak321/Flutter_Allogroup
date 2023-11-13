import 'package:flutter/material.dart';



class HistoriqueCourses extends StatefulWidget {
  const HistoriqueCourses({super.key});

  @override
  State<HistoriqueCourses> createState() => _HistoriqueCoursesState();
}

class _HistoriqueCoursesState extends State<HistoriqueCourses> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(title: Text("Vos courses")),
       
    );
  }
}