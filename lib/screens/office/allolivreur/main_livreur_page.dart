import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart'; 
import './description_livreur.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Delivery extends StatelessWidget {
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
    final timestamp = courseData['id'];
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
    final formattedDate = DateFormat('EEEE d MMMM y, HH:mm:ss', 'fr_FR').format(date);


    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.orange, 
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(8.0),
        
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Bilan d'une course",
            style: TextStyle(fontSize: 18.0, color: Colors.black),
          ),
          Text(
            'Date de commande : $formattedDate',
            style: TextStyle(fontSize: 18.0, color: Colors.blue),
          ),
          Text(
            'Adresse de Récupération: $addressRecuperation',
            style: TextStyle(fontSize: 18.0, color: Colors.blue),
          ),
          Text(
            'Adresse de Livraison: $addressLivraison',
            style: TextStyle(fontSize: 18.0, color: Colors.blue),
          ),
          Text(
            'Type de Livraison: $typeLivraison',
            style: TextStyle(fontSize: 18.0, color: Colors.blue),
          ),
          Text(
            'Titre: $title',
            style: TextStyle(fontSize: 18.0, color: Colors.blue),
          ),
          Text(
            'Prix: $depense',
            style: TextStyle(fontSize: 18.0, color: Colors.blue),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Allô Livreur'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            color: Colors.blue,
            height: 200,
            child: Center(
              child: Text(
                'Un Livreur a votre disposition pour vos courses 24h/24 et 7/7',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
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
            child: Text('Commencez une course'),
          ),
          SizedBox(height: 20.0),
          Text(
            'Consultez vos courses antérieurs',
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.orange,
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
                      "Vous n'avez pas encore de courses",
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.orange,
                      ),
                    ),
                  );
                }

                final courses = userData['courses'] as List<dynamic>;

                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final courseData = courses[index] as Map<String, dynamic>;

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
