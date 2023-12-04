import 'package:flutter/material.dart';

class BestSeller extends StatefulWidget {
  const BestSeller({super.key});

  @override
  State<BestSeller> createState() => _BestSellerState();
}

class _BestSellerState extends State<BestSeller> {
  @override
  Widget build(BuildContext context) {
    int items = 10;

    Widget burgerImage = SizedBox(
      height: 100,
      child: Image.asset("assets/images/burger.png"),
    );

    Widget chickenImage = SizedBox(
      height: 100,
      child: Image.asset("assets/images/burger.png"),
    );

    return SliverToBoxAdapter(
      child: Container(
        height: 240,
        margin: EdgeInsets.only(top: 15),
        child: ListView.builder(
          // Conteneur pour liste
          scrollDirection: Axis.horizontal, // gestion de la direction du scroll
          itemCount: items,
          itemBuilder: (context, index) {
            bool reverse = index.isEven;
            return Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      left: 20,
                      right: index == items
                          ? 20
                          : 0), // si l'index == items () ,la marge à droite est 20 sinon 0. definition de la marge à droite à 0 pour le dernier element de la liste et 20 à gauche pour tout
                  height: 240,
                  width: 200,
                  child: GestureDetector(
                    onTap: () {
                      //:TODO NAVIGATOR
                    },
                    child: Card(
                      // margin: EdgeInsets.only(bottom: 85),
                      elevation: 3,
                      margin: EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(45),
                          bottomRight: Radius.circular(15),
                          topLeft: Radius.circular(45),
                          topRight: Radius.circular(45),
                        ),
                      ),
                      // margin: EdgeInsets.only(bottom: 85),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            Text(
                              "Burger",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            Row(
                              children: [
                                Spacer(),
                                Text(
                                  "15.55 \$ CAD",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Spacer(),
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    color: Colors.white,
                                    child: Icon(Icons.add),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  // image
                  top: reverse ? 70: 70,  //60 60 pour la position de chaque image
                  child: GestureDetector(
                    onTap: () {
                      //:TODO NAVIGATOR
                    },
                    child: reverse ? chickenImage : burgerImage,
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
