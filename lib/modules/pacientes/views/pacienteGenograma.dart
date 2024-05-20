import 'package:acolherconsultas/modules/pacientes/models/paciente.dart';
import 'package:acolherconsultas/shared/components/bars/pacienteAppbar.dart';
import 'package:flutter/material.dart';

class PacienteGenograma extends StatelessWidget {
  final Paciente? paciente;
  const PacienteGenograma({super.key, this.paciente});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PacienteAppbar(paciente: paciente,),
      body: const Center(child:Text("Genograma"))
    );
  }
}
