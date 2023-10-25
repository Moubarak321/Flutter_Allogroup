// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:allogroup/home.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './profilMenuWidget.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import './updateProfil.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

const String tProfile = "Moi";
const String tProfileImage = 'assets/images/reng.jpg';
const String tProfileHeading = "Mon Profil";
const String tProfileSubHeading = "Description de mon profil";
const String tEditProfile = 'Modifiez';
const double tDefaultSize = 16.0;
const Color tPrimaryColor = Colors.blue; // Couleur primaire
const Color tDarkColor = Colors.white; // Couleur sombre


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

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
        print("Erreur lors de la récupération de l'URL de l'image : $error");
      }
    }

    return imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            // onPressed: () => Get.back(),
            onPressed: () {
              // Navigator.pop(context);
              Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return Home(); // Remplacez DetailPage par votre propre page.
              },
            ),
          );
            },
            icon: const Icon(LineAwesomeIcons.angle_left)),
        title: Text(
          tProfile,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        // titleTextStyle: TextStyle(color: Colors.white),

        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(tDefaultSize),
          child: Column(
            children: [
              /// -- IMAGE
              GestureDetector(
                onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return UpdateProfileScreen(); // Remplacez DetailPage par votre propre page.
                          },
                        ),
                      );
                    },
                child: Stack(
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: CircleAvatar(
                        backgroundColor: Colors.orange,
                        radius: 45,
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
                                  backgroundColor: Colors.orange,
                                  radius: 55,
                                  backgroundImage: NetworkImage(snapshot.data!),
                                  // radius: 55,
                                );
                              }
                            }
                            // Pendant le chargement, vous pouvez montrer un indicateur de chargement ou autre chose
                            return CircularProgressIndicator();
                          },
                        ),
                      ),
                      // child: ClipRRect(
                      //     borderRadius: BorderRadius.circular(100),
                      //     child: const Image(image: AssetImage(tProfileImage))),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: tPrimaryColor),
                        child: const Icon(
                          LineAwesomeIcons.alternate_pencil,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(tProfileHeading,
                  style: Theme.of(context).textTheme.headlineMedium),
              Text(tProfileSubHeading,
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 20),

              /// -- BUTTON
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () => Get.to(() => const UpdateProfileScreen()),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: tPrimaryColor,
                      side: BorderSide.none,
                      shape: const StadiumBorder()),
                  child: const Text(tEditProfile,
                      style: TextStyle(color: tDarkColor)),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),

              /// -- MENU
              ProfileMenuWidget(
                  title: "Paramètres",
                  icon: LineAwesomeIcons.cog,
                  onPress: () {}),
              ProfileMenuWidget(
                  title: "Portefeuille",
                  icon: LineAwesomeIcons.wallet,
                  onPress: () {}),
              ProfileMenuWidget(
                  title: "Gestion utilisateur",
                  icon: LineAwesomeIcons.user_check,
                  onPress: () {}),
              const Divider(),
              const SizedBox(height: 10),
              ProfileMenuWidget(
                  title: "Informations",
                  icon: LineAwesomeIcons.info,
                  onPress: () {}),
              ProfileMenuWidget(
                  title: "Déconnecter",
                  icon: LineAwesomeIcons.alternate_sign_out,
                  textColor: Colors.red,
                  endIcon: false,
                  onPress: () {
                    Get.defaultDialog(
                      title: "DECONNEXION",
                      titleStyle: const TextStyle(fontSize: 20),
                      content: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        child: Text(
                            "Etes-vous sûre de vouloir vous déconnecter ?"),
                      ),
                      confirm: Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            try {
                              // Utilisez FirebaseAuth pour déconnecter l'utilisateur actuellement connecté.
                              await FirebaseAuth.instance.signOut();

                              // Une fois l'utilisateur déconnecté avec succès, vous pouvez effectuer des actions supplémentaires si nécessaire.
                              // Par exemple, naviguer vers la page de connexion.

                              // Assurez-vous d'avoir les routes appropriées définies dans votre application pour la page de connexion.
                              // Vous pouvez utiliser Get.offAllNamed('/nom_de_votre_page_de_connexion') pour naviguer vers la page de connexion en utilisant GetX.

                              Get.offAllNamed('/signInScreen');
                            } catch (e) {
                              // Gérez les erreurs éventuelles liées à la déconnexion de l'utilisateur.
                              print("Erreur lors de la déconnexion : $e");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              side: BorderSide.none),
                          child: const Text("Oui"),
                        ),
                      ),
                      cancel: OutlinedButton(
                          onPressed: () => Get.back(),
                          child: const Text("Non")),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}





