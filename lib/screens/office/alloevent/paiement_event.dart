import 'dart:convert';
import 'package:allogroup/screens/office/user/utilisateur/details/historiqueCouresActuelle.dart';
import 'package:allogroup/screens/office/widgets/app_icon.dart';
import 'package:http/http.dart' as http;
import 'package:allogroup/screens/office/widgets/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:allogroup/screens/office/components/recuperation.dart';
import 'package:get/get.dart';
import '../allolivreur/attente_livreur.dart';
import '../components/details.dart';

class PaiementEvent extends StatefulWidget {
  const PaiementEvent({Key? key}) : super(key: key);

  @override
  State<PaiementEvent> createState() => _PaiementEventState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
String? pickupAddress;
int? pickupNumero;
String? title;
String? details;
String? error;
List<Map<String, dynamic>> tousLesProduits = [];
List<Map<String, dynamic>> commandes = [];
List<Map<String, dynamic>> products = [];

User? getCurrentUser() {
  return FirebaseAuth.instance.currentUser;
}

int currentStep = 0; // Étape actuelle du formulaire
String cancel = "Cancel";

Future<void> sendNotificationToMerchant(
    String token, String body, String title) async {
  try {
    final String serverKey =
        "AAAAhN35nhQ:APA91bEABl_ccVcCigFgN6QOrpgFvdEbyzxtTsDSGhy2BN8IUGd_Pfkeeaj5CkDeygLZBB2Bn5PRYqQesDsRVwab9EcgYtFklvKVSTX0d9xOH44g3VqHXxQv1IBmxHsw6nGg_WGG9EUV";

    final Map<String, dynamic> data = {
      'priority': 'high',
      'notification': {
        'title': title,
        'body': body,
      },
      'data': {
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'status': 'done',
      },
      'to': token,
    };

    final String jsonBody = jsonEncode(data);

    final http.Response response = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      },
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      //print('Notification envoyée avec succès à $token');
    } else {
      print(
          'Échec de l\'envoi de la notification à $token. Statut : ${response.statusCode}');
    }
  } catch (e) {
    print('Erreur lors de l\'envoi de la notification : $e');
  }
}

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
      List<dynamic> cart = userData['cartEvent'] as List<dynamic>;

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
        'cartEvent': [],
      });
    }
  } catch (e) {
    // print("Erreur lors de la suppression du panier : $e");
    // Gérer l'erreur selon vos besoins
  }
}

Future<String?> getUserToken(String userId) async {
  try {
    DocumentSnapshot userDocSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    Map<String, dynamic>? userData =
        userDocSnapshot.data() as Map<String, dynamic>?;

    if (userData != null && userData.containsKey('fcmToken')) {
      return userData['fcmToken'] as String?;
    } else {
      return null;
    }
  } catch (e) {
    print('Erreur lors de la récupération du token de l\'utilisateur : $e');
    return null;
  }
}

Future<void> envoi() async {
  try {
    products = await GetProductFromCart();
    final user = getCurrentUser();
    if (user != null) {
      for (var order in products) {
        // Récupérer l'identifiant du marchand associé au produit
        String? userToken = await getUserToken(user.uid);
        String? merchantId = order['boutiqueId'];
        print(userToken);
        // Vérifier si l'identifiant du marchand est valide
        if (merchantId != null && merchantId.isNotEmpty) {
          // Accéder au document du marchand dans Firebase Firestore
          DocumentReference merchantDocRef = FirebaseFirestore.instance
              .collection('events')
              .doc(merchantId);

          final DocumentSnapshot merchantDocSnapshot =
              await merchantDocRef.get();
          final Map<String, dynamic>? merchantData =
              merchantDocSnapshot.data() as Map<String, dynamic>?;
          String token = merchantData?['fcmToken'];
          // Mettre à jour le champ 'commandes' du marchand avec le produit
          await merchantDocRef.update({
            'commandes': FieldValue.arrayUnion([
              {
                ...order,
                'commandaire': user.uid,
                'lieuLivraison': pickupAddress,
                'numeroLivraison': pickupNumero,
                'detailsLivraison': details,
                'titreLivraison': title,
                'prix': await Recuperationprix(pickupAddress ?? ''),
                'paye':
                    (int.parse(order['prix']) * int.parse(order['quantite']))
                        .toString(),
                'fcmToken': userToken,
              }
            ]),
          });
          final prix = int.parse(order['prix']) * int.parse(order['quantite']);
          final nom = order['boutique'];
          String body =
              "Vous avez recu une commande de ${order['quantite']} ${order['titre']} du ${order['numeroLivraison']} pour la zone ${order['lieuLivraison']}";
          String titre = "Commande de ${order['titre']}";
          sendNotificationToMerchant(token, titre, body);

          Get.snackbar("Succès",
              "Commande envoyée au marchand $nom et vous payerai $prix F en plus du service livraison habituel.",
              backgroundColor: Colors.orange, colorText: Colors.white);
        }
      }
    } else {
      Get.snackbar("Erreur", "Impossible d'envoyer les produits",
          backgroundColor: Colors.orange, colorText: Colors.white);
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
        'paiementFood': FieldValue.arrayUnion(
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
      Get.snackbar("Erreur", "Impossible de mettre à jour le statut",
          backgroundColor: Colors.orange, colorText: Colors.white);
    }
  } catch (e) {
    Get.snackbar("Erreur", "Une erreur est survenue ",
        backgroundColor: Colors.orange, colorText: Colors.white);
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

class _PaiementEventState extends State<PaiementEvent> {
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
            Text("Livraison de la commande",
                style: TextStyle(
                    color: Colors.white, fontSize: Dimensions.height20)),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConfirmationLivraison(),
                  ),
                );
              },
              child: AppIcon(
                icon: Icons.location_on,
                iconColor: Colors.white,
                backgroundColor: Color(0xCC0A5089),
              ),
            ),
          ],
        ),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return HistoriqueCoursesActuelle();
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
                title: Text('Détails sur la Course'),
                content: DetailsInfoWidget(
                  formKey: _formKey,
                  title: title,
                  details: details,
                  updateDetailsInfo: (courseTitle, courseDetails) {
                    setState(() {
                      title = courseTitle;
                      details = courseDetails;
                    });
                  },
                ),
              ),
              Step(
                title: Text("Service de livraison"),
                content: Card(
                  color: Colors.orange,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        FutureBuilder<int>(
                          future: Recuperationprix(pickupAddress ?? ''),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              // Afficher un indicateur de chargement si nécessaire
                              return CircularProgressIndicator();
                            } else {
                              if (snapshot.hasError) {
                                // Gérer les erreurs si elles se produisent pendant le chargement des données
                                return Text(
                                  'Erreur lors de la récupération du prix',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.white, // Couleur du texte
                                  ),
                                );
                              } else {
                                // Afficher le prix récupéré
                                return Text(
                                  'Prix du service : ${snapshot.data ?? ''} F',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.white, // Couleur du texte
                                  ),
                                );
                              }
                            }
                          },
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
