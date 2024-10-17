import 'package:acolherconsultas/modules/genogramaEcomapa/controllers/genogramaController.dart';
import 'package:acolherconsultas/modules/pacientes/models/paciente.dart';
import 'package:acolherconsultas/modules/genogramaEcomapa/views/genogramaScreen.dart';
import 'package:acolherconsultas/shared/components/bars/pacienteAppbar.dart';
import 'package:acolherconsultas/shared/components/list/listaGenogramaEcomapa.dart';
import 'package:flutter/material.dart';

class PacienteGenograma extends StatelessWidget {
  final Paciente? paciente;
  final PacienteGenogramaController controller = PacienteGenogramaController();
  PacienteGenograma({super.key, this.paciente});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PacienteAppbar(paciente: paciente,),
      body: FutureBuilder(
        future: controller.getGenogramasPaciente(paciente?.id ?? ''), 
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if(snapshot.hasError) {
            print(snapshot.error);
            return Center(child: Text('Erro ao carregar genogramas'));
          } else {
            return ListaGenogramaEcomapa(
              elementos: snapshot.data ?? [],
              paciente: paciente,
              isGenograma: true,
            );
          }
        }
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => GenogramaScreen(paciente: paciente, isEditable: true))),
      ),
    );
  }
}
