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
  @override
  Widget build(BuildContext context) {
    // print("height ${MediaQuery.of(context).size.height}");
    // print("width ${MediaQuery.of(context).size.width}");
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
        ],
      ),
    );
  }
}
