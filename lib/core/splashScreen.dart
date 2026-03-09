
import 'package:flutter/material.dart';
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, this.nextScreen, this.duration});

  final Widget? nextScreen;
  final Duration? duration;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return FlutterSplashScreen.gif(
          gifPath: 'src/gifs/acolherGifFast.gif',
          gifWidth: 269,
          gifHeight: 474,
          nextScreen: widget.nextScreen,
          duration: widget.duration,
          onInit: () async {
            
          },
          onEnd: () async {
            
          },
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        );
  }
}
