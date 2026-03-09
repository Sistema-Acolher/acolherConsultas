import 'package:acolherconsultas/shared/components/bars/pacienteAppbar.dart';
import 'package:flutter/material.dart';

class CasaDeApoioScreen extends StatelessWidget {
  const CasaDeApoioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PacienteAppbar(admin: true),
      body: Center(child: Text("Casa de Apoio")),
    );
  }
}