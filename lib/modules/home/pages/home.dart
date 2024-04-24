import 'package:acolherconsultas/modules/pacientes/pages/cadastroPacienteScreen.dart';
import 'package:acolherconsultas/modules/pacientes/pages/pacientesCadastradosScreen.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CadastroPacienteScreen(title: "Cadastro de Pacientes"))),
              child: const Text("Cadastro de Pacientes")
            ),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PacientesCadastradosScreen())),
              child: const Text("Lista de Pacientes Cadastrados")
            ),
          ],
        ),
      ),
    );
  }
}