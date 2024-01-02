import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

// ignore: must_be_immutable
class DeliveryInfoWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  String? deliveryAddress;
  int? deliveryNumero;
  final Function(String, int) updateDeliveryInfo;
  TextEditingController controller = TextEditingController();

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
              GooglePlaceAutoCompleteTextField(
                textEditingController: controller,
                googleAPIKey: "YOUR_GOOGLE_API_KEY",
                inputDecoration: InputDecoration(
                  hintText: "Adresse de récupération",
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                ),
                debounceTime: 400,
                countries: ["bj"],
                isLatLngRequired: false,
                getPlaceDetailWithLatLng: (Prediction prediction) {
                  print("placeDetails" + prediction.lat.toString());
                },
                itemClick: (Prediction prediction) {
                  controller.text = prediction.description ?? "";
                  controller.selection = TextSelection.fromPosition(
                      TextPosition(
                          offset: prediction.description?.length ?? 0));
                },
                seperatedBuilder: Divider(),
                itemBuilder: (context, index, Prediction prediction) {
                  return Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Icon(Icons.location_on),
                        SizedBox(width: 7),
                        Expanded(
                            child: Text("${prediction.description ?? ""}")),
                      ],
                    ),
                  );
                },
                isCrossBtnShown: true,
              ),
              // ElevatedButton(
              //   onPressed: () {
              //     setState(() {
              //       useCurrentLocation = false;
              //     });
              //   },
              //   child: Text("Utiliser une adresse spécifiée"),
              // ),
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