import 'package:acolherconsultas/shared/components/bars/pageAppBar.dart';
import 'package:flutter/material.dart';

class ConsultaNovaScreen extends StatefulWidget {
  const ConsultaNovaScreen({super.key});

  @override
  State<ConsultaNovaScreen> createState() => _ConsultaNovaScreenState();
}

class _ConsultaNovaScreenState extends State<ConsultaNovaScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PageAppBar(titulo: "Consultar"),
      body: Center(
        child: Text(
          "Sumario",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      )
    );
  }
}
