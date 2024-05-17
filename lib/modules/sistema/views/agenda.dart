import 'package:acolherconsultas/shared/components/bars/pageAppBar.dart';
import 'package:flutter/material.dart';

class Agenda extends StatelessWidget {
  const Agenda({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: const PageAppBar(titulo: "Agenda",),
      body: Center(
        child: Text(
          "Agenda",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      )
    );
  }
}