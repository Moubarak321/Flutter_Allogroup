import 'dart:math';
import 'package:allogroup/screens/office/allofood/recommended_food_detail.dart';
import 'package:allogroup/screens/office/components/app_column_restau.dart';
import 'package:allogroup/screens/office/widgets/big_text.dart';
import 'package:allogroup/screens/office/widgets/dimensions.dart';
import 'package:allogroup/screens/office/widgets/icon_and_text_widget.dart';
import 'package:allogroup/screens/office/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:allogroup/screens/office/alloevent/popular_event_details.dart';
import 'package:get/get.dart';
import 'dart:async';

class EventBodyCard extends StatefulWidget {
  const EventBodyCard({Key? key}) : super(key: key);

  @override
  State<EventBodyCard> createState() => _EventBodyCardState();
}

class _EventBodyCardState extends State<EventBodyCard> {
  PageController pageController = PageController(
      viewportFraction:
          0.85); //gestion des marges au niveau du caroussel à droite et à gauche de sorte qu'on ait un aperçu du prochain er précédent slide
  var _currPageValue = 0.0; // pour le zoom in et out
  double _scaleFactor = 0.8;
  double _height = Dimensions.pageViewContainer;
  bool showSpinner = true;
  // bool isFavorite = false;
  // bool isFavorite = false;
  TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> tousLesProduits = [];
  List<Map<String, dynamic>> tousLesMarchants = [];
  List<Map<String, dynamic>> produitsNonFiltres = [];

