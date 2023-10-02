import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

const double tDefaultSize = 16.0;
const String tEditProfile = 'Mettre à jour';
const String tProfileImage = 'assets/images/reng.jpg';
const double tFormHeight = 60.0;
const Color tPrimaryColor = Colors.blue;
const Color tDarkColor = Colors.orange;
const String tFullName = 'Nom complet';
const String tEmail = 'Adresse e-mail';
const String tPhoneNo = 'Numéro de téléphone';
const String tPassword = 'Mot de passe';
// const String tJoined = 'Rejoignez-nous le';
// const String tJoinedAt = '01 Janvier 2023';
const String tDelete = 'Supprimer le profil';

class UpdateProfileScreen extends StatelessWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final controller = Get.put(ProfileController());
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(LineAwesomeIcons.angle_left)),
        // title: Text(tEditProfile, style: Theme.of(context).textTheme.headlineMedium),
        title: Text(tEditProfile,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            )),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(tDefaultSize),
          child: Column(
            children: [
              // -- IMAGE with ICON
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CircleAvatar(
                      backgroundColor: Colors.orange,
                      radius: 45,
                      child: CircleAvatar(
                        backgroundImage: AssetImage(tProfileImage),
                        radius: 55,
                      ),
                    ),
                    // child: ClipRRect(
                    //   borderRadius: BorderRadius.circular(100),
                    //   child: const Image(
                    //     image: AssetImage(tProfileImage),
                    //   ),
                    // ),
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
                      child: const Icon(LineAwesomeIcons.camera,
                          color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),

              // -- Form Fields
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                          label: Text(tFullName),
                          prefixIcon: Icon(LineAwesomeIcons.user)),
                    ),
                    const SizedBox(height: tFormHeight - 20),
                    TextFormField(
                      decoration: const InputDecoration(
                          label: Text(tEmail),
                          prefixIcon: Icon(LineAwesomeIcons.envelope_1)),
                    ),
                    const SizedBox(height: tFormHeight - 20),
                    TextFormField(
                      decoration: const InputDecoration(
                          label: Text(tPhoneNo),
                          prefixIcon: Icon(LineAwesomeIcons.phone)),
                    ),
                    const SizedBox(height: tFormHeight - 20),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        label: const Text(tPassword),
                        prefixIcon: const Icon(Icons.fingerprint),
                        suffixIcon: IconButton(
                            icon: const Icon(LineAwesomeIcons.eye_slash),
                            onPressed: () {}),
                      ),
                    ),
                    const SizedBox(height: tFormHeight),

                    // -- Form Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () =>
                            Get.to(() => const UpdateProfileScreen()),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: tPrimaryColor,
                            side: BorderSide.none,
                            shape: const StadiumBorder()),
                        child: const Text(tEditProfile,
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: tFormHeight),

                    // -- Created Date and Delete Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // const Text.rich(
                        // TextSpan(
                        //   text: tJoined,
                        //   style: TextStyle(fontSize: 12),
                        //   children: [
                        //     TextSpan(
                        //         text: tJoinedAt,
                        //         style: TextStyle(
                        //             fontWeight: FontWeight.bold,
                        //             fontSize: 12))
                        //   ],
                        // ),
                        // ),
                        ElevatedButton(
                          onPressed: () {
                            Get.defaultDialog(
                              title: "Supprimer mon profil",
                              titleStyle: const TextStyle(fontSize: 20),
                              content: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 15.0),
                                child: Text(
                                    "Voulez-vous supprimer votre compte ?"),
                              ),
                              confirm: Expanded(
                                child: ElevatedButton(
                                  onPressed: () => () async {
                                    try {
                                      // Utilisez FirebaseAuth pour déconnecter l'utilisateur actuellement connecté.
                                      await FirebaseAuth.instance.signOut();

                                      // Une fois l'utilisateur déconnecté avec succès, vous pouvez effectuer des actions supplémentaires si nécessaire.
                                      // Par exemple, naviguer vers la page de connexion.

                                      // Assurez-vous d'avoir les routes appropriées définies dans votre application pour la page de connexion.
                                      // Vous pouvez utiliser Get.offAllNamed('/nom_de_votre_page_de_connexion') pour naviguer vers la page de connexion en utilisant GetX.

                                      Get.offAllNamed(
                                          '/../signInScreen/signInScreen.dart');
                                    } catch (e) {
                                      // Gérez les erreurs éventuelles liées à la déconnexion de l'utilisateur.
                                      print(
                                          "Erreur lors de la déconnexion : $e");
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
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.redAccent.withOpacity(0.1),
                              elevation: 0,
                              foregroundColor: Colors.red,
                              shape: const StadiumBorder(),
                              side: BorderSide.none),
                          child: const Text(tDelete),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
