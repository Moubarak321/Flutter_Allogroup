import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

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
              updatePickupInfo(pickupAddress ?? '', int.parse(phoneNumber));    
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
