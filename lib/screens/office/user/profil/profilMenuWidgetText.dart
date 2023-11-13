import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

// Couleur primaire de votre application
const Color tPrimaryColor = Colors.blue;

// Couleur d'accentuation de votre application
const Color tAccentColor = Colors.orange;

class ProfileMenuWidgetText extends StatefulWidget {
  const ProfileMenuWidgetText({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPress,
    required this.text,
    this.endIcon = true,
    this.textColor,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final String text;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  _ProfileMenuWidgetTextState createState() => _ProfileMenuWidgetTextState();
}

class _ProfileMenuWidgetTextState extends State<ProfileMenuWidgetText> {
  bool switchValue = false;

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    var iconColor = isDark ? tPrimaryColor : tAccentColor;

    return ListTile(
      onTap: widget.onPress,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: iconColor.withOpacity(0.1),
        ),
        child: Icon(widget.icon, color: iconColor),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title, style: Theme.of(context).textTheme.bodyLarge?.apply(color: widget.textColor)),
          if (widget.text.isNotEmpty) Text(widget.text, style: Theme.of(context).textTheme.caption?.apply(color: widget.textColor)),
        ],
      ),
      trailing: widget.endIcon
          ? Switch(
              value: switchValue,
              onChanged: (value) {
                setState(() {
                  switchValue = value;
                });
              },
              activeColor: Colors.blue, // Customize switch color
            )
          : null,
    );
  }
}
