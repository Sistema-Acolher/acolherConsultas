import 'package:acolherconsultas/modules/casasDeApoio/controller/casaDeApoioController.dart';
import 'package:acolherconsultas/modules/pacientes/models/paciente.dart';
import 'package:acolherconsultas/shared/components/bars/pacienteAppbar.dart';
import 'package:acolherconsultas/shared/components/calendario.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConsultaAgendar extends StatelessWidget {
  final Paciente? paciente;
  const ConsultaAgendar({super.key, this.paciente});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PacienteAppbar(paciente: paciente),
      body: Calendario(paciente: paciente, casaDeApoio: context.read<CasaDeApoioController>().casaDeApoioSelecionada.value,)
    );
  }
}