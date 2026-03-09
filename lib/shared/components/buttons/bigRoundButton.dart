import 'package:acolherconsultas/shared/colors.dart';
import 'package:flutter/material.dart';

class BigRoundButton extends StatelessWidget {
  final IconData? icon;
  final String text;
  final double horizontalPaddingFactor;
  final double verticalPaddingFactor;
  final double fontSizeFactor;
  final double iconSizeFactor;
  final void Function()? onPressed;

  const BigRoundButton({
    super.key,
    this.icon,
    required this.text,
    this.onPressed,
    this.horizontalPaddingFactor = 1,
    this.verticalPaddingFactor = 1,
    this.fontSizeFactor = 1,
    this.iconSizeFactor = 1,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(verde),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(horizontal: horizontalPaddingFactor*16, vertical: verticalPaddingFactor*4),
        ),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: Colors.white,
              size: iconSizeFactor*40,
            )
          ],
          Text(
            text.contains(' ') ? text.replaceAll(' ', '\n') : text,
            style: TextStyle(
              height: 1,
              color: Colors.black,
              fontSize: fontSizeFactor*14,
              fontWeight: FontWeight.bold,
              fontFamily: "Montserrat",
              
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
