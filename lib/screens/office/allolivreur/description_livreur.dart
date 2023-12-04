import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/recuperation.dart';
import '../components/livraison.dart';
import '../components/details.dart';
import 'package:get/get.dart';
import './attente_livreur.dart';

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
  String? password;
  //final prix = Recuperationprix(pickupAddress);
  // DateTime? deliveryDate;
  // TimeOfDay? deliveryTime;
  DateTime? selectedDateTime = DateTime.now();
  int currentStep = 0; // Étape actuelle du formulaire
  

  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
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
        Map<String, dynamic>? data =
            zoneSnapshot.data() as Map<String, dynamic>?;

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
      
      throw e; 
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
        Map<String, dynamic>? data =
            prixSnapshot.data() as Map<String, dynamic>?;

        if (data != null && data.containsKey('prix')) {
          List<dynamic> prixList = data['prix'];

          if (indice >= 0 && indice < prixList.length) {
            return prixList[indice]; // Retourner le prix correspondant à l'indice
          }
        }
      }
    } catch (e) {
      print('Erreur lors de la récupération des prix : $e');
      throw e; // Gérer l'erreur selon vos besoins
    }

    return -1; // Prix non trouvé pour l'indice donné
  }


  void saveFormDataToFirestore () {
    final user = getCurrentUser();
    if (user != null) {
      final courseId = DateTime.now().millisecondsSinceEpoch.toString();

      final userData = {
        'id': courseId,
        'type_courses': 'Livraison de bien',
        'addressRecuperation': pickupAddress,
        'numeroARecuperation': pickupNumero,
        'addressLivraison': deliveryAddress,
        'numeroALivraison': deliveryNumero,
        'dateDeLivraison': selectedDateTime,
        'password': password,
        'title': title,
        'details': details,
        'prix': Recuperationprix(pickupAddress ?? ''),
        'status': false,
      };

      // Adding data to 'administrateur' collection
      FirebaseFirestore.instance
          .collection('administrateur')
          .doc("commandeCourses")
          .update({
        'courses': FieldValue.arrayUnion([userData])
      }).then((_) {
        // Data saved successfully.
        print("Data saved successfully to 'administrateur' collection");
      }).catchError((error) {
        // An error occurred while updating the data.
      });

      // Adding data to 'users' collection
      FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'courses': FieldValue.arrayUnion([userData])
      }).then((_) {
        // Data saved successfully.
      }).catchError((error) {
        // An error occurred while updating the data.
        print("Error in 'users' collection: $error");
      });
    }
  }

  void sendNotificationForPromo() async {}

  Future<DateTime?> setDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      helpText: "Choisissez une date de livraison",
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      // ignore: use_build_context_synchronously
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          );
        },
        helpText: "Choisissez l'heure de la livraison",
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        // Combine date and time into a single DateTime object
        DateTime selectedDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        // Return the selected DateTime
        print(selectedDateTime);
        return selectedDateTime;
      }
    }

    // Return null if the user cancels the date or time picker
    return null;
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
        return selectedDateTime != null;
      case 4:
        return password != null;
      case 5:
        return title != null && details != null;
      case 6:
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
        actions: [
          IconButton(
            icon: Icon(Icons.location_on), // Icône de suivi
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
                if (currentStep < 6) {
                  setState(() {
                    currentStep++;
                  });
                } else {
                  saveFormDataToFirestore();
                  Get.snackbar(
                      "Succès", "Votre comande est envoyée au livreur");

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConfirmationLivraison(),
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
                title: Text('Date de livraison'),
                content: Column(
                  children: [
                    // Use any date picker widget of your choice
                    ElevatedButton(
                      onPressed: () async {
                        await setDate(context);
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.orange),
                      ),
                      child: Text(
                        selectedDateTime != null
                            ? 'Date sélectionnée: $selectedDateTime'
                            : 'Date actuelle: ${DateTime.now()}',
                      ),
                    ),
                    SizedBox(height: 16.0),
                  ],
                ),
              ),
              Step(
                title: Text('Sécurisez votre course'),
                content: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        labelText:
                            'Code de sécurité', // Vous pouvez personnaliser le texte d'invite
                      ),
                      onChanged: (value) {
                        setState(() {
                          password = value;
                        });
                        // Vous pouvez utiliser la valeur entrée par l'utilisateur ici
                        // La valeur est accessible via la variable "value"
                        // Vous pouvez la stocker dans une variable d'état ou la traiter comme nécessaire
                      },
                    ),
                    // Ajoutez d'autres champs ou widgets selon vos besoins
                  ],
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
                          'Zone de Récupération: $pickupAddress',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white, // Couleur du texte
                          ),
                        ),
                        Text(
                          'Destinataire: $deliveryAddress',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white, // Couleur du texte
                          ),
                        ),
                        Text(
                          'Date de Livraison: $selectedDateTime',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white, // Couleur du texte
                          ),
                        ),
                        FutureBuilder<int>(
                          future: Recuperationprix(pickupAddress ?? ''),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
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
                                  'Prix du service : ${snapshot.data ?? ''}',
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
