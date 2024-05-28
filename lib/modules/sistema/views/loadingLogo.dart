import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingLogo extends StatelessWidget {
  const LoadingLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Hero(
        tag: "logo",
        child: Image(image: AssetImage('src/images/logo.gif'))
      ),
    );
  }
}