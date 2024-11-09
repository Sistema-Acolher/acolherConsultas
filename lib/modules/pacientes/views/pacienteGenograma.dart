import 'package:acolherconsultas/modules/genogramaEcomapa/controllers/genogramaController.dart';
import 'package:acolherconsultas/modules/genogramaEcomapa/models/genograma.dart';
import 'package:acolherconsultas/modules/pacientes/models/paciente.dart';
import 'package:acolherconsultas/modules/genogramaEcomapa/views/genogramaScreen.dart';
import 'package:acolherconsultas/shared/components/bars/pacienteAppbar.dart';
import 'package:acolherconsultas/shared/components/list/listaGenogramaEcomapa.dart';
import 'package:flutter/material.dart';

class PacienteGenograma extends StatefulWidget {
  final Paciente? paciente;

  const PacienteGenograma({super.key, this.paciente});

  @override
  State<PacienteGenograma> createState() => _PacienteGenogramaState();
}

class _PacienteGenogramaState extends State<PacienteGenograma> {
  final PacienteGenogramaController controller = PacienteGenogramaController();

  late Future<List<Genograma>> futureGenogramas;

  @override
  void initState() {
    super.initState();
    _loadGenogramas();
  }

  void _loadGenogramas() {
    futureGenogramas = controller.getGenogramasPaciente(widget.paciente?.id ?? '');
  }

  Future<void> _refreshGenogramas() async {
    setState(() {
      _loadGenogramas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PacienteAppbar(paciente: widget.paciente,),
      body: RefreshIndicator(
        onRefresh: _refreshGenogramas,
        child: FutureBuilder<List<Genograma>>(
        future: futureGenogramas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar genogramas'));
          }
          else {
            return ListaGenogramaEcomapa(
              elementos: snapshot.data ?? [],
              paciente: widget.paciente,
              isGenograma: true,
              refreshFunction: _refreshGenogramas,
            );
          }
        },
      ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => GenogramaScreen(paciente: widget.paciente, isEditable: true)));

          _refreshGenogramas();
        },
      ),
    );
  }
}
