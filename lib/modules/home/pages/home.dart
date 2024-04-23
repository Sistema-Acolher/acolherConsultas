import 'package:acolherconsultas/modules/cadastroPaciente/pages/cadastroPaciente.dart';
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
        child: TextButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CadastroPaciente(title: "Cadastro de Pacientes"))),
          child: const Text("Cadastro de Pacientes")
        ),
      ),
    );
  }
}