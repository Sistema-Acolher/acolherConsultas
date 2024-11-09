import 'package:acolherconsultas/modules/genogramaEcomapa/controllers/ecomapaController.dart';
import 'package:acolherconsultas/modules/genogramaEcomapa/models/ecomapa.dart';
import 'package:acolherconsultas/modules/pacientes/models/paciente.dart';
import 'package:acolherconsultas/modules/genogramaEcomapa/views/ecomapaScreen.dart';
import 'package:acolherconsultas/shared/components/bars/pacienteAppbar.dart';
import 'package:acolherconsultas/shared/components/list/listaGenogramaEcomapa.dart';
import 'package:flutter/material.dart';

class PacienteEcomapa extends StatefulWidget {
  final Paciente? paciente;

  const PacienteEcomapa({super.key, this.paciente});

  @override
  State<PacienteEcomapa> createState() => _PacienteEcomapaState();
}

class _PacienteEcomapaState extends State<PacienteEcomapa> {
  final PacienteEcomapaController controller = PacienteEcomapaController();

  late Future<List<Ecomapa>> futureEcomapas;

  @override
  void initState() {
    super.initState();
    _loadEcomapas();
  }

  void _loadEcomapas() {
    futureEcomapas = controller.getEcomapasPaciente(widget.paciente?.id ?? '');
  }

  Future<void> _refreshEcomapas() async {
    setState(() {
      _loadEcomapas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PacienteAppbar(paciente: widget.paciente,),
      body: RefreshIndicator(
        onRefresh: _refreshEcomapas,
        child: FutureBuilder(
          future: futureEcomapas, 
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if(snapshot.hasError) {
              return const Center(child: Text('Erro ao carregar ecomapas'));
            } else {
              return ListaGenogramaEcomapa(
                elementos: snapshot.data ?? [],
                paciente: widget.paciente,
                isGenograma: false,
                refreshFunction: _refreshEcomapas,
              );
            }
          }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => EcomapaScreen(paciente: widget.paciente, isEditable: true)));

          _refreshEcomapas();
        }
      ),
    );
  }
}
