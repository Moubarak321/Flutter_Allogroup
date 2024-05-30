import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

const kGoogleApiKey = "AIzaSyAgjmN1oAneb0t9v8gIgWSWkwwBj-KLLsw";

// ignore: must_be_immutable
class DeliveryInfoWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  String? tempDeliveryAddress;
  int? tempDeliveryNumero;
  final Function(String, int) onDeliveryInfoSelected;

  DeliveryInfoWidget({
    required this.formKey,
    required this.tempDeliveryAddress,
    required this.tempDeliveryNumero,
    required this.onDeliveryInfoSelected
  });

  @override
  _PickupInfoWidgetState createState() => _PickupInfoWidgetState();
}

class _PickupInfoWidgetState extends State<DeliveryInfoWidget> {
  //final FirebaseAuth _auth = FirebaseAuth.instance;
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController controller = TextEditingController();
  bool showSourceField = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Adresse",
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
                    widget.onDeliveryInfoSelected(selectedPlace, widget.tempDeliveryNumero ?? 0);
                  },
                  decoration: InputDecoration(
                    hintText: "Destination",
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
          'Contact',
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

            widget.onDeliveryInfoSelected( widget.tempDeliveryAddress ?? '', widget.tempDeliveryNumero?? 0);
          },
        ),
        
      ],
    );
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
        widget.tempDeliveryAddress = selectedAddress;
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
      widget.tempDeliveryAddress = address;
    });
  }
  void updatePhoneNumber(String phoneNumber) {
    setState(() {
      widget.tempDeliveryNumero = int.parse(phoneNumber) ?? 0;
    });
  }
}
