import 'package:allogroup/screens/office/widgets/dimensions.dart';
import 'package:allogroup/screens/office/widgets/icon_and_text_widget.dart';
import 'package:allogroup/screens/office/widgets/small_text.dart';
import 'package:flutter/material.dart';

import '../widgets/big_text.dart';

class AppColumn extends StatelessWidget {
  final String text;
  const AppColumn({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment
          .start, // alignement des composants de la boîte suivant le côté
      children: [
        BigText(text: text, size: Dimensions.font20,),
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
            SmallText(text: "4.5"),
            SizedBox(
              width: 9,
            ),
            SmallText(text: "1234"),
            SizedBox(
              width: 9,
            ),
            SmallText(
              text: "comments",
              size: 11,
            )
          ],
        ),
        SizedBox(
          height: Dimensions.height10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconAndTextWidget(
                icon: Icons.circle_rounded,
                text: "Normal",
                iconColor: Colors.orange),
            IconAndTextWidget(
                icon: Icons.location_on,
                text: "1.7km",
                iconColor: Color.fromRGBO(10, 80, 137, 0.8)),
            IconAndTextWidget(
                icon: Icons.access_time_rounded,
                text: "32min",
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
