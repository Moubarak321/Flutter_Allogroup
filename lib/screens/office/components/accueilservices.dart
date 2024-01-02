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

  List<String> serviceNames = [
    "AlloFood",
    "AlloLivreur",
    "AlloMarket",
    "AlloZem",
    "AlloEvent",
    "Aide"
  ];

  // commenté pour test popular
  List<String> serviceRoutes = [
    Routes.mainFoodPage,
    // Routes.interfaceMarchand,
    Routes.delivery,
    Routes.interfaceBoutique,
    Routes.interfaceZem,
    Routes.evenement,
    Routes.homehelp,
  ];

  List<String> serviceRoutes1 = [
    Routes.interfaceMarchand,
    Routes.interfaceLivreur,
    Routes.interfaceShopKeeper,
    Routes.interfaceKekenon
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

        // Vérifier si le champ "role" existe dans le document
        if (userDoc.exists && userDoc.data() is Map<String, dynamic>) {
          return (userDoc.data() as Map<String, dynamic>)['role'];
        }
      }
    } catch (e) {
      // print("Erreur lors de la récupération du rôle de l'utilisateur : $e");
    }

    // Retourner null si l'utilisateur n'a pas de rôle défini
    return null;
  }

  // test popular
  // List<String> serviceRoutes = [Routes.popularFoodDetails, Routes.delivery, Routes.help]; // Routes correspondant aux boutons

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Center(
        child: SizedBox(
          height: 200, // Ajustez la hauteur en fonction du nombre de rangées
          child: Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: List.generate(
              serviceNames.length,
              (index) {
                return Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          height: 90,
                          width: 90,
                          child: GestureDetector(
                            onTap: () async {
                              setState(() {
                                currentSelectedItem = index;
                              });

                              // Récupérer le rôle de l'utilisateur
                              String? userRole = await getUserRole();

                              // Vérifier le rôle et rediriger en conséquence
                              if (userRole == "Livreur" && index == 1) {
                                Navigator.pushNamed(context, serviceRoutes1[1]);
                              } else if (userRole == "Marchand" && index == 0) {
                                Navigator.pushNamed(context, serviceRoutes1[0]);
                              } else if (userRole == "Shopkeeper" &&
                                  index == 2) {
                                Navigator.pushNamed(context, serviceRoutes1[2]);
                              } else if (userRole == "Chauffeur" &&
                                  index == 3) {
                                Navigator.pushNamed(context, serviceRoutes1[3]);
                              } else {
                                Navigator.pushNamed(
                                    context, serviceRoutes[index]);
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
                                // Utilisez les icônes appropriées pour chaque bouton
                                index == 0
                                    ? Icons.fastfood
                                    : index == 1
                                        ? Icons.delivery_dining
                                        : index == 2
                                            ? Icons.shopping_cart
                                            : index == 3
                                                ? Icons.directions_bike
                                                : index == 4
                                                    ? Icons.event
                                                    : Icons.help,
                                color: index == currentSelectedItem
                                    ? Colors.white
                                    : Colors.orange,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          serviceNames[index],
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.w100,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}












































//marche mais scroll
//   @override
//   Widget build(BuildContext context) {
//     return SliverToBoxAdapter(
//       child: SizedBox(
//         height: 200, // Ajustez la hauteur en fonction du nombre de rangées
//         child: ListView.builder(
//           scrollDirection:
//               Axis.vertical, // Changez la direction de défilement à vertical
//           itemCount: (serviceNames.length / 3).ceil(), // Nombre de rangées
//           itemBuilder: (context, rowIndex) {
//             return Wrap(
//               spacing: 20,
//               runSpacing: 20,
//               children: List.generate(
//                 3,
//                 (colIndex) {
//                   final index = rowIndex * 3 + colIndex;
//                   if (index < serviceNames.length) {
//                     return Stack(
//                       children: [
//                         Column(
//                           children: [
//                             Container(
//                               height: 90,
//                               width: 90,
//                               child: GestureDetector(
//                                 onTap: () async {
//                                   setState(() {
//                                     currentSelectedItem = index;
//                                   });

//                                   // Récupérer le rôle de l'utilisateur
//                                   String? userRole = await getUserRole();

//                                   // Vérifier le rôle et rediriger en conséquence
//                                   if (userRole == "Livreur" && index == 1) {
//                                     Navigator.pushNamed(
//                                         context, serviceRoutes1[1]);
//                                   } else if (userRole == "Marchand" &&
//                                       index == 0) {
//                                     Navigator.pushNamed(
//                                         context, serviceRoutes1[0]);
//                                   } else {
//                                     Navigator.pushNamed(
//                                         context, serviceRoutes[index]);
//                                   }
//                                 },
//                                 child: Card(
//                                   color: index == currentSelectedItem
//                                       ? const Color.fromRGBO(10, 80, 137, 0.8)
//                                           .withOpacity(0.7)
//                                       : Colors.white,
//                                   elevation: 3,
//                                   margin: EdgeInsets.all(10),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(25),
//                                   ),
//                                   child: Icon(
//                                     // Utilisez les icônes appropriées pour chaque bouton
//                                     index == 0
//                                         ? Icons.fastfood
//                                         : index == 1
//                                             ? Icons.delivery_dining
//                                             : index == 2
//                                                 ? Icons.shopping_cart
//                                                 : index == 3
//                                                     ? Icons.directions_bike
//                                                     : index == 4
//                                                         ? Icons.event
//                                                         : Icons.help,
//                                     color: index == currentSelectedItem
//                                         ? Colors.white
//                                         : Colors.orange,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             // SizedBox(
//                             //     height:
//                             //         1), // Ajout d'un espace entre l'icône et le texte
//                             Text(
//                               serviceNames[index],
//                               style: TextStyle(
//                                 fontFamily: 'Poppins',
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w100,
//                                 color: Colors.black54,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     );
//                   } else {
//                     return Container(); // Rendu vide pour les cases supplémentaires si le nombre total n'est pas un multiple de 3
//                   }
//                 },
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }





































//marche
//   @override
//   Widget build(BuildContext context) {
//     return SliverToBoxAdapter(
//       child: SizedBox(
//         height: 200, // Ajustez la hauteur en fonction du nombre de rangées
//         child: ListView.builder(
//           scrollDirection:
//               Axis.vertical, // Changez la direction de défilement à vertical
//           itemCount: (serviceNames.length / 3).ceil(), // Nombre de rangées
//           itemBuilder: (context, rowIndex) {
//             return Wrap(
//               spacing: 20,
//               runSpacing: 20,
//               children: List.generate(
//                 3,
//                 (colIndex) {
//                   final index = rowIndex * 3 + colIndex;
//                   if (index < serviceNames.length) {
//                     return Stack(
//                       children: [
//                         Column(
//                           children: [
//                             Container(
//                               height: 90,
//                               width: 90,
//                               child: GestureDetector(
//                                 onTap: () async {
//                                   setState(() {
//                                     currentSelectedItem = index;
//                                   });

//                                   // Récupérer le rôle de l'utilisateur
//                                   String? userRole = await getUserRole();

//                                   // Vérifier le rôle et rediriger en conséquence
//                                   if (userRole == "Livreur" && index == 1) {
//                                     Navigator.pushNamed(
//                                         context, serviceRoutes1[1]);
//                                   } else if (userRole == "Marchand" &&
//                                       index == 0) {
//                                     Navigator.pushNamed(
//                                         context, serviceRoutes1[0]);
//                                   } else {
//                                     Navigator.pushNamed(
//                                         context, serviceRoutes[index]);
//                                   }
//                                 },
//                                 child: Card(
//                                   color: index == currentSelectedItem
//                                       ? const Color.fromRGBO(10, 80, 137, 0.8)
//                                           .withOpacity(0.7)
//                                       : Colors.white,
//                                   elevation: 3,
//                                   margin: EdgeInsets.all(10),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(25),
//                                   ),
//                                   child: Icon(
//                                     // Utilisez les icônes appropriées pour chaque bouton
//                                     index == 0
//                                         ? Icons.fastfood
//                                         : index == 1
//                                             ? Icons.delivery_dining
//                                             : index == 2
//                                                 ? Icons.shopping_cart
//                                                 : index == 3
//                                                     ? Icons.directions_bike
//                                                     : index == 4
//                                                         ? Icons.event
//                                                         : Icons.help,
//                                     color: index == currentSelectedItem
//                                         ? Colors.white
//                                         : Colors.orange,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         Positioned(
//                           bottom: 0,
//                           child: Container(
//                             margin: EdgeInsets.only(
//                               left: colIndex == 0 ? 20 : 0,
//                               right: 20,
//                             ),
//                             width: 90,
//                             child: Row(
//                               children: [
//                                 Spacer(),
//                                 Text(serviceNames[index],
//                                     style: TextStyle(
//                                       fontFamily: 'Poppins',
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.w100,
//                                       color: Colors.black54,
//                                     )),
//                                 Spacer(),
                               
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     );
//                   } else {
//                     return Container(); // Rendu vide pour les cases supplémentaires si le nombre total n'est pas un multiple de 3
//                   }
//                 },
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }



























//   @override
//   Widget build(BuildContext context) {
//     return SliverToBoxAdapter(
//       child: SizedBox(
//         height: 200, // Ajustez la hauteur selon vos besoins
//         child: Column(
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: serviceNames.length,
//                 itemBuilder: (context, index) {
//                   return Stack(
//                     children: [
//                       Column(
//                         children: [
//                           Container(
//                             height: 90,
//                             width: 90,
//                             margin: EdgeInsets.only(
//                               left: index == 0 ? 20 : 0,
//                               right: 20,
//                             ),
//                             child: GestureDetector(
//                               onTap: () async {
//                                 setState(() {
//                                   currentSelectedItem = index;
//                                 });

//                                 String? userRole = await getUserRole();

//                                 if (userRole == "Livreur" && index == 1) {
//                                   Navigator.pushNamed(
//                                       context, serviceRoutes1[1]);
//                                 } else if (userRole == "Marchand" &&
//                                     index == 0) {
//                                   Navigator.pushNamed(
//                                       context, serviceRoutes1[0]);
//                                 } else {
//                                   Navigator.pushNamed(
//                                       context, serviceRoutes[index]);
//                                 }
//                               },
//                               child: Card(
//                                 color: index == currentSelectedItem
//                                     ? const Color.fromRGBO(10, 80, 137, 0.8)
//                                         .withOpacity(0.7)
//                                     : Colors.white,
//                                 elevation: 3,
//                                 margin: EdgeInsets.all(10),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(25),
//                                 ),
//                                 child: Icon(
//                                   index == 0
//                                       ? Icons.fastfood
//                                       : index == 1
//                                           ? Icons.delivery_dining
//                                           : Icons.help,
//                                   color: index == currentSelectedItem
//                                       ? Colors.white
//                                       : Colors.orange,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       Positioned(
//                         bottom: 0,
//                         child: Container(
//                           margin: EdgeInsets.only(
//                             left: index == 0 ? 20 : 0,
//                             right: 20,
//                           ),
//                           width: 90,
//                           child: Row(
//                             children: [
//                               Spacer(),
//                               Text(
//                                 serviceNames[index],
//                                 style: TextStyle(
//                                   fontFamily: 'Poppins',
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.w100,
//                                   color: Colors.black54,
//                                 ),
//                               ),
//                               Spacer(),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             ),
//             SizedBox(height: 10), // Espace entre les deux listes
//             Expanded(
//               child: ListView(
//                 scrollDirection: Axis.horizontal,
//                 children: [
//                   // Nouveaux boutons
//                   buildIconButton(Icons.shopping_cart, "AlloBoutique", 2),
//                   buildIconButton(Icons.directions_bike, "AlloZem", 3),
//                   buildIconButton(Icons.event, "AlloEvent", 4),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildIconButton(IconData icon, String label, int index) {
//     return Stack(
//       children: [
//         Column(
//           children: [
//             Container(
//               height: 90,
//               width: 90,
//               margin: EdgeInsets.only(
//                 left: index == 2 ? 20 : 0,
//                 right: 20,
//               ),
//               child: GestureDetector(
//                 onTap: () async {
//                   setState(() {
//                     currentSelectedItem = index;
//                   });

//                   String? userRole = await getUserRole();

//                   // Ajoutez des conditions spécifiques si nécessaire

//                   Navigator.pushNamed(context, serviceRoutes[index]);
//                 },
//                 child: Card(
//                   color: index == currentSelectedItem
//                       ? const Color.fromRGBO(10, 80, 137, 0.8).withOpacity(0.7)
//                       : Colors.white,
//                   elevation: 3,
//                   margin: EdgeInsets.all(10),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(25),
//                   ),
//                   child: Icon(
//                     icon,
//                     color: index == currentSelectedItem
//                         ? Colors.white
//                         : Colors.orange,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         Positioned(
//           bottom: 0,
//           child: Container(
//             margin: EdgeInsets.only(
//               left: index == 2 ? 20 : 0,
//               right: 20,
//             ),
//             width: 90,
//             child: Row(
//               children: [
//                 Spacer(),
//                 Text(
//                   label,
//                   style: TextStyle(
//                     fontFamily: 'Poppins',
//                     fontSize: 12,
//                     fontWeight: FontWeight.w100,
//                     color: Colors.black54,
//                   ),
//                 ),
//                 Spacer(),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

































//   @override
//   Widget build(BuildContext context) {
//     return SliverToBoxAdapter(
//       child: SizedBox(
//         height: 100,
//         child: ListView.builder(
//           scrollDirection: Axis.horizontal,
//           itemCount: serviceNames.length,
//           itemBuilder: (context, index) {
//             return Stack(
//               children: [
//                 Column(
//                   children: [
//                     Container(
//                       height: 90,
//                       width: 90,
//                       margin: EdgeInsets.only(
//                         left: index == 0 ? 20 : 0,
//                         right: 20,
//                       ),
//                       child: GestureDetector(
//                         onTap: () async {
//                           setState(() {
//                             currentSelectedItem = index;
//                           });

//                           // Récupérer le rôle de l'utilisateur
//                           String? userRole = await getUserRole();

//                           // Vérifier le rôle et rediriger en conséquence
//                           if (userRole == "Livreur" && index == 1) {
//                             Navigator.pushNamed(context, serviceRoutes1[1]);
//                           } else if (userRole == "Marchand" && index == 0) {
//                             Navigator.pushNamed(context, serviceRoutes1[0]);
//                           } else {
//                             Navigator.pushNamed(context, serviceRoutes[index]);
//                           }
//                         },
//                         child: Card(
//                           color: index == currentSelectedItem
//                               ? const Color.fromRGBO(10, 80, 137, 0.8)
//                                   .withOpacity(0.7)
//                               : Colors.white,
//                           elevation: 3,
//                           margin: EdgeInsets.all(10),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(25),
//                           ),
//                           child: Icon(
//                             // Utilisez les icônes appropriées pour chaque bouton
//                             index == 0
//                                 ? Icons.fastfood
//                                 : index == 1
//                                     ? Icons.delivery_dining
//                                     : index == 2
//                                         ? Icons.shopping_cart
//                                         : index == 3
//                                             ? Icons.directions_bike
//                                             : index == 4
//                                                 ? Icons.event
//                                                 : Icons.help,
//                             color: index == currentSelectedItem
//                                 ? Colors.white
//                                 : Colors.orange,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Positioned(
//                   bottom: 0,
//                   child: Container(
//                     margin: EdgeInsets.only(
//                       left: index == 0 ? 20 : 0,
//                       right: 20,
//                     ),
//                     width: 90,
//                     child: Row(
//                       children: [
//                         Spacer(),
//                         Text(serviceNames[index],
//                             style: TextStyle(
//                               fontFamily: 'Poppins',
//                               fontSize: 12,
//                               fontWeight: FontWeight.w100,
//                               color: Colors.black54,
//                             )),
//                         Spacer(),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }























//   @override
//   Widget build(BuildContext context) {
//     return SliverToBoxAdapter(
//       child: SizedBox(
//         height: 100,
//         child: ListView.builder(
//           scrollDirection: Axis.horizontal,
//           itemCount: serviceNames.length,
//           itemBuilder: (context, index) {
//             return Stack(
//               children: [
//                 Column(
//                   children: [
//                     Container(
//                       height: 90,
//                       width: 90,
//                       margin: EdgeInsets.only(
//                         left: index == 0 ? 20 : 0,
//                         right: 20,
//                       ),
//                       child: GestureDetector(
                       
//                         onTap: () async {
//                           setState(() {
//                             currentSelectedItem = index;
//                           });

//                           // Récupérer le rôle de l'utilisateur
//                           String? userRole =
//                               await getUserRole(); // À implémenter

//                           // Vérifier le rôle et rediriger en conséquence
//                           if (userRole == "Livreur" && index == 1) {
//                             // Utilisateur avec le rôle "livreur" - rediriger vers la page livreur
//                             Navigator.pushNamed(context, serviceRoutes1[1]);
//                           } else if (userRole == "Marchand" && index == 0) {
//                             // Aucun rôle défini - rediriger vers la page de bienvenue
//                             Navigator.pushNamed(context, serviceRoutes1[0]);
//                           } else {
//                             // Autres cas - rediriger vers la page correspondante
//                             Navigator.pushNamed(context, serviceRoutes[index]);
//                           }
//                         },

//                         child: Card(
//                           color: index == currentSelectedItem
//                               ? const Color.fromRGBO(10, 80, 137, 0.8)
//                                   .withOpacity(0.7)
//                               : Colors.white,
//                           elevation: 3,
//                           margin: EdgeInsets.all(10),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(25),
//                           ),
                          // child: Icon(
                          //   index == 0
                          //       ? Icons.fastfood
                          //       : index == 1
                          //           ? Icons.delivery_dining
                          //           : Icons.help,
                          //   color: index == currentSelectedItem
                          //       ? Colors.white
                          //       : Colors.orange,
                          // ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Positioned(
//                   bottom: 0,
//                   child: Container(
//                     margin: EdgeInsets.only(
//                       left: index == 0 ? 20 : 0,
//                       right: 20,
//                     ),
//                     width: 90,
//                     child: Row(
//                       children: [
//                         Spacer(),
//                         Text(serviceNames[index],
//                             style: TextStyle(
//                                 fontFamily: 'Poppins',
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w100,
//                                 color: Colors.black54)),
//                         Spacer(),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
