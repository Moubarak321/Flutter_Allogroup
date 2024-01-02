import 'package:allogroup/screens/office/allolivreur/courseLivreur.dart';
import 'package:allogroup/screens/office/allolivreur/detailsOnLivreur.dart';
import 'package:allogroup/screens/office/widgets/app_icon.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:allogroup/screens/office/widgets/dimensions.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InterFaceLivreurChampion extends StatefulWidget {
  @override
  _InterFaceLivreurChampionState createState() =>
      _InterFaceLivreurChampionState();
}

class _InterFaceLivreurChampionState extends State<InterFaceLivreurChampion> {
  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  Future<void> envoiProfilcourse(Map<String, dynamic> courseData) async {
    try {
      final User? user = getCurrentUser();
      if (user != null) {
        // Récupérer le document de l'utilisateur dans la collection "champions"
        final DocumentSnapshot userData = await FirebaseFirestore.instance
            .collection('champions')
            .doc(user.uid)
            .get();

        // Vérifier si le document de l'utilisateur existe
        if (userData.exists) {
          final Map<String, dynamic>? championData =
              userData.data() as Map<String, dynamic>?;

          if (championData != null) {
            final Map<String, dynamic> champion = {
              "photo": championData['profileImageUrl'] ?? '',
              "numero": championData['phoneNumber'] ?? '',
              "fullName": championData['fullName'] ?? '',
            };

            final Map<String, dynamic> combinedData = {
              ...champion,
              ...courseData,
            };

            List<Map<String, dynamic>> userCourses = [];
            userCourses.add(combinedData);
            //print(userCourses);
            // Ajouter les données de la course terminée à la collection 'users'
            await FirebaseFirestore.instance
                .collection('users')
                .doc(courseData['commandaire'])
                .update({
              'coursesTermine': FieldValue.arrayUnion(userCourses),
            });
          }
        }
      }
    } catch (error) {
      print(
          'Erreur lors de l\'envoi des données du profil de l\'utilisateur : $error');
      // Gérer l'erreur ici
    }
  }

  Future<bool> checkIfUserIsChampion() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          // Vérifier si l'utilisateur a le champ "role" égal à "Champion"
          Map<String, dynamic>? userData =
              userDoc.data() as Map<String, dynamic>?;

          if (userData != null && userData.containsKey('role')) {
            var role = userData['role'];
            if (role == 'Champion') {
              // L'utilisateur a le rôle de champion
              return true;
            }
          }
        }
      } catch (e) {
        // print('Erreur lors de la récupération du rôle de champion : $e');
      }
    }

    return false;
  }

  Future<bool> isUserEligibleForCourse(int coursePrice) async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        final userData = userDoc.data();

        if (userData != null && userData.containsKey('wallet')) {
          final int walletAmount = userData['wallet'];

          // Vérifier si le montant dans le wallet est suffisant pour la course
          if (walletAmount >= coursePrice) {
            // Vérifier s'il n'y a pas de cours en instance dans le champ 'courses' du document 'champions'
            final champDoc = await FirebaseFirestore.instance
                .collection('champions')
                .doc(user.uid)
                .get();
            final champData = champDoc.data();

            if (champData != null && champData.containsKey('commandes')) {
              final List<dynamic> userCourses = champData['commandes'];

              if (userCourses.isEmpty) {
                var commision = coursePrice * 0.2;
                int roundedCommission = (commision).toInt();
                // Mettre à jour le wallet de l'utilisateur dans Firestore
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .update({
                  'wallet': walletAmount - roundedCommission,
                });
                return true;
              } else {
                // print('L\'utilisateur a des cours en instance');
                return false;
              }
            } else {
              // print('Champ "courses" manquant dans le document de champion');
              return false;
            }
          } else {
            // print('Solde insuffisant dans le portefeuille');
            return false;
          }
        } else {
          // print('Champ "wallet" manquant dans le document de l\'utilisateur');
          return false;
        }
      } catch (error) {
        // print(
        // 'Erreur lors de la vérification de l\'éligibilité de l\'utilisateur : $error');
        return false; // Erreur lors de la récupération des données de l'utilisateur
      }
    } else {
      // print('Utilisateur non authentifié');
      return false; // Utilisateur non authentifié
    }
  }

  Future<void> validerCourse(Map<String, dynamic> courseData) async {
    final User? user = getCurrentUser();

    if (user != null) {
      try {
        // Récupérer le document de l'utilisateur dans la collection "champions"
        final userDoc =
            FirebaseFirestore.instance.collection('champions').doc(user.uid);

        // Obtenir les données du document utilisateur
        final userData = await userDoc.get();

        // Vérifier si le document de l'utilisateur existe
        if (userData.exists) {
          // Accéder à la clé "commandes" du document utilisateur
          List<dynamic>? userCourses = userData.get('commandes');

          // Vérifier si la liste des commandes existe
          userCourses ??= [];
           
          print("les courses en  données");
          print(courseData);
          String titre = 'Livraison';
          String body = 'Votre livreur est en route';
          print(
              'courseData--------------------------- ${courseData["fcmToken"]}');
          sendNotificationToClient(courseData['fcmToken'], titre, body); 

          // Ajouter les données de la course à la liste des commandes de l'utilisateur
          userCourses.add(courseData);

          // Mettre à jour le document utilisateur avec la liste mise à jour des commandes
          await userDoc.update({'commandes': userCourses});

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
          // print('Document utilisateur non trouvé');
        }
      } catch (error) {
        // print('Erreur lors de la validation de la course : $error');
      }
    } else {
      // print('Utilisateur non authentifié');
    }
  }

  Future<void> sendNotificationToClient(
      String token, String body, String title) async {
    try {
      final String serverKey =
          "AAAAhN35nhQ:APA91bEABl_ccVcCigFgN6QOrpgFvdEbyzxtTsDSGhy2BN8IUGd_Pfkeeaj5CkDeygLZBB2Bn5PRYqQesDsRVwab9EcgYtFklvKVSTX0d9xOH44g3VqHXxQv1IBmxHsw6nGg_WGG9EUV";

      final Map<String, dynamic> data = {
        'priority': 'high',
        'notification': {
          'title': title,
          'body': body,
        },
        'data': {
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'status': 'done',
        },
        'to': token,
      };

      final String jsonBody = jsonEncode(data);

      final http.Response response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
        body: jsonBody,
      );

      if (response.statusCode == 200) {
        print('Notification envoyée avec succès à $token');
      } else {
        print(
            'Échec de l\'envoi de la notification à $token. Statut : ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur lors de l\'envoi de la notification : $e');
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
    final commission = courseData['prix'] * 0.2;
    final livraison = courseData['dateDeLivraison'];
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
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Ticket de livraison",
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
            'Zone de récupération: $adresseRecuperation',
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          ),
          Text(
            'Destinataire: $adresseLivraison',
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
            '20% de commission Allô Group: $commission FCFA',
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              bool isEligible =
                  await isUserEligibleForCourse(courseData['prix']);
              if (isEligible) {
                validerCourse(courseData);

                envoiProfilcourse(courseData);
                Get.snackbar(
                    "Infos", "Vous pouvez passer à la livraison, bonne chance",
                    backgroundColor: Colors.orange, colorText: Colors.white);
              } else {
                Get.snackbar("Infos", "Vous n'êtes pas éligible pour la course",
                    backgroundColor: Colors.orange, colorText: Colors.white);
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
            Text("Des Tickets de Livraison",
                style: TextStyle(
                    color: Colors.white, fontSize: Dimensions.height20)),
            GestureDetector(
              onTap: () {
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
