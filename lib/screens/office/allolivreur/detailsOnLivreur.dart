import 'package:allogroup/screens/office/allolivreur/courseLivreur.dart';
import 'package:allogroup/screens/office/widgets/app_icon.dart';
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
        ? DateTime.fromMillisecondsSinceEpoch(
            courseData['dateDeLivraison'].seconds * 1000)
        : null;

    final formattedDate = dateDeLivraison != null
        ? DateFormat('EEEE d MMMM y, HH:mm:ss', 'fr_FR').format(dateDeLivraison)
        : 'Non spécifiée';

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context); // Revenir à la page précédente
              },
              child: AppIcon(
                icon: Icons.arrow_back,
                backgroundColor: Color(0xCC0A5089),
                iconColor: Colors.white,
              ),
            ),
            Text("Details de livraison"),
            GestureDetector(
              onTap: () {
                // Redirect to DetailsOnLivraison() when sticky note icon is clicked
                // Get.showSnackbar(GetSnackBar(message:"ddddddd",));
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return CourseLivreur();
                    },
                  ),
                );
              },
              child: Icon(
                Icons.sticky_note_2_outlined,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color(0xFFe8e8e8),
              blurRadius: 5.0,
              offset: Offset(0, 5),
            ),
            BoxShadow(
              color: Colors.white,
              offset: Offset(-5, 0),
            ),
            BoxShadow(
              color: Colors.white,
              offset: Offset(5, 0),
            ),
          ],
          color: Colors.orange,
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(8.0),
        ),
        // child: Column(

        //   mainAxisAlignment: MainAxisAlignment.center,

        //   children: <Widget>[
        //     buildTextWithBackground('Type de livraison:', courseData['type_courses']),
        //     Text('Quoi: ${courseData['title']}'),
        //     Text('Prix: ${courseData['prix']}'),
        //     Text('Adresse de récupération: ${courseData['addressRecuperation']}'),
        //     Text('Numéro à contacter au lieu de récupération: ${courseData['numeroARecuperation']}'),
        //     Text('Adresse de livraison: ${courseData['addressLivraison']}'),
        //     Text('Numéro à contacter au lieu de livraison: ${courseData['numeroALivraison']}'),
        //     Text('Informations complémentaires: ${courseData['details']}'),
        //     Text('Date de livraison: $formattedDate'),
        //   ],
        // ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            
            Text(
              'Type de livraison : ${courseData['type_courses']}',
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
            Text(
              'Prix: ${courseData['prix']} FCFA',
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
            Text(
              'Quoi: ${courseData['title']}',
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
            Text(
              "Zone d'échange: ${courseData['addressRecuperation']}",
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
            Text(
              'Numéro à contacter au lieu de récupération: ${courseData['numeroARecuperation']}',
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
            Text(
              'Destinataire: ${courseData['addressLivraison']}',
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
            Text(
              'Numéro à contacter au lieu de Livraison: ${courseData['numeroALivraison']}',
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
            Text(
              'Date de livraison: $formattedDate',
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
            Text(
              'Informations complémentaires: ${courseData['details']} ',
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
            
          ],
        ),
      ),
    );
  }

  Widget buildTextWithBackground(String label, String value) {
    return Container(
      width: double.infinity,
      color: Colors.orange, // Set the background color here
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        '$label $value',
        style: TextStyle(fontSize: 18.0, color: Colors.white),
      ),
    );
  }
}
