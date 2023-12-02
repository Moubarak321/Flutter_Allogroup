// import 'package:flutter/material.dart';

// class HistoriqueCommandesRepas extends StatefulWidget {
//   const HistoriqueCommandesRepas({super.key});

//   @override
//   State<HistoriqueCommandesRepas> createState() => _HistoriqueCommandesRepasState();
// }

// class _HistoriqueCommandesRepasState extends State<HistoriqueCommandesRepas> {
//   @override
//   Widget build(BuildContext context) {
//  return Scaffold(
//        appBar: AppBar(title: Text("Vos commandes")),

//     );  }
// }

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:intl/date_symbol_data_local.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:allogroup/screens/office/widgets/dimensions.dart';
// // import 'package:intl/date_symbol_data_local.dart';

// class EnCoursDeTraitement extends StatelessWidget {
//   User? getCurrentUser() {
//     return FirebaseAuth.instance.currentUser;
//   }

//   Widget buildCourseCard(Map<String, dynamic> courseData) {
//     // Initialisez la localisation française
//     initializeDateFormatting('fr_FR', null);

//     // final boutique = courseData['boutique'];
//     // final categorie = courseData['categorie'];
//     final prix = courseData['prix'];
//     final quantite = courseData['quantite'];
//     final titre = courseData['titre'];
//     // final livraison = courseData['dateLivraison'];
//     final livraison = courseData['dateLivraison'];
//     final date = DateTime.fromMillisecondsSinceEpoch(livraison.seconds * 1000);
//     final formattedDate =
//         DateFormat('EEEE d MMMM y, HH:mm:ss', 'fr_FR').format(date);

//     return Container(
//       width: double.infinity,
//       margin: EdgeInsets.all(8.0),
//       padding: EdgeInsets.all(20.0),
//       decoration: BoxDecoration(
//         boxShadow: [
//           BoxShadow(
//             color: Color(0xFFe8e8e8),
//             blurRadius: 5.0,
//             offset: Offset(0, 5),
//           ),
//           BoxShadow(
//             color: Colors.white,
//             offset: Offset(-5, 0),
//           ),
//           BoxShadow(
//             color: Colors.white,
//             offset: Offset(5, 0),
//           ),
//         ],
//         color: Colors.orange,
//         // border: Border.all(color: Colors.blue),
//         borderRadius: BorderRadius.circular(8.0),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Text(
//             "Bilan d'un achat",
//             style: TextStyle(fontSize: 18.0, color: Colors.white),
//           ),

//           Text(
//             'Article: $titre',
//             style: TextStyle(fontSize: 18.0, color: Colors.white),
//           ),

//           Text(
//             'Prix unitaire: $prix FCFA',
//             style: TextStyle(fontSize: 18.0, color: Colors.white),
//           ),
//           Text(
//             'Quantité: $quantite',
//             style: TextStyle(fontSize: 18.0, color: Colors.white),
//           ),
//           Text(
//             'Date de livraison: $formattedDate',
//             style: TextStyle(fontSize: 18.0, color: Colors.white),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Vos commandes'),
//       ),
//       body: Column(
//         children: <Widget>[
//           Container(
//             padding: EdgeInsets.only(
//                 right: Dimensions.width20, left: Dimensions.width20),
//                 color: Colors.blue,
//             height: 100,
//             child: Center(
//               child: Text(
//                 'Tous vos achats',
//                 style: TextStyle(
//                   fontSize: 20.0,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: StreamBuilder(
//               stream: FirebaseFirestore.instance
//                   .collection('marchands')
//                   .doc(getCurrentUser()?.uid)
//                   .snapshots(),
//               builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//                 if (!snapshot.hasData) {
//                   return CircularProgressIndicator();
//                 }

//                 final userData = snapshot.data!.data() as Map<String, dynamic>;
//                 if (!userData.containsKey('traitement')) {
//                   return Center(
//                     child: Text(
//                       "Aucun produit",
//                       style: TextStyle(
//                         fontSize: 20.0,
//                       ),
//                     ),
//                   );
//                 }

//                 final courses = userData['traitement'] as Map<String, dynamic>;
//                 print("courses...................$courses");

//                 if (courses.isEmpty) {
//                   return Center(
//                     child: Text(
//                       "Aucun produit",
//                       style: TextStyle(
//                         fontSize: 20.0,
//                       ),
//                     ),
//                   );
//                 }

//                 return ListView.builder(
//                   scrollDirection: Axis.vertical,
//                   itemCount: courses.length,
//                   itemBuilder: (context, index) {
//                     final courseData =
//                         courses[index] as Map<String, dynamic>;

//                     return buildCourseCard(courseData);
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:intl/date_symbol_data_local.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:allogroup/screens/office/widgets/dimensions.dart';

// class EnCoursDeTraitement extends StatelessWidget {
//   User? getCurrentUser() {
//     return FirebaseAuth.instance.currentUser;
//   }

//   @override
//   Widget build(BuildContext context) {
//     initializeDateFormatting('fr_FR', null);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Vos commandes'),
//       ),
//       body: Column(
//         children: <Widget>[
//           Container(
//             padding: EdgeInsets.only(
//               right: Dimensions.width20,
//               left: Dimensions.width20,
//             ),
//             color: Colors.blue,
//             height: 100,
//             child: Center(
//               child: Text(
//                 'Tous vos achats',
//                 style: TextStyle(
//                   fontSize: 20.0,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: StreamBuilder(
//               stream: FirebaseFirestore.instance
//                   .collection('marchands')
//                   .doc(getCurrentUser()?.uid)
//                   .snapshots(),
//               builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 }

//                 if (!snapshot.hasData || !snapshot.data!.exists) {
//                   return Center(
//                     child: Text(
//                       "Aucun produit",
//                       style: TextStyle(
//                         fontSize: 20.0,
//                       ),
//                     ),
//                   );
//                 }

//                 final userData = snapshot.data!.data() as Map<String, dynamic>;
//                 if (!userData.containsKey('traitement') ||
//                     userData['traitement'] == null) {
//                   return Center(
//                     child: Text(
//                       "Aucun produit",
//                       style: TextStyle(
//                         fontSize: 20.0,
//                       ),
//                     ),
//                   );
//                 }

//                 final courses = userData['traitement'] as Map<String, dynamic>;

//                 if (courses.isEmpty) {
//                   return Center(
//                     child: Text(
//                       "Aucun produit",
//                       style: TextStyle(
//                         fontSize: 20.0,
//                       ),
//                     ),
//                   );
//                 }

//                 return ListView.builder(
//                   scrollDirection: Axis.vertical,
//                   itemCount: courses.length,
//                   itemBuilder: (context, index) {
//                     final courseData = courses[index] as Map<String, dynamic>;

//                     return buildCourseCard(courseData);
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildCourseCard(Map<String, dynamic> courseData) {
//     final prix = courseData['prix'];
//     final quantite = courseData['quantite'];
//     final titre = courseData['titre'];
//     final livraison = courseData['dateLivraison'];
//     final date = DateTime.fromMillisecondsSinceEpoch(livraison.seconds * 1000);
//     final formattedDate =
//         DateFormat('EEEE d MMMM y, HH:mm:ss', 'fr_FR').format(date);

//     return Container(
//       width: double.infinity,
//       margin: EdgeInsets.all(8.0),
//       padding: EdgeInsets.all(20.0),
//       decoration: BoxDecoration(
//         boxShadow: [
//           BoxShadow(
//             color: Color(0xFFe8e8e8),
//             blurRadius: 5.0,
//             offset: Offset(0, 5),
//           ),
//           BoxShadow(
//             color: Colors.white,
//             offset: Offset(-5, 0),
//           ),
//           BoxShadow(
//             color: Colors.white,
//             offset: Offset(5, 0),
//           ),
//         ],
//         color: Colors.orange,
//         borderRadius: BorderRadius.circular(8.0),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Text(
//             "Bilan d'un achat",
//             style: TextStyle(fontSize: 18.0, color: Colors.white),
//           ),
//           Text(
//             'Article: $titre',
//             style: TextStyle(fontSize: 18.0, color: Colors.white),
//           ),
//           Text(
//             'Prix unitaire: $prix FCFA',
//             style: TextStyle(fontSize: 18.0, color: Colors.white),
//           ),
//           Text(
//             'Quantité: $quantite',
//             style: TextStyle(fontSize: 18.0, color: Colors.white),
//           ),
//           Text(
//             'Date de livraison: $formattedDate',
//             style: TextStyle(fontSize: 18.0, color: Colors.white),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:allogroup/screens/office/components/function.dart';
import 'package:allogroup/screens/office/widgets/app_icon.dart';
import 'package:allogroup/screens/office/widgets/big_text.dart';
import 'package:allogroup/screens/office/widgets/dimensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:allogroup/screens/office/widgets/small_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EnCoursDeTraitement extends StatefulWidget {
  const EnCoursDeTraitement({super.key});

  @override
  State<EnCoursDeTraitement> createState() => _EnCoursDeTraitementState();
}

class _EnCoursDeTraitementState extends State<EnCoursDeTraitement> {
  bool isLoading = true;
  String? error;
  late String total;
  List<Map<String, dynamic>> tousLesProduits = [];
  List<Map<String, dynamic>> commandes = [];

  String getTotalPrice() {
    int totalPrice = calculateTotalPrice();
    return "$totalPrice F";
  }

