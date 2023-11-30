import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:allogroup/screens/office/components/livraison.dart';
import 'package:get/get.dart';

class Utilisateur extends StatefulWidget {
  const Utilisateur({Key? key}) : super(key: key);

  @override
  State<Utilisateur> createState() => _UtilisateurState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
String? deliveryAddress;
int? deliveryNumero;
String? error;
List<Map<String, dynamic>> tousLesProduits = [];
List<Map<String, dynamic>> commandes = [];
List<Map<String, dynamic>> products = [];

User? getCurrentUser() {
  return FirebaseAuth.instance.currentUser;
}

int currentStep = 0; // Étape actuelle du formulaire
String cancel = "Cancel";

Future<dynamic> GetProductFromCart() async {
  try {
    List<Map<String, dynamic>> products = [];

    final user = getCurrentUser();
    // Accédez au document de l'utilisateur
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();

    if (userDoc.exists) {
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      List<dynamic> cart = userData['cart'] as List<dynamic>;

      for (var cartItem in cart) {
        if (cartItem['status'] == false) {
          products.add(cartItem);
        }
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

/** 
void sendNotificationForPromo() async {
  
} */

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

Future<void> clearCart() async {
  try {
    final user = getCurrentUser();

    if (user != null) {
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);

      // Vider le champ 'cart' dans Firestore
      await userDocRef.update({
        'cart': [],
      });
    }
  } catch (e) {
    print("Erreur lors de la suppression du panier : $e");
    // Gérer l'erreur selon vos besoins
  }
}

Future<void> envoi() async {
  try {
    products = await GetProductFromCart();
    final user = getCurrentUser();

    if (user != null) {
      for (var order in products) {
        // Récupérer l'identifiant du marchand associé au produit
        String? merchantId = order['boutiqueId'];

        // Vérifier si l'identifiant du marchand est valide
        if (merchantId != null && merchantId.isNotEmpty) {
          // Accéder au document du marchand dans Firebase Firestore
          DocumentReference merchantDocRef = FirebaseFirestore.instance
              .collection('marchands')
              .doc(merchantId);

          // Mettre à jour le champ 'commandes' du marchand avec le produit
          await merchantDocRef.update({
            'commandes': FieldValue.arrayUnion([
              {
                ...order,
                'lieuLivraison': deliveryAddress,
                'numeroLivraison': deliveryNumero,
              }
            ]),
          });
        }
      }

      Get.snackbar("Succès", "Commandes envoyées aux marchands");
    } else {
      Get.snackbar("Erreur", "Impossible d'envoyer les produits");
    }
  } catch (e) {
    Get.snackbar("Erreur", "Une erreur est survenue : $e");
  }
}

Future<void> commande() async {
  try {
    products = await GetProductFromCart();
    final user = getCurrentUser();

    if (user != null) {
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);

      // Mettre à jour la base de données avec le lieu et le numéro de livraison
      await userDocRef.update({
        'paiementBoutique': FieldValue.arrayUnion(
          products
              .map((order) => {
                    ...order,
                    'lieuLivraison': deliveryAddress,
                    'numeroLivraison': deliveryNumero,
                  })
              .toList(),
        ),
      });

      // Mettre à jour le statut et supprimer les produits du panier
      for (var order in products) {
        order['status'] = true;
        commandes.add(order);
      }

      // Supprimer le produit du panier
      await clearCart();
    } else {
      Get.snackbar("Erreur", "Impossible de mettre à jour le statut");
    }
  } catch (e) {
    Get.snackbar("Erreur", "Une erreur est survenue : $e");
  }
}

bool isStepValid() {
  switch (currentStep) {
    case 0:
      return true;
    case 1:
      return true;
    case 2:
      return deliveryAddress != null && deliveryNumero != null;
    default:
      return false;
  }
}

class _UtilisateurState extends State<Utilisateur> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Livraison de la commande")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Stepper(
            currentStep: currentStep,
            onStepContinue: () {
              if (isStepValid()) {
                if (currentStep < 2) {
                  setState(() {
                    currentStep++;
                  });
                } else {
                  envoi();
                  commande();
                  //sendNotificationForPromo();
                }
              }
            },
            onStepCancel: () {
              if (currentStep > 0) {
                setState(() {
                  currentStep--;
                });
              }
            },
            steps: [
              Step(
                title: Text('Service de Livraison'),
                content: Card(
                  color: Colors.orange, // Couleur de l'arrière-plan
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Prix en fonction de la distance :',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white, // Couleur du texte
                          ),
                        ),
                        Text(
                          'Inférieur à 5km : 500 F',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white, // Couleur du texte
                          ),
                        ),
                        Text(
                          'Entre 5km et 10km : 1000 F',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white, // Couleur du texte
                          ),
                        ),
                        Text(
                          'Supérieur à 10km : 2000 F',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white, // Couleur du texte
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Step(
                title: const Text('Processus de paiement'),
                content: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              side: BorderSide.none,
                              shape: const StadiumBorder()),
                          child: const Text(
                            "Payez maintenant",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Step(
                title: Text('Processus de Livraison'),
                content: DeliveryInfoWidget(
                  formKey: _formKey,
                  deliveryAddress: deliveryAddress,
                  deliveryNumero: deliveryNumero,
                  updateDeliveryInfo: (address, numero) {
                    setState(() {
                      deliveryAddress = address;
                      deliveryNumero = numero;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
