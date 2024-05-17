
import 'package:acolherconsultas/modules/sistema/views/home.dart';
import 'package:flutter/material.dart';
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterSplashScreen.gif(
          gifPath: 'src/gifs/acolherGifFast.gif',
          gifWidth: 269,
          gifHeight: 474,
          nextScreen: const HomePage(),
          duration: const Duration(milliseconds: 3515),
          onInit: () async {
            debugPrint("onInit");
          },
          onEnd: () async {
            debugPrint("onEnd 1");
          },
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        );
  }
}
