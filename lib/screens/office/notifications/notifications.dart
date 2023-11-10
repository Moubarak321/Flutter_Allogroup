// import 'package:allogroup/screens/office/widgets/big_text.dart';
import 'package:flutter/material.dart';




class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text("Notifications")),
    );
  }
}