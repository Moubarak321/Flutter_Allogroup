import 'package:allogroup/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

const double tDefaultSize = 16.0;
const String tEditProfile = 'Mettre à jour';
const String tProfileImage = 'assets/images/reng.jpg';
const double tFormHeight = 60.0;
const Color tPrimaryColor = Colors.blue;
const Color tDarkColor = Colors.orange;
const String tFullName = 'Votre prénom';
const String tEmail = 'Adresse e-mail';
const String tPhoneNo = 'Numéro de téléphone';
const String tPassword = 'Ancien mot de passe';
const String tPassword2 = 'Mot de passe';
const String tDelete = 'Supprimer le profil';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  // TextEditingController _passwordController = TextEditingController();
  String _pickedImagePath = '';
  // ignore: unused_field
  bool _isDataModified = false;
  // bool _isPasswordVisible = false;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _loadUserData();
    // _isPasswordVisible = false;
  }

  Future<void> _loadUserData() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      setState(() {
        _fullNameController.text = user.displayName ?? '';
        _emailController.text = user.email ?? '';
        _phoneController.text = userDoc.get('phoneNumber') ?? '';
        _pickedImagePath = userDoc.get('profileImageUrl') ?? '';
      });
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    // _passwordController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      print("=============user authentifié=============");
      try {
        await user.updateProfile(displayName: _fullNameController.text);
        // await user.updateDisplayName ( _fullNameController.text);
        print("=============user fullName=============");

        if (_pickedImagePath.isNotEmpty) {
          final String imageFileName = 'profile_images/${user.uid}.jpg';
          final Reference storageReference =
              FirebaseStorage.instance.ref().child(imageFileName);
          print("=============user img=============");

          final UploadTask uploadTask =
              storageReference.putFile(File(_pickedImagePath));
          print("=============send img=============");

          await uploadTask.whenComplete(() async {
            final String imageUrl = await storageReference.getDownloadURL();
            print("=============ok img=============");

            //nouvelle
            // await user.updateEmail( _emailController.text);
            print("=============ok email=============");

            // await user.updatePassword(_passwordController.text);
            print("=============ok pass=============");

            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .update({
              'profileImageUrl': imageUrl,
              'fullName': _fullNameController.text,
              // 'email': _emailController.text,
              // 'phoneNumber': _phoneController.text,
            });
            print("=============user sending data=============");
          });
          print('Envoie des données');
          _showSuccesDialog("Vos données ont été mis à jours");
        }
      } catch (error) {
        print("Erreur lors de la mise à jour du profil : $error");
        _showErrorDialog("Erreur lors de la mise à jour du profil");
        setState(() {
          _isLoading = false; // Démarrez l'indicateur de chargement
        });
      }
    } else {
      print("Aucun utilisateur connecté.");
    }
  }

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _pickedImagePath = pickedImage.path;
        _isDataModified = true;
      });
    } else {
      print("Sélection d'image annulée.");
    }
  }

  void _showSuccesDialog(String succesMessage) {
    Get.defaultDialog(
      title: "Super !!!",
      titleStyle: TextStyle(
          fontSize: 20,
          color: Color.fromARGB(255, 65, 238, 137)), // Style du titre
      content: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0),
        child: Text(
          succesMessage,
          style: TextStyle(
            fontSize: 16, // Taille de police du texte du contenu
            color: Colors.black, // Couleur du texte du contenu
          ),
        ),
      ),
      confirm: ElevatedButton(
        onPressed: () {
          // Get.back(); // Ferme le dialogue
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Home()), // Remplacez par le nom de votre page de changement de mot de passe
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:
              Color.fromARGB(255, 38, 152, 245), // Couleur du bouton "OK"
          side: BorderSide.none,
        ),
        child: Text(
          "OK",
          style: TextStyle(
            fontSize: 16, // Taille de police du texte du bouton
            color: Colors.white, // Couleur du texte du bouton
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(String succesMessage) {
    Get.defaultDialog(
      title: "Echec !!!",
      titleStyle: TextStyle(
          fontSize: 20,
          color: Color.fromARGB(255, 238, 65, 65)), // Style du titre
      content: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0),
        child: Text(
          succesMessage,
          style: TextStyle(
            fontSize: 16, // Taille de police du texte du contenu
            color: Colors.black, // Couleur du texte du contenu
          ),
        ),
      ),
      confirm: ElevatedButton(
        onPressed: () {
          Get.back(); // Ferme le dialogue
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) =>
          //           Home()), // Remplacez par le nom de votre page de changement de mot de passe
          // );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:
              Color.fromARGB(255, 38, 152, 245), // Couleur du bouton "OK"
          side: BorderSide.none,
        ),
        child: Text(
          "OK",
          style: TextStyle(
            fontSize: 16, // Taille de police du texte du bouton
            color: Colors.white, // Couleur du texte du bouton
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(LineAwesomeIcons.angle_left)),
        title: Text(tEditProfile,
            style: TextStyle(color: Colors.white, fontSize: 24)),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(tDefaultSize),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CircleAvatar(
                      backgroundColor: Colors.orange,
                      radius: 45,
                      child: CircleAvatar(
                        // Charger l'image à partir de l'URL
                        backgroundImage: NetworkImage(_pickedImagePath),

                        radius: 55,
                      ),
                    ),
                    
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImageFromGallery,
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: tPrimaryColor,
                        ),
                        child: const Icon(LineAwesomeIcons.camera,
                            color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Form(
                onChanged: () {
                  setState(() {
                    _isDataModified = true;
                  });
                },
                child: Column(
                  children: [
                    TextFormField(
                      controller: _fullNameController,
                      decoration: const InputDecoration(
                        label: Text(tFullName),
                        prefixIcon: Icon(LineAwesomeIcons.user),
                      ),
                    ),
                    const SizedBox(height: tFormHeight - 20),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        label: Text(tEmail),
                        prefixIcon: Icon(LineAwesomeIcons.envelope_1),
                      ),
                    ),
                    const SizedBox(height: tFormHeight - 20),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        label: Text(tPhoneNo),
                        prefixIcon: Icon(LineAwesomeIcons.phone),
                      ),
                    ),
                    const SizedBox(height: tFormHeight - 20),
                    // TextFormField(
                    //   obscureText: !_isPasswordVisible,
                    //   decoration: InputDecoration(
                    //     label: const Text(tPassword),
                    //     prefixIcon: const Icon(Icons.fingerprint),
                    //     suffixIcon: IconButton(
                    //       icon: Icon(
                    //         _isPasswordVisible
                    //             ? Icons.visibility
                    //             : Icons.visibility_off,
                    //       ),
                    //       onPressed: () {
                    //         setState(() {
                    //           _isPasswordVisible = !_isPasswordVisible;
                    //         });
                    //       },
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(height: tFormHeight - 20),
                    // TextFormField(
                    //   obscureText: !_isPasswordVisible,
                    //   decoration: InputDecoration(
                    //     label: const Text(tPassword2),
                    //     prefixIcon: const Icon(Icons.fingerprint),
                    //     suffixIcon: IconButton(
                    //       icon: Icon(
                    //         _isPasswordVisible
                    //             ? Icons.visibility
                    //             : Icons.visibility_off,
                    //       ),
                    //       onPressed: () {
                    //         setState(() {
                    //           _isPasswordVisible = !_isPasswordVisible;
                    //         });
                    //       },
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(height: tFormHeight),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            _isLoading =
                                true; // Démarrez l'indicateur de chargement
                          });
                          _updateProfile();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: tPrimaryColor,
                          side: BorderSide.none,
                          shape: const StadiumBorder(),
                        ),
                        // child: const Text(tEditProfile,
                        //     style: TextStyle(color: Colors.white)),
                        child: _isLoading
                            ? CircularProgressIndicator(
                                // Affiche l'indicateur de chargement
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : Text(tEditProfile),
                      ),
                    ),
                    const SizedBox(height: tFormHeight),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                                  onPressed: () async {
                                    try {
                                      final User? user =
                                          FirebaseAuth.instance.currentUser;
                                      if (user != null) {
                                        await user.delete();
                                        Get.offAllNamed('/signInScreen');
                                      } else {
                                        print("Aucun utilisateur connecté.");
                                      }
                                    } catch (e) {
                                      print(
                                          "Erreur lors de la suppression : $e");
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    side: BorderSide.none,
                                  ),
                                  child: const Text("Oui"),
                                ),
                              ),
                              cancel: OutlinedButton(
                                onPressed: () => Get.back(),
                                child: const Text("Non"),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent.withOpacity(0.1),
                            elevation: 0,
                            foregroundColor: Colors.red,
                            shape: const StadiumBorder(),
                            side: BorderSide.none,
                          ),
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

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:line_awesome_flutter/line_awesome_flutter.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// const double tDefaultSize = 16.0;
// const String tEditProfile = 'Mettre à jour';
// const String tProfileImage = 'assets/images/reng.jpg';
// const double tFormHeight = 60.0;
// const Color tPrimaryColor = Colors.blue;
// const Color tDarkColor = Colors.orange;
// const String tFullName = 'Nom complet';
// const String tEmail = 'Adresse e-mail';
// const String tPhoneNo = 'Numéro de téléphone';
// const String tPassword = 'Mot de passe';
// // const String tJoined = 'Rejoignez-nous le';
// // const String tJoinedAt = '01 Janvier 2023';
// const String tDelete = 'Supprimer le profil';

// class UpdateProfileScreen extends StatelessWidget {
//   const UpdateProfileScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     //final controller = Get.put(ProfileController());
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//             onPressed: () => Get.back(),
//             icon: const Icon(LineAwesomeIcons.angle_left)),
//         // title: Text(tEditProfile, style: Theme.of(context).textTheme.headlineMedium),
//         title: Text(tEditProfile,
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 24,
//             )),
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           padding: const EdgeInsets.all(tDefaultSize),
//           child: Column(
//             children: [
//               // -- IMAGE with ICON
//               Stack(
//                 children: [
//                   SizedBox(
//                     width: 120,
//                     height: 120,
//                     child: CircleAvatar(
//                       backgroundColor: Colors.orange,
//                       radius: 45,
//                       child: CircleAvatar(
//                         backgroundImage: AssetImage(tProfileImage),
//                         radius: 55,
//                       ),
//                     ),
//                     // child: ClipRRect(
//                     //   borderRadius: BorderRadius.circular(100),
//                     //   child: const Image(
//                     //     image: AssetImage(tProfileImage),
//                     //   ),
//                     // ),
//                   ),
//                   Positioned(
//                     bottom: 0,
//                     right: 0,
//                     child: Container(
//                       width: 35,
//                       height: 35,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(100),
//                           color: tPrimaryColor),
//                       child: const Icon(LineAwesomeIcons.camera,
//                           color: Colors.white, size: 20),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 50),

//               // -- Form Fields
//               Form(
//                 child: Column(
//                   children: [
//                     TextFormField(
//                       decoration: const InputDecoration(
//                           label: Text(tFullName),
//                           prefixIcon: Icon(LineAwesomeIcons.user)),
//                     ),
//                     const SizedBox(height: tFormHeight - 20),
//                     TextFormField(
//                       decoration: const InputDecoration(
//                           label: Text(tEmail),
//                           prefixIcon: Icon(LineAwesomeIcons.envelope_1)),
//                     ),
//                     const SizedBox(height: tFormHeight - 20),
//                     TextFormField(
//                       decoration: const InputDecoration(
//                           label: Text(tPhoneNo),
//                           prefixIcon: Icon(LineAwesomeIcons.phone)),
//                     ),
//                     const SizedBox(height: tFormHeight - 20),
//                     TextFormField(
//                       obscureText: true,
//                       decoration: InputDecoration(
//                         label: const Text(tPassword),
//                         prefixIcon: const Icon(Icons.fingerprint),
//                         suffixIcon: IconButton(
//                             icon: const Icon(LineAwesomeIcons.eye_slash),
//                             onPressed: () {}),
//                       ),
//                     ),
//                     const SizedBox(height: tFormHeight),

//                     // -- Form Submit Button
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: () =>
//                             Get.to(() => const UpdateProfileScreen()),
//                         style: ElevatedButton.styleFrom(
//                             backgroundColor: tPrimaryColor,
//                             side: BorderSide.none,
//                             shape: const StadiumBorder()),
//                         child: const Text(tEditProfile,
//                             style: TextStyle(color: Colors.white)),
//                       ),
//                     ),
//                     const SizedBox(height: tFormHeight),

//                     // -- Created Date and Delete Button
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         // const Text.rich(
//                         // TextSpan(
//                         //   text: tJoined,
//                         //   style: TextStyle(fontSize: 12),
//                         //   children: [
//                         //     TextSpan(
//                         //         text: tJoinedAt,
//                         //         style: TextStyle(
//                         //             fontWeight: FontWeight.bold,
//                         //             fontSize: 12))
//                         //   ],
//                         // ),
//                         // ),
//                         ElevatedButton(
//                           onPressed: () {
//                             Get.defaultDialog(
//                               title: "Supprimer mon profil",
//                               titleStyle: const TextStyle(fontSize: 20),
//                               content: const Padding(
//                                 padding: EdgeInsets.symmetric(vertical: 15.0),
//                                 child: Text(
//                                     "Voulez-vous supprimer votre compte ?"),
//                               ),
//                               confirm: Expanded(
//                                 child: ElevatedButton(
//                                   onPressed: () => () async {
//                                     try {
//                                       // Utilisez FirebaseAuth pour déconnecter l'utilisateur actuellement connecté.
//                                       await FirebaseAuth.instance.signOut();

//                                       // Une fois l'utilisateur déconnecté avec succès, vous pouvez effectuer des actions supplémentaires si nécessaire.
//                                       // Par exemple, naviguer vers la page de connexion.

//                                       // Assurez-vous d'avoir les routes appropriées définies dans votre application pour la page de connexion.
//                                       // Vous pouvez utiliser Get.offAllNamed('/nom_de_votre_page_de_connexion') pour naviguer vers la page de connexion en utilisant GetX.

//                                       Get.offAllNamed(
//                                           '/../signInScreen/signInScreen.dart');
//                                     } catch (e) {
//                                       // Gérez les erreurs éventuelles liées à la déconnexion de l'utilisateur.
//                                       print(
//                                           "Erreur lors de la déconnexion : $e");
//                                     }
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                       backgroundColor: Colors.redAccent,
//                                       side: BorderSide.none),
//                                   child: const Text("Oui"),
//                                 ),
//                               ),
//                               cancel: OutlinedButton(
//                                   onPressed: () => Get.back(),
//                                   child: const Text("Non")),
//                             );
//                           },
//                           style: ElevatedButton.styleFrom(
//                               backgroundColor:
//                                   Colors.redAccent.withOpacity(0.1),
//                               elevation: 0,
//                               foregroundColor: Colors.red,
//                               shape: const StadiumBorder(),
//                               side: BorderSide.none),
//                           child: const Text(tDelete),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
