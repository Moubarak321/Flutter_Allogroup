import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

const kGoogleApiKey = "AIzaSyAgjmN1oAneb0t9v8gIgWSWkwwBj-KLLsw";

// ignore: must_be_immutable
class PickupInfoWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  String? tempPickupAddress;
  int? tempPickupNumero;
  final Function(String, int) onPickupInfoSelected;


  PickupInfoWidget({
    required this.formKey,
    required this.tempPickupAddress,
    required this.tempPickupNumero,
    required this.onPickupInfoSelected,
  });

  @override
  _PickupInfoWidgetState createState() => _PickupInfoWidgetState();
}

class _PickupInfoWidgetState extends State<PickupInfoWidget> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController controller = TextEditingController();
  bool showSourceField = false;



  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Adresse de récupération",
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 20.0),
              Container(
                width: Get.width,
                height: 50,
                padding: EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      spreadRadius: 1,
                      blurRadius: 1,
                    )
                  ],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextFormField(
                  controller: controller,
                  onTap: () async {
                    String selectedPlace = await showGoogleAutoComplete(context);
                    controller.text = selectedPlace;

                    setState(() {
                      showSourceField = true;
                    });

                    widget.onPickupInfoSelected(selectedPlace, widget.tempPickupNumero ?? 0);
                  },
                  decoration: InputDecoration(
                    hintText: "Destination initiale",
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Icon(
                        Icons.search,
                        color: Colors.black12,
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
          onChanged: (value) async {
            final completeNumber = value.completeNumber;
            updatePhoneNumber(completeNumber);
            setState(() {
              showSourceField = true;
            });

            widget.onPickupInfoSelected( widget.tempPickupAddress  ?? '', widget.tempPickupNumero ?? 0);
          },
        ),
        ElevatedButton(
          onPressed: () async {
            // Vérifiez si l'utilisateur est connecté
            User? user = _auth.currentUser;
            if (user != null) {
              // Utilisateur connecté, envoyez les données à Firestore
              await sendDataToFirestore(user.uid);
            } else {
              // L'utilisateur n'est pas connecté, affichez un message ou redirigez vers la page de connexion
              print("L'utilisateur n'est pas connecté");
            }
          },
          child: Text('Validation'),
        ),
      ],
    );
  }

  Future<void> sendDataToFirestore(String userId) async {
    try {
      // Vous pouvez ajuster cette logique en fonction de votre structure de données
      await _firestore.collection('users').doc(userId).set(
        {
          'deplacementRecuperation': FieldValue.arrayUnion([
            {
              'recuperation': widget.tempPickupAddress,
              'numeroRecup': widget.tempPickupNumero,
            },
          ]),
        },
        SetOptions(merge: true), // Utilisez merge: true pour mettre à jour plutôt qu'ajouter
      );

      String message = "Nous récupérons à ${widget.tempPickupAddress} et appelerons le numéro ${widget.tempPickupNumero}";
      
      Get.snackbar("Infos",
                  message,
                  backgroundColor: Colors.orange, colorText: Colors.white);

      print(message); // Cela affichera également les valeurs dans la console.
    } catch (error) {
      print("Erreur lors de la mise à jour des données dans Firestore: $error");
    }
  }


  Future<String> showGoogleAutoComplete(BuildContext context) async {
    try {
      Prediction? p = await PlacesAutocomplete.show(
        offset: 0,
        radius: 1000,
        strictbounds: false,
        region: "us",
        language: "fr",
        context: context,
        mode: Mode.overlay,
        apiKey: kGoogleApiKey,
        components: [new Component(Component.country, "bj")],
        types: [],
        hint: "Emplacement",
      );

      if (p != null) {
        String selectedAddress = p.description!;
        widget.tempPickupAddress = selectedAddress;
        updateSelectedAddress(selectedAddress);
        print(selectedAddress);
        return selectedAddress;
      } else {
        print('Aucune prédiction trouvée');
        return ''; // ou une valeur par défaut
      }
    } catch (e) {
      print("Erreur lors de l'autocomplétion : $e");
      return ''; 
    }
  }

  void updateSelectedAddress(String address) {
    setState(() {
      widget.tempPickupAddress = address;
    });
  }
  
  void updatePhoneNumber(String phoneNumber) {
    setState(() {
      widget.tempPickupNumero = int.parse(phoneNumber) ?? 0;
    });
  }
}
