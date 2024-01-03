import 'package:allogroup/screens/office/allofood/traitementEnCours.dart';
import 'package:allogroup/screens/office/widgets/app_icon.dart';
import 'package:allogroup/screens/office/widgets/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/date_symbol_data_local.dart';
import '../widgets/big_text.dart';
import '../widgets/icon_and_text_widget.dart';
import '../widgets/small_text.dart';
import 'dart:async';

class InterfaceBoutique extends StatefulWidget {
  @override
  _InterfaceBoutique createState() => _InterfaceBoutique();
}

class _InterfaceBoutique extends State<InterfaceBoutique> {
  final User? user = FirebaseAuth.instance.currentUser;

  Future<List<String>> recuperationToken() async {
    try {
      final QuerySnapshot championsSnapshot =
          await FirebaseFirestore.instance.collection('champions').get();

      List<String> tokens = [];

      championsSnapshot.docs.forEach((DocumentSnapshot document) {
        final Map<String, dynamic>? championData =
            document.data() as Map<String, dynamic>?;

        if (championData != null && championData.containsKey('fcmToken')) {
          final String? fmcToken = championData['fcmToken'] as String?;
          if (fmcToken != null) {
            tokens.add(fmcToken);
          }
        }
      });

      return tokens;
    } catch (e) {
      // Gérer les erreurs ici
      print('Erreur lors de la récupération des tokens : $e');
      return []; // Retourner une liste vide en cas d'erreur
    }
  }

  Future<void> sendNotificationToChampion(
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

  void sendNotificationLivraison() async {
    List<String> tokens = await recuperationToken();
    String titre = "Livraison";
    String body = "Une nouvelle livraison est disponible";
    for (String token in tokens) {
      sendNotificationToChampion(token, titre, body);
    }
  }

  Future<void> removeFromCommandList(
    List<Map<String, dynamic>> commandesASupprimer,
    Map<String, dynamic> marchandData,
  ) async {
    final User? user = FirebaseAuth.instance.currentUser;
    initializeDateFormatting('fr_FR', null);

    if (user != null) {
      final currentTime = DateTime.now();
      final List<Map<String, dynamic>> commandes =
          List.from(marchandData['commandes']);

      for (var commandeASupprimer in commandesASupprimer) {
        // Recherchez l'index de chaque commande à supprimer dans la liste
        int index = commandes
            .indexWhere((cmd) => cmd['id'] == commandeASupprimer['id']);

        if (index != -1) {
          final deliveryTime = DateTime.fromMillisecondsSinceEpoch(
              commandes[index]['dateLivraison'].millisecondsSinceEpoch);

          final currentTimeInSeconds =
              currentTime.millisecondsSinceEpoch ~/ 1000;

          final deliveryTimeInSeconds =
              deliveryTime.millisecondsSinceEpoch ~/ 1000;

          final differenceInSeconds =
              (deliveryTimeInSeconds - currentTimeInSeconds).abs();

          if (differenceInSeconds < 3600) {
            // Enregistrez les données de la commande sous la clé 'traitement'
            Map<String, dynamic> commandeTraitement = commandes[index];

            try {
              await FirebaseFirestore.instance
                  .collection('boutiques')
                  .doc(user.uid)
                  .update({
                'traitement': FieldValue.arrayUnion([commandeTraitement])
              });

              // Supprimez le produit spécifique de la liste
              commandes.removeAt(index);

              // Mettez à jour les données du marchand avec la liste de commandes modifiée
              await FirebaseFirestore.instance
                  .collection('boutiques')
                  .doc(user.uid)
                  .update({'commandes': commandes});
            } catch (error) {
              print("");
            }
          } else {
            Get.snackbar("Infos",
                "Cette commande ne peut pas être livrée pour le moment.",
                backgroundColor: Colors.orange, colorText: Colors.white);
          }
        } else {
          print("");
        }
      }
    }
  }

  Map<String, List<Map<String, dynamic>>> groupCommandsByAddress(
      List<dynamic> commandes) {
    Map<String, List<Map<String, dynamic>>> commandesGroupedByAddress = {};

    for (var commande in commandes) {
      var adresseLivraison = commande['lieuLivraison'] as String;
      var numeroLivraison = commande['numeroLivraison'] as int;
      var adresseEtNumero = '$adresseLivraison - $numeroLivraison';

      if (!commandesGroupedByAddress.containsKey(adresseEtNumero)) {
        commandesGroupedByAddress[adresseEtNumero] = [commande];
      } else {
        commandesGroupedByAddress[adresseEtNumero]!.add(commande);
      }
    }

    return commandesGroupedByAddress;
  }

  void envoicommandaire(
      List<Map<String, dynamic>> commandes, Map<String, dynamic> marchandData) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final courseId = DateTime.now();
      final List<Map<String, dynamic>> userDataList = [];
      var adresseRestaurant = marchandData['adresse'];

      var userData = {
        'id': courseId,
        'type_courses': 'Livraison de produit de chez $adresseRestaurant',
        'addressRecuperation': marchandData['adresse'],
        'numeroARecuperation': marchandData['phoneNumber'],
        'addressLivraison': commandes[0]['lieuLivraison'],
        'numeroALivraison': commandes[0]['numeroLivraison'],
        'commandaire': commandes[0]['commandaire'],
        'dateDeLivraison': courseId,
        'title': commandes[0]['titreLivraison'],
        'details': commandes[0]['detailsLivraison'],
        'prix': commandes[0]['prix'],
        'status': false,
        "password": marchandData["password"]
      };
      userDataList.add(userData);
      // Enregistrement des données de livraison dans Firestore
      FirebaseFirestore.instance
          .collection('users')
          .doc(commandes[0]['commandaire'])
          .set({
        'coursesBoutique': FieldValue.arrayUnion(userDataList),
      }, SetOptions(merge: true)).then((_) {
        String titre = "Commande";
        String body =
            "Votre commande est en cours de traitement par ${marchandData['fullName']}";
        sendNotificationToChampion(commandes[0]['fcmToken'], titre, body);
      }).catchError((error) {
        // Erreur : une erreur est survenue lors de l'enregistrement des données.
        print("Erreur lors de l'enregistrement des données : $error");
      });
    }
  }

  void sendFormDataToDelivery(
      List<Map<String, dynamic>> commandes, Map<String, dynamic> marchandData) {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final courseId = DateTime.now();
      final List<Map<String, dynamic>> userDataList = [];
      var adresseRestaurant = marchandData['adresse'];
      var userData = {
        'id': courseId,
        'commandaire': commandes[0]['commandaire'],
        'type_courses': 'Livraison de repas de chez $adresseRestaurant',
        'addressRecuperation': marchandData['adresse'],
        'numeroARecuperation': marchandData['phoneNumber'],
        'addressLivraison': commandes[0]['lieuLivraison'],
        'numeroALivraison': commandes[0]['numeroLivraison'],
        'dateDeLivraison': courseId,
        'title': commandes[0]['titreLivraison'],
        'details': commandes[0]['detailsLivraison'],
        'prix': commandes[0]['prix'],
        'status': false,
        "password": marchandData["password"]
      };
      userDataList.add(userData);

      // Enregistrement des données de livraison dans Firestore
      FirebaseFirestore.instance
          .collection('administrateur')
          .doc("commandeCourses")
          .set({
        'courses': FieldValue.arrayUnion(userDataList),
      }, SetOptions(merge: true)).then((_) {
        // Succès : les données ont été enregistrées avec succès.
        // print("Données enregistrées avec succès");
        //sendNotificationForPromo();
      }).catchError((error) {
        // Erreur : une erreur est survenue lors de l'enregistrement des données.
        print("Erreur lors de l'enregistrement des données : $error");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('fr_FR', null);

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
            Text("Vos commandes",
                style: TextStyle(
                    color: Colors.white, fontSize: Dimensions.height20)),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return EnCoursDeTraitement();
                    },
                  ),
                );
              },
              child: Icon(
                Icons.bar_chart_rounded,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('boutiques')
            .doc(user?.uid)
            .get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Erreur: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Text('Aucune donnée de marchand disponible.'),
            );
          } else {
            var marchandData = snapshot.data!.data() as Map<String, dynamic>;
            var commandes = marchandData['commandes'] as List<dynamic>;
            var commandesGroupedByAddress = groupCommandsByAddress(commandes);
            var marchandImageURL = marchandData['profileImageUrl'];
            var marchandName = marchandData['fullName'];

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  toolbarHeight: 75,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(20),
                    child: Container(
                      width: double.maxFinite,
                      padding: EdgeInsets.only(top: 5, bottom: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          marchandName,
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  pinned: true,
                  backgroundColor: Color.fromRGBO(142, 207, 250, 1),
                  expandedHeight: 300,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.network(
                      marchandImageURL,
                      width: double.maxFinite,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                ...commandesGroupedByAddress.entries.map((entry) {
                  var adresse = entry.key;
                  var commandesParAdresse = entry.value;
                  return SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Livraison à : $adresse',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.orange,
                                ),
                              ),
                              SizedBox(
                                  height:
                                      10), // Espacement entre le texte et les icônes
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // Action à effectuer pour Mon Livreur

                                      envoicommandaire(
                                          commandesParAdresse, marchandData);
                                      removeFromCommandList(
                                          commandesParAdresse, marchandData);
                                      Get.snackbar("Infos",
                                          "OK, votre champion s'occupe de la livraison",
                                          backgroundColor: Colors.orange,
                                          colorText: Colors.white);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return EnCoursDeTraitement();
                                          },
                                        ),
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        Icon(Icons
                                            .directions_bike), // Icône pour Mon Livreur
                                        Text(
                                            'Mon Livreur'), // Texte pour Mon Livreur
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                      width: 10), // Espacement entre les icônes
                                  GestureDetector(
                                    onTap: () {
                                      sendFormDataToDelivery(
                                          commandesParAdresse, marchandData);
                                      envoicommandaire(
                                          commandesParAdresse, marchandData);
                                      sendNotificationLivraison();
                                      removeFromCommandList(
                                          commandesParAdresse, marchandData);
                                      Get.snackbar("Infos",
                                          "Un Champion Allo livreur passera chercher la commande",
                                          backgroundColor: Colors.orange,
                                          colorText: Colors.white);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return EnCoursDeTraitement();
                                          },
                                        ),
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        Icon(Icons
                                            .delivery_dining), // Icône pour Allo Livreur
                                        Text(
                                            'Allo Livreur'), // Texte pour Allo Livreur
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: commandesParAdresse.length,
                          itemBuilder: (context, index) {
                            var commandData = commandesParAdresse[index];
                            var image = commandData["image"];
                            var titre = commandData["titre"];
                            var numeroClient = commandData["numeroLivraison"];
                            var adresseClient = commandData["lieuLivraison"];
                            var quantite = commandData["quantite"];
                            var paye = commandData["paye"];
                            final livraison = commandData["dateLivraison"];
                            final date = DateTime.fromMillisecondsSinceEpoch(
                                livraison.seconds * 1000);
                            final formattedDate =
                                DateFormat('EEEE d MMMM y, HH:mm:ss', 'fr_FR')
                                    .format(date);

                            return Card(
                              color: Color.fromRGBO(250, 250, 250, 1),
                              margin: EdgeInsets.all(8.0),
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: Dimensions.width20,
                                  vertical: Dimensions.height10,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: Dimensions.listViewImgSize,
                                      height: Dimensions.listViewImgSize,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          Dimensions.radius20,
                                        ),
                                        color: Color(0x61FFFFFF),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(image),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          Get.defaultDialog(
                                            title:
                                                "Information sur la livraison",
                                            middleText:
                                                "Livraison de $quantite $titre à $adresseClient pour le $numeroClient ce $formattedDate",
                                            backgroundColor: Color.fromRGBO(
                                                10, 80, 137, 0.8),
                                            titleStyle:
                                                TextStyle(color: Colors.white),
                                            middleTextStyle:
                                                TextStyle(color: Colors.white),
                                            cancel: OutlinedButton(
                                              onPressed: () {
                                                Get.back();
                                              },
                                              child: const Text(
                                                "OK",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          height:
                                              Dimensions.listViewTextContSize,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(
                                                Dimensions.radius20,
                                              ),
                                              bottomRight: Radius.circular(
                                                Dimensions.radius20,
                                              ),
                                            ),
                                            color: Colors.white,
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: Dimensions.width10,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                BigText(text: titre),
                                                SizedBox(
                                                  height: Dimensions.height10,
                                                ),
                                                SmallText(text: adresseClient),
                                                SizedBox(
                                                  height: Dimensions.height10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    IconAndTextWidget(
                                                      icon:
                                                          Icons.balance_rounded,
                                                      text: quantite,
                                                      iconColor: Colors.red,
                                                    ),
                                                    IconAndTextWidget(
                                                      icon: Icons.money_rounded,
                                                      text: "$paye F",
                                                      iconColor: Color.fromRGBO(
                                                        10,
                                                        80,
                                                        137,
                                                        0.8,
                                                      ),
                                                    ),
                                                    IconAndTextWidget(
                                                      icon:
                                                          Icons.delivery_dining,
                                                      text: "",
                                                      iconColor: Color.fromRGBO(
                                                        10,
                                                        80,
                                                        137,
                                                        0.8,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            );
          }
        },
      ),
    );
  }
}
