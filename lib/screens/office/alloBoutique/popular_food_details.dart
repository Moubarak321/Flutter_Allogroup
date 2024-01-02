import 'package:allogroup/screens/office/components/app_column_food.dart';
import 'package:allogroup/screens/office/components/function.dart';
import 'package:allogroup/screens/office/widgets/app_icon.dart';
import 'package:allogroup/screens/office/widgets/big_text.dart';
import 'package:allogroup/screens/office/widgets/dimensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:allogroup/screens/office/widgets/quantity_controller.dart';
import '../widgets/expandable_text_widget.dart';
import 'package:get_storage/get_storage.dart';

class PopularFoodDetail extends StatefulWidget {
  final Map<String, dynamic> produit;

  PopularFoodDetail({required this.produit, Key? key}) : super(key: key);

  @override
  _PopularFoodDetailState createState() => _PopularFoodDetailState();
}

class _PopularFoodDetailState extends State<PopularFoodDetail> {
//Début gestion du panier
  final QuantityController quantityController =
      Get.put(QuantityController()); // Initialize the controller
  final box = GetStorage();
  int get quantity => box.read('quantity') ?? 1;
  late final Map<String, dynamic> produit;
  int _quantity = 1;
  // int get quantity => _quantity;
  // int _inCartItems = 0;
  // int get inCartItems => _inCartItems + _quantity;
  void setQuantity(bool isIncrement) {
    setState(
      () {
        int checkQuantity(int quantity) {
          if (quantity < 1) {
            Get.snackbar("Attention", "Vous devez acheter au moins 1 produit",
                backgroundColor: Colors.orange, colorText: Colors.white);
            return 1;
          } else if (quantity > 20) {
            Get.snackbar("Attention",
                "Vous ne pouvez pas commander au delà de 20 articles",
                backgroundColor: Colors.orange, colorText: Colors.white);
            return 20;
          } else {
            return quantity;
          }
        }

        if (isIncrement) {
          _quantity = checkQuantity(_quantity + 1);
        } else {
          if (_quantity > 1) {
            _quantity = checkQuantity(_quantity - 1);
          }
        }
        quantityController.setQuantity(quantity);
        box.write('quantity', _quantity);
      },
    );
  }

  Future<void> AjouterAuPanier() async {
    User? getCurrentUser() {
      return FirebaseAuth.instance.currentUser;
    } // Assurez-vous que vous récupérez l'utilisateur correctement.

    if (user != null) {
      final AppColumnFood food = AppColumnFood(
        text: produit["title"],
        restau: produit["fullName"],
      );

      final DateTime? selectedDateTime = await food.setDate(context);

      if (selectedDateTime != null) {
        final userData = {
          'id': DateTime
              .now(), // Utilisez un identifiant unique pour chaque produit ajouté.
          'titre': produit["title"],
          'categorie': produit["categorie"],
          'prix': produit["price"],
          'image': produit["image"],
          'boutique': produit["fullName"],
          'boutiqueId': produit["boutiqueId"],
          'quantite': quantity.toString(),
          'dateLivraison': selectedDateTime,
          // 'categorie': produit["categorie"],
          'status': false,
        };

        FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .get()
            .then((userDoc) {
          if (userDoc.exists) {
            // L'utilisateur existe, mettez à jour son panier existant.
            FirebaseFirestore.instance
                .collection('users')
                .doc(user?.uid)
                .update({
                  'cart': FieldValue.arrayUnion([userData]),
                })
                .then((_) {})
                .catchError((error) {
                  // Une erreur s'est produite lors de la mise à jour des données.
                });
          } else {
            // L'utilisateur n'a pas de panier, créez-en un nouveau pour lui.
            final newCartData = {
              'cart': [userData], // Le premier produit est ajouté au panier.
            };

            FirebaseFirestore.instance
                .collection('users')
                .doc(user?.uid)
                .set(newCartData)
                .then((_) {
              // Les données ont été enregistrées avec succès.
            }).catchError((error) {
              // Une erreur s'est produite lors de la création du panier.
            });
          }
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialize the quantity value from the controller
    produit = widget.produit;
    _quantity = quantityController.quantity.value;
  }

  @override
  Widget build(BuildContext context) {
    //print("height ${MediaQuery.of(context).size.height}");
    //print("width ${MediaQuery.of(context).size.width}");
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: -20,
            left: 0,
            right: 0,
            child: Container(
              width: double.maxFinite,
              height: Dimensions.popularFoodImgSize,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(widget.produit['image']),
                ),
              ),
            ),
          ),
          Positioned(
            top: Dimensions.height45,
            left: Dimensions.width20,
            right: Dimensions.width20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Revenir à la page précédente
                  },
                  child: AppIcon(icon: Icons.arrow_back_ios),
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.popAndPushNamed(context, '/cart');
                    },
                    child: AppIcon(icon: Icons.shopping_cart_outlined)),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: Dimensions.popularFoodImgSize - 30,
            child: Container(
              padding: EdgeInsets.only(
                left: Dimensions.width20,
                right: Dimensions.width20,
                top: Dimensions.height20,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(Dimensions.radius20),
                  topLeft: Radius.circular(Dimensions.radius20),
                ),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppColumnFood(
                    text: widget.produit['title'],
                    restau: widget.produit['fullName'],
                  ),
                  SizedBox(
                    height: Dimensions.height20,
                  ),
                  BigText(
                      text: "Prix unitaire : ${widget.produit['price']} F",
                      color: Color(0xFF89dad0)),
                  BigText(
                      text: "Promo: ${widget.produit['note']} ",
                      color: Color(0xFF89dad0)),
                  BigText(text: "Description"),
                  SizedBox(
                    height: Dimensions.height10,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: ExpandableTextWidget(
                        text: widget.produit['description'],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Dimensions.height10,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        // height: 120,
        height: Dimensions.bottomHeightBar,
        padding: EdgeInsets.only(
            top: Dimensions.height30,
            bottom: Dimensions.height30,
            left: Dimensions.width20,
            right: Dimensions.width20),
        decoration: BoxDecoration(
          color: Color.fromRGBO(231, 238, 243, 0.8),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Dimensions.radius20 * 2),
            topRight: Radius.circular(Dimensions.radius20 * 2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.only(
                  top: Dimensions.height20,
                  bottom: Dimensions.height20,
                  left: Dimensions.width20,
                  right: Dimensions.width20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radius20),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setQuantity(false);
                    },
                    child: Icon(
                      Icons.remove,
                      color: Color.fromRGBO(10, 80, 137, 0.8),
                    ),
                  ),
                  SizedBox(
                    width: Dimensions.width10 / 2,
                  ),
                  BigText(text: quantity.toString()),
                  SizedBox(
                    width: Dimensions.width10 / 2,
                  ),
                  GestureDetector(
                    onTap: () {
                      //print("increment");
                      setQuantity(true);
                    },
                    child: Icon(
                      Icons.add,
                      color: Color.fromRGBO(10, 80, 137, 0.8),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () async {
                //  var userId;
                // addProductToCart(produit as String, userId );
                await AjouterAuPanier();
                Get.snackbar("Succes", "Ce produit à bien été ajouté au panier",
                    backgroundColor: Colors.orange, colorText: Colors.white);
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) {
                //       return Cart();
                //     },
                //   ),
                // );
              },
              child: Container(
                padding: EdgeInsets.only(
                    top: Dimensions.height20,
                    bottom: Dimensions.height20,
                    left: Dimensions.width20,
                    right: Dimensions.width20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  color: Color.fromRGBO(10, 80, 137, 0.8),
                ),
                child: BigText(
                  text: "Ajouter au panier",
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


