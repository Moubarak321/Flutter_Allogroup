// import 'package:allogroup/screens/office/allofood/popular_food_details.dart';
import 'package:allogroup/screens/office/help/home_help.dart';
import 'package:allogroup/screens/office/user/profil/profilScreen.dart';
import 'package:flutter/material.dart';
import 'package:allogroup/home.dart';
import 'package:allogroup/routes.dart';
import 'package:allogroup/screens/office/allofood/main_food_page.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:allogroup/screens/office/user/signInScreen/signInScreen.dart';
import 'package:allogroup/screens/office/user/confirmation/verification_otp.dart';

//ancien void mouba
// void main() {
//   runApp(MyApp());
// }

//ancien void flutter
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      navigatorKey.currentState
          ?.pushReplacementNamed(initializeAppAndNavigate() as String);
      // navigatorKey.currentState?.pushReplacementNamed('/home');
    });
  }









Future<void> initializeAppAndNavigate() async {
  try {
    // Vérifiez si l'utilisateur est déjà connecté.
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DateTime lastLoginTime = user.metadata.lastSignInTime!;
      DateTime now = DateTime.now();
      DateTime oneMonthAgo =now.subtract(Duration(days: 30));

      bool registeredByEmail = user.providerData.any((userInfo) => userInfo.providerId == 'password');
      bool registeredByPhone = user.providerData.any((userInfo) => userInfo.providerId == 'phoneNumber');

      if ((registeredByEmail & registeredByPhone ) && (lastLoginTime.isBefore(oneMonthAgo)) ) {
        await Future.delayed(const Duration(seconds: 5));
        navigatorKey.currentState?.pushReplacementNamed('/home');
      } else {

        navigatorKey.currentState?.pushReplacementNamed('/signInScreen');

        
      }

      return;
    }

    // Si l'utilisateur n'est pas connecté, vous pouvez le rediriger vers l'écran de connexion.
    await Future.delayed(const Duration(seconds: 5));
    navigatorKey.currentState?.pushReplacementNamed('/signInScreen'); // Exemple : Page de connexion
  } catch (e) {
    print("Erreur lors de l'initialisation de Firebase : $e");
  }
}











  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        //theme globaux du projet
        // cardColor: Color.fromRGBO(10, 80, 137, 0.8), //couleur des cards
        cardColor: Color.fromRGBO(10, 80, 137, 0.8), //couleur des cards
        appBarTheme: const AppBarTheme(
            color: Color.fromRGBO(10, 80, 137, 0.8), centerTitle: true),
        // appBarTheme: const AppBarTheme(color: Colors.teal, centerTitle: true),
        bottomAppBarTheme: const BottomAppBarTheme(
            color: Color.fromRGBO(10, 80, 137, 0.8)), //bottom appbar
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.orange), // home button
      ),
      navigatorKey: navigatorKey, // Utilisez la clé globale ici
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      // routes: {
      //   '/home': (context) => const Home(),
      // },
      routes: {
        '/home': (context) => const Home(),
        '/signInScreen': (context) => SignIn(),
        '/Verification_otp': (context) => VerificationOtp(phoneNumber: '', verificationId: '',),
        '/profilScreen': (context) => ProfileScreen(),
        Routes.mainFoodPage: (context) => MainFoodPage(),
        Routes.homehelp: (context) => PresentationApp(),
      },
      home: Scaffold(
        backgroundColor: const Color.fromRGBO(10, 80, 137, 0.8),
        body: Center(
          child: Image.asset(
            "assets/images/Home.png",
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
