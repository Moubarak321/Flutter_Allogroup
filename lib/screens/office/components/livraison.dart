import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DeliveryInfoWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  String? deliveryAddress;
  int? deliveryNumero;
  final Function(String, int) updateDeliveryInfo;

  DeliveryInfoWidget({
    required this.formKey,
    required this.deliveryAddress,
    required this.deliveryNumero,
    required this.updateDeliveryInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Adresse de Destination',
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
              labelText: 'Adresse de livraison',
              prefixIcon: Icon(Icons.location_on),
            ),
            onChanged: (value) {
              // Appeler la fonction pour mettre à jour les données
              updateDeliveryInfo(value, deliveryNumero ?? 0);
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ce champ est requis pour une bonne orientation';
              }
              return null;
            },
          ),
        ),
        SizedBox(height: 20.0),

        Text(
          'Numéro à contacter au lieu de livraison',
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
              // Appeler la fonction pour mettre à jour les données
              int numero = int.tryParse(value) ?? 0;
              updateDeliveryInfo(deliveryAddress ?? '', numero);
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ce champ est requis pour favoriser la communication';
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
