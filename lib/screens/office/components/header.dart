// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// import 'package:allogroup/screens/office/user/profil/profilScreen.dart';

// ignore: use_key_in_widget_constructors
class Header extends StatefulWidget {
  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  late TextEditingController _roleController;

  String userName = '';
  String fund = '' ;
  Future<void> _loadUserRole() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      setState(() {
        _roleController.text = userDoc.get("role").toString();
       
      });
    }
  }
  Future<String> _getProfileImageUrl() async {
    final User? user = FirebaseAuth.instance.currentUser;
    String imageUrl = '';

    if (user != null) {
      final String imageFileName = 'profile_images/${user.uid}.jpg';
      final Reference storageReference =
          FirebaseStorage.instance.ref().child(imageFileName);

      try {
        final String url = await storageReference.getDownloadURL();
        imageUrl = url;
      } catch (error) {
        // print("Erreur lors de la récupération de l'URL de l'image : $error");
      }
    }

    return imageUrl;
  }

  Future<String> _loadUserName() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      setState(() {
        userName = user.displayName ?? 'John Doe';
      });
    }
    return userName;
  }

  String formatName(String fullName) {
    final names = fullName.split(' ');

    if (names.length >= 2) {
      // final firstName = names[0];
      // final lastName = names[names.length - 1];
      final lastName = names[0];

      // Utilisez le premier prénom suivi de la première lettre du dernier prénom en majuscule
      // return '$firstName ${lastName[0].toUpperCase()}.';
      return lastName;
    } else {
      return fullName;
    }
  }

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
      // print("Erreur lors de la récupération du solde du portefeuille : $e");
    }

    // Retourner null si l'utilisateur n'a pas de portefeuille ou s'il y a une erreur
    return null;
  }
   @override
  void dispose() {
    _roleController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
     _roleController = TextEditingController();
    _loadUserRole();
    _loadUserName().then((name) {
      setState(() {
        userName = name;
      });
    });
    getUserWalletBalance().then((walletBalance) {
    if (walletBalance != null) {
      setState(() {
        fund = walletBalance.toString(); // Convertir le solde du portefeuille en String
      });
    }
  });
  }

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
                      height: 5ad,
                    ), // height de l'avatar
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context,
                                '/profilScreen'); // Revenir à la page précédente
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.white70,
                            radius: 40,
                            child: FutureBuilder<String>(
                              future: _getProfileImageUrl(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  if (snapshot.hasError) {
                                    // Gérer les erreurs ici
                                    return Text(
                                        'Erreur lors de la récupération de l\'image');
                                  }
                                  if (snapshot.hasData) {
                                    return CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(snapshot.data!),
                                      radius: 35,
                                    );
                                  }
                                }
                                // Pendant le chargement, vous pouvez montrer un indicateur de chargement ou autre chose
                                return CircularProgressIndicator();
                              },
                            ),
                          ),
                        ),

                        // const CircleAvatar(
                        //   backgroundColor: Colors.white70,
                        //   radius: 35,
                        //   child: CircleAvatar(
                        //     backgroundImage:
                        //         NetworkImage("assets/images/reng.jpg"),
                        //     radius: 30,
                        //   ),
                        // ),
                        const SizedBox(width: 5),
                        Column(
                          children: [
                            //username
                            Text(
                              formatName(userName),
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

                              child:  Text(
                                _roleController.text,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                         Text(
                          "$fund CFA",
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
