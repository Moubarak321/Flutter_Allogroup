import 'package:allogroup/screens/office/widgets/big_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:allogroup/screens/office/widgets/dimensions.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';


class Wallet extends StatefulWidget {
  const Wallet({Key? key}) : super(key: key);

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  String dropdownValue = 'Option 1';
  String fund = '';
  String solde = "0";
  String name = "";

  Future<int?> getUserWalletBalance() async {
    try {
      // Récupérer l'utilisateur authentifié
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Accéder au document de l'utilisateur dans Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        // Vérifier si le document de l'utilisateur existe et contient la clé 'wallet'
        if (userDoc.exists &&
            userDoc.data() is Map<String, dynamic> &&
            (userDoc.data() as Map<String, dynamic>).containsKey('wallet')) {
          // Récupérer et retourner la valeur de la clé 'wallet'
          return (userDoc.data() as Map<String, dynamic>)['wallet'];
        }
      }
    } catch (e) {
      print("Erreur lors de la récupération du solde du portefeuille : $e");
    }

    // Retourner null si l'utilisateur n'a pas de portefeuille ou s'il y a une erreur
    return null;
  }

  Future<String?> getUserName() async {
    try {
      // Récupérer l'utilisateur authentifié
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Accéder au document de l'utilisateur dans Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        // Vérifier si le document de l'utilisateur existe et contient la clé 'wallet'
        if (userDoc.exists &&
            userDoc.data() is Map<String, dynamic> &&
            (userDoc.data() as Map<String, dynamic>).containsKey('phoneNumber')) {
          // Récupérer et retourner la valeur de la clé 'wallet'
          return (userDoc.data() as Map<String, dynamic>)['phoneNumber'];
        }
      }
    } catch (e) {
      print("Erreur lors de la récupération du solde du portefeuille : $e");
    }

    // Retourner null si l'utilisateur n'a pas de portefeuille ou s'il y a une erreur
    return null;
  }


 _paiement() async {
    var url = Uri.parse("https://allogroupweb.vercel.app/");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
//-------------------------------

  ///----------------------------
  @override
  void initState() {
    super.initState();

    getUserWalletBalance().then((walletBalance) {
      if (walletBalance != null) {
        setState(() {
          fund = walletBalance
              .toString(); // Convertir le solde du portefeuille en String
        });
      } else {
        return solde;
      }
    });

    getUserName().then((username) {
      if (username != null) {
        setState(() {
          name = username
              .toString(); // Convertir le solde du portefeuille en String
        });
      } else {
        return "John DOE";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Portefeuille")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image(
              image: AssetImage("assets/images/wallet2.png"),
              height: MediaQuery.of(context).size.height * 0.35,
              width: MediaQuery.of(context).size.width,
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              // child: BigText(text: "Rechargez votre portefeuille",size: Dimensions.font20),
              child: BigText(
                  text: "Rechargez votre portefeuille",
                  size: Dimensions.font20),
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Votre solde:$fund ",
                    style: TextStyle(fontSize: Dimensions.font16),
                  ),
                  SizedBox(height: 8.0),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "$fund FCFA",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.text,
                    /*inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],*/
                    enabled: false,
                    // Utilisation de initialValue pour afficher fund par défaut
                  ),
                  Text(
                    "Votre numéro:",
                    style: TextStyle(fontSize: Dimensions.font16),
                  ),
                  SizedBox(height: 8.0),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "$name",
                      border: OutlineInputBorder(),
                    ),
                    // keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    enabled: false,
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () =>
                  _paiement(),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  side: BorderSide.none,
                  shape: const StadiumBorder()),
              child: const Text(
                "Rechargez",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class BigText extends StatelessWidget {
//   final String text;

//   const BigText({required this.text});

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       text,
//       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//     );
//   }
// }
