import 'package:flutter/material.dart';
// import 'package:allogroup/screens/office/user/profil/profilScreen.dart';

// ignore: use_key_in_widget_constructors
class Header extends StatefulWidget {
  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context)
        .size; // var size pour gerer les media-queries, taille, hauteur ... il calcule ces dimensions automatiqument et les affecte relativement au parent

    return SliverList(
      delegate: SliverChildListDelegate([
        // a voir***************
        Stack(
          children: [
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  height: size.height / 5, //voir ligne 12
                  decoration: const BoxDecoration(
                    // arrondir les coins de la boxe et ajouter de la couleur
                    // color: Colors.teal,
                    color: Color.fromRGBO(10, 80, 137, 0.8),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(45),
                    ),
                  ),
                  child: Column(children: [
                    //avatar utilisateur
                    const SizedBox(
                      height: 20,
                    ), // height de l'avatar
                    Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.white70,
                          radius: 35,
                          child: CircleAvatar(
                            backgroundImage:
                                AssetImage("assets/images/reng.jpg"),
                            radius: 30,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Column(
                          children: [
                            //username
                            const Text(
                              "Mr Bull",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                            Container(
                              //user status
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.black54,
                              ),

                              child: const Text(
                                "VIP",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        const Text(
                          "154 \$ CAD",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        )
                      ],
                    )
                  ]),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ],
        ),
      ]),
    );
  }
}
