import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:allogroup/screens/office/widgets/dimensions.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:get/get.dart';

class HistoriqueCoursesActuelle extends StatelessWidget {
  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  Widget buildCourseCard(Map<String, dynamic> courseData) {
    // Initialisez la localisation française
    initializeDateFormatting('fr_FR', null);

    final boutique = courseData['boutique'];
    final categorie = courseData['categorie'];
    final prix = courseData['prix'];
    final quantite = courseData['quantite'];
    final titre = courseData['titre'];
    // final livraison = courseData['dateLivraison'];
    final livraison = courseData['dateLivraison'];
    final date = DateTime.fromMillisecondsSinceEpoch(livraison.seconds * 1000);
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
            "Bilan d'un achat",
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          ),
          Text(
            'Boutique : $boutique',
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          ),
          Text(
            'Article: $titre',
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          ),
          Text(
            'Catégorie: $categorie',
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          ),
          Text(
            'Prix unitaire: $prix FCFA',
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          ),
          Text(
            'Quantité: $quantite',
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          ),
          Text(
            'Date de livraison: $formattedDate',
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
            icon: const Icon(LineAwesomeIcons.angle_left)),
        title: Text('Vos commandes',
           style: TextStyle(color: Colors.white, fontSize: Dimensions.height20)),
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
                'Vos récentes courses',
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
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }

                final userData = snapshot.data!.data() as Map<String, dynamic>;
                if (!userData.containsKey('paiementBoutique')) {
                  return Center(
                    child: Text(
                      "Aucun produit",
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  );
                }

                final courses = userData['paiementBoutique'] as List<dynamic>;

                courses.sort((a, b) =>
                    b['dateLivraison'].seconds.compareTo(a['dateLivraison'].seconds));

                // Take only the first 5 courses
                final latestCourses = courses.take(5).toList();

               
                // Filter the courses list to include only those with status set to true
                // final filteredCourses = courses
                //     .where((courseData) => courseData['status'] == false)
                //     .toList();

                if (latestCourses.isEmpty) {
                  return Center(
                    child: Text(
                      "Aucun produit",
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  );
                }
                
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: latestCourses.length,
                  itemBuilder: (context, index) {
                    final courseData =
                        latestCourses[index] as Map<String, dynamic>;

                    return buildCourseCard(courseData);
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
