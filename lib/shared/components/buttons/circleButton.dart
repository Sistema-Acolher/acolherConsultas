import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  const CircleButton({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(55.0),
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.grey,
      child: InkWell(
        borderRadius: BorderRadius.circular(55.0),
        onTap: onPressed,
        child: Container(
          width: 110.0,
          height: 110.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40.0,
                color: Colors.black,
              ),
              const SizedBox(height: 8.0),
              Text(
                title,
                style: const TextStyle(
                    color: Colors.black, fontFamily: 'Roboto', fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
