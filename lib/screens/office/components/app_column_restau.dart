import 'package:allogroup/screens/office/widgets/dimensions.dart';
// import 'package:allogroup/screens/office/widgets/expandable_text_widget.dart';
import 'package:allogroup/screens/office/widgets/icon_and_text_widget.dart';
// import 'package:allogroup/screens/office/widgets/small_text.dart';
import 'package:flutter/material.dart';

import '../widgets/big_text.dart';

class AppColumnRestau extends StatelessWidget {
  final String text;
  // final String cat;
  const AppColumnRestau({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment
          .start, // alignement des composants de la boîte suivant le côté
      children: [
        BigText(
          text: text,
          size: Dimensions.font20,
        ),
        SizedBox(
          height: Dimensions.height10,
        ),
        Row(
          // etoiles
          children: [
            Wrap(
              children: List.generate(
                  5,
                  (index) => Icon(
                        Icons.star,
                        color: Color.fromRGBO(10, 80, 137, 0.8),
                        size: 15,
                      )),
            ),
            SizedBox(
              width: 9,
            ),
            // SmallText(text: "4.5"),
            // SizedBox(
            //   width: 9,
            // ),
            // SmallText(text: "1234"),
            // SizedBox(
            //   width: 9,
            // ),
            // SmallText(
            //   text: "comments",
            //   size: 11,
            // )
          ],
        ),
        SizedBox(
          height: Dimensions.height10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconAndTextWidget(
                icon: Icons.verified,
                text: "Vérifié",
                iconColor: Colors.orange),
            IconAndTextWidget(
                icon: Icons.location_on,
                text: "1.7km",
                iconColor: Color.fromRGBO(10, 80, 137, 0.8)),
            IconAndTextWidget(
                icon: Icons.access_time_rounded,
                text: "30min",
                iconColor: Colors.red),
          ],
        ),
        SizedBox(
          height: Dimensions.height10,
        ),
      ],
    );
  }
}

































































































// import 'package:allogroup/screens/office/widgets/dimensions.dart';
// // import 'package:allogroup/screens/office/widgets/expandable_text_widget.dart';
// import 'package:allogroup/screens/office/widgets/icon_and_text_widget.dart';
// // import 'package:allogroup/screens/office/widgets/small_text.dart';
// import 'package:allogroup/screens/office/widgets/text_and_icon_widget.dart';
// import 'package:flutter/material.dart';

// // import '../widgets/big_text.dart';

// class AppColumn extends StatelessWidget {
//   final String text;
//   final String cat;
//   final String adrs;
//   const AppColumn({super.key, required this.text, required this.cat, required this.adrs});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment
//           .start, // alignement des composants de la boîte suivant le côté
//       children: [
//         // BigText(
//         //   text: text,
//         //   size: Dimensions.font20,
          
//         // ),
//         TextAndIconWidget(
//                 text: text,
//                 icon: Icons.verified,
//                 iconColor: Colors.orange),
//         SizedBox(
//           height: Dimensions.height10,
//         ),
//         Row(
//           // etoiles
//           children: [
//             // Wrap(
//             //   children: List.generate(
//             //       5,
//             //       (index) => Icon(
//             //             Icons.star,
//             //             color: Color.fromRGBO(10, 80, 137, 0.8),
//             //             size: 15,
//             //           )),
//             // ),
//             // SizedBox(
//             //   width: 9,
//             // ),
//             // SmallText(text: "4.5"),
//             // SizedBox(
//             //   width: 9,
//             // ),
//             // SmallText(text: "1234"),
//             // SizedBox(
//             //   width: 9,
//             // ),
//             // SmallText(
//             //   text: adrs,
//             //   size: 11,
              
//             // ),
//             IconAndTextWidget(
//                 icon: Icons.food_bank_rounded,
//                 text: cat,
//                 iconColor: Colors.red),
            
//           ],
//         ),
//         SizedBox(
//           height: Dimensions.height10,
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             // IconAndTextWidget(
//             //     icon: Icons.verified,
//             //     text: "Vérifié",
//             //     iconColor: Colors.orange),
//             IconAndTextWidget(
//                 icon: Icons.location_on_outlined,
//                 text: adrs,
//                 iconColor: Color.fromRGBO(10, 80, 137, 0.8)),
//             IconAndTextWidget(
//                 icon: Icons.access_time_rounded,
//                 text: "Top",
//                 iconColor: Colors.red),
//           ],
//         ),
//         SizedBox(
//           height: Dimensions.height10,
//         ),
//       ],
//     );
//   }
// }
