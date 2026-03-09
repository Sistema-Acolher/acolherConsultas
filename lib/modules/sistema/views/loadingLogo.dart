import 'package:flutter/material.dart';

class LoadingLogo extends StatelessWidget {
  const LoadingLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Hero(
          tag: "logo",
          child: Image(
            image: AssetImage('src/images/logo.gif'),
            width: 269,
            height: 474,
          )
        ),
      ),
    );
  }
}