import 'package:allogroup/home.dart';
import 'package:allogroup/screens/office/widgets/dimensions.dart';
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

  String _pickedImagePath = '';
  // ignore: unused_field
  bool _isDataModified = false;

  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _loadUserData();
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
    super.dispose();
  }

  Future<void> _updateProfile() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        await user.updateProfile(displayName: _fullNameController.text);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'phoneNumber': _phoneController.text,
          'fullName': _fullNameController.text,
        });

        _showSuccesDialog("Vos données ont été mises à jour");

        if (_pickedImagePath.isNotEmpty) {
          final String imageFileName = 'profile_images/${user.uid}.jpg';
          final Reference storageReference =
              FirebaseStorage.instance.ref().child(imageFileName);

          final UploadTask uploadTask =
              storageReference.putFile(File(_pickedImagePath));

          await uploadTask.whenComplete(() async {
            final String imageUrl = await storageReference.getDownloadURL();

            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .update({
              'profileImageUrl': imageUrl,
              'phoneNumber': _phoneController.text,
              'fullName': _fullNameController.text,
            });

            _showSuccesDialog("Vos données ont été mises à jour");
          });
        } else {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({
            'phoneNumber': _phoneController.text,
            'fullName': _fullNameController.text,
          });

          _showSuccesDialog("Vos données ont été mises à jour");
        }
      } catch (error) {
        print("Erreur lors de la mise à jour du profil : $error");
        _showErrorDialog("Erreur lors de la mise à jour du profil");
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _pickedImagePath = pickedImage.path;
        _isDataModified = false;
      });
    } else {
      print("Sélection d'image annulée.");
    }
  }

  void _showSuccesDialog(String succesMessage) {
    Get.defaultDialog(
      title: "Super !!!",
      titleStyle:
          TextStyle(fontSize: 20, color: Color.fromARGB(255, 65, 238, 137)),
      content: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0),
        child: Text(
          succesMessage,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ),
      confirm: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Home()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 38, 152, 245),
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
      titleStyle:
          TextStyle(fontSize: 20, color: Color.fromARGB(255, 238, 65, 65)),
      content: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0),
        child: Text(
          succesMessage,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ),
      confirm: ElevatedButton(
        onPressed: () {
          Get.back();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 38, 152, 245),
          side: BorderSide.none,
        ),
        child: Text(
          "OK",
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
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
            icon: const Icon(
              LineAwesomeIcons.angle_left,
              color: Colors.white,
            )),
        title: Text(tEditProfile,
            style:
                TextStyle(color: Colors.white, fontSize: Dimensions.height20)),
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
                    _isDataModified = false;
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
                      enabled: false,
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
                    const SizedBox(height: tFormHeight),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            _isLoading = true;
                          });
                          _updateProfile();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: tPrimaryColor,
                          side: BorderSide.none,
                          shape: const StadiumBorder(),
                        ),
                        child: _isLoading
                            ? CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : Text(tEditProfile,
                                style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: tFormHeight),
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
