import 'package:allogroup/home.dart';
import 'package:allogroup/screens/office/components/function.dart';
import 'package:allogroup/screens/office/widgets/app_icon.dart';
import 'package:allogroup/screens/office/widgets/big_text.dart';
import 'package:allogroup/screens/office/widgets/dimensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class CourseLivreur extends StatefulWidget {
  const CourseLivreur({super.key});

  @override
  State<CourseLivreur> createState() => _CourseLivreurState();
}

class _CourseLivreurState extends State<CourseLivreur> {
  List<Map<String, dynamic>> tousLesProduits = [];
  bool isLoading = true;
  final TextEditingController passwordController = TextEditingController();

  Future<dynamic> GetProductFromCart() async {
    try {
      List<Map<String, dynamic>> products = [];

      // Accédez au document de l'utilisateur
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('champions')
          .doc(user?.uid)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        List<dynamic> cart = userData['commandes'] as List;

        for (var cartItem in cart) {
          // if (cartItem['status'] == false) {
          products.add(cartItem);
          // }
        }
      }

      if (products.isEmpty) {
        return "Le panier est vide"; // Retourne un texte si le panier est vide
      }

      return products;
    } catch (e) {
      return null;
    }
  }

  Future<void> fetchProductsFromCart() async {
    try {
      List<Map<String, dynamic>>? products = await GetProductFromCart();
      setState(() {
        tousLesProduits = products!;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }


 void verificationCourseTermine(String password) async {
  print("---------------------$password");
  final User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('champions')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;

        if (userData != null && userData.containsKey('commandes')) {
          List<dynamic>? commandes = userData['commandes'];

          String pass = commandes?[0]["password"] ?? "";
          String pass0 = pass.trim();
          password = password.trim();
          print("pass----------------------------$pass0");
          print("password----------------------------$password");

          if (password == pass0) {
            print("ok----------------------------");
            try {
                await FirebaseFirestore.instance
                .collection('champions')
                .doc(user.uid)
                .update({
                'livraisons': FieldValue.arrayUnion([commandes?[0]])
                });

                await FirebaseFirestore.instance
                    .collection('champions')
                    .doc(user.uid)
                    .update({'commandes': []});

            Get.snackbar("Super!", "Vous venez de terminer votre course.");
            Get.to(
            Home(),
          );            }
            catch (e){
                print(e);
            }
            
            return; // Quitte la fonction après avoir terminé la course
          }
        }
      }
      // Si le mot de passe ne correspond pas ou si les conditions ne sont pas remplies
      Get.snackbar("Erreur", "Votre course n'est pas encore terminée");
    } catch (e) {
      print('Erreur lors de la récupération du rôle de champion : $e');
    }
  }
}

  Widget buildCourseCard(Map<String, dynamic> courseData) {
    // Initialisez la localisation française
    initializeDateFormatting('fr_FR', null);

    final typeLivraison = courseData['type_courses'];
    final adresseRecuperation = courseData['addressRecuperation'];
    final prix = courseData['prix'];
    final adresseLivraison = courseData['addressLivraison'];
    final titre = courseData['title'];

    final livraison = courseData['dateDeLivraison'];
    final date = DateTime.fromMillisecondsSinceEpoch(livraison.seconds * 1000);
    final formattedDate =
        DateFormat('EEEE d MMMM y, HH:mm:ss', 'fr_FR').format(date);
    double commission = courseData['prix'] * 0.20;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0xFFe8e8e8),
            blurRadius: 5.0,
            offset: Offset(0, 5),
          ),
          BoxShadow(
            color: Colors.white,
            offset: Offset(-5, 0),
          ),
          BoxShadow(
            color: Colors.white,
            offset: Offset(5, 0),
          ),
        ],
        color: Colors.orange,
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Demande de livraison",
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          ),
          Text(
            'Type de livraison : $typeLivraison',
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          ),
          Text(
            'Quoi: $titre',
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          ),
          Text(
            "Zone d'échange: $adresseRecuperation",
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          ),
          Text(
            'Numéro à contacter au lieu de récupération: ${courseData['numeroARecuperation']}',
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          ),
          Text(
            'Destinataire: $adresseLivraison',
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          ),
          Text(
            'Numéro à contacter au lieu de Livraison: ${courseData['numeroALivraison']}',
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          ),
          Text(
            'Date de livraison: $formattedDate',
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          ),
          Text(
            'Prix: $prix FCFA',
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          ),
          Text(
            '20% de comission Allo Group: $commission FCFA',
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          ),
          SizedBox(height: 20),

          Container(
            padding: EdgeInsets.all(16.0),
            // child: BigText(text: "Rechargez votre portefeuille",size: Dimensions.font20),
            child: BigText(
                text: "Mot de passe de securité de cette commande",
                color: Colors.white,
                size: Dimensions.font20),
          ),
          // Text("Solde Actuel : $fund FCFA"),
          Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Entrez le mot de passe du commanditaire :",
                  style: TextStyle(
                    fontSize: Dimensions.font16,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: "Mot de passe",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,
                  inputFormatters: <TextInputFormatter>[],
                ),
              ],
            ),
          ),
          Container(
            child: ElevatedButton(
              onPressed: () {
                String enteredPassword = passwordController.text;
                print("$enteredPassword---------------------$enteredPassword");
                verificationCourseTermine(enteredPassword);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  side: BorderSide.none,
                  shape: const StadiumBorder()),
              child: const Text(
                "Terminer ma course",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  // fontFamily: 'Poppins',
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchProductsFromCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context); // Revenir à la page précédente
              },
              child: AppIcon(
                icon: Icons.arrow_back,
                backgroundColor: Color(0xCC0A5089),
                iconColor: Colors.white,
              ),
            ),
            Text("Votre course"),
            // GestureDetector(
            //   onTap: () {

            //   },
            //   child: Icon(
            //     Icons.bar_chart_rounded,
            //     color: Colors.white,
            //   ),
            // ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                right: Dimensions.width20, left: Dimensions.width20),
            height: 100,
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Center(
              child: Text(
                'Votre actuelle course',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : tousLesProduits.isEmpty
                    ? Center(
                        child: Text(
                          "Aucune course en instance",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      )
                    : ListView.builder(
                        itemCount: tousLesProduits.length,
                        itemBuilder: (context, index) {
                          return buildCourseCard(tousLesProduits[index]);
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
