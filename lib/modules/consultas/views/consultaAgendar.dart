import 'package:acolherconsultas/modules/pacientes/models/paciente.dart';
import 'package:acolherconsultas/shared/components/bars/pacienteAppbar.dart';
import 'package:acolherconsultas/shared/components/calendario.dart';
import 'package:flutter/material.dart';

class ConsultaAgendar extends StatelessWidget {
  final Paciente? paciente;
  const ConsultaAgendar({super.key, this.cor = 0xFF2277AE, this.paciente});
  final int cor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PacienteAppbar(paciente: paciente),
      body: Calendario(paciente: paciente)
    );
  }
}