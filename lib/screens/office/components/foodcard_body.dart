// import 'package:allogroup/screens/office/components/app_column.dart';
// import 'package:allogroup/screens/office/widgets/big_text.dart';
// import 'package:allogroup/screens/office/widgets/dimensions.dart';
// import 'package:allogroup/screens/office/widgets/icon_and_text_widget.dart';
// import 'package:allogroup/screens/office/widgets/small_text.dart';
// import 'package:flutter/material.dart';
// import 'package:dots_indicator/dots_indicator.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// import '../allofood/popular_food_details.dart';

// class FoodPageBody extends StatefulWidget {
//   // const FoodPageBody({super.key});
//   const FoodPageBody({Key? key}) : super(key: key);

//   @override
//   State<FoodPageBody> createState() => _FoodPageBodyState();
// }

// class _FoodPageBodyState extends State<FoodPageBody> {
//   PageController pageController = PageController(
//       viewportFraction:
//           0.85); //gestion des marges au niveau du caroussel à droite et à gauche de sorte qu'on ait un aperçu du prochain er précédent slide
//   var _currPageValue = 0.0; // pour le zoom in et out
//   double _scaleFactor = 0.8;
//   double _height = Dimensions.pageViewContainer;
//   // String tousLesProduits = [] as String;
//   // List<String> tousLesProduits = [];
//   List<Map<String, dynamic>> tousLesProduits = [];

//   Future<List<String>> getCaroussImages() async {
//     List<String> images = [];
//     try {
//       final Reference storageReference =
//           FirebaseStorage.instance.ref("articles");
//       final ListResult result = await storageReference.list();
//       // print(
//       //     "============================== final2========================================");

//       for (var item in result.items) {
//         final String imageUrl = await item.getDownloadURL();
//         images.add(imageUrl);
//       }
//       print(
//           "===================================images added===================================");
//     } catch (error) {
//       print("Erreur lors de la récupération des images : $error");
//     }
//     print(images);
//     print(
//         "======================================================================");
//     print(
//         "======================================================================");
//     print(
//         "======================================================================");
//     return images;
//   }

//   Future<List<Map<String, dynamic>>?> getAllProducts() async {
//     try {
//       List<Map<String, dynamic>> products = [];

//       // Accédez à la collection "Marchands" dans Firestore
//       QuerySnapshot marchandsSnapshot =
//           await FirebaseFirestore.instance.collection('marchands').get();

//       print(marchandsSnapshot);
//       // Parcourez les documents de la collection "Marchands"
//       for (QueryDocumentSnapshot marchand in marchandsSnapshot.docs) {
//         // Accédez à la sous-collection "Produits" de chaque marchand

//         print(marchand);

//         Map<String, dynamic> data = marchand.data() as Map<String, dynamic>;

//         print(data);

//         print(data['produits']);

//         // Parcourez les documents de la sous-collection "Produits" et ajoutez-les à la liste des produits
//         for (var produit in data['produits']) {
//           products.add(produit as Map<String, dynamic>);
//         }
//       }

//       print(products);

//       return products;
//     } catch (e) {
//       print("Erreur lors de la récupération des produits : $e");
//       return null;
//     }
//   }

//  Future<List<Map<String, dynamic>>?> getAllMerchants() async {
//   try {
//     List<Map<String, dynamic>> merchants = [];

//     // Accédez à la collection "Marchands" dans Firestore
//     QuerySnapshot merchantsSnapshot = await FirebaseFirestore.instance.collection('marchands').get();

//     // Parcourez les documents de la collection "Marchands"
//     for (QueryDocumentSnapshot merchantDocument in merchantsSnapshot.docs) {
//       // Accédez aux données de chaque marchand
//       Map<String, dynamic> merchantData = merchantDocument.data() as Map<String, dynamic>;

//       // Récupérez le nom de la boutique et l'URL de l'image du marchand
//       String merchantName = merchantData['NomBoutique'];
//       String merchantImageURL = merchantData['ImageURL']; // Remplacez 'ImageURL' par le nom de votre champ pour l'image

//       // Créez un objet Map pour stocker le nom de la boutique et l'URL de l'image
//       Map<String, dynamic> merchantInfo = {
//         'name': merchantName,
//         'imageURL': merchantImageURL,
//       };

//       // Ajoutez les informations du marchand à la liste des marchands
//       merchants.add(merchantInfo);
//     }

//     return merchants;
//   } catch (e) {
//     print("Erreur lors de la récupération des marchands : $e");
//     return null;
//   }
// }

//   @override
//   void initState() {
//     super.initState();
//     getAllProducts().then((products) {
//       setState(() {
//         tousLesProduits = products!;
//         print(
//             "000000000000000000000000000000000000000/////////////000000000000000000000000000000000000000");
//         print(tousLesProduits);
//         print(
//             "000000000000000000000000000000000000000/////////////000000000000000000000000000000000000000");
//       });
//     });

//     pageController.addListener(() {
//       setState(() {
//         _currPageValue = pageController.page!;
//         // print("Current value is $_currPageValue");
//       });
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     pageController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         SizedBox(
//           height: Dimensions.pageView,
//           child: PageView.builder(
//             controller: pageController,
//             itemCount: 5,
//             itemBuilder: (context, position) {
//               return _buildPageItem(position);
//               //nous retournons un widget créé un peu plus bas contenant tous les details du caroussel
//             },
//           ),
//         ),

//         ////============== caroussel dots //==============
//         DotsIndicator(
//           dotsCount: 5,
//           position: _currPageValue,
//           decorator: DotsDecorator(
//             size: const Size.square(9.0),
//             // color: Colors.blue,
//             activeSize: const Size(18.0, 9.0),
//             activeShape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(5.0)),
//             activeColor: Colors.orange,
//           ),
//         ),

//         //============== Popular Text ==============
//         //espace
//         SizedBox(
//           height: Dimensions.height30,
//         ),

//         Container(
//           margin: EdgeInsets.only(left: Dimensions.width30),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               BigText(
//                 text: "Popular",
//                 size: Dimensions.height20,
//               ),
//               SizedBox(
//                 width: Dimensions.width10,
//               ),
//               Container(
//                 margin: const EdgeInsets.only(bottom: 4),
//                 child: BigText(
//                   text: ".",
//                   color: Colors.black26,
//                 ),
//               ),
//               SizedBox(
//                 width: Dimensions.width10,
//               ),
//               Container(
//                 margin: const EdgeInsets.only(bottom: 2),
//                 child: SmallText(text: "Food pairing"),
//               ),
//             ],
//           ),
//         ),

//         ListView.builder(
//           physics: NeverScrollableScrollPhysics(),
//           shrinkWrap: true,
//           itemCount: tousLesProduits.length,
//           itemBuilder: (context, index) {
//             var produit = tousLesProduits[index];
//             var categorie = produit['categorie'];
//             var title = produit['title'];
//             var imageUrl = produit['image'];
//             var prix = produit['price'];
//             var duree = produit['during'];

//             return GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) {
//                       return PopularFoodDetail(produit: tousLesProduits[index]);
//                     },
//                   ),
//                 );
//               },
//               child: Container(
//                 margin: EdgeInsets.only(
//                   left: Dimensions.width20,
//                   right: Dimensions.width20,
//                   bottom: Dimensions.height10,
//                 ),
//                 child: Row(
//                   children: [
//                     // =============== image section ===============
//                     Container(
//                       width: Dimensions.listViewImgSize, //120
//                       height: Dimensions.listViewImgSize, //120
//                       decoration: BoxDecoration(
//                         borderRadius:
//                             BorderRadius.circular(Dimensions.radius20),
//                         color: Colors.white38,
//                         image: DecorationImage(
//                           fit: BoxFit.cover,
//                           image: NetworkImage(imageUrl),
//                         ),
//                       ),
//                     ),

//                     // =============== Text section ===============
//                     Expanded(
//                       child: Container(
//                         height: Dimensions.listViewTextContSize, //100
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.only(
//                             topRight: Radius.circular(Dimensions.radius20),
//                             bottomRight: Radius.circular(Dimensions.radius20),
//                           ),
//                           color: Colors.white,
//                         ),
//                         child: Padding(
//                           padding: EdgeInsets.only(
//                             left: Dimensions.width10,
//                             right: Dimensions.width10,
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               BigText(
//                                 text: title,
//                               ),
//                               SizedBox(
//                                 height: Dimensions.height10,
//                               ),
//                               SmallText(text: categorie),
//                               SizedBox(
//                                 height: Dimensions.height10,
//                               ),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   IconAndTextWidget(
//                                     icon: Icons.monetization_on_rounded,
//                                     text: prix + " FCFA",
//                                     iconColor: Colors.orange,
//                                   ),
//                                   IconAndTextWidget(
//                                     icon: Icons.access_time_rounded,
//                                     text: duree + " min",
//                                     iconColor: Colors.red,
//                                   ),
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildPageItem(int index) {
//     Matrix4 matrix = Matrix4.identity(); //animation zoomin zoomout
//     if (index == _currPageValue.floor()) {
//       var currScale = 1 - (_currPageValue - index) * (1 - _scaleFactor);
//       var currTrans = _height * (1 - currScale) / 2;
//       matrix = Matrix4.diagonal3Values(1, currScale, 1)
//         ..setTranslationRaw(0, currTrans, 0);
//     } else if (index == _currPageValue.floor() + 1) {
//       var currScale =
//           _scaleFactor + (_currPageValue - index + 1) * (1 - _scaleFactor);
//       var currTrans = _height * (1 - currScale) / 2;
//       matrix = Matrix4.diagonal3Values(1, currScale, 1);
//       matrix = Matrix4.diagonal3Values(1, currScale, 1)
//         ..setTranslationRaw(0, currTrans, 0);
//     } else if (index == _currPageValue.floor() - 1) {
//       // var currScale = _scaleFactor + (_currPageValue - index + 1) * (1 - _scaleFactor);
//       var currScale = 1 - (_currPageValue - index) * (1 - _scaleFactor);
//       var currTrans = _height * (1 - currScale) / 2;
//       matrix = Matrix4.diagonal3Values(1, currScale, 1);
//       matrix = Matrix4.diagonal3Values(1, currScale, 1)
//         ..setTranslationRaw(0, currTrans, 0);
//     } else {
//       var currScale = 0.8;
//       matrix = Matrix4.diagonal3Values(1, currScale, 1)
//         ..setTranslationRaw(0, _height * (1 - _scaleFactor) / 2, 1);
//     }

//     return Transform(
//       transform: matrix,
//       child: Stack(
//         children: [
//           Container(
//             ////============== image container //==============
//             height: Dimensions.pageViewContainer,
//             margin: EdgeInsets.only(
//                 left: Dimensions.width10,
//                 right: Dimensions.width10), // marge légère entre les slides
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(Dimensions.radius30),
//               color: index.isEven ? Color(0xFF69c5df) : Color(0xFF9294CC),
//               image: DecorationImage(
//                 fit: BoxFit.cover,
//                 image: AssetImage("assets/images/hamburger.jpg"),
//               ),
//             ),
//           ),
//           Align(
//             //============== section tombante sous images du carouss ==============
//             alignment: Alignment.bottomCenter,
//             child: Container(
//               // ============== conteneur blanc sous le carouss ==============
//               height: Dimensions.pageViewTextContainer,
//               margin: EdgeInsets.only(
//                   left: Dimensions.width30,
//                   right: Dimensions.width30,
//                   bottom: Dimensions.height30),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(Dimensions.radius20),
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Color(0xFFe8e8e8),
//                     blurRadius: 5.0,
//                     offset: Offset(0, 5),
//                   ),
//                   BoxShadow(
//                     color: Colors.white,
//                     offset: Offset(-5, 0),
//                   ),
//                   BoxShadow(
//                     color: Colors.white,
//                     offset: Offset(5, 0),
//                   ),
//                 ],
//               ),

//               child: Container(
//                 //============== section des textes ==============
//                 padding: EdgeInsets.only(
//                     top: Dimensions.height10, left: 15, right: 15),
//                 child: AppColumn(
//                   text: "Chinese Side",
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:math';

// import 'package:allogroup/screens/office/allofood/recommended_food_detail.dart';
import 'package:allogroup/screens/office/components/app_column_restau.dart';
import 'package:allogroup/screens/office/widgets/big_text.dart';
import 'package:allogroup/screens/office/widgets/dimensions.dart';
import 'package:allogroup/screens/office/widgets/icon_and_text_widget.dart';
import 'package:allogroup/screens/office/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:allogroup/screens/office/allofood/popular_food_details.dart';
import 'package:get/get.dart';

// import '../allofood/popular_food_details.dart';

class FoodPageBody extends StatefulWidget {
  // const FoodPageBody({super.key});
  const FoodPageBody({Key? key}) : super(key: key);

  @override
  State<FoodPageBody> createState() => _FoodPageBodyState();
}

class _FoodPageBodyState extends State<FoodPageBody> {
  PageController pageController = PageController(
      viewportFraction:
          0.85); //gestion des marges au niveau du caroussel à droite et à gauche de sorte qu'on ait un aperçu du prochain er précédent slide
  var _currPageValue = 0.0; // pour le zoom in et out
  double _scaleFactor = 0.8;
  double _height = Dimensions.pageViewContainer;

  List<Map<String, dynamic>> tousLesProduits = [];
  List<Map<String, dynamic>> tousLesMarchants = [];

  Future<List<Map<String, dynamic>>?> getAllProducts() async {
    try {
      List<Map<String, dynamic>> products = [];

      // Accédez à la collection "Marchands" dans Firestore
      QuerySnapshot marchandsSnapshot =
          await FirebaseFirestore.instance.collection('marchands').get();
      // Parcourez les documents de la collection "Marchands"
      for (QueryDocumentSnapshot marchand in marchandsSnapshot.docs) {
        // Accédez à la sous-collection "Produits" de chaque marchand
        Map<String, dynamic> data = marchand.data() as Map<String, dynamic>;
        // print("------------data----------: $data");
        // Parcourez les documents de la sous-collection "Produits" et ajoutez-les à la liste des produits
        for (var produit in data['produits']) {
          produit["fullName"] = data["fullName"];
          produit["boutiqueId"] = data["id"];
          products.add(produit as Map<String, dynamic>);
          // .add(produit as Map<String, dynamic>);
          // print("Produit : $produit");
          print("Voilà le nom de la boutique " + produit["fullName"]);
        }
      }
      return products;
    } catch (e) {
      print("Erreur lors de la récupération des produits : $e");
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> getAllMerchants() async {
    try {
      List<Map<String, dynamic>> merchants = [];

      // Accédez à la collection "Marchands" dans Firestore
      QuerySnapshot merchantsSnapshot =
          await FirebaseFirestore.instance.collection('marchands').get();
// print("*****************************************DONE*************************************");
      // Parcourez les documents de la collection "Marchands"
      for (QueryDocumentSnapshot merchantDocument in merchantsSnapshot.docs) {
        // Accédez aux données de chaque marchand
        Map<String, dynamic> merchantData =
            merchantDocument.data() as Map<String, dynamic>;

        String merchantName = merchantData['fullName'];
        String merchantCat = merchantData['cuisine'];
        String merchantAdresse = merchantData['adresse'];
        String merchantImageURL = merchantData[
            'profileImageUrl']; // Remplacez 'ImageURL' par le nom de votre champ pour l'image

        // Créez un objet Map pour stocker le nom de la boutique et l'URL de l'image
        Map<String, dynamic> merchantInfo = {
          'name': merchantName,
          'imageURL': merchantImageURL,
          'categorie': merchantCat,
          'adresse': merchantAdresse
        };

        // Ajoutez les informations du marchand à la liste des marchands
        merchants.add(merchantInfo);
      }

      return merchants;
    } catch (e) {
      print("Erreur lors de la récupération des marchands : $e");
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    getAllProducts().then((products) {
      setState(() {
        tousLesProduits = products!;
      });
    });

    // getAllProducts().then((products) {
    //   if (products != null) {
    //     setState(() {
    //       tousLesProduits = products!;
    //     });
    //   }
    // });
    getAllMerchants().then((merchants) {
      setState(() {
        tousLesMarchants = merchants!;
      });
    });

    pageController.addListener(() {
      setState(() {
        _currPageValue = pageController.page!;
        // print("Current value is $_currPageValue");
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: Dimensions.pageView,
          child: PageView.builder(
            controller: pageController,
            itemCount: tousLesMarchants.length,
            itemBuilder: (context, position) {
              return _buildPageItem(position);
              //nous retournons un widget créé un peu plus bas contenant tous les details du caroussel
            },
          ),
        ),

        ////============== caroussel dots //==============
        DotsIndicator(
          dotsCount: max(tousLesMarchants.length,
              1), // Utilisez max() pour garantir un minimum de 1 point,
          position: _currPageValue,
          decorator: DotsDecorator(
            size: const Size.square(9.0),
            // color: Colors.blue,
            activeSize: const Size(18.0, 9.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            activeColor: Colors.orange,
          ),
        ),

        //============== Popular Text ==============
        //espace
        SizedBox(
          height: Dimensions.height30,
        ),

        Container(
          margin: EdgeInsets.only(left: Dimensions.width30),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              BigText(
                text: "Populaires",
                size: Dimensions.height20,
              ),
              SizedBox(
                width: Dimensions.width10,
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 4),
                child: BigText(
                  text: ".",
                  color: Colors.black26,
                ),
              ),
              SizedBox(
                width: Dimensions.width10,
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 2),
                child: SmallText(text: "Parcourez les offres"),
              ),
            ],
          ),
        ),
        buildProductList(),
      ],
    );
  }

  Widget _buildPageItem(int index) {
    // Votre code de transformation ici
    Matrix4 matrix = Matrix4.identity(); //animation zoomin zoomout
    if (index == _currPageValue.floor()) {
      var currScale = 1 - (_currPageValue - index) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == _currPageValue.floor() + 1) {
      var currScale =
          _scaleFactor + (_currPageValue - index + 1) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1);
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == _currPageValue.floor() - 1) {
      // var currScale = _scaleFactor + (_currPageValue - index + 1) * (1 - _scaleFactor);
      var currScale = 1 - (_currPageValue - index) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1);
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else {
      var currScale = 0.8;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, _height * (1 - _scaleFactor) / 2, 1);
    }
    // Vérifiez que l'index est valide
    // var merchants = getAllMerchants();
    if (index >= 0 && index < tousLesMarchants.length) {
      String merchantName = tousLesMarchants[index]['name'];
      String merchantImageURL = tousLesMarchants[index]['imageURL'];
      // String merchantCat = tousLesMarchants[index]['categorie'];
      // String merchantAdresse = tousLesMarchants[index]['adresse'];

      return GestureDetector(
        onTap: () {
          // Gérez la redirection vers la page de détail ici
          Get.snackbar("Info",
              "Ce restaurant est vérifié et prêt à vous servir. Parcourez les offres en dessous pour commander");
        },
        child: Transform(
          transform: matrix,
          child: Stack(
            children: [
              Container(
                ////============== image container //==============
                height: Dimensions.pageViewContainer,
                margin: EdgeInsets.only(
                    left: Dimensions.width10,
                    right: Dimensions.width10), // marge légère entre les slides
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius30),
                  color: index.isEven ? Color(0xFF69c5df) : Color(0xFF9294CC),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(merchantImageURL),
                  ),
                ),
              ),
              Align(
                //============== section tombante sous images du carouss ==============
                alignment: Alignment.bottomCenter,
                child: Container(
                  // ============== conteneur blanc sous le carouss ==============
                  height: Dimensions.pageViewTextContainer,
                  margin: EdgeInsets.only(
                      left: Dimensions.width30,
                      right: Dimensions.width30,
                      bottom: Dimensions.height30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radius20),
                    color: Colors.white,
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
                  ),

                  child: Container(
                    //============== section des textes ==============
                    padding: EdgeInsets.only(
                        top: Dimensions.height10, left: 15, right: 15),
                    child: AppColumnRestau(
                      text: merchantName,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(); // Gérer le cas où l'index est hors limites de la liste de marchands
    }
  }

// if (tousLesProduits.isNotEmpty) {
//   return buildProductList();
// } else {
//   return CircularProgressIndicator(); // Ou un widget indiquant qu'aucun produit n'est disponible
// }

  Widget buildProductList() {
    if (tousLesProduits.isNotEmpty) {
      return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: tousLesProduits.length,
        itemBuilder: (context, index) {
          var produit = tousLesProduits[index];
          var categorie = produit['categorie'];
          var title = produit['title'];
          var imageUrl = produit['image'];
          var prix = produit['price'];
          var duree = produit['during'];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return PopularFoodDetail(produit: tousLesProduits[index]);
                  },
                ),
              );
            },
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
                      borderRadius: BorderRadius.circular(Dimensions.radius20),
                      color: Colors.white38,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(imageUrl),
                      ),
                    ),
                  ),

                  // =============== Text section ===============
                  Expanded(
                    child: Container(
                      height: Dimensions.listViewTextContSize, //100
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
                          right: Dimensions.width10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            BigText(
                              text: title,
                            ),
                            SizedBox(
                              height: Dimensions.height10,
                            ),
                            SmallText(text: categorie),
                            SizedBox(
                              height: Dimensions.height10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconAndTextWidget(
                                  icon: Icons.monetization_on_rounded,
                                  text: prix + " FCFA",
                                  iconColor: Colors.orange,
                                ),
                                IconAndTextWidget(
                                  icon: Icons.access_time_rounded,
                                  text: duree + " min",
                                  iconColor: Colors.red,
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
      );
    } else {
      return SizedBox(
        height: Dimensions.height30,
        child: CircularProgressIndicator(),
      ); // Ou un widget indiquant qu'aucun produit n'est disponible
    }
  }
}
