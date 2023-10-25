// ignore: file_names
// import 'package:allogroup/screens/office/allofood/popular_food_details.dart';
import 'package:allogroup/screens/office/components/foodcard_body.dart';
import 'package:allogroup/screens/office/widgets/big_text.dart';
import 'package:allogroup/screens/office/widgets/dimensions.dart';
import 'package:allogroup/screens/office/widgets/small_text.dart';
import 'package:flutter/material.dart';

class MainFoodPage extends StatefulWidget {
  const MainFoodPage({super.key});

  @override
  State<MainFoodPage> createState() => _MainFoodPageState();
}

class _MainFoodPageState extends State<MainFoodPage> {
  bool foodButtonSelected = true; // Par défaut, "food" est actif
  bool homeButtonSelected = false; // Par défaut, "Home" est inactif
  bool deliveryButtonSelected = false; // "Delivery" est inactif

  void selectFood() {
    setState(() {
      foodButtonSelected = true;
      homeButtonSelected = false; // Par défaut, "Home" est inactif
      deliveryButtonSelected = false;
    });
    // Vous pouvez ajouter ici le code pour naviguer vers la page d'accueil
  }

  void selectHome() {
    setState(() {
      homeButtonSelected = true;
      deliveryButtonSelected = false;
      foodButtonSelected = false;
    });
    // Vous pouvez ajouter ici le code pour naviguer vers la page d'accueil
  }

  void selectDelivery() {
    setState(() {
      deliveryButtonSelected = true;
      homeButtonSelected = false;
      foodButtonSelected = false;

    });
    // Vous pouvez ajouter ici le code pour gérer la page de livraison
  }

  @override
  Widget build(BuildContext context) {
    print("height ${MediaQuery.of(context).size.height}");
    print("width ${MediaQuery.of(context).size.width}");
    return Scaffold(
      // appBar: AppBar(backgroundColor: Colors.white,),
      body: Column(
        children: [
          Container(
            // color: Colors.blue,
            margin: EdgeInsets.only(
                top: Dimensions.height45, bottom: Dimensions.height15),
            padding: EdgeInsets.only(
                left: Dimensions.width20, right: Dimensions.width20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    BigText(
                      text: "Allô Food",
                      color: Color.fromRGBO(10, 80, 137, 0.8),
                    ),
                    Row(
                      children: [
                        SmallText(text: "Cotonou", color: Colors.orange),
                        Icon(Icons.arrow_drop_down_circle_rounded)
                      ],
                    ),
                  ],
                ),
                Center(
                  child: Container(
                    // chopping card
                    width: Dimensions.height45,
                    height: Dimensions.height45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radius15),
                      color: Color.fromRGBO(10, 80, 137, 0.8),
                    ),
                    child: Icon(
                      Icons.shopping_cart_rounded,
                      color: Colors.white,
                      size: Dimensions.iconSize24,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // SliverPadding(
          //   padding: EdgeInsets.only(bottom: 24.0), // Marge inférieure
          //   sliver: Expanded(
          //     child: SingleChildScrollView(
          //       child: FoodPageBody(),
          //     ),
          //   ),
          // ),

          Expanded(
            child: SingleChildScrollView(
              child: FoodPageBody(),
            ),
          ),
          SizedBox(
            height: Dimensions.height20,
          ),
        ],
      ),

      //============  Bottom Navbar Buttons  ============

      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          selectFood();
          // Naviguer vers la nouvelle page lorsque l'élément est cliqué
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return MainFoodPage(); // Remplacez DetailPage par votre propre page.
              },
            ),
          );
        },
        backgroundColor: foodButtonSelected
            ? Colors.orange
            : Color.fromRGBO(10, 80, 137, 0.8),
        child: Icon(
          Icons.fastfood,
        ),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(45),
        ),
        child: Container(
          color: Colors.black38,
          child: BottomAppBar(
              shape: CircularNotchedRectangle(),
              child: Row(
                children: [
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      selectHome();
                      Navigator.pushNamed(context, '/home');
                    },
                    tooltip: 'Accueil',
                    icon: Icon(Icons.home),
                    color: homeButtonSelected ? Colors.orange : Colors.white,
                  ),
                  Spacer(),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      selectDelivery();
                    },
                    tooltip: 'Livraison',
                    icon: Icon(Icons.delivery_dining),
                    color:
                        deliveryButtonSelected ? Colors.orange : Colors.white,
                  ),
                  Spacer(),
                ],
              )),
        ),
      ),
    );
  }
}



