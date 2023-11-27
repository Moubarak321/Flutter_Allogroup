import 'package:allogroup/screens/office/user/profil/profilMenuWidgetText.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';




class Parametres extends StatefulWidget {
  const Parametres({super.key});

  @override
  State<Parametres> createState() => _ParametresState();
}

class _ParametresState extends State<Parametres> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text("Paramètres")),
      body: Column(
       children: [
        ProfileMenuWidgetText(
                  title: "Promo et MAJ",
                  text: "Soyez au parfum des nouveautés et mises à jours",
                  icon: LineAwesomeIcons.bell_1,
                  onPress: () {
                    // _launchURL(_webController);
                  }), 
        ProfileMenuWidgetText(
                  title: "Alerte champion",
                  text: "Vous alerte lorsqu'un champion reçois votre commande",
                  icon: LineAwesomeIcons.bell_1,
                  onPress: () {
                    // _launchURL(_webController);
                  }), 
        ProfileMenuWidgetText(
                  title: "Alerte livraison",
                  text: "Vous alerte lorsque le livreur est à votre portée",
                  icon: LineAwesomeIcons.bell_1,
                  onPress: () {
                    // _launchURL(_webController);
                  }),
       ],

      ),
    );
  }
}