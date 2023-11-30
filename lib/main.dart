// import 'package:allogroup/screens/office/allofood/popular_food_details.dart';
import 'package:allogroup/screens/office/allofood/cart.dart';
import 'package:allogroup/screens/office/allofood/interfacefoodmarchand.dart';
import 'package:allogroup/screens/office/allofood/popular_food_details.dart';
import 'package:allogroup/screens/office/allofood/recommended_food_detail.dart';
import 'package:allogroup/screens/office/allolivreur/interfacelivreurchampion.dart';
import 'package:allogroup/screens/office/help/home_help.dart';
import 'package:allogroup/screens/office/notifications/notifications.dart';
import 'package:allogroup/screens/office/notifications/detailsnotifications.dart';
import 'package:allogroup/screens/office/user/informations/informations.dart';
import 'package:allogroup/screens/office/user/parametres/parametres.dart';
import 'package:allogroup/screens/office/user/profil/profilScreen.dart';
import 'package:allogroup/screens/office/user/profil/updateProfil.dart';
import 'package:allogroup/screens/office/user/utilisateur/utilisateur.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:allogroup/screens/office/user/utilisateur/details/historiqueCommandes.dart';
import 'package:allogroup/screens/office/user/utilisateur/details/historiqueCourses.dart';
import 'package:allogroup/screens/office/user/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:allogroup/home.dart';
import 'package:allogroup/routes.dart';
import 'package:allogroup/screens/office/allofood/main_food_page.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:allogroup/screens/office/user/signInScreen/signInScreen.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:allogroup/screens/office/allolivreur/main_livreur_page.dart';
import 'package:allogroup/screens/office/allofood/traitementEnCours.dart';
//51518759

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
 
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    // Gérez les notifications lorsque l'application est en premier plan
    print('Message data: ${message.data}');
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Gérez les notifications lorsque l'application est en arrière-plan
  print('Handling a background message: ${message.data}');
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

    /// whenever your initialization is completed, remove the splash screen:
    // Future.delayed(Duration(seconds: 5)).then((value) => {
    Future.delayed(Duration(seconds: 5), () {
      FlutterNativeSplash.remove();
      navigatorKey.currentState
          ?.pushReplacementNamed(initializeAppAndNavigate() as String);
    });
  }

  Future<void> initializeAppAndNavigate() async {
    try {
      // Vérifiez si l'utilisateur est déjà connecté.
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        DateTime lastLoginTime = user.metadata.lastSignInTime!;
        DateTime now = DateTime.now();
        DateTime oneMonthAgo = now.subtract(Duration(days: 30));

        bool registeredByEmail = user.providerData
            .any((userInfo) => userInfo.providerId == 'password');
        // bool registeredByPhone = user.providerData.any((userInfo) => userInfo.providerId == 'phoneNumber');

        if ((registeredByEmail) && (lastLoginTime.isBefore(oneMonthAgo))) {
          await Future.delayed(const Duration(seconds: 5));
          navigatorKey.currentState?.pushReplacementNamed('/signInScreen');
        } else {
          navigatorKey.currentState?.pushReplacementNamed('/home');
        }

        return;
      }

      // Si l'utilisateur n'est pas connecté, vous pouvez le rediriger vers l'écran de connexion.
      await Future.delayed(const Duration(seconds: 3));
      navigatorKey.currentState?.pushReplacementNamed(
          '/signInScreen'); // Exemple : Page de connexion
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
        cardColor: Color(0xCC0A5089), //couleur des cards
        appBarTheme: const AppBarTheme(
            color: Color.fromRGBO(10, 80, 137, 0.8), centerTitle: true),
        // appBarTheme: const AppBarTheme(color: Colors.teal, centerTitle: true),
        bottomAppBarTheme: const BottomAppBarTheme(
          color: Color.fromRGBO(10, 80, 137, 1),
        ), //bottom appbar
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
        // '/Verification_otp': (context) => VerificationOtp(phoneNumber: '', verificationId: '',),
        '/profilScreen': (context) => ProfileScreen(),
        Routes.mainFoodPage: (context) => MainFoodPage(),
        Routes.homehelp: (context) => PresentationApp(),
        Routes.delivery: (context) => Delivery(),
        '/popular_food_details': (context) => PopularFoodDetail(
              produit: {},
            ),
        '/UpdateProfileScreen': (context) => UpdateProfileScreen(),
        // '/recommended_food_detail': (context) => RecommendedFoodDetail(),
        '/cart': (context) => Cart(),
        '/notifications': (context) => Notifications(),
        '/wallet': (context) => Wallet(),
        '/parametres': (context) => Parametres(),
        '/informations': (context) => Informations(),
        '/utilisateur': (context) => Utilisateur(),
        '/historiqueCommandes': (context) => HistoriqueCommandesRepas(),
        '/historiqueCourses': (context) => HistoriqueCourses(),
        '/traitementEnCours.dart': (context) => EnCoursDeTraitement(),
        '/detailsnotifications': (context) => Detailsnotifications(courseData: {}, index: 0,),
        Routes.interfaceMarchand: (context) => InterfaceFoodMarchand(),
        Routes.interfaceLivreur: (context) => InterFaceLivreurChampion(),
        'recommended_food_detail': (context) =>
            RecommendedFoodDetail(marchand: {})
      },
      home: Scaffold(
        backgroundColor: const Color.fromRGBO(10, 80, 137, 0.8),
        body: Center(
          child: Image.asset(
            "assets/images/livreur2.png",
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
