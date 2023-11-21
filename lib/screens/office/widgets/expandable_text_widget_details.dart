// import 'package:allogroup/screens/office/components/app_column.dart';
import 'package:allogroup/screens/office/widgets/small_text.dart';
import 'package:flutter/material.dart';

import 'dimensions.dart';

class ExpandableTextWidgetDetails extends StatefulWidget {
  final String text;
  // ignore: non_constant_identifier_names
  const ExpandableTextWidgetDetails( {super.key, required this.text});

  @override
  State<ExpandableTextWidgetDetails> createState() => _ExpandableTextWidgetDetailsState();
}

class _ExpandableTextWidgetDetailsState extends State<ExpandableTextWidgetDetails> {
  late String firstHalf;
  late String secondHalf;

  bool hiddenText = true;
  double textHeight = Dimensions.screenHeight / 5.01;

  @override
  void initState() {
    super.initState();
    if (widget.text.length > textHeight) {
      firstHalf = widget.text.substring(0, textHeight.toInt());
      secondHalf =
          widget.text.substring(textHeight.toInt() + 1, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: secondHalf.isEmpty
          ? SmallText(size: Dimensions.font16,text: firstHalf,color: Colors.blue,)
          : Column(
              children: [
                SmallText(
                  height: 1.8,
                  size: Dimensions.font16,
                  text: hiddenText
                      ? ("$firstHalf...")
                      : (firstHalf + secondHalf),
                      color: Colors.blue,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      hiddenText = !hiddenText;
                    });
                  },
                  child: Row(
                    children: [
                      SmallText(
                        text: "Voir plus",
                        color: Color.fromRGBO(10, 80, 137, 0.8),
                      ),
                      Icon(
                        hiddenText
                            ? Icons.arrow_drop_down
                            : Icons.arrow_drop_up,
                        color: Color.fromRGBO(10, 80, 137, 0.8),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
