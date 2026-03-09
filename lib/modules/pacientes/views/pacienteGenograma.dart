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
  final ValueNotifier<bool> isRemovingNotifier = ValueNotifier(false);

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
    isRemovingNotifier.value = false;
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
            return ValueListenableBuilder(
              valueListenable: isRemovingNotifier,
              builder: (context, bool isRemoving, _) {
                return Stack(
                children: [
                  ListaGenogramaEcomapa(
                    isRemoving: isRemovingNotifier.value,
                    elementos: snapshot.data ?? [],
                    paciente: widget.paciente,
                    isGenograma: true,
                    refreshFunction: _refreshGenogramas,
                  ),
                  snapshot.data != null && snapshot.data!.isNotEmpty ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: FloatingActionButton(
                        heroTag: null,
                        child: Icon(
                          isRemovingNotifier.value ? Icons.close :
                          Icons.delete_outlined
                        ),
                        onPressed: () {
                          isRemovingNotifier.value = !isRemovingNotifier.value;
                        },
                      )
                    ),
                  ) : Container(),
                ],
              );
              },
            );
          }
        },
      ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => GenogramaScreen(paciente: widget.paciente, isEditable: true)));

          _refreshGenogramas();
        },
      ),
    );
  }
}
