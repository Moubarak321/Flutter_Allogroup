import 'package:allogroup/screens/office/allofood/traitementEnCours.dart';
import 'package:allogroup/screens/office/widgets/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../widgets/big_text.dart';
import '../widgets/icon_and_text_widget.dart';
import '../widgets/small_text.dart';

class InterfaceFoodMarchand extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  void listenForPromotionsChanges() {
    List<dynamic> previousPromotions = [];

    final User? user = FirebaseAuth.instance.currentUser;

    FirebaseFirestore.instance
        .collection('marchands')
        .doc(user!.uid)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        final adminData = snapshot.data() as Map<String, dynamic>;

        if (adminData.containsKey('commandes')) {
          List<dynamic> promotions = adminData['commandes'] ?? [];

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

  void removeFromCommandList(List<Map<String, dynamic>> commandesASupprimer, Map<String, dynamic> marchandData) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Récupérez la liste de commandes actuelle
      var commandes = marchandData['commandes'] as List<dynamic>;

      for (var commandeASupprimer in commandesASupprimer) {
        // Recherchez l'index de chaque commande à supprimer dans la liste
        int index = commandes.indexWhere((cmd) => cmd['id'] == commandeASupprimer['id']);

        if (index != -1) {
          // Enregistrez les données de la commande sous la clé 'traitement'
          Map<String, dynamic> commandeTraitement = commandes[index];
          FirebaseFirestore.instance
            .collection('marchands')
            .doc(user.uid)
            .update({'traitement': commandeTraitement}) // Enregistrez sous 'traitement'
            .then((_) {
              // Succès : données de commande enregistrées avec succès.
              print("Données de commande enregistrées avec succès sous 'traitement'");

              // Supprimez le produit spécifique de la liste
              commandes.removeAt(index);

              // Mettez à jour les données du marchand avec la liste de commandes modifiée
              FirebaseFirestore.instance
                .collection('marchands')
                .doc(user.uid)
                .update({'commandes': commandes})
                .then((_) {
                  // Succès : la suppression a été effectuée avec succès.
                  print("Commandes supprimées de la liste avec succès");
                })
                .catchError((error) {
                  // Erreur : une erreur est survenue lors de la suppression des produits.
                  print("Erreur lors de la suppression des commandes : $error");
                });
            })
            .catchError((error) {
              // Erreur : une erreur est survenue lors de l'enregistrement des données de commande.
              print("Erreur lors de l'enregistrement des données de commande : $error");
            });
        } else {
          print("La commande n'a pas été trouvée dans la liste");
        }
      }
    }
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

  void sendFormDataToDelivery(List<Map<String, dynamic>> commandes, Map<String, dynamic> marchandData) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final courseId = DateTime.now();
      final List<Map<String, dynamic>> userDataList = [];

      for (var commande in commandes) {
        var userData = {
          'id': courseId,
          'type_courses': 'Livraison de repas',
          'addressRecuperation': marchandData['adresse'],
          'numeroARecuperation': marchandData['phoneNumber'],
          'addressLivraison': commande['lieuLivraison'],
          'numeroALivraison': commande['numeroLivraison'],
          'dateDeLivraison': courseId,
          'title': "Spéciale commande restaurant",
          'details': "Cette livraison sera en deux tours.",
          'prix': 1000,
          'status': false,
        };
        userDataList.add(userData);
      }

      // Enregistrement des données de livraison dans Firestore
      FirebaseFirestore.instance
          .collection('administrateur')
          .doc("commandeCourses")
          .set({
        'courses': FieldValue.arrayUnion(userDataList),
      }, SetOptions(merge: true))
      .then((_) {
        // Succès : les données ont été enregistrées avec succès.
        print("Données enregistrées avec succès");
      })
      .catchError((error) {
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
        title: Text('Vos Commandes'),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('marchands')
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
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(
                              context); // Revenir à la page précédente
                        },
                        child: Icon(
                          Icons.clear,
                          color: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return EnCoursDeTraitement(); // Remplacez DetailPage par votre propre page.
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
                                      removeFromCommandList(commandesParAdresse, marchandData);
                                      Get.snackbar("Infos", "OK, votre champion s'occupe de la livraison");
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
                                      sendFormDataToDelivery(commandesParAdresse, marchandData);
                                      removeFromCommandList(commandesParAdresse, marchandData); 
                                      Get.snackbar("Infos", "Un Champion Allo livreur passera chercher la commande");
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
                            var prix = commandData["prix"];
                            var numeroClient = commandData["numeroLivraison"];
                            var adresseClient = commandData["lieuLivraison"];
                            var quantite = commandData["quantite"];
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
                                                SmallText(text: formattedDate),
                                                SizedBox(
                                                  height: Dimensions.height10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    IconAndTextWidget(
                                                      icon: Icons
                                                          .monetization_on_rounded,
                                                      text: prix + " FCFA",
                                                      iconColor: Colors.orange,
                                                    ),
                                                    IconAndTextWidget(
                                                      icon:
                                                          Icons.balance_rounded,
                                                      text: quantite,
                                                      iconColor: Colors.red,
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
