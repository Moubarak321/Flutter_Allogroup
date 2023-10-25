import 'package:allogroup/screens/office/user/profil/profilScreen.dart';
import 'package:flutter/material.dart';
import 'screens/office/components/header.dart';
import 'screens/office/components/accueilservices.dart';
import 'screens/office/components/carousel_accueil.dart';
// import 'screens/office/components/best_seller_list_accueil.dart';
// import 'package:allogroup/screens/office/user/profil/profilScreen.dart';
// import 'package:allogroup/screens/office/help/home_help.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool homeButtonSelected = true; // Par défaut, "Home" est inactif
  bool notifButtonSelected = false; // Par défaut, "food" est actif
  bool profilButtonSelected = false; // "Delivery" est inactif

  void selectHome() {
    setState(() {
      homeButtonSelected = true; // Par défaut, "Home" est inactif
      notifButtonSelected = false;
      profilButtonSelected = false;
    });
    // Vous pouvez ajouter ici le code pour naviguer vers la page d'accueil
  }

  void selectProfil() {
    setState(() {
      profilButtonSelected = true;
      homeButtonSelected = false;
      notifButtonSelected = false;
    });
    // Vous pouvez ajouter ici le code pour naviguer vers la page d'accueil
  }

  void selectNotif() {
    setState(() {
      notifButtonSelected = true;
      homeButtonSelected = false;
      profilButtonSelected = false;
    });
    // Vous pouvez ajouter ici le code pour gérer la page de livraison
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        //widget scroll view wrapping the body
        slivers: [
          SliverAppBar(
            //Barre de navigation
            pinned: true, //fixation de la navbar
            title: const Text("Allô Group"), //nom de l'app
            leading: IconButton(
              //button menu
              icon: const Icon(Icons.menu),
              onPressed: () {},
            ),
            actions: [
              IconButton(
                  //button shopping
                  onPressed: () {},
                  icon: const Icon(Icons.shopping_cart))
            ],
          ),
          // imbrication du composant header directement en dessous de la barre de navigation
          Header(),
          ButtonServices(),
          Carousel(),
          // BestSeller()
          // SliverPadding(
          //   // ajout d'espace en dessous du compoant
          //   padding:
          //       EdgeInsets.only(bottom: 100.0, top: 10), // Marge inférieure
          //   sliver: BestSeller(),
          // ),
        ],
      ),

      //============  Bottom Navbar Buttons  ============

      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          selectHome();

          // Navigator.pushNamed(context, '/home');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return Home(); // Remplacez DetailPage par votre propre page.
              },
            ),
          );
        },
        backgroundColor: homeButtonSelected
            ? Colors.orange
            : Color.fromRGBO(10, 80, 137, 0.8),
        child: Icon(
          Icons.home,
        ),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(45),
        ),
        child: Container(
          color: Colors.black38,
          child: BottomAppBar(
              shape: CircularNotchedRectangle(),
              child: Row(
                children: [
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      selectProfil();

                      // Navigator.pushNamed(context, '/profilScreen');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ProfileScreen(); // Remplacez DetailPage par votre propre page.
                          },
                        ),
                      );
                    },
                    tooltip: 'Profil',
                    icon: Icon(Icons.person),
                    color: profilButtonSelected ? Colors.orange : Colors.white,
                  ),
                  Spacer(),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      selectNotif();
                    },
                    tooltip: 'Notifications',
                    icon: Icon(Icons.notifications),
                    color: notifButtonSelected ? Colors.orange : Colors.white,
                  ),
                  Spacer(),
                ],
              )),
        ),
      ),
    );
  }
}
