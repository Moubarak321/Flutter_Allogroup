import 'package:get/get.dart';

class Dimensions {
  static double screenHeight = Get.context!.height;
  static double screenWidth = Get.context!.width;
  
  static double pageView = screenHeight / 2.35;   // layout pour la partie food et autre. taille de l'ecran 752 / la taille prevue pour la box . ici 320 (conteneur du carouss)

  static double pageViewContainer = screenHeight / 3.41;  // layout pour la partie food et autre. taille de l'ecran / la taille prevue pour la box . ici 220 (conteneur img)
  static double pageViewTextContainer = screenHeight / 6.26;  // layout pour la partie food et autre. taille de l'ecran / la taille prevue pour la box . ici 120


// Dynamic height for padding and margin
  static double height10 = screenHeight / 75.2;  // layout pour la partie food. taille de l'ecran / la taille prevue pour la box . ici 10 (box sous les images du carous ==> expacement entre les texts)
  static double height20 = screenHeight / 37.6;
  static double height15 = screenHeight / 50.13;
  static double height30 = screenHeight / 25.06;
  static double height45 = screenHeight / 16.71;

// dynamic width for padding and margin
  static double width20 = screenHeight / 37.6;
  static double width10 = screenHeight / 75.2;  // layout pour la partie food et autre. largeur de l'ecran / la taille prevue pour la box . ici 10 (box sous les images du carous ==> expacement entre les texts)
  static double width15 = screenHeight / 50.13;
  static double width30 = screenHeight / 25.06;

  static double font20 = screenHeight / 50.13;
  // static double font45 = screenHeight / 16.71;

  static double radius15 = screenHeight / 50.13;
  static double radius20 = screenHeight / 37.6;
  static double radius30 = screenHeight / 25.06;

  //icon size
  static double iconSize24 = screenHeight / 31.33;

  //List view size
  static double listViewImgSize = screenWidth / 3.6; //pour height 100 et screen width 360
  static double listViewTextContSize = screenWidth / 4; //pour height 100 et screen width 90



}
