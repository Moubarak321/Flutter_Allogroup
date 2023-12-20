import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:allogroup/screens/office/widgets/dimensions.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:get/get.dart';

class HistoriqueCourses extends StatelessWidget {
  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  Widget buildCourseCard(Map<String, dynamic> courseData) {
    // Initialisez la localisation française
    initializeDateFormatting('fr_FR', null);

    final addressRecuperation = courseData['addressRecuperation'];
    final addressLivraison = courseData['addressLivraison'];
    final typeLivraison = courseData['type_courses'];
    final title = courseData['title'];
    final depense = courseData['prix'];
    final timestamp = courseData['dateDeLivraison'];
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
    final formattedDate =
        DateFormat('EEEE d MMMM y, HH:mm:ss', 'fr_FR').format(date);

    return Container(
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
        // border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Bilan d'une course",
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          ),
          Text(
            'Date de commande : $formattedDate',
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          ),
          Text(
            'Adresse de Récupération: $addressRecuperation',
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          ),
          Text(
            'Adresse de Livraison: $addressLivraison',
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          ),
          Text(
            'Type de Livraison: $typeLivraison',
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          ),
          Text(
            'Titre: $title',
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          ),
          Text(
            'Prix: $depense F',
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(LineAwesomeIcons.angle_left),color: Colors.white),
        title: Text('Vos courses',
            style:
                TextStyle(color: Colors.white, fontSize: Dimensions.height20)),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                right: Dimensions.width20, left: Dimensions.width20),
            color: Colors.blue,
            height: 100,
            child: Center(
              child: Text(
                'Vos dernières courses',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(getCurrentUser()?.uid)
                  .snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                // Utilisez DocumentSnapshot au lieu de QuerySnapshot
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }

                final userData = snapshot.data!.data() as Map<String, dynamic>;
                if (!userData.containsKey('courses')) {
                  // L'utilisateur n'a pas de données de courses
                  return Center(
                    child: Text(
                      "Aucune course",
                      style: TextStyle(
                        fontSize: 20.0,
                        // color: Colors.orange,
                      ),
                    ),
                  );
                }

                final latestCourses = List<Map<String, dynamic>>.from(
                  (userData['courses'] as List<dynamic>).take(5),
                );

                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: latestCourses.length,
                  itemBuilder: (context, index) {
                    final courseData = latestCourses[index];
                    // Check if the status is true before building the course card
                    if (courseData['status'] == false) {
                      return buildCourseCard(courseData);
                    } else {
                      // If the status is false, return an empty container or null
                      return Container(); // You can also return null if you want to skip this item
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
