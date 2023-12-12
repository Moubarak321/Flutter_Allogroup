import 'package:allogroup/screens/office/user/profil/profilMenuWidgetText.dart';
import 'package:allogroup/screens/office/widgets/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:get/get.dart';




class Parametres extends StatefulWidget {
  const Parametres({super.key});

  @override
  State<Parametres> createState() => _ParametresState();
}

class _ParametresState extends State<Parametres> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(LineAwesomeIcons.angle_left,color: Colors.white)),
        title: Text('Paramètres',
           style: TextStyle(color: Colors.white, fontSize: Dimensions.height20)),
      ),
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
                  text: "Vous alerter lorsqu'un champion reçoit votre commande",
                  icon: LineAwesomeIcons.bell_1,
                  onPress: () {
                    // _launchURL(_webController);
                  }), 
        ProfileMenuWidgetText(
                  title: "Alerte livraison",
                  text: "Vous alerter lorsque le livreur est à votre portée",
                  icon: LineAwesomeIcons.bell_1,
                  onPress: () {
                    // _launchURL(_webController);
                  }),
        ProfileMenuWidgetText(
                  title: "Alerte Commande",
                  text: "Vous alerter lorsqu'un marchand reçoit votre commande",
                  icon: LineAwesomeIcons.bell_1,
                  onPress: () {
                    // _launchURL(_webController);
                  })

       ],

      ),
    );
  }
}