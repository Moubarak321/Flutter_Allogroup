import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:get/get.dart';

const kGoogleApiKey = "AIzaSyAgjmN1oAneb0t9v8gIgWSWkwwBj-KLLsw";

// AIzaSyAvZjW1qK8FgWbZKTQCPPbyy1rAwcnqi3o
// AIzaSyA5RGQzj1CdR_A5TOjRXUcw1Q7K_iOEfd8   ********
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
  TextEditingController controller = TextEditingController();
  bool useCurrentLocation = false;
  bool showSourceField = false;
  @override
  void initState() {
    super.initState();
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

      return p!.description!;
    } catch (e) {
      print("Erreur lors de l'autocomplétion : $e");
      // Gérer l'erreur selon vos besoins
      return ''; // ou une valeur par défaut
    }
  }


  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    var pickupAddress = await Geolocator.getCurrentPosition();
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return pickupAddress;
  }

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
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    useCurrentLocation = true;
                  });
                  _determinePosition();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.location_on),
                    SizedBox(width: 8),
                    Text("Ma position"),
                  ],
                ),
              ),
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
                    borderRadius: BorderRadius.circular(8)),
                child: TextFormField(
                  controller: controller,
                  readOnly: true,
                  onTap: () async {
                    String selectedPlace = await showGoogleAutoComplete(context);
                    controller.text = selectedPlace;

                    setState(() {
                      showSourceField = true;
                    });
                  },
                  decoration: InputDecoration(
                      hintText: "Destination initiale",
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Icon(
                          Icons.search,
                          color: Colors.black12,
                        ),
                      )),
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
          onChanged: (value) {
            final phoneNumber = value.completeNumber;
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

//=========================================================================
// ancien code fonctionnel
//=========================================================================

// import 'package:flutter/material.dart';
// import 'package:intl_phone_field/intl_phone_field.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// // ignore: must_be_immutable
// class PickupInfoWidget extends StatefulWidget {
//   final GlobalKey<FormState> formKey;
//   String? pickupAddress;
//   int? pickupNumero;
//   final Function(String, int) updatePickupInfo;

//   PickupInfoWidget({
//     required this.formKey,
//     required this.pickupAddress,
//     required this.pickupNumero,
//     required this.updatePickupInfo,
//   });

//   @override
//   _PickupInfoWidgetState createState() => _PickupInfoWidgetState();
// }

// class _PickupInfoWidgetState extends State<PickupInfoWidget> {
//   List<String> addressList = [];
//   String? selectedAddress;

//   @override
//   void initState() {
//     super.initState();
//     fetchDeliveryAddresses(); // Appel de la fonction au démarrage de la page
//   }

//   void fetchDeliveryAddresses() async {
//     try {
//       // Récupérer les données depuis Firestore
//       DocumentSnapshot zoneSnapshot = await FirebaseFirestore.instance
//           .collection('administrateur')
//           .doc('zone')
//           .get();

//       // Vérifier si le document existe et s'il contient la clé 'livraison'
//       if (zoneSnapshot.exists) {
//         Map<String, dynamic>? data =
//             zoneSnapshot.data() as Map<String, dynamic>?;
//         if (data != null && data.containsKey('livraison')) {
//           List<dynamic> livraisonList = data['livraison'];
//           setState(() {
//             addressList = List<String>.from(livraisonList);
//             selectedAddress = addressList.isNotEmpty ? addressList.first : null;
//           });
//         }
//       }
//     } catch (e) {
//       print('Erreur lors de la récupération des adresses de livraison : $e');
//       // Gérer l'erreur selon vos besoins
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Text(
//           "Zone d'échange",
//           style: TextStyle(
//             fontSize: 20.0,
//             fontWeight: FontWeight.bold,
//             color: Colors.orange,
//           ),
//         ),
//         Container(
//             decoration: BoxDecoration(
//               border: Border.all(
//                 color: Colors.lightBlue,
//               ),
//               borderRadius: BorderRadius.circular(8.0),
//             ),
//             child: Autocomplete<String>(
//               optionsBuilder: (TextEditingValue textEditingValue) {
//                 // Filtrer les suggestions en fonction de la saisie de l'utilisateur
//                 return addressList
//                     .where((String option) => option
//                         .toLowerCase()
//                         .contains(textEditingValue.text.toLowerCase()))
//                     .toList();
//               },
//               onSelected: (String selectedAddress) {
//                 // Mettre à jour la valeur sélectionnée
//                 setState(() {
//                   this.selectedAddress = selectedAddress;
//                 });
//                 widget.updatePickupInfo(
//                     selectedAddress, widget.pickupNumero ?? 0);
//               },
//               fieldViewBuilder: (BuildContext context,
//                   TextEditingController textEditingController,
//                   FocusNode focusNode,
//                   VoidCallback onFieldSubmitted) {
//                 return TextFormField(
//                   controller: textEditingController,
//                   focusNode: focusNode,
//                   onFieldSubmitted: (value) => onFieldSubmitted(),
//                   decoration: InputDecoration(
//                     labelText: 'Zone',
//                     prefixIcon: Icon(Icons.location_on),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Il est important de préciser une adresse de récupération';
//                     }
//                     return null;
//                   },
//                 );
//               },
//               optionsViewBuilder: (BuildContext context,
//                   AutocompleteOnSelected<String> onSelected,
//                   Iterable<String> options) {
//                 return Material(
//                   elevation: 4.0,
//                   child: Container(
//                     height: 200.0,
//                     child: ListView(
//                       children: options
//                           .map((String option) => ListTile(
//                                 title: Text(option),
//                                 onTap: () {
//                                   onSelected(option);
//                                 },
//                               ))
//                           .toList(),
//                     ),
//                   ),
//                 );
//               },
//             )),
//         SizedBox(height: 20.0),
//         Text(
//           'Prendre chez',
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
//           keyboardType: TextInputType.phone,
//           onChanged: (value) {
//             // Extraire le numéro de téléphone
//             final phoneNumber = value.completeNumber;
//             // Appeler la fonction pour mettre à jour les données
//             widget.updatePickupInfo(
//                 widget.pickupAddress ?? '', int.tryParse(phoneNumber) ?? 0);
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