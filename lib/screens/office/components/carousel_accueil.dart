import 'package:flutter/material.dart';
import 'dart:async';

class Carousel extends StatefulWidget {
  const Carousel({super.key});

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  int _currentIndex = 0;
  PageController _pageController =
      PageController(); // Ajoutez un PageController

  List<String> imageList = [
    'assets/images/a1.jpg',
    'assets/images/a2.jpg',
    'assets/images/a3.jpg',
    'assets/images/a4.jpg',
    'assets/images/a5.jpg',
  ];

  @override
  void initState() {
    super.initState();

    // Configure un Timer pour défilement automatique toutes les 3 secondes
    //PageController pour contrôler le défilement des images et eviter la perte de mémoire.
    //Le Timer permet de passer automatiquement à la page suivante toutes les 3 secondes
    //en utilisant animateToPage pour déplacer le carrousel.
    Timer.periodic(Duration(seconds: 5), (timer) {
      if (_currentIndex < imageList.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }
      _pageController.animateToPage(_currentIndex,
          duration: Duration(milliseconds: 500), curve: Curves.easeOut);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Column(
          
          children: <Widget>[          
            Text(
              "Promotions et nouveautés",
              style: TextStyle(
                color: Colors.orange,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            
            SizedBox(
              height: 200,
              child: PageView.builder(
                itemCount: imageList.length,
                controller: _pageController, //import du page controller
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical:
                            20.0), // margin: EdgeInsets.symmetric(horizontal: 10.0),
      
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(0.3), // Couleur et opacité de l'ombre
                          spreadRadius: 2, // Étalement de l'ombre
                          blurRadius: 3, // Flou de l'ombre
                          offset: Offset(0, 3),
                        ), // Décalage de l'ombre (élévation)
                      ], // Bords arrondis
                    ),
      
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0), // Bords arrondis
                      child: Image.asset(
                        imageList[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: imageList.map((image) {
                //iteration de la liste d'image
                int index = imageList.indexOf(image);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index ? Colors.orange : Colors.grey,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
