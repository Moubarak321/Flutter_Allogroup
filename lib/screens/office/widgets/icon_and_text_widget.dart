import 'package:allogroup/screens/office/widgets/dimensions.dart';
import 'package:allogroup/screens/office/widgets/small_text.dart';
import 'package:flutter/material.dart';

class IconAndTextWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  // final Color color;
  final Color iconColor;

  const IconAndTextWidget(
      {super.key,
      required this.icon,
      required this.text,
      // required this.color,
      required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: Dimensions.iconSize24),
        SmallText(text: text,),
        SizedBox(width: 5,),
        
      ],
    );
  }
}
