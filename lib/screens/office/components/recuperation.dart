import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: must_be_immutable
class PickupInfoWidget extends StatefulWidget {
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
  _PickupInfoWidgetState createState() => _PickupInfoWidgetState();
}

class _PickupInfoWidgetState extends State<PickupInfoWidget> {
  List<String> addressList = [];
  String? selectedAddress;

  @override
  void initState() {
    super.initState();
    fetchDeliveryAddresses(); // Appel de la fonction au démarrage de la page
  }

  void fetchDeliveryAddresses() async {
  try {
    // Récupérer les données depuis Firestore
    DocumentSnapshot zoneSnapshot = await FirebaseFirestore.instance
        .collection('administrateur')
        .doc('zone')
        .get();

    // Vérifier si le document existe et s'il contient la clé 'livraison'
    if (zoneSnapshot.exists) {
      Map<String, dynamic>? data = zoneSnapshot.data() as Map<String, dynamic>?;
      if (data != null && data.containsKey('livraison')) {
        List<dynamic> livraisonList = data['livraison'];
        setState(() {
          addressList =
              List<String>.from(livraisonList); 
          selectedAddress = addressList.isNotEmpty ? addressList.first : null;
        });
      }
    }
  } catch (e) {
    print('Erreur lors de la récupération des adresses de livraison : $e');
    // Gérer l'erreur selon vos besoins
  }
}


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Zone d'échange",
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
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Zone',
              prefixIcon: Icon(Icons.location_on),
            ),
            value: selectedAddress ?? addressList.first,
            items: addressList.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              // Mettre à jour la valeur sélectionnée
              setState(() {
                selectedAddress = newValue;
              });
              widget.updatePickupInfo(newValue ?? '', widget.pickupNumero ?? 0);
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
          'Prendre chez',
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
          keyboardType: TextInputType.phone,
          onChanged: (value) {
            // Extraire le numéro de téléphone
            final phoneNumber = value.completeNumber;
            // Appeler la fonction pour mettre à jour les données
            widget.updatePickupInfo(
                widget.pickupAddress ?? '', int.tryParse(phoneNumber) ?? 0);
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
