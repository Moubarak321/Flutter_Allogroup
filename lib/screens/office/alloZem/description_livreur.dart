import 'package:allogroup/screens/office/user/utilisateur/details/historiqueCouresActuelle.dart';
import 'package:allogroup/screens/office/widgets/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'dart:convert';
import '../components/recuperation.dart';
import '../components/livraison.dart';
import '../components/details.dart';
import 'package:get/get.dart';
import './attente_livreur.dart';

class DeliveryFormPage extends StatefulWidget {
  @override
  _DeliveryFormPageState createState() => _DeliveryFormPageState();
}
const kGoogleApiKey = "AIzaSyAgjmN1oAneb0t9v8gIgWSWkwwBj-KLLsw";
class _DeliveryFormPageState extends State<DeliveryFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  String? pickupAddress;
  int? pickupNumero;
  String? deliveryAddress;
  int? deliveryNumero;
  String? title;
  String? details;
  String? password;

  DateTime? selectedDateTime = DateTime.now();
  int currentStep = 0; // Étape actuelle du formulaire

  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  Future<List<String>> recuperationToken() async {
    try {
      final QuerySnapshot championsSnapshot =
          await FirebaseFirestore.instance.collection('zems').get();

      List<String> tokens = [];

      championsSnapshot.docs.forEach((DocumentSnapshot document) {
        final Map<String, dynamic>? championData =
            document.data() as Map<String, dynamic>?;

        if (championData != null && championData.containsKey('fcmToken')) {
          final String? fmcToken = championData['fcmToken'] as String?;
          if (fmcToken != null) {
            tokens.add(fmcToken);
          }
        }
      });
      return tokens;
    } catch (e) {
      // Gérer les erreurs ici
      print('Erreur lors de la récupération des tokens : $e');
      return []; // Retourner une liste vide en cas d'erreur
    }
  }

  Future<void> sendNotificationToChampion(
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
  
 Future<int> Recuperationdistance(String pickupAddress, String deliveryAddress) async {
  try {
    final String apiUrl = "https://maps.googleapis.com/maps/api/distancematrix/json";
    
    final Map<String, String> params = {
      'origins': pickupAddress,
      'destinations': deliveryAddress,
      'key': kGoogleApiKey,
    };

    final Uri uri = Uri.parse(apiUrl).replace(queryParameters: params);

    final http.Response response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      // Vérifier si la requête a réussi
      if (data['status'] == 'OK') {
        // Extraire la distance depuis la réponse JSON
        final String distanceText =
            data['rows'][0]['elements'][0]['distance']['text'];

        // Convertir la distance en mètres
        final double distanceInMeters = double.parse(
          distanceText.replaceAll(RegExp(r'[^0-9.]'), ''),
        );

        // Appliquer la logique de tarification basée sur la distance
        return distanceInMeters.toInt(); // Convertir la distance en entier
      } else {
        print("Erreur dans la réponse de l'API Distance Matrix: ${data['status']}");
      }
    } else {
      print("Erreur lors de la requête vers l'API Distance Matrix. Statut : ${response.statusCode}");
    }
  } catch (e) {
    print("Erreur lors de la récupération de la distance : $e");
  }

  // En cas d'erreur, retourner une valeur par défaut
  return -1;
}

  Future<int> Recuperationprix(String pickupAddress, String deliveryAddress) async {
  try {
    final String apiUrl =
        "https://maps.googleapis.com/maps/api/distancematrix/json?origins=$pickupAddress&destinations=$deliveryAddress&key=$kGoogleApiKey";

    final http.Response response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      // Vérifier si la requête a réussi
      if (data['status'] == 'OK') {
        // Extraire la distance depuis la réponse JSON
        final String distanceText =
            data['rows'][0]['elements'][0]['distance']['text'];

        // Convertir la distance en mètres
        final double distanceInMeters = double.parse(
          distanceText.replaceAll(RegExp(r'[^0-9.]'), ''),
        );

        // Appliquer la logique de tarification basée sur la distance
        return calculerPrix(distanceInMeters);
      } else {
        print("Erreur dans la réponse de l'API Distance Matrix");
      }
    } else {
      print("Erreur lors de la requête vers l'API Distance Matrix");
    }
  } catch (e) {
    print("Erreur lors de la récupération de la distance : $e");
  }

  // En cas d'erreur, retourner une valeur par défaut
  return -1;
}

  int calculerPrix(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return 500; 
    } else if (distanceInMeters < 5000) {
      return 1000; // Exemple de prix pour une distance entre 1 km et 5 km
    } else {
      return 1500; // Exemple de prix pour une distance supérieure à 5 km
    }
  }

 

  Future<void> saveFormDataToFirestore() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final courseId = DateTime.now().millisecondsSinceEpoch.toString();

        // Récupérer le token de l'utilisateur
        String? fcmToken = await getUserFCMToken(user.uid);

        final userData = {
          'id': courseId,
          'commandaire': user.uid,
          'type_courses': 'Taxi moto',
          'addressRecuperation': pickupAddress,
          'numeroARecuperation': pickupNumero,
          'addressLivraison': deliveryAddress,
          'numeroALivraison': deliveryNumero,
          'dateDeLivraison': selectedDateTime,
          'password': password,
          'title': title,
          'details': details,
          'prix': await Recuperationprix(pickupAddress ?? '', deliveryAddress ?? ''),
          'status': false,
          'fcmToken': fcmToken,
        };

        // Ajouter les données à la collection 'administrateur'
        await FirebaseFirestore.instance
            .collection('administrateur')
            .doc("commandeCourses")
            .update({
          'courses': FieldValue.arrayUnion([userData])
        });

        // Ajouter les données à la collection 'users'

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'coursesLivraison': FieldValue.arrayUnion([userData])
        });
      }
    } catch (error) {
      // Gérer les erreurs
      print("Erreur lors de l'enregistrement des données : $error");
    }
  }

  Future<String?> getUserFCMToken(String userId) async {
    try {
      DocumentSnapshot userDocSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

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

  void sendNotificationLivraison() async {
    List<String> tokens = await recuperationToken();
    String titre = "Livraison";
    String body = "Une nouvelle livraison est disponible";
    for (String token in tokens) {
      print('token');
      sendNotificationToChampion(token, titre, body);
    }
  }

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
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(LineAwesomeIcons.angle_left, color: Colors.white)),
        title: Text(
          'Informations sur la Course',
          style: TextStyle(color: Colors.white, fontSize: Dimensions.height20),
        ),
        actions: [
          IconButton(
            icon:
                Icon(Icons.location_on, color: Colors.white), // Icône de suivi
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    // return HistoriqueCoursesActuelle();
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
                  sendNotificationLivraison();
                  Get.snackbar("Succès", "Votre comande est envoyée au livreur",
                      backgroundColor: Colors.orange, colorText: Colors.white);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HistoriqueCoursesActuelle(),
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
                title: Text("Information sur le lieu de départ "),
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
                title: Text('Information sur le receveur'),
                content: DeliveryInfoWidget(
                  formKey: _formKey,
                  deliveryAddress: deliveryAddress,
                  deliveryNumero: deliveryNumero,
                  updateDeliveryInfo: (address, numero) {
                    print(address);
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
                title: Text("Plus d'orientation"),
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
                          'Récupération: $pickupAddress',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white, // Couleur du texte
                          ),
                        ),
                        Text(
                          'Destination: $deliveryAddress',
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
                        Text(
                              'Estimation de distance: ',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.white, // Couleur du texte
                              ),
                            ),
                            FutureBuilder<int>(
                              future: Recuperationdistance(pickupAddress ?? '', deliveryAddress ?? ''),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return CircularProgressIndicator(); // Afficher un indicateur de chargement pendant le chargement de la distance
                                } else if (snapshot.hasError) {
                                  return Text(
                                    'Erreur lors de la récupération de la distance',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.white,
                                    ),
                                  );
                                } else {
                                  // Utiliser la distance récupérée
                                  return Text(
                                    '${snapshot.data} mètres',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.white,
                                    ),
                                  );
                                }
                              },
                            ),
                        FutureBuilder<int>(
                          future: Recuperationprix(pickupAddress ?? '', deliveryAddress ?? ''),
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
