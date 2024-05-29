import 'package:acolherconsultas/modules/casasDeApoio/controller/casaDeApoioController.dart';
import 'package:acolherconsultas/modules/consultas/models/consulta.dart';
import 'package:acolherconsultas/modules/pacientes/models/paciente.dart';
import 'package:acolherconsultas/shared/components/bars/pacienteAppbar.dart';
import 'package:acolherconsultas/shared/components/calendario.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConsultaAgendar extends StatelessWidget {
  final Paciente? paciente;
  final Consulta? consulta;
  const ConsultaAgendar({super.key, this.paciente, this.consulta});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PacienteAppbar(paciente: paciente),
      body: Calendario(paciente: paciente, consulta: consulta, casaDeApoio: context.read<CasaDeApoioController>().casaDeApoioSelecionada.value,)
    );
  }
}