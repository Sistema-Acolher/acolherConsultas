import 'package:acolherconsultas/modules/casasDeApoio/controller/casaDeApoioController.dart';
import 'package:acolherconsultas/modules/pacientes/models/paciente.dart';
import 'package:acolherconsultas/shared/components/bars/pacienteAppbar.dart';
import 'package:acolherconsultas/shared/components/bars/pageAppBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConsultaNovaScreen extends StatefulWidget {
  const ConsultaNovaScreen({super.key, this.pacienteConsulta});
  
  final Paciente? pacienteConsulta;

  @override
  State<ConsultaNovaScreen> createState() => _ConsultaNovaScreenState();
}

class _ConsultaNovaScreenState extends State<ConsultaNovaScreen> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: context.read<CasaDeApoioController>().casaDeApoioSelecionada,
      builder: (context, casaDeApoio, child) {
        return Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: widget.pacienteConsulta==null? PageAppBar(titulo: "Consultar", casaDeApoioSelecionada: casaDeApoio): PacienteAppbar(paciente: widget.pacienteConsulta)
            ),
            body: const Center(
            child: Text(
              "Consultar",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            )
        );
      }
    );
  }
}
