import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final String text;
  final double horizontalPaddingFactor;
  final double verticalPaddingFactor;
  final double fontSizeFactor;
  final double iconSizeFactor;
  final void Function()? onPressed;

  const LoginButton({
    super.key,
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
        backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF212121)),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(horizontal: horizontalPaddingFactor*12, vertical: verticalPaddingFactor*10),
        ),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          letterSpacing: 2.5,
          fontSize: fontSizeFactor*16.0,
          fontFamily: "Roboto"
        ),
      )
    );
  }
}
