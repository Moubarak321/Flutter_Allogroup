import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';

const kGoogleApiKey = "AIzaSyAgjmN1oAneb0t9v8gIgWSWkwwBj-KLLsw";

// ignore: must_be_immutable
class DeliveryInfoWidget extends StatefulWidget {
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
  _DeliveryInfoWidgetState createState() => _DeliveryInfoWidgetState();
}

class _DeliveryInfoWidgetState extends State<DeliveryInfoWidget> {
  TextEditingController controller = TextEditingController();

  Future<void> _handlePressButton(BuildContext context) async {
    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      mode: Mode.overlay,
      language: "fr",
      components: [new Component(Component.country, "bj")],
      hint: 'Rechercher des villes',
      startText: controller.text,
    );

    if (p != null) {
      print(p.description);
    } else {
      print('Erreur');
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
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        labelText: 'Rechercher des villes',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () async {
                            await _handlePressButton(context);
                          },
                        ),
                      ),
                      onChanged: (value) {
                        // Vous pouvez ajouter des filtres supplémentaires ici si nécessaire
                      },
                    ),
                  ],
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

            // Appeler la fonction pour mettre à jour les données
            widget.updateDeliveryInfo(
                widget.deliveryAddress ?? '', int.parse(phoneNumber));
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
