import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

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
          'Identifiant',
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
              labelText: 'Prénom',
              prefixIcon: Icon(Icons.person_2_rounded),
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
          'Rendre à',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
       
        IntlPhoneField(
          key: Key('phoneFieldKey'), 
          flagsButtonPadding: const EdgeInsets.all(5),
          dropdownIconPosition: IconPosition.trailing,
          initialCountryCode: 'BJ',
          decoration: const InputDecoration(
            labelText: 'Numéro',
            labelStyle: TextStyle(color: Color.fromRGBO(250, 153, 78, 1)),
            filled: true,
            fillColor: Colors.white,
            alignLabelWithHint: true,
            border: OutlineInputBorder(
              borderSide: BorderSide(),
              borderRadius: BorderRadius.all(Radius.circular(35)),
            ),
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            // Extraire le numéro de téléphone
            final phoneNumber = value.completeNumber;
           
              // Appeler la fonction pour mettre à jour les données
            updateDeliveryInfo(deliveryAddress ?? '', int.parse(phoneNumber));
           
          },
          validator: (value) {
            if (value == null) {
              return 'Il est important de préciser un numéro de contact';
            }
            return null;
          },
        ),
      ],
    );
  }
}