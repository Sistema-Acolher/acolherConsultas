import 'package:acolherconsultas/modules/genogramaEcomapa/controllers/ecomapaController.dart';
import 'package:acolherconsultas/modules/pacientes/models/paciente.dart';
import 'package:acolherconsultas/modules/genogramaEcomapa/views/ecomapaScreen.dart';
import 'package:acolherconsultas/shared/components/bars/pacienteAppbar.dart';
import 'package:acolherconsultas/shared/components/list/listaGenogramaEcomapa.dart';
import 'package:flutter/material.dart';

class PacienteEcomapa extends StatelessWidget {
  final Paciente? paciente;
  final PacienteEcomapaController controller = PacienteEcomapaController();
  PacienteEcomapa({super.key, this.paciente});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PacienteAppbar(paciente: paciente,),
      body: FutureBuilder(
        future: controller.getEcomapasPaciente(paciente?.id ?? ''), 
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if(snapshot.hasError) {
            return Center(child: Text('Erro ao carregar ecomapas'));
          } else {
            return ListaGenogramaEcomapa(
              elementos: snapshot.data ?? [],
              paciente: paciente,
              isGenograma: false,
            );
          }
        }
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EcomapaScreen(paciente: paciente, isEditable: true))),
      ),
    );
  }
}
