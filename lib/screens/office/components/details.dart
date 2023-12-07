import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DetailsInfoWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  String? title;
  String? details;
  final Function(String, String) updateDetailsInfo;

  DetailsInfoWidget({
    required this.formKey,
    required this.title,
    required this.details,
    required this.updateDetailsInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Note pour le champion",
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: TextFormField(
            decoration: InputDecoration(
              labelText: "Message au champion",
              prefixIcon: Icon(Icons.library_books),
            ),
            onChanged: (value) {
              // Appeler la fonction pour mettre à jour les données
              updateDetailsInfo(value, details ?? '');
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ce champ est requis';
              }
              return null;
            },
          ),
        ),
        SizedBox(height: 20.0),

        Text(
          "Description sur l'échange",
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: TextFormField(
            maxLines: 5,
            decoration: InputDecoration(
              labelText: "Ex: Du CEG Godomey chez Papa Yabo pour Toyota chez Maman Yabo",
              prefixIcon: Icon(Icons.library_books),
            ),
            onChanged: (value) {
              // Appeler la fonction pour mettre à jour les données
              updateDetailsInfo(title ?? '', value);
            },
          ),
        ),

        SizedBox(height: 20.0),
      ],
    );
  }
}
