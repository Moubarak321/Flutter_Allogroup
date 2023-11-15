import 'package:allogroup/screens/office/widgets/dimensions.dart';
// import 'package:allogroup/screens/office/widgets/expandable_text_widget.dart';
import 'package:allogroup/screens/office/widgets/icon_and_text_widget.dart';
import 'package:allogroup/screens/office/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/big_text.dart';

class AppColumnFood extends StatelessWidget {
  final String text;
  final String restau;
  // final String cat;
  const AppColumnFood({super.key, required this.text, required this.restau});
  Future<DateTime?> setDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        // Combine date and time into a single DateTime object
        DateTime selectedDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        // Return the selected DateTime
        // print(selectedDateTime.ty);
        return selectedDateTime;
      }
    }

    // Return null if the user cancels the date or time picker
    return null;
  }

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
            // Wrap(
            //   children: List.generate(
            //       5,
            //       (index) => Icon(
            //             Icons.star,
            //             color: Color.fromRGBO(10, 80, 137, 0.8),
            //             size: 15,
            //           )),
            // ),
            // SizedBox(
            //   width: 9,
            // ),
            SmallText(text: restau),
            SizedBox(
              width: 9,
            ),
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
            GestureDetector(
              onTap: () async {
                DateTime? selectedDateTime = await setDate(context);

                if (selectedDateTime != null) {
                  // Do something with the selected date and time
                  print("Selected Date and Time: $selectedDateTime");
                } else {
                  print("Date and Time selection canceled");
                }

                Get.snackbar("Infos", "Vous programmez l'achat de ce produit");
              },
              child: IconAndTextWidget(
                icon: Icons.calendar_month,
                text: "??",
                iconColor: Colors.red,
              ),
            ),
            IconAndTextWidget(
                icon: Icons.delivery_dining,
                text: "--",
                iconColor: Colors.blue),
          ],
        ),
        SizedBox(
          height: Dimensions.height10,
        ),
      ],
    );
  }
}
