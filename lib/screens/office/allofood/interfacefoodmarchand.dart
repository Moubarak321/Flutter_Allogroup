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
  
  Map<String, List<Map<String, dynamic>>> groupCommandsByAddress(List<dynamic> commandes) {
    Map<String, List<Map<String, dynamic>>> commandesGroupedByAddress = {};

    for (var commande in commandes) {
      var adresseLivraison = commande['lieuLivraison'] as String;

      if (!commandesGroupedByAddress.containsKey(adresseLivraison)) {
        commandesGroupedByAddress[adresseLivraison] = [commande];
      } else {
        commandesGroupedByAddress[adresseLivraison]!.add(commande);
      }
    }

    return commandesGroupedByAddress;
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
            var marchandDescription = marchandData['descriptionboutique'];

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
                  backgroundColor: Color.fromRGBO(255, 81, 1, 1),
                  expandedHeight: 300,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.network(
                      marchandImageURL,
                      width: double.maxFinite,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      marchandDescription,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                // Mapping des commandes groupées par adresse en SliverList
                ...commandesGroupedByAddress.entries.map((entry) {
                  var adresse = entry.key;
                  var commandesParAdresse = entry.value;
                  return SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  'Livraison à : $adresse',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.orange,
                                  ),
                                ),
                                SizedBox(width: 10), // Espacement entre le texte et les icônes
                                GestureDetector(
                                  onTap: () {
                                    // Action à effectuer pour Mon Livreur
                                  },
                                  child: Column(
                                    children: [
                                      Icon(Icons.directions_bike), // Icône pour Mon Livreur
                                      Text('Mon Livreur'), // Texte pour Mon Livreur
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10), // Espacement entre les icônes
                                GestureDetector(
                                  onTap: () {
                                    // Action à effectuer pour Allo Livreur
                                  },
                                  child: Column(
                                    children: [
                                      Icon(Icons.delivery_dining), // Icône pour Allo Livreur
                                      Text('Allo Livreur'), // Texte pour Allo Livreur
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: commandesParAdresse.length,
                          itemBuilder: (context, i) {
                            var commandData = commandesParAdresse[i];
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
                                        title: "Information sur la livraison",
                                        middleText:
                                            "Livraison de $quantite $titre à $adresseClient pour le $numeroClient ce $formattedDate",
                                        backgroundColor: Color.fromRGBO(10, 80, 137, 0.8),
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
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      height: Dimensions.listViewTextContSize,
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
                                                  icon:
                                                      Icons.monetization_on_rounded,
                                                  text: prix + " FCFA",
                                                  iconColor: Colors.orange,
                                                ),
                                                IconAndTextWidget(
                                                  icon: Icons.balance_rounded,
                                                  text: quantite,
                                                  iconColor: Colors.red,
                                                ),
                                                IconAndTextWidget(
                                                  icon: Icons.delivery_dining,
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

              