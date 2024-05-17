import 'package:acolherconsultas/shared/components/bars/homeAppbar.dart';
import 'package:acolherconsultas/shared/components/text/confirmacao.dart';
import 'package:flutter/material.dart';

class Sumario extends StatelessWidget {
  const Sumario({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppbar(),
      body: Center(
        child: Confirmacao(nome: "nome", dataHorario: DateTime.now())
      ),
    );
  }
}