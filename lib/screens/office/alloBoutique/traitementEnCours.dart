import 'package:allogroup/screens/office/components/function.dart';
import 'package:allogroup/screens/office/widgets/app_icon.dart';
import 'package:allogroup/screens/office/widgets/big_text.dart';
import 'package:allogroup/screens/office/widgets/dimensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:allogroup/screens/office/widgets/small_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

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

  Future<dynamic> GetProductFromCart() async {
    try {
      List<Map<String, dynamic>> products = [];

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('boutiques')
          .doc(user?.uid)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        List<dynamic> cart = userData['traitement'] as List;

        for (var cartItem in cart) {
          products.add(cartItem);
        }
      }

      if (products.isEmpty) {
        return "Le panier est vide";
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

  Future<void> validerLivraison(Map<String, dynamic> article) async {
    try {
      final User? user = getCurrentUser();
      if (user != null) {
        // Remove the product from "traitement"
        await FirebaseFirestore.instance
            .collection('boutiques')
            .doc(user.uid)
            .update({
          'traitement': FieldValue.arrayRemove([article])
        });

        // Add the product to "livraison"
        await FirebaseFirestore.instance
            .collection('boutiques')
            .doc(user.uid)
            .update({
          'livraison': FieldValue.arrayUnion([article])
        });

        // Show confirmation popup
        Get.defaultDialog(
          title: "Super",
          middleText: "Cette commande a été validée pour la livraison .",
          confirm: ElevatedButton(
            onPressed: () {
              Get.back();
              Get.offAndToNamed('/traitementEnCours');
            },
            child: Text("OK"),
          ),
        );

        // Refresh the product list
        fetchProductsFromCart();
      }
    } catch (e) {
      print('Error during validation: $e');
    }
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
                Navigator.pop(context);
              },
              child: AppIcon(
                icon: Icons.arrow_back,
                backgroundColor: Color(0xCC0A5089),
                iconColor: Colors.white,
              ),
            ),
            Text("En cours de traitement",
                style: TextStyle(
                    color: Colors.white, fontSize: Dimensions.height20)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                  var title = article['titre'];
                  var imageUrl = article['image'];
                  var qte = article['quantite'];
                  var paye = article['paye'];
                  var adresseLivraison = article["lieuLivraison"];
                  var numeroLivraison = article["numeroLivraison"];
                  final dateLivraison = article["dateLivraison"];
                  final date = DateTime.fromMillisecondsSinceEpoch(
                      dateLivraison.seconds * 1000);
                  final formattedDate =
                      DateFormat('EEEE d MMMM y, HH:mm:ss', 'fr_FR')
                          .format(date);

                  return SingleChildScrollView(
                    child: GestureDetector(
                      onTap: () {
                        Get.defaultDialog(
                          title: "Confirmation",
                          middleText:
                              "$qte $title à livrer ce $formattedDate à $adresseLivraison pour le $numeroLivraison ",
                          confirm: ElevatedButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Text("OK"),
                          ),
                        );
                      },
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
                                    topRight:
                                        Radius.circular(Dimensions.radius20),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      BigText(
                                        text: title,
                                      ),
                                      SmallText(
                                        text: "$paye FCFA",
                                        size: Dimensions.font20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(
                                                top: Dimensions.height10,
                                                bottom: Dimensions.height10,
                                                right: Dimensions.width20),
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
                                                SizedBox(
                                                  width: Dimensions.width10 / 2,
                                                ),
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
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        Dimensions.radius20),
                                                color: Color.fromRGBO(
                                                    10, 80, 137, 0.8),
                                              ),
                                              child: GestureDetector(
                                                onTap: () {
                                                  validerLivraison(article);
                                                },
                                                child: Icon(
                                                  Icons.done_all,
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
