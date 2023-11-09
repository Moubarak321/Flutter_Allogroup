import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PickupInfoWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  String? pickupAddress;
  int? pickupNumero;
  final Function(String, int) updatePickupInfo;

  PickupInfoWidget({
    required this.formKey,
    required this.pickupAddress,
    required this.pickupNumero,
    required this.updatePickupInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Adresse de Récupération',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.lightBlue,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Adresse de récupération',
              prefixIcon: Icon(Icons.location_on),
            ),
            onChanged: (value) {
              // Appeler la fonction pour mettre à jour les données
              updatePickupInfo(value, pickupNumero ?? 0);
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Il est important de préciser une adresse de récupération';
              }
              return null;
            },
          ),
        ),
        SizedBox(height: 20.0),
        Text(
          'Numéro à contacter au lieu de récupération',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.lightBlue,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Numéro',
              prefixIcon: Icon(Icons.phone),
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              int numero = int.tryParse(value) ?? 0;
              updatePickupInfo(pickupAddress ?? '', numero);
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Il est important de préciser un numéro de contact';
              }
              final numero = int.tryParse(value);
              if (numero == null || numero == 0) {
                return 'Veuillez saisir un numéro valide';
              }
              return null;
            },
          ),
        ),
        SizedBox(height: 20.0),
      ],
    );
  }
}
