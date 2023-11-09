import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/recuperation.dart';
import '../components/livraison.dart';
import '../components/details.dart';
// import './attente_livreur.dart';
import 'package:get/get.dart';


class DeliveryFormPage extends StatefulWidget {
  @override
  _DeliveryFormPageState createState() => _DeliveryFormPageState();
}

class _DeliveryFormPageState extends State<DeliveryFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? pickupAddress;
  int? pickupNumero;
  String? deliveryAddress;
  int? deliveryNumero;
  String? title;
  String? details;

  int currentStep = 0; // Étape actuelle du formulaire

/** 
  double calculatePrice(Position startPoint, Position endPoint) {
  // Supposons que Position est une classe qui contient les coordonnées
  // Vous devrez ajuster cela en fonction de votre propre modèle de données

  // Calculez la distance entre les deux points (par exemple, en kilomètres)
  double distance = calculateDistance(startPoint, endPoint);

  // Appliquez vos tarifs en fonction de la distance
    if (distance < 5) {
      return 500.0; // Prix si la distance est inférieure à 5 km
    } else if (distance >= 5 && distance <= 10) {
      return 1000.0; // Prix si la distance est entre 5 km et 10 km
    } else {
      return 2000.0; // Prix si la distance est supérieure à 10 km
    }
  }

  double calculateDistance(Position startPoint, Position endPoint) {
    // Ici, vous pouvez utiliser des formules mathématiques ou des bibliothèques
    // pour calculer la distance entre les deux points. Par exemple, la formule de Haversine
    // ou utiliser une bibliothèque comme geolocator

    // Pour cet exemple, supposons que vous avez une méthode pour calculer la distance
    // entre deux points (en kilomètres)
    double distance = startPoint.distanceTo(endPoint);

    return distance;
  } */

  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  void saveFormDataToFirestore() {
    final user = getCurrentUser();
    if (user != null) {
      final courseId = DateTime.now();

      final userData = {
        'id': courseId,
        'type_courses': 'Livraison de bien',
        'addressRecuperation': pickupAddress,
        'numeroARecuperation': pickupNumero,
        'addressLivraison': deliveryAddress,
        'numeroALivraison': deliveryNumero,
        'title': title,
        'details': details,
        'prix': 500,
        'status': false,
      };

      FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'courses': FieldValue.arrayUnion([userData]),
      }).then((_) {
        // Les données ont été enregistrées avec succès.
      }).catchError((error) {
        // Une erreur s'est produite lors de la mise à jour des données.
      });
    }
  }

  bool isStepValid() {
    switch (currentStep) {
      case 0:
        return true;
      case 1:
        return pickupAddress != null && pickupNumero != null;
      case 2:
        return deliveryAddress != null && deliveryNumero != null;
      case 3:
        return title != null && details != null;
      case 4:
        return true;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Informations sur la Course'),
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
                  // Soumission du formulaire, faites ce que vous voulez ici
                  saveFormDataToFirestore();
                  Get.snackbar("Succès", "Statut mis à jour");

                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => DeliveryMapPage(),
                  //   ),
                  // );
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
                title: Text('Adresse de Récupération'),
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
                title: Text('Adresse de Livraison'),
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
                title: Text('Bilan de course'),
                content: Card(
                  color: Colors.orange, // Couleur de l'arrière-plan
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Lieu de Récupération: $pickupAddress',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white, // Couleur du texte
                          ),
                        ),
                        Text(
                          'Lieu de Livraison: $deliveryAddress',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white, // Couleur du texte
                          ),
                        ),
                        Text(
                          'Prix du service : 500 F',
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
            ],
          ),
        ),
      ),
    );
  }
}
