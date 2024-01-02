import 'package:allogroup/screens/office/user/utilisateur/details/historiqueCouresActuelle.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import './description_livreur.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:allogroup/screens/office/widgets/dimensions.dart';

import 'package:allogroup/screens/office/widgets/app_icon.dart';

class Zem extends StatelessWidget {
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
    final title = courseData['title'];
    final depense = courseData['prix'];
    final codesecret = courseData['password'];
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
            "Zone d'échange : $addressRecuperation",
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
        automaticallyImplyLeading: false,
        // leading: IconButton(
        //   onPressed: () => Get.back(),
        //   icon: const Icon(LineAwesomeIcons.angle_left, color: Colors.white),
        // ),
        // title: Text(
        //   'Allô Livreur',
        //   style: TextStyle(color: Colors.white, fontSize: Dimensions.height20),
        // ),
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
            Text("Allô Livreur",
                style: TextStyle(
                    color: Colors.white, fontSize: Dimensions.height20)),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HistoriqueCoursesActuelle(),
                  ),
                );
              },
              child: AppIcon(
                icon: Icons.delivery_dining_outlined,
                backgroundColor: Color(0xCC0A5089),
                iconColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                right: Dimensions.width20, left: Dimensions.width20),
            // color: Colors.white,
            height: 200,
            child: Center(
              child: Image.asset(
                'assets/images/livreur.png', // Replace 'your_image.png' with the actual path to your image asset
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            //          child: Text(
            //   'Un Livreur a votre disposition pour vos courses 24h/24 et 7/7',
            //   style: TextStyle(
            //     fontSize: 20.0,
            //     color: Colors.white,
            //   ),
            // ),
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DeliveryFormPage(),
                ),
              );
            },
            child: Icon(Icons.add),
          ),
          SizedBox(height: 20.0),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(getCurrentUser()?.uid)
                  .snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                // Utilisez DocumentSnapshot au lieu de QuerySnapshot
                if (!snapshot.hasData) {
                  return SizedBox(
                    height: Dimensions.height30,
                    child: CircularProgressIndicator(),
                  );
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
                    // if ( courseData['status'] ?? false);
                    final bool courseStatus = courseData['status'] == false;

                    // Check if the product status is true before displaying the card
                    if (courseStatus) {
                      return buildCourseCard(courseData);
                    } else {
                      // You can return an empty container or null if you don't want to display
                      return Container();
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
