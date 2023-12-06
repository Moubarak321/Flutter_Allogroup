import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:allogroup/screens/office/components/recuperation.dart';
import 'package:get/get.dart';
import '../allolivreur/attente_livreur.dart';

class Utilisateur extends StatefulWidget {
  const Utilisateur({Key? key}) : super(key: key);

  @override
  State<Utilisateur> createState() => _UtilisateurState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
String? pickupAddress;
int? pickupNumero;
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

Future<int> Recuperationprix(String pickupAddress) async {
  try {
    // Récupérer les données depuis Firestore
    DocumentSnapshot zoneSnapshot = await FirebaseFirestore.instance
        .collection('administrateur')
        .doc('zone')
        .get();

    // Vérifier si le document existe et s'il contient la clé 'livraison'
    if (zoneSnapshot.exists) {
      Map<String, dynamic>? data = zoneSnapshot.data() as Map<String, dynamic>?;

      if (data != null && data.containsKey('livraison')) {
        List<dynamic> livraisonList = data['livraison'];

        // Parcourir la liste des adresses de livraison pour trouver l'indice
        for (int i = 0; i < livraisonList.length; i++) {
          // Vérifier si l'adresse correspond à celle fournie
          if (livraisonList[i] == pickupAddress) {
            return await getPrixForIndice(i);
          }
        }

        return -1;
      }
    }
  } catch (e) {
    print('Erreur lors de la récupération des adresses de livraison : $e');

  }

  return -1;
}

Future<int> getPrixForIndice(int indice) async {
  try {
    // Récupérer les données depuis Firestore pour les prix
    DocumentSnapshot prixSnapshot = await FirebaseFirestore.instance
        .collection('administrateur')
        .doc('zone')
        .get();

    // Vérifier si le document existe et s'il contient la clé 'prix'
    if (prixSnapshot.exists) {
      Map<String, dynamic>? data = prixSnapshot.data() as Map<String, dynamic>?;

      if (data != null && data.containsKey('prix')) {
        List<dynamic> prixList = data['prix'];

        if (indice >= 0 && indice < prixList.length) {
          return prixList[indice]; // Retourner le prix correspondant à l'indice
        }
      }
    }
  } catch (e) {
    // print('Erreur lors de la récupération des prix : $e');
    // throw e; // Gérer l'erreur selon vos besoins
  }

  return -1; // Prix non trouvé pour l'indice donné
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
    // print("Erreur lors de la suppression du panier : $e");
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
                'commandaire': user.uid,
                'lieuLivraison': pickupAddress,
                'numeroLivraison': pickupNumero,
                'prix': await Recuperationprix(pickupAddress ?? ''),
                'paye': (int.parse(order['prix']) * int.parse(order['quantite'])).toString(),
              }
            ]),
          });
          final prix = int.parse(order['prix']) * int.parse(order['quantite']);
          final nom = order['boutique'];

          Get.snackbar("Succès",
              "Commande envoyée au marchand $nom et vous payerai $prix F", backgroundColor: Colors.orange,
                                        colorText: Colors.white);
        }
      }
    } else {
      Get.snackbar("Erreur", "Impossible d'envoyer les produits", backgroundColor: Colors.orange,
                                        colorText: Colors.white);
    }
  } catch (e) {
    Get.snackbar("Erreur", "Une erreur est survenue ");
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
                    'lieuLivraison': pickupAddress,
                    'numeroLivraison': pickupNumero,
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
      Get.snackbar("Erreur", "Impossible de mettre à jour le statut", backgroundColor: Colors.orange,
                                        colorText: Colors.white);
    }
  } catch (e) {
    Get.snackbar("Erreur", "Une erreur est survenue ", backgroundColor: Colors.orange,
                                        colorText: Colors.white);
  }
}

bool isStepValid() {
  switch (currentStep) {
    case 0:
      return true;
    case 1:
      return true;
    case 2:
      return pickupAddress != null && pickupNumero != null;
    case 3:
      return true;
    case 4:
      return true;
    default:
      return false;
  }
}

class _UtilisateurState extends State<Utilisateur> {
  int totalPrice = 0;
  int deliveryCost = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData(); // Appel de la méthode pour récupérer les valeurs
  }

  Future<void> fetchData() async {
    // Récupération des valeurs du panier et de la livraison
    fetchProductsFromCart();
    deliveryCost = await Recuperationprix(pickupAddress ?? '');
    isLoading = false; // Mettre à jour l'état du chargement
    setState(() {});
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Livraison de la commande'),
        actions: [
          IconButton(
            icon: Icon(Icons.location_on),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ConfirmationLivraison();
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Stepper(
            currentStep: currentStep,
            onStepContinue: () {
              if (isStepValid()) {
                if (currentStep < 4) {
                  setState(() {
                    currentStep++;
                  });
                } else {
                  envoi();
                  commande();
                  //sendNotificationForPromo();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ConfirmationLivraison();
                      },
                    ),
                  );
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
                          'Nous vous prions de consulter le contrat de livraison',
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
                            "Payez à la livraison",
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
                content: PickupInfoWidget(
                  formKey: _formKey,
                  pickupAddress: pickupAddress,
                  pickupNumero: pickupNumero,
                  updatePickupInfo: (address, numero) {
                    setState(() {
                      pickupAddress = address;
                      pickupNumero = numero;
                    });
                  },
                ),
              ),
              Step(
                title: Text('Pour le livreur'),
                content: Card(
                  color: Colors.orange, // Couleur de l'arrière-plan
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Une fois le livreur sur place, vous pourrez lui payer le service de livraison et le prix des produits. Dans le cas où la commande est effectuée dans divers boutique, vous aurez autant de livraison',
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
                title: Text("Sécurisation"),
                content: Card(
                  color: Colors.orange,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Le code de sécurité est confié à la charge du marchand",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                        ),
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
  }
}
