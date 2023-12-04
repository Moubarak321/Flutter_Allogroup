import 'package:flutter/material.dart';
import 'package:allogroup/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ButtonServices extends StatefulWidget {
  const ButtonServices({Key? key});

  @override
  State<ButtonServices> createState() => _ButtonServicesState();
}

class _ButtonServicesState extends State<ButtonServices> {
  int currentSelectedItem = -1;

  List<String> serviceNames = ["AlloFood", "AlloLivreur", "Aide"];

  // commenté pour test popular
  List<String> serviceRoutes = [
    Routes.mainFoodPage,
    // Routes.interfaceMarchand,
    Routes.delivery,
    Routes.homehelp
  ];

  List<String> serviceRoutes1 = [
    Routes.interfaceMarchand,
    Routes.interfaceLivreur,
  ]; // Routes correspondant aux boutons

  Future<String?> getUserRole() async {
    try {
      // Récupérer l'utilisateur authentifié
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Accéder au document de l'utilisateur dans Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        var a = userDoc.data();
        print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ $a ");
        // Vérifier si le champ "role" existe dans le document
        if (userDoc.exists && userDoc.data() is Map<String, dynamic>) {
          print(
              "****************************role******************************");
          // Récupérer et retourner la valeur du champ "role"
          print("33333333333333333333333333333333333" +
              (userDoc.data() as Map<String, dynamic>)['role']);
          return (userDoc.data() as Map<String, dynamic>)['role'];
        }
      }
    } catch (e) {
      print("Erreur lors de la récupération du rôle de l'utilisateur : $e");
    }

    // Retourner null si l'utilisateur n'a pas de rôle défini
    return null;
  }

  // test popular
  // List<String> serviceRoutes = [Routes.popularFoodDetails, Routes.delivery, Routes.help]; // Routes correspondant aux boutons

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: serviceNames.length,
          itemBuilder: (context, index) {
            return Stack(
              children: [
                Column(
                  children: [
                    Container(
                      height: 90,
                      width: 90,
                      margin: EdgeInsets.only(
                        left: index == 0 ? 20 : 0,
                        right: 20,
                      ),
                      child: GestureDetector(
                        // onTap: () {
                        //   setState(() {
                        //     currentSelectedItem = index;
                        //   });

                        //   // Navigation vers la page correspondante
                        //   Navigator.pushNamed(context, serviceRoutes[index]);

                        // },
                        onTap: () async {
                          setState(() {
                            currentSelectedItem = index;
                          });

                          // Récupérer le rôle de l'utilisateur
                          String? userRole =
                              await getUserRole(); // À implémenter

                          // Vérifier le rôle et rediriger en conséquence
                          if (userRole == "Champion" && index == 1) {
                            // Utilisateur avec le rôle "livreur" - rediriger vers la page livreur
                            Navigator.pushNamed(context, serviceRoutes1[1]);
                          } else if (userRole == "Marchand" && index == 0) {
                            // Aucun rôle défini - rediriger vers la page de bienvenue
                            Navigator.pushNamed(context, serviceRoutes1[0]);
                          } else {
                            // Autres cas - rediriger vers la page correspondante
                            Navigator.pushNamed(context, serviceRoutes[index]);
                          }
                        },

                        child: Card(
                          color: index == currentSelectedItem
                              ? const Color.fromRGBO(10, 80, 137, 0.8)
                                  .withOpacity(0.7)
                              : Colors.white,
                          elevation: 3,
                          margin: EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Icon(
                            index == 0
                                ? Icons.fastfood
                                : index == 1
                                    ? Icons.delivery_dining
                                    : Icons.help,
                            color: index == currentSelectedItem
                                ? Colors.white
                                : Colors.orange,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    margin: EdgeInsets.only(
                      left: index == 0 ? 20 : 0,
                      right: 20,
                    ),
                    width: 90,
                    child: Row(
                      children: [
                        Spacer(),
                        Text(serviceNames[index],
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                fontWeight: FontWeight.w100,
                                color: Colors.black54)),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
