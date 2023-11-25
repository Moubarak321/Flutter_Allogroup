import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class DetailsOnLivraison extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> courseData = Get.arguments;
    initializeDateFormatting('fr_FR', null);

    final dateDeLivraison = courseData['dateDeLivraison'] != null
        ? DateTime.fromMillisecondsSinceEpoch(courseData['dateDeLivraison'].seconds * 1000)
        : null;

    final formattedDate = dateDeLivraison != null
        ? DateFormat('EEEE d MMMM y, HH:mm:ss', 'fr_FR').format(dateDeLivraison)
        : 'Non spécifiée';

    return Scaffold(
      appBar: AppBar(
        title: Text('Détails sur la livraison'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Type de livraison: ${courseData['type_courses']}'),
            Text('Quoi: ${courseData['title']}'),
            Text('Prix: ${courseData['prix']}'),
            Text('Adresse de récupération: ${courseData['addressRecuperation']}'),
            Text('Numéro à contacter au lieu de récupération: ${courseData['numeroARecuperation']}'),
            Text('Adresse de livraison: ${courseData['addressLivraison']}'),
            Text('Numéro à contacter au lieu de livraison: ${courseData['numeroALivraison']}'),
            Text('Informations complémentaires: ${courseData['details']}'),
            Text('Date de livraison: $formattedDate'),
          ],
        ),
      ),
    );
  }
}
