import 'package:allogroup/screens/office/widgets/dimensions.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class IntText extends StatelessWidget {
  Color? color;
  final int text;
  double size;
  TextOverflow overflow;

  IntText({super.key, this.color = const Color(0xFF332d2b), required this.text,this.size =0, this.overflow = TextOverflow.ellipsis});

  @override
  Widget build(BuildContext context) {
    return Text(
      text as String,
      maxLines: 1,
      overflow: overflow,
      style: TextStyle(
        color: color,
        fontSize: size ==0?Dimensions.font20:size,
        fontWeight: FontWeight.w300,
        fontFamily: 'Poppins',
      ),
    );
  }
}
