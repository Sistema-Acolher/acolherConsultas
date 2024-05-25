import 'package:acolherconsultas/shared/components/bars/pacienteAppbar.dart';
import 'package:flutter/material.dart';

class UsuarioScreen extends StatelessWidget {
  const UsuarioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PacienteAppbar(admin: true),
      body: Center(child: Text("Casa de Apoio")),
    );
  }
}