import 'package:allogroup/screens/office/allofood/main_food_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:allogroup/screens/office/widgets/dimensions.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ConfirmationLivraison extends StatelessWidget {
  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  String gestioncode(typeLivraison, codesecret) {
    if (typeLivraison == 'Livraison de bien') {
      return codesecret.toString();
    } else {
      var message = "gestion du code par le restaurant";
      return message;
    }
  }

  Widget buildCourseCard(Map<String, dynamic> courseData) {
    // Initialisez la localisation française
    initializeDateFormatting('fr_FR', null);

    final addressRecuperation = courseData['addressRecuperation'];
    final addressLivraison = courseData['addressLivraison'];
    final typeLivraison = courseData['type_courses'];
    final codesecret = courseData['password'];
    final title = courseData['title'];
    final depense = courseData['prix'];
    final timestamp = courseData['dateDeLivraison'];
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
    final formattedDate =
        DateFormat('EEEE d MMMM y, HH:mm:ss', 'fr_FR').format(date);
    final codeMessage = gestioncode(typeLivraison, codesecret);

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
            "Zone d'échange: $addressRecuperation",
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          ),
          Text(
            'Destinataire: $addressLivraison',
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
          Text(
            'Code de course à communiquer au destinatire: $codeMessage',
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return MainFoodPage();
                  },
                ),
              );
            },
            icon: const Icon(LineAwesomeIcons.angle_left, color: Colors.white)),
        title: Text('Service de livraison',
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
                'En cas de manquement, vous pouvez appeler ou écrire au +22953899427',
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
                      "Aucune course en instance",
                      style: TextStyle(
                        fontSize: 20.0,
                        // color: Colors.orange,
                      ),
                    ),
                  );
                }

                final courses = userData['courses'] as List<dynamic>;
                // Only display the last two courses
                final displayedCourses = courses.length >= 1
                    ? courses.sublist(courses.length - 1)
                    : courses;

                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: displayedCourses.length,
                  itemBuilder: (context, index) {
                    final courseData =
                        displayedCourses[index] as Map<String, dynamic>;
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
