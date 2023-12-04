import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SmallText extends StatelessWidget {
  Color? color;
  final String text;
  double size;
  // TextOverflow overflow;
  double height;
  SmallText({
    super.key,
    this.color = const Color(0xFF89dad0),
    required this.text,
    this.size = 12,
    this.height = 1.2,
    // this.overflow = TextOverflow.ellipsis
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      // overflow: overflow,
      style: TextStyle(
        color: color,
        fontSize: size,
        height: height,
        // fontWeight: FontWeight.w400,
        fontFamily: 'Poppins',
      ),
    );
  }
}