  Future<dynamic> GetProductFromCart() async {
    try {
      List<Map<String, dynamic>> products = [];

      // Accédez au document de l'utilisateur
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('marchands')
          .doc(user?.uid)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        List<dynamic> cart = userData['traitement'] as List;

        for (var cartItem in cart) {
          // if (cartItem['status'] == false) {
          products.add(cartItem);
          // }
        }
      }

      if (products.isEmpty) {
        return "Le panier est vide"; // Retourne un texte si le panier est vide
      }

      return products;
    } catch (e) {
      return null;
    }
  }

  Future<void> fetchProductsFromCart() async {
    try {
      List<Map<String, dynamic>>? products = await GetProductFromCart();
      setState(() {
        tousLesProduits = products!;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  

  int calculateTotalPrice() {
    int totalPrice = 0;
    for (var product in tousLesProduits) {
      var prix = product['prix'];
      var qte = product['quantite'];
      var intQuantite = int.parse(qte);
      var intPrix = int.parse(prix);
      var sousTotal = intQuantite * intPrix;
      totalPrice += sousTotal;
    }
    return totalPrice;
  }

  @override
  void initState() {
    super.initState();
    fetchProductsFromCart();
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
            Text("Commandes traitées"),
            // GestureDetector(
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => Utilisateur(),
            //       ),
            //     );
            //   },
            //   child: AppIcon(
            //     icon: Icons.delivery_dining_sharp,
            //     backgroundColor: Color(0xCC0A5089),
            //     iconColor: Colors.white,
            //   ),
            // ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Votre avoir est de ${getTotalPrice()}",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange),
              ),
            ),
            if (isLoading)
              Center(
                child: CircularProgressIndicator(),
              )
            else if (error != null)
              Center(
                child: Text("Une erreur s'est produite : $error"),
              )
            else
              // Expanded(
      
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: tousLesProduits.length,
                itemBuilder: (context, index) {
                  var article = tousLesProduits[index];
                  // var categorie = article['categorie'];
                  var title = article['titre'];
                  var imageUrl = article['image'];
                  var prix = article['prix'];
                  var qte = article['quantite'];
                  var intQuantite = int.parse(qte);
                  var intPrix = int.parse(prix);
                  var sousTotal = intQuantite * intPrix;
                  return SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.only(
                          left: Dimensions.width20,
                          right: Dimensions.width20,
                          bottom: Dimensions.height10),
                      child: Row(
                        children: [
                          // =============== image section ===============
                          Container(
                            width: Dimensions.listViewImgSize, //120
                            height: Dimensions.listViewImgSize, //120
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(Dimensions.radius20),
                              color: Colors.white38,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(imageUrl),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: Dimensions.height30,
                          ),
                          // =============== Text section ===============
                          Expanded(
                            child: Container(
                              height: Dimensions.listViewTextContSize, //100
                              // width: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(Dimensions.radius20),
                                  bottomRight:
                                      Radius.circular(Dimensions.radius20),
                                ),
                                color: Colors.white,
                              ),
      
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: Dimensions.width10,
                                    right: Dimensions.width10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    BigText(
                                      text: title,
                                    ),
                                    // SizedBox(
                                    //   height: Dimensions.height10,
                                    // ),
                                    SmallText(
                                      text: prix + " FCFA",
                                      size: Dimensions.font20,
                                    ),
                                    // SizedBox(
                                    //   height: Dimensions.height10,
                                    // ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                              top: Dimensions.height10,
                                              bottom: Dimensions.height10,
                                              // left: Dimensions.width20,
                                              right: Dimensions.width20),
                                          // decoration: BoxDecoration(
                                          //   borderRadius: BorderRadius.circular(
                                          //       Dimensions.radius20),
                                          //   color: const Color.fromARGB(255, 245, 4, 4),
                                          // ),
                                          child: Row(
                                            children: [
                                              SmallText(
                                                  text: "Nbre ",
                                                  size: Dimensions.font20,
                                                  color: Colors.orange),
                                              SmallText(
                                                  text: qte,
                                                  size: Dimensions.font20,
                                                  color: const Color.fromARGB(
                                                      255, 139, 105, 52)),
      
                                              SizedBox(
                                                width: Dimensions.width10 / 2,
                                              ),
                                              SmallText(
                                                  text: "~",
                                                  size: Dimensions.font20),
                                              SmallText(
                                                  text: " $sousTotal F",
                                                  size: Dimensions.font20),
                                              // BigText(text: quantity.toString()),
                                              SizedBox(
                                                width: Dimensions.width10 / 2,
                                              ),
                                              // GestureDetector(
                                              //   onTap: () {
                                              //     print("increment");
                                              //     // setQuantity(true);
                                              //   },
                                              //   child: Icon(
                                              //     Icons.add,
                                              //     color:
                                              //         Color.fromRGBO(10, 80, 137, 0.8),
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          
                                          child: Container(
                                            padding: EdgeInsets.only(
                                                top: Dimensions.height10,
                                                bottom: Dimensions.height10,
                                                left: Dimensions.width10,
                                                right: Dimensions.width10),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(
                                                  Dimensions.radius20),
                                              color: Color.fromRGBO(
                                                  10, 80, 137, 0.8),
                                            ),
                                            child: GestureDetector(
                                              
                                              child: Icon(
                                                Icons.sticky_note_2_outlined,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
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
      ),
    );
  }
}