  Future<List<Map<String, dynamic>>?> getAllProducts() async {
    try {
      List<Map<String, dynamic>> products = [];

      // Accédez à la collection "Marchands" dans Firestore
      QuerySnapshot marchandsSnapshot =
          await FirebaseFirestore.instance.collection('events').get();
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
          // print("Voilà le nom de la boutique " + produit["fullName"]);
        }
      }
      produitsNonFiltres =
          List.from(products); // initialise la liste des produits non filtrés
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
          await FirebaseFirestore.instance.collection('events').get();
      // print("*****************************************DONE*************************************");
      // Parcourez les documents de la collection "Marchands"
      for (QueryDocumentSnapshot merchantDocument in merchantsSnapshot.docs) {
        // Accédez aux données de chaque marchand
        Map<String, dynamic> merchantData =
            merchantDocument.data() as Map<String, dynamic>;

        String merchantName = merchantData['fullName'];
        String merchantId = merchantData['id'];
        String merchantCat = merchantData['cuisine'];
        String merchantAdresse = merchantData['adresse'];
        String merchantDescription = merchantData['descriptionboutique'];

        List<dynamic> merchantProducts = merchantData['produits'];
        String merchantImageURL = merchantData[
            'profileImageUrl']; // Remplacez 'ImageURL' par le nom de votre champ pour l'image

        // Créez un objet Map pour stocker le nom de la boutique et l'URL de l'image
        Map<String, dynamic> merchantInfo = {
          'id': merchantId,
          'name': merchantName,
          'imageURL': merchantImageURL,
          'categorie': merchantCat,
          'adresse': merchantAdresse,
          'products': merchantProducts,
          'description': merchantDescription
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

  void filterProducts(String query) {
    // Utilisez la méthode where pour filtrer les produits en fonction de la saisie de l'utilisateur et de la catégorie
    List<Map<String, dynamic>> filteredProducts = produitsNonFiltres
        .where((product) =>
            product['title'].toLowerCase().contains(query.toLowerCase()) ||
            product['categorie'].toLowerCase().contains(query.toLowerCase()) ||
            product['price'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    // Mettez à jour l'état avec la liste filtrée
    setState(() {
      tousLesProduits = filteredProducts;
    });
  }

  void clearSearch() {
    setState(() {
      searchController.clear();
      tousLesProduits =
          List.from(produitsNonFiltres); // réinitialise à la liste initiale
    });
  }

// =========================================================================
// Fonctions a activer plus tard
// =========================================================================

  // void AddtoFavorite(Map<String, dynamic> product) async {
  //   User? getCurrentUser() {
  //     return FirebaseAuth.instance.currentUser;
  //   } // Assurez-vous que vous récupérez l'utilisateur correctement.

  //   if (user != null) {
  //     final userData = {
  //       'id': DateTime.now()
  //           .millisecondsSinceEpoch, // Utilisez un identifiant unique pour chaque produit ajouté.
  //       'titre': product["title"],
  //       'categorie': product["categorie"],
  //       'prix': product["price"],
  //       'image': product["image"],
  //       'boutique': product["fullName"],
  //       'boutiqueId': product["boutiqueId"],
  //       // 'quantite': quantity.toString(),
  //       // 'categorie': product["categorie"],
  //       'status': product["isFavorite"],
  //     };

  //     FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(user?.uid)
  //         .get()
  //         .then((userDoc) {
  //       if (userDoc.exists) {
  //         // L'utilisateur existe, mettez à jour son panier existant.
  //         FirebaseFirestore.instance
  //             .collection('users')
  //             .doc(user?.uid)
  //             .update({
  //               'Favoris': FieldValue.arrayUnion([userData]),
  //             })
  //             .then((_) {})
  //             .catchError((error) {
  //               // Une erreur s'est produite lors de la mise à jour des données.
  //             });
  //       } else {
  //         // L'utilisateur n'a pas de panier, créez-en un nouveau pour lui.
  //         final newCartData = {
  //           'Favoris': [userData], // Le premier produit est ajouté au panier.
  //         };

  //         FirebaseFirestore.instance
  //             .collection('users')
  //             .doc(user?.uid)
  //             .set(newCartData)
  //             .then((_) {
  //           // Les données ont été enregistrées avec succès.
  //         }).catchError((error) {
  //           // Une erreur s'est produite lors de la création du panier.
  //         });
  //       }
  //     });
  //   }
  // }

  // Future<bool> RemoveFromFavorite(Map<String, dynamic> product) async {
  //   try {
  //     User? getCurrentUser() {
  //       return FirebaseAuth.instance.currentUser;
  //     }

  //     if (user != null) {
  //       final userData = {
  //         'id': DateTime.now().millisecondsSinceEpoch,
  //         'titre': product["title"],
  //         'categorie': product["categorie"],
  //         'prix': product["price"],
  //         'image': product["image"],
  //         'boutique': product["fullName"],
  //         'boutiqueId': product["boutiqueId"],
  //         'status': product["isFavorite"],
  //       };

  //       final userDoc = await FirebaseFirestore.instance
  //           .collection('users')
  //           .doc(user?.uid)
  //           .get();

  //       if (userDoc.exists) {
  //         // L'utilisateur existe, mettez à jour son panier existant.
  //         await FirebaseFirestore.instance
  //             .collection('users')
  //             .doc(user?.uid)
  //             .update({
  //           'Favoris': FieldValue.arrayRemove([userData]),
  //         });
  //         return true; // La suppression a réussi.
  //       }
  //     }

  //     return false; // La suppression a échoué.
  //   } catch (error) {
  //     print("Erreur lors de la suppression du favori : $error");
  //     return false; // La suppression a échoué en raison d'une erreur.
  //   }
  // }

// =========================================================================
// Fin Fonctions a activer plus tard
// =========================================================================

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

    Timer(Duration(seconds: 3), () {
      // Après 5 secondes, masquez le spinner
      setState(() {
        showSpinner = false;
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

        Center(
          child: Container(
            margin: EdgeInsets.only(
                left: Dimensions.width30, right: Dimensions.width30),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: "Que voulez-vous acheter aujourd'hui ?",
                prefixIcon: Icon(Icons.search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              ),
              enableSuggestions: true,
              enableIMEPersonalizedLearning: true,
              enableInteractiveSelection: true,
              onChanged: (value) {
                filterProducts(value);
              },
            ),
          ),
        ),

        // TextField(
        //   controller: searchController,
        //   decoration: InputDecoration(
        //       labelText: 'Rechercher des produits',
        //       prefixIcon: Icon(Icons.search),
        //       border: UnderlineInputBorder(borderSide: BorderSide.none)),
        //   enableSuggestions: true,
        //   enableIMEPersonalizedLearning: true,
        //   enableInteractiveSelection: true,
        //   onChanged: (value) {
        //     filterProducts(value);
        //   },
        // ),

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
      // var marchand = tousLesMarchants[index];

      // String merchantCat = tousLesMarchants[index]['categorie'];
      // String merchantAdresse = tousLesMarchants[index]['adresse'];

      return GestureDetector(
        onTap: () {
          // Gérez la redirection vers la page de détail ici
          // Get.snackbar("Info", "Ce restaurant est vérifié et prêt à vous servir. Parcourez les offres en dessous pour commander");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                print(tousLesMarchants[index]);
                return RecommendedFoodDetail(marchand: tousLesMarchants[index]);
              },
            ),
          );
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
    if (showSpinner) {
      // Afficher le spinner pendant 5 secondes
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (tousLesProduits.isNotEmpty) {
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
          var promo = produit['note'];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    // print("--------------$produit");
                    return PopularEventDetail(produit: tousLesProduits[index]);
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
                                GestureDetector(
                                  onTap: () {
                                    Get.snackbar("Infos",
                                        "Le temps de reponse est d'environs $duree min",
                                        backgroundColor: Colors.orange,
                                        colorText: Colors.white);
                                  },
                                  child: IconAndTextWidget(
                                    icon: Icons.access_time_rounded,
                                    text: duree + " min",
                                    iconColor: Colors.red,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.snackbar("Promo", "$promo",
                                        backgroundColor: Colors.orange,
                                        colorText: Colors.white);
                                  },
                                  child: IconAndTextWidget(
                                    icon: Icons.discount_rounded,
                                    text: "",
                                    iconColor: Color.fromRGBO(10, 80, 137, 0.8),
                                  ),
                                ),

                                // GestureDetector(
                                //   onTap: () {
                                //     setState(() {
                                //       produit["isFavorite"] = !produit[
                                //           "isFavorite"]; // Inverser l'état actuel
                                //       AddtoFavorite(produit);
                                //       Get.snackbar(
                                //         "Infos",
                                //         produit["isFavorite"]
                                //             ? "Ce produit a été ajouté aux favoris"
                                //             : "Ce produit a été supprimé des favoris",
                                //       );

                                //       // Ajoutez cette condition pour gérer le changement d'icône et de couleur lorsque le produit est retiré des favoris
                                //       if (!produit["isFavorite"]) {
                                //         RemoveFromFavorite(produit);
                                //         // Si le produit n'est plus un favori, changez la couleur de l'icône en noir
                                //         IconAndTextWidget(
                                //           icon: Icons.favorite_border,
                                //           text: "",
                                //           iconColor: Colors.black,
                                //         );
                                //       }
                                //     });
                                //   },
                                //   child: IconAndTextWidget(
                                //     icon: produit["isFavorite"]
                                //         ? Icons.favorite
                                //         : Icons.favorite_border,
                                //     text: "",
                                //     iconColor: produit["isFavorite"]
                                //         ? Colors.red
                                //         : Colors.black,
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
            ),
          );
        },
      );
    } else {
      return Center(
        child: Text(
          "Aucun produit trouvé",
          style: TextStyle(fontSize: 16),
        ),
      );
    }
  }
}
