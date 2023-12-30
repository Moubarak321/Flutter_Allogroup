import 'package:allogroup/home.dart';
import 'package:allogroup/screens/office/widgets/dimensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:allogroup/screens/office/user/profil/profilMenuWidget.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:allogroup/screens/office/user/profil/updateProfil.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:firebase_auth/firebase_auth.dart';

const String tProfile = "Plus proche de vous";
const String tProfileImage = 'assets/images/Icone.png';
const String tProfileHeading = "Statut du compte";
const double tDefaultSize = 16.0;
const Color tPrimaryColor =
    Color.fromRGBO(10, 80, 137, 0.8); // Couleur primaire
const Color tDarkColor = Colors.white; // Couleur sombre

List<Map<String, dynamic>> links = [];

class Informations extends StatefulWidget {
  const Informations({Key? key}) : super(key: key);

  @override
  _InformationsState createState() => _InformationsState();
}

class _InformationsState extends State<Informations> {
  late TextEditingController _tiktokController;
  late TextEditingController _linkedinController;
  late TextEditingController _facebookController;
  late TextEditingController _instagramController;
  late TextEditingController _webController;
  late TextEditingController _roleController;
  late TextEditingController _youtubeController;
  late TextEditingController _dashboardController;

  void _launchURL(TextEditingController controller) async {
    String url = controller.text;

    if (url.isNotEmpty && await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

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

  Future<void> _loadUserData() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('administrateur')
          .doc("admin")
          .get();

      setState(() {
        _tiktokController.text = userDoc.get("tiktok").toString();
        _facebookController.text = userDoc.get("facebook").toString();
        _instagramController.text = userDoc.get('instagram').toString();
        _webController.text = userDoc.get('web').toString();
        _linkedinController.text = userDoc.get('linked').toString();
        _youtubeController.text = userDoc.get("youtube").toString();
        _dashboardController.text = userDoc.get("dashboard").toString();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _tiktokController = TextEditingController();
    _linkedinController = TextEditingController();
    _facebookController = TextEditingController();
    _instagramController = TextEditingController();
    _webController = TextEditingController();
    _youtubeController = TextEditingController();
    _dashboardController = TextEditingController();
    _loadUserData();
    _roleController = TextEditingController();
    _loadUserRole();
  }

  @override
  void dispose() {
    _tiktokController.dispose();
    _linkedinController.dispose();
    _facebookController.dispose();
    _instagramController.dispose();
    _webController.dispose();
    _roleController.dispose();
    _youtubeController.dispose();
    _dashboardController.dispose();
    super.dispose();
  }

  // rest of your code...

  @override
  Widget build(BuildContext context) {
    // var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    var role = _roleController.text;

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
            icon: const Icon(LineAwesomeIcons.angle_left, color: Colors.white)),
        title: Text(tProfile,
            style:
                TextStyle(color: Colors.white, fontSize: Dimensions.height20)),
        // actions: [
        //   IconButton(
        //       onPressed: () {},
        //       icon: Icon(isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon))
        // ],
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
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image(image: AssetImage(tProfileImage))),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(tProfileHeading,
                  style: Theme.of(context).textTheme.headlineMedium),

              const SizedBox(height: 20),

              /// -- BUTTON
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    Get.snackbar("Infos", "Vous êtes actuellement $role");
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: tPrimaryColor,
                      side: BorderSide.none,
                      shape: const StadiumBorder()),
                  child: Text(_roleController.text,
                      style: TextStyle(color: tDarkColor)),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),

              /// -- MENU

              ProfileMenuWidget(
                  title: "Changer mon statut",
                  icon: LineAwesomeIcons.user_circle,
                  onPress: () {
                    _launchURL(_webController);
                  }),
              const Divider(),
              if (role == "Livreur" || role == "Marchand")
                ProfileMenuWidget(
                  title: "Dashboard",
                  icon: LineAwesomeIcons.bar_chart,
                  onPress: () {
                    _launchURL(_dashboardController);
                  },
                ),
              ProfileMenuWidget(
                  title: "Linkedin",
                  icon: LineAwesomeIcons.linkedin,
                  onPress: () {
                    _launchURL(_linkedinController);
                  }),
              ProfileMenuWidget(
                  title: "Facebook",
                  icon: LineAwesomeIcons.facebook,
                  onPress: () {
                    _launchURL(_facebookController);
                  }),
              // const SizedBox(height: 10),
              ProfileMenuWidget(
                  title: "Tiktok",
                  icon: LineAwesomeIcons.music,
                  onPress: () {
                    _launchURL(_tiktokController);
                  }),
              ProfileMenuWidget(
                  title: "Instagram",
                  icon: LineAwesomeIcons.instagram,
                  // endIcon: false,
                  onPress: () {
                    _launchURL(_instagramController);
                  }),
              ProfileMenuWidget(
                  title: "Youtube",
                  icon: LineAwesomeIcons.youtube,
                  onPress: () {
                    _launchURL(_youtubeController);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
