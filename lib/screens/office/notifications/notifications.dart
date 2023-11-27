import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:allogroup/screens/office/widgets/dimensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:allogroup/screens/office/notifications/detailsnotifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Notifications extends StatelessWidget {
  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  void listenForPromotionsChanges() {
    List<dynamic> previousPromotions = [];
    FirebaseFirestore.instance
        .collection('administrateur')
        .doc('admin')
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        final adminData = snapshot.data() as Map<String, dynamic>;

        if (adminData.containsKey('promotion')) {
          List<dynamic> promotions = adminData['promotion'] ?? [];

          // Comparez les nouvelles promotions avec les anciennes pour détecter les ajouts
          List<dynamic> newPromotions =
              findNewPromotions(previousPromotions, promotions);

          // Envoyez les notifications pour les nouvelles promotions détectées
          newPromotions.forEach((newPromotion) {
            // Appelez la fonction d'envoi de notification avec les détails de la nouvelle promotion
            sendNotificationForPromotion(newPromotion);
          });

          // Mettez à jour la liste des anciennes promotions pour la prochaine comparaison
          previousPromotions = promotions;
        }
      }
    });
  }

  List<dynamic> findNewPromotions(
      List<dynamic> previousPromotions, List<dynamic> currentPromotions) {
    List<dynamic> newPromotions = [];

    // Parcourez les promotions actuelles pour trouver celles qui ne sont pas présentes dans les promotions précédentes
    for (var promotion in currentPromotions) {
      if (!previousPromotions.contains(promotion)) {
        // Ajoutez la promotion à la liste des nouvelles promotions détectées
        newPromotions.add(promotion);
      }
    }

    return newPromotions;
  }

  void sendNotificationForPromotion(dynamic promotion) async {
    // Récupérer le token FCM de chaque utilisateur pour l'envoi de la notification
    String? fcmToken = await getFCMToken();

    if (fcmToken != null) {
      // Initialiser Firebase Messaging
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      // Configurer la notification avec les détails de la promotion
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      print('User granted permission: ${settings.authorizationStatus}');
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Une nouvelle promotion est disponible : ${promotion.title}');
        print('Message data: ${message.data}');

        if (message.notification != null) {
          print(
              'Message also contained a notification: ${message.notification}');
        }
      });
    } else {
      print('Impossible d\'obtenir le token FCM de l\'utilisateur');
    }
  }

  void navigateToDetailsNotifications(
      BuildContext context, Map<String, dynamic> courseData, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              Detailsnotifications(courseData: courseData, index: index)),
    );
  }

  Future<String?> getFCMToken() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        final DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        final userData = userDoc.data();

        if (userData != null &&
            userData is Map &&
            userData.containsKey('fcmToken')) {
          final fcmToken = userData['fcmToken'];
          return fcmToken;
        } else {
          print('Champ "fcmToken" manquant dans le document de l\'utilisateur');
          return null;
        }
      } catch (error) {
        print('Erreur lors de la récupération du FCM Token: $error');
        return null;
      }
    } else {
      print('Utilisateur non authentifié');
      return null;
    }
  }

  Widget buildCourseCard(
      Map<String, dynamic> courseData, BuildContext context, int index) {
    initializeDateFormatting('fr_FR', null);

    final date = courseData['date'] != null
        ? DateTime.fromMillisecondsSinceEpoch(courseData['date'])
        : null;
    final titre = courseData['title'];

    return GestureDetector(
      onTap: () {
        navigateToDetailsNotifications(context, courseData, index);
      },
      child: Container(
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
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Affichage du titre
            Text(
              titre ?? "",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),

            // Affichage de l'image
            /*if (image != null && image.isNotEmpty)
              Image.network(
                image,
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
              ),*/
            //SizedBox(height: 10),

            // Affichage de la date
            if (date != null)
              Text(
                DateFormat.yMMMMEEEEd('fr_FR').format(date),
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                ),
              ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                right: Dimensions.width20, left: Dimensions.width20),
            height: 100,
            decoration: BoxDecoration(
              color: Colors.blue, // Couleur d'arrière-plan en bleu
            ),
            child: Center(
              child: Text(
                'Quoi de neuf ?',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white, // Couleur du texte en blanc
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('administrateur')
                  .doc('admin')
                  .snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.data() == null) {
                  return Center(
                    child: Text(
                      "Aucune donnée disponible",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  );
                }

                final userData = snapshot.data!.data() as Map<String, dynamic>;

                if (!userData.containsKey('promotion')) {
                  return Center(
                    child: Text(
                      "Aucune promotion disponible",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  );
                }

                final courses = userData['promotion'] as List<dynamic>;

                return ListView.builder(
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final courseData = courses[index] as Map<String, dynamic>;
                    return buildCourseCard(courseData, context, index);
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
