import 'package:flutter/material.dart';

class SuccessScreen extends StatefulWidget {
  final double amount;
  final String transactionId;

  const SuccessScreen({Key? key, required this.amount, required this.transactionId}) : super(key: key);

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  Widget build(BuildContext context) {
    // Utilisez les valeurs passées dans les paramètres ici
    return Scaffold(
      appBar: AppBar(
        title: Text('Success'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Amount: ${widget.amount}'),
            Text('ID: ${widget.transactionId}'),
          ],
        ),
      ),
    );
  }
}
