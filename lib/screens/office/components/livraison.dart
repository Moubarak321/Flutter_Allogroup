import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:get/get.dart';

const kGoogleApiKey = "AIzaSyAgjmN1oAneb0t9v8gIgWSWkwwBj-KLLsw";

// ignore: must_be_immutable
class DeliveryInfoWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  // String? deliveryAddress;
  // int? deliveryNumero;

  String? tempDeliveryAddress;
  int? tempDeliveryNumero;

  final Function(String, int) updateDeliveryInfo;

  DeliveryInfoWidget({
    required this.formKey,
    required this.tempDeliveryAddress,
    required this.tempDeliveryNumero,
    required this.updateDeliveryInfo,
  });

  @override
  _DeliveryInfoWidgetState createState() => _DeliveryInfoWidgetState();
}

class _DeliveryInfoWidgetState extends State<DeliveryInfoWidget> {
  TextEditingController controller = TextEditingController();
  bool showSourceField = false;

  String? tempDeliveryAddress;
  int? tempDeliveryNumero;

  void updateSelectedAddress(String address) {
    setState(() {
      widget.tempDeliveryAddress = address;
    });
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
        updateSelectedAddress(selectedAddress);
        return selectedAddress;
      } else {
        print('Aucune prédiction trouvée');
        return ''; // ou une valeur par défaut
      }
    } catch (e) {
      print("Erreur lors de l'autocomplétion : $e");
      // Gérer l'erreur selon vos besoins
      return ''; // ou une valeur par défaut
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Lieu de livraison',
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
                    String selectedPlace =
                        await showGoogleAutoComplete(context);
                    controller.text = selectedPlace;

                    setState(() {
                      showSourceField = true;
                    });
                    // Assignez les valeurs à la variable temporaire ici
                    tempDeliveryAddress = selectedPlace;
                    tempDeliveryNumero = widget.tempDeliveryNumero ?? 0;
                  },
                  onChanged: (String? newValue) {
                    // Mettre à jour la valeur sélectionnée
                    setState(() {
                      widget.tempDeliveryAddress = newValue;
                    });

                    // Utilisez les valeurs de la variable temporaire ici
                    widget.updateDeliveryInfo(
                        tempDeliveryAddress ?? '', tempDeliveryNumero ?? 0);
                    // widget.updateDeliveryInfo(newValue ?? '', widget.deliveryNumero ?? 0);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Il est important de préciser une adresse de récupération';
                    }
                    return null;
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

            // Assignez les valeurs à la variable temporaire ici
            tempDeliveryAddress = widget.tempDeliveryAddress ?? '';
            tempDeliveryNumero = int.parse(phoneNumber);

            // Utilisez les valeurs de la variable temporaire ici
            widget.updateDeliveryInfo(
                tempDeliveryAddress ?? '', tempDeliveryNumero ?? 0);

            // // Appeler la fonction pour mettre à jour les données
            // widget.updateDeliveryInfo(
            //     widget.deliveryAddress ?? '', int.parse(phoneNumber));
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



















































// import 'package:flutter/material.dart';
// import 'package:intl_phone_field/intl_phone_field.dart';

// // ignore: must_be_immutable
// class DeliveryInfoWidget extends StatelessWidget {
//   final GlobalKey<FormState> formKey;
//   String? deliveryAddress;
//   int? deliveryNumero;
//   final Function(String, int) updateDeliveryInfo;

//   DeliveryInfoWidget({
//     required this.formKey,
//     required this.deliveryAddress,
//     required this.deliveryNumero,
//     required this.updateDeliveryInfo,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Text(
//           'Identifiant',
//           style: TextStyle(
//             fontSize: 20.0,
//             fontWeight: FontWeight.bold,
//             color: Colors.orange,
//           ),
//         ),
//         Container(
//           decoration: BoxDecoration(
//             border: Border.all(
//               color: Colors.lightBlue,
//             ),
//             borderRadius: BorderRadius.circular(8.0),
//           ),
//           child: TextFormField(
//             decoration: InputDecoration(
//               labelText: 'Prénom',
//               prefixIcon: Icon(Icons.person_2_rounded),
//             ),
//             onChanged: (value) {
//               // Appeler la fonction pour mettre à jour les données
//               updateDeliveryInfo(value, deliveryNumero ?? 0);
//             },
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Ce champ est requis pour une bonne orientation';
//               }
//               return null;
//             },
//           ),
//         ),
//         SizedBox(height: 20.0),

//         Text(
//           'Rendre à',
//           style: TextStyle(
//             fontSize: 20.0,
//             fontWeight: FontWeight.bold,
//             color: Colors.orange,
//           ),
//         ),
       
//         IntlPhoneField(
//           key: Key('phoneFieldKey'), 
//           flagsButtonPadding: const EdgeInsets.all(5),
//           dropdownIconPosition: IconPosition.trailing,
//           initialCountryCode: 'BJ',
//           decoration: const InputDecoration(
//             labelText: 'Numéro',
//             labelStyle: TextStyle(color: Color.fromRGBO(250, 153, 78, 1)),
//             filled: true,
//             fillColor: Colors.white,
//             alignLabelWithHint: true,
//             border: OutlineInputBorder(
//               borderSide: BorderSide(),
//               borderRadius: BorderRadius.all(Radius.circular(35)),
//             ),
//           ),
//           keyboardType: TextInputType.number,
//           onChanged: (value) {
//             // Extraire le numéro de téléphone
//             final phoneNumber = value.completeNumber;
           
//               // Appeler la fonction pour mettre à jour les données
//             updateDeliveryInfo(deliveryAddress ?? '', int.parse(phoneNumber));
           
//           },
//           validator: (value) {
//             if (value == null) {
//               return 'Il est important de préciser un numéro de contact';
//             }
//             return null;
//           },
//         ),
//       ],
//     );
//   }
// }