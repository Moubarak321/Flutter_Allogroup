/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InterfaceFoodMarchand extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
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

            return ListView.builder(
              itemCount: commandes.length,
              itemBuilder: (context, index) {
                var commandData = commandes[index] as Map<String, dynamic>;
                var commandId = commandData['id'];
                var statut = commandData['statut'];

                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text('Commande ID: $commandId'),
                    subtitle: Text('Statut: $statut'),
                    // Ajoutez d'autres informations que vous souhaitez afficher
                    // à partir des données de la commande.
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
  
}
*/

/*
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InterfaceFoodMarchand extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return 
    Scaffold(
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

            // Récupérer les détails du marchand
            var marchandImageURL = marchandData['profileImageUrl'];
            var marchandName = marchandData['fullName'];
            var marchandDescription = marchandData['descriptionboutique'];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Afficher les détails du marchand avec son image et nom
                Container(
                  height: 300, // ou tout autre hauteur souhaitée pour l'image
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(marchandImageURL),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        color: Colors.black.withOpacity(0.5),
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          marchandName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                // Afficher la description du marchand
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    marchandDescription,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(height: 10),
                // Afficher la liste des commandes
                Expanded(
                  child: ListView.builder(
                    itemCount: commandes.length,
                    itemBuilder: (context, index) {
                      var commandData = commandes[index] as Map<String, dynamic>;
                      var commandId = commandData['id'];
                      var statut = commandData['statut'];

                      return Card(
                        margin: EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text('Commande ID: $commandId'),
                          subtitle: Text('Statut: $statut'),
                          // Ajoutez d'autres informations que vous souhaitez afficher
                          // à partir des données de la commande.
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}*/

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
                      width: double.infinity,
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
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      var commandData =
                          commandes[index] as Map<String, dynamic>;
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
                          margin: EdgeInsets.only(
                            left: Dimensions.width20,
                            right: Dimensions.width20,
                            bottom: Dimensions.height10,
                          ),
                          child: Row(
                            children: [
                              // =============== image section ===============
                              Container(
                                width: Dimensions.listViewImgSize, //120
                                height: Dimensions.listViewImgSize, //120
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radius20),
                                  color: Color(0x61FFFFFF),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(image),
                                  ),
                                ),
                              ),

                              // =============== Text section ===============
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Get.defaultDialog(
                                      title: "Informations sur la livraison",
                                      middleText:
                                          "Livraison de $quantite $titre à $adresseClient pour le $numeroClient ce $formattedDate",
                                      backgroundColor: Colors.orange,
                                      titleStyle:
                                          TextStyle(color: Colors.white),
                                      middleTextStyle:
                                          TextStyle(color: Colors.white),
                                      radius: 30,
                                      confirm: OutlinedButton(
                                        onPressed: () {
                                          // Action à effectuer lorsque le bouton "Mon Livreur" est appuyé
                                          Get.back();
                                          // Votre code pour l'action du bouton "Mon Livreur" ici
                                        },
                                        child: const Text(
                                          "Mon Livreur",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      cancel: OutlinedButton(
                                        onPressed: () {
                                          // Action à effectuer lorsque le bouton "Autre" est appuyé
                                          Get.back();
                                          // Votre code pour l'action du bouton "Autre" ici
                                        },
                                        child: const Text(
                                          "Allo Livreur",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height:
                                        Dimensions.listViewTextContSize, //100
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(
                                            Dimensions.radius20),
                                        bottomRight: Radius.circular(
                                            Dimensions.radius20),
                                      ),
                                      color: Colors.white,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        left: Dimensions.width10,
                                        right: Dimensions.width10,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          BigText(
                                            text: titre,
                                          ),
                                          SizedBox(
                                            height: Dimensions.height10,
                                          ),
                                          SmallText(text: formattedDate),
                                          SizedBox(
                                            height: Dimensions.height10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              IconAndTextWidget(
                                                icon: Icons
                                                    .monetization_on_rounded,
                                                text: prix + " FCFA",
                                                iconColor: Colors.orange,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  /*Get.snackbar("Infos",
                                                      "Ce produit vous sera livré dans environ $duree min");*/ ////
                                                },
                                                child: IconAndTextWidget(
                                                  icon: Icons.balance_rounded,
                                                  text: quantite,
                                                  iconColor: Colors.red,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Get.snackbar("Infos",
                                                      "Ce produit est prêt à être livré.");
                                                },
                                                child: IconAndTextWidget(
                                                  icon: Icons.delivery_dining,
                                                  text: "",
                                                  iconColor: Color.fromRGBO(
                                                      10, 80, 137, 0.8),
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
                        /*ListTile(
                          title: Text('Commande ID: $commandId'),
                          subtitle: Text('Statut: $statut'),
                          // Ajoutez d'autres informations que vous souhaitez afficher
                          // à partir des données de la commande.
                        ),*/
                      );
                    },
                    childCount: commandes.length,
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
