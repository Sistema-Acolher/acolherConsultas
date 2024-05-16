import 'package:acolherconsultas/shared/components/bars/homeAppbar.dart';
import 'package:flutter/material.dart';

class Sumario extends StatelessWidget {
  const Sumario({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: HomeAppbar(),
      body: Center(
        child: Text(
          "Sumario",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      )
    );
  }
}