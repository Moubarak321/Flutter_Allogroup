// import 'package:flutter/material.dart';

// class ButtonServices extends StatefulWidget {
//   const ButtonServices({super.key});

//   @override
//   State<ButtonServices> createState() => _ButtonServicesState();
// }

// // liste des services allofood, livreur ...
// class _ButtonServicesState extends State<ButtonServices> {
//   int currentSelectedItem = 0;
//   @override
//   Widget build(BuildContext context) {
//     int items = 10;
//     return SliverToBoxAdapter(
//       child: SizedBox(
//         height: 100,
//         child: ListView.builder(
//           scrollDirection: Axis.horizontal,
//           itemCount: items,
//           itemBuilder: (context, index) => Stack(
//             children: [
//               Column(
//                 children: [
//                   Container(
//                     // box du bouton
//                     height: 90,
//                     width: 90,
//                     margin: EdgeInsets.only(
//                         left: index == 0 ? 20 : 0,
//                         right: 20), //space management for buttons
//                     child: GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           //mettre un focus surbrillant sur l'icone une fois cliqué. la page est refraichie puis etabli les changements
//                           currentSelectedItem = index;
//                         });
//                       },
//                       child: Card(
//                         color: index ==
//                                 currentSelectedItem //hover au click pour la boite. blanc par defaut et bleu au click
//                             ? const Color.fromRGBO(10, 80, 137, 0.8)
//                                 .withOpacity(0.7)
//                             : Colors.white,
//                         elevation: 3,
//                         margin: EdgeInsets.all(10),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(25),
//                         ),
//                         child: Icon(
//                           Icons.fastfood,
//                           color: index ==
//                                   currentSelectedItem // ligne 34 =>hover pour l'icone. orange pour la couleur standard et blanc au clic
//                               ? Colors.white
//                               : Colors.orange,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Positioned(
//                 // Pour le text du bouton
//                 bottom: 0, //positionner le texte ne bas
//                 child: Container(
//                   margin: EdgeInsets.only(left: index == 0 ? 20 : 0, right: 20),
//                   width: 90,
//                   child: Row(
//                     children: [
//                       Spacer(), //centrage
//                       Text("AlloFood"),
//                       Spacer(),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }














// import 'package:flutter/material.dart';

// class ButtonServices extends StatefulWidget {
//   const ButtonServices({Key? key});

//   @override
//   State<ButtonServices> createState() => _ButtonServicesState();
// }

// class _ButtonServicesState extends State<ButtonServices> {
//   int currentSelectedItem = 0;

//   // Liste des noms des services que vous voulez afficher
//   List<String> serviceNames = ["AlloFood", "AlloLivreur", "Aide"];

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
//                         onTap: () {
//                           setState(() {
//                             currentSelectedItem = index;
//                           });
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
//                             index == 0
//                                 ? Icons.fastfood
//                                 : index == 1
//                                     ? Icons.delivery_dining
//                                     : Icons.help,
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
//                         Text(serviceNames[index]),
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



























import 'package:flutter/material.dart';
import 'package:allogroup/routes.dart';

class ButtonServices extends StatefulWidget {
  const ButtonServices({Key? key});

  @override
  State<ButtonServices> createState() => _ButtonServicesState();
}

class _ButtonServicesState extends State<ButtonServices> {
  int currentSelectedItem = -1;

  List<String> serviceNames = ["AlloFood", "AlloLivreur", "Aide"]; 

  // commenté pour test popular
  List<String> serviceRoutes = [Routes.mainFoodPage, Routes.delivery, Routes.homehelp]; // Routes correspondant aux boutons

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
                        onTap: () {
                          setState(() {
                            currentSelectedItem = index;
                          });

                          // Navigation vers la page correspondante
                          Navigator.pushNamed(context, serviceRoutes[index]);

                          
                        },
                        child: Card(
                          color: index == currentSelectedItem
                              ? const Color.fromRGBO(10, 80, 137, 0.8).withOpacity(0.7)
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
                        Text(serviceNames[index], style:TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w100, color: Colors.black54)),
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
