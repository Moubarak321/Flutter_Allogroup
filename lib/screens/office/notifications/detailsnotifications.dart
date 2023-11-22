import 'package:flutter/material.dart';


class Detailsnotifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Que dissent-ils ?',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Que dissent-ils ?'),
        ),
        body: Center(
          child: Text(
            'Bonjour',
            style: TextStyle(fontSize: 32.0),
          ),
        ),
      ),
    );
  }
}
