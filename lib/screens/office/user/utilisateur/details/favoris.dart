import 'package:allogroup/screens/office/components/function.dart';
import 'package:allogroup/screens/office/widgets/big_text.dart';
import 'package:allogroup/screens/office/widgets/dimensions.dart';
import 'package:allogroup/screens/office/widgets/small_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Favoris extends StatefulWidget {
  const Favoris({super.key});

  @override
  State<Favoris> createState() => _FavorisState();
}

class _FavorisState extends State<Favoris> {
  
bool isLoading = true;
String? error;
List<Map<String, dynamic>> tousLesProduits = [];

Future<dynamic> GetProductFromCart() async {
  try {
    List<Map<String, dynamic>> products = [];

    // Accédez au document de l'utilisateur
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();

    if (userDoc.exists) {
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      List<dynamic> cart = userData['Favoris'] as List<dynamic>;

      for (var cartItem in cart) {
        products.add(cartItem);
      }
    }

    if (products.isEmpty) {
      return "Vos favoris sont vides"; // Retourne un texte si le panier est vide
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

@override
void initState() {
  super.initState();
  fetchProductsFromCart();

  // GetProductFromCart().then((products) {
  //   setState(() {
  //     tousLesProduits = products!;
  //   });
  // });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Vos Favoris")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Voici vos favoris :",
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
                  var boutique = article['boutique'];
                  // var intQuantite = int.parse(qte);
                  // var intPrix = int.parse(prix);
                  // var sousTotal = intQuantite * intPrix;
                  return Container(
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
                                bottomRight: Radius.circular(Dimensions.radius20),
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
                                        MainAxisAlignment.start,
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
                                            // SmallText(
                                            //     text: "Nbre ",
                                            //     size: Dimensions.font20,
                                            //     color: Colors.orange),
                                            SmallText(
                                                text: boutique,
                                                size: Dimensions.font20,
                                                color: const Color.fromARGB(
                                                    255, 139, 105, 52)),
      
                                            SizedBox(
                                              width: Dimensions.width10 / 2,
                                            ),
                                            // SmallText(
                                            //     text: "Total",
                                            //     size: Dimensions.font20),
                                            // SmallText(
                                            //     text: " 100",
                                            //     size: Dimensions.font20),
                                            // BigText(text: quantity.toString()),
                                            // SizedBox(
                                            //   width: Dimensions.width10 / 2,
                                            // ),
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
                                      // GestureDetector(
                                      //   onTap: () {
                                      //     //  var userId;
                                      //     // addProductToCart(produit as String, userId );
                                      //     // AjouterAuPanier();
                                      //     Get.snackbar("Succes",
                                      //         "Ce produit à bien été ajouté au panier");
                                      //     // Navigator.push(
                                      //     //   context,
                                      //     //   MaterialPageRoute(
                                      //     //     builder: (context) {
                                      //     //       return Cart();
                                      //     //     },
                                      //     //   ),
                                      //     // );
                                      //   },
                                      //   child: Container(
                                      //     padding: EdgeInsets.only(
                                      //         top: Dimensions.height10,
                                      //         bottom: Dimensions.height10,
                                      //         left: Dimensions.width10,
                                      //         right: Dimensions.width10),
                                      //     decoration: BoxDecoration(
                                      //       borderRadius: BorderRadius.circular(
                                      //           Dimensions.radius20),
                                      //       color:
                                      //           Color.fromRGBO(10, 80, 137, 0.8),
                                      //     ),
                                      //     // child: GestureDetector(
                                      //     //   onTap: () {
                                      //     //     removeFromCart(index as int);
                                      //     //   },
                                      //     //   child: Icon(
                                      //     //     Icons.delete_rounded,
                                      //     //     color: Colors.white,
                                      //     //   ),
                                      //     // ),
                                      //   ),
                                      // ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            // PickupInfoWidget(
            //   formKey: _formKey,
            //   pickupAddress: "pickupAddress",
            //   pickupNumero: 555445,
            //   updatePickupInfo: (address, numero) {
            //     setState(() {
            //       pickupAddress = address;
            //       pickupNumero = numero;
            //     });
            //   },
            // )
      
            // )
          ],
        ),
      ),
    );
  }
}
