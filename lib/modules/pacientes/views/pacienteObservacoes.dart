import 'package:acolherconsultas/modules/pacientes/models/paciente.dart';
import 'package:acolherconsultas/shared/components/bars/pacienteAppbar.dart';
import 'package:flutter/material.dart';

class PacienteObservacoes extends StatelessWidget {
  final Paciente? paciente;
  const PacienteObservacoes({super.key, this.paciente});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PacienteAppbar(paciente: paciente,),
      body: const Center(child:Text("Observações"))
    );
  }
}
