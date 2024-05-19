import 'package:acolherconsultas/shared/colors.dart';
import 'package:flutter/material.dart';

class HomeButton extends StatelessWidget {
  final IconData? icon;
  final String text;
  final bool iconOnRight;
  final Color backgroundColor;
  final double horizontalPaddingFactor;
  final double verticalPaddingFactor;
  final void Function()? onPressed;

  const HomeButton({
    super.key,
    this.icon,
    required this.text,
    this.onPressed,
    this.iconOnRight = false,
    this.backgroundColor = Colors.green,
    this.horizontalPaddingFactor = 3,
    this.verticalPaddingFactor = 1,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(
              horizontal: horizontalPaddingFactor * 8,
              vertical: verticalPaddingFactor * 8),
        ),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: iconOnRight ? _buildTextIcon() : _buildIconText(),
      ),
    );
  }

  List<Widget> _buildIconText() {
    return [
      if (icon != null) ...[
        Icon(
          icon,
          color: cinza,
          size: 50,
        ),
      ],
      SizedBox(
        width: 176,
        child: Text(
          text.contains(' ') ? text.replaceAll(' ', '\n') : text,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 30.0,
            fontFamily: "BobbyJonesSoft",
          ),
          textAlign: TextAlign.center,
        ),
      ),
    ];
  }

  List<Widget> _buildTextIcon() {
    return [
      SizedBox(
        width: 176,
        child: Text(
          text.contains(' ') ? text.replaceAll(' ', '\n') : text,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 30.0,
            fontFamily: "BobbyJonesSoft",
          ),
          textAlign: TextAlign.center,
        ),
      ),
      if (icon != null) ...[
        Icon(
          icon,
          color: cinza,
          size: 50,
        ),
      ],
    ];
  }
}


 /* chamando o componente:
 
 const SizedBox(height: 20),
  HomeButton(
    icon: Icons.book,
    text: "Cadastrados",
    onPressed: () {
      /*Navigator.push(
          context,
          MaterialPageRoute(
          builder: (context) => const screen()));*/
    },
    iconOnRight: false,
    backgroundColor: Colors.green,
),*/
