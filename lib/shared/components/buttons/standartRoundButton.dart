import 'package:acolherconsultas/shared/colors.dart';
import 'package:flutter/material.dart';

class StandartRoundButton extends StatelessWidget {
  final IconData? icon;
  final Color color;
  final String text;
  final double horizontalPaddingFactor;
  final double verticalPaddingFactor;
  final double fontSizeFactor;
  final double iconSizeFactor;
  final void Function()? onPressed;

  const StandartRoundButton({
    super.key,
    this.icon,
    required this.text,
    this.onPressed,
    this.horizontalPaddingFactor = 1,
    this.verticalPaddingFactor = 1,
    this.fontSizeFactor = 1,
    this.iconSizeFactor = 1,
    this.color = verde,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return Colors.grey;
            }
            return color;
          }
        ),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(horizontal: horizontalPaddingFactor*8, vertical: verticalPaddingFactor*8),
        ),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: Colors.white,
              size: iconSizeFactor*42,
            ),
            const SizedBox(width: 4)
          ],
          Text(
            text.contains(' ') ? text.replaceAll(' ', '\n') : text,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSizeFactor*16.0,
              fontFamily: "BobbyJonesSoft",
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}
