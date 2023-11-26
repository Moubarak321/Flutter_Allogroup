
import 'package:allogroup/screens/office/allolivreur/detailsOnLivreur.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:allogroup/screens/office/widgets/dimensions.dart';
import 'package:get/get.dart';

class InterFaceLivreurChampion extends StatelessWidget {
  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  Future<bool> isUserEligibleForCourse(double coursePrice) async {
  final User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final userData = userDoc.data();

      if (userData != null && userData.containsKey('wallet')) {
        final double walletAmount = userData['wallet'];

        // Vérifier si le montant dans le wallet est suffisant pour la course
        if (walletAmount >= coursePrice) {
          // Vérifier s'il n'y a pas de cours en instance dans le champ 'courses' du document 'champions'
          final champDoc = await FirebaseFirestore.instance
              .collection('champions')
              .doc(user.uid)
              .get();
          final champData = champDoc.data();

          if (champData != null && champData.containsKey('courses')) {
            final List<dynamic> userCourses = champData['courses'];

            if (userCourses.isEmpty) {
              // Mettre à jour le wallet de l'utilisateur dans Firestore
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .update({
                'wallet': walletAmount - coursePrice * 0.20,
              });
              return true;
            } else {
              print('L\'utilisateur a des cours en instance');
              return false;
            }
          } else {
            print('Champ "courses" manquant dans le document de champion');
            return false;
          }
        } else {
          print('Solde insuffisant dans le portefeuille');
          return false;
        }
      } else {
        print('Champ "wallet" manquant dans le document de l\'utilisateur');
        return false;
      }
    } catch (error) {
      print(
          'Erreur lors de la vérification de l\'éligibilité de l\'utilisateur : $error');
      return false; // Erreur lors de la récupération des données de l'utilisateur
    }
  } else {
    print('Utilisateur non authentifié');
    return false; // Utilisateur non authentifié
  }
}

Future<void> validerCourse(Map<String, dynamic> courseData) async {   
  final User? user = getCurrentUser();
    if (user != null) {
      try {
        // Récupérer le document de l'utilisateur dans la collection "champions"
        final userDoc =
            FirebaseFirestore.instance.collection('users').doc(user.uid);

        // Obtenir les données du document utilisateur
        final userData = await userDoc.get();

        // Vérifier si le document de l'utilisateur existe
        if (userData.exists) {
          // Accéder à la clé "commandes" du document utilisateur
          List<dynamic>? userCourses = userData.get('commandesLivraison');

          // Vérifier si la liste des commandes existe
          if (userCourses == null) {
            userCourses = [];
          }

          // Ajouter les données de la course à la liste des commandes de l'utilisateur
          userCourses.add(courseData);

          // Mettre à jour le document utilisateur avec la liste mise à jour des commandes
          await userDoc.update({'commandesLivraison': userCourses});

          // Récupérer l'ID de la course
          final courseId = courseData['id'];

          // Mettre à jour le statut de la commande dans la collection "administrateur"

          // Récupérer toutes les données de la collection 'administrateur' pour mettre à jour la liste des cours
          final adminDoc = await FirebaseFirestore.instance
              .collection('administrateur')
              .doc('commandeCourses')
              .get();
          final allCourses = adminDoc.get('courses') as List<dynamic>;
          final updateCourses = List.from(allCourses);
          // Supprimer la course spécifique de la liste en fonction de l'ID
          updateCourses.removeWhere((course) =>
              course['id'] == courseId || course['status'] != false);

          // Mettre à jour la liste des cours dans la collection 'administrateur'
          await FirebaseFirestore.instance
              .collection('administrateur')
              .doc('commandeCourses')
              .update({
            'courses': updateCourses,
          });

        
          Get.to(
            DetailsOnLivraison(),
            arguments: courseData,
          );

                        
        } else {
          print('Document utilisateur non trouvé');
        }
      } catch (error) {
        print('Erreur lors de la validation de la course : $error');
      }
    } else {
      print('Utilisateur non authentifié');
    }
  }

  Widget buildCourseCard(Map<String, dynamic> courseData) {
    // Initialisez la localisation française
    initializeDateFormatting('fr_FR', null);

    final typeLivraison = courseData['type_courses'];
    final adresseRecuperation = courseData['addressRecuperation'];
    final prix = courseData['prix'];
    final adresseLivraison = courseData['addressLivraison'];
    final titre = courseData['title'];

    final livraison = courseData['dateDeLivraison'];
    final date = DateTime.fromMillisecondsSinceEpoch(livraison.seconds * 1000);
    final formattedDate =
        DateFormat('EEEE d MMMM y, HH:mm:ss', 'fr_FR').format(date);
    double commission = courseData['prix'] * 0.20;

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
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Demande de livraison",
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          ),
          Text(
            'Type de livraison : $typeLivraison',
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          ),
          Text(
            'Quoi: $titre',
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          ),
          Text(
            'Adresse de récupération: $adresseRecuperation',
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          ),
          Text(
            'Adresse de Livraison: $adresseLivraison',
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          ),
          Text(
            'Date de livraison: $formattedDate',
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          ),
          Text(
            'Prix: $prix FCFA',
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          ),
          Text(
            '20% de comission Allo Group: $commission FCFA',
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              bool isEligible =
                  await isUserEligibleForCourse(courseData['prix']);
              if (isEligible) {
                validerCourse(courseData);
                Get.snackbar(
                    "Infos", "Vous pouvez passer à la livraison, bonne chance");
              } else {
                Get.snackbar("Infos",
                    "Vous n'êtes pas éligible pour la course, veillez bien vouloir rechargez votre portefeuille");
              }
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              onPrimary: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Validez la livraison',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vos demandes'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                right: Dimensions.width20, left: Dimensions.width20),
            height: 100,
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Center(
              child: Text(
                'Propositions de livraison',
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
                  .collection('administrateur')
                  .doc('commandeCourses')
                  .snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }

                final userData = snapshot.data!.data() as Map<String, dynamic>;
                if (!userData.containsKey('courses')) {
                  return Center(
                    child: Text(
                      "Aucune courses",
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  );
                }

                final courses = userData['courses'] as List<dynamic>;

                final filteredCourses = courses
                    .where((courseData) => courseData['status'] == false)
                    .toList();

                if (filteredCourses.isEmpty) {
                  return Center(
                    child: Text(
                      "Aucune livraison",
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: filteredCourses.length,
                  itemBuilder: (context, index) {
                    final courseData =
                        filteredCourses[index] as Map<String, dynamic>;

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
