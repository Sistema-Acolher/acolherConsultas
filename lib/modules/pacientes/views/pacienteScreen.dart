import 'package:acolherconsultas/modules/pacientes/models/paciente.dart';
import 'package:acolherconsultas/shared/components/bars/pacienteAppbar.dart';
import 'package:acolherconsultas/shared/components/bars/tabBar.dart';
import 'package:flutter/material.dart';

class PacienteScreen extends StatelessWidget {
  final Paciente? paciente;
  const PacienteScreen({super.key, this.paciente});

  @override
  Widget build(BuildContext context) {
    return CustomTabBar(
      appBar: PacienteAppbar(paciente: paciente), 
      tabs_: const [
        "Informações\n\t\t\tPessoais",
        "\t\tHistória\nPregressa"
      ], 
      views_: const [
        InfoPessoais(),
        HistPregressa()
      ]
    ); 
  }
}

class InfoPessoais extends StatelessWidget {
  const InfoPessoais({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Informações Pessoais"),);
  }
}

class HistPregressa extends StatelessWidget {
  const HistPregressa({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("História Pregressa"),);
  }
}

