import 'package:flutter/material.dart';

class SearchButton extends StatelessWidget {
  final IconData? icon;
  final Color backgroundColor;
  final double horizontalPaddingFactor;
  final double verticalPaddingFactor;
  final double fontSizeFactor;
  final double iconSizeFactor;
  final void Function()? onPressed;

  const SearchButton({
    super.key,
    this.icon,
    required this.backgroundColor,
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
        backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(
              horizontal: horizontalPaddingFactor * 2,
              vertical: verticalPaddingFactor * 2),
        ),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
      child: ButtonBar(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Align(
              alignment: Alignment.center,
              child: Icon(
              icon,
              color: Colors.white,
              size: iconSizeFactor * 20,
            ),
            ),
          ],
        ],
      ),
    
    );
  }
}