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
  final ValueNotifier<bool> isRemovingNotifier = ValueNotifier(false);

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
    isRemovingNotifier.value = false;
    setState(() {
      _loadEcomapas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PacienteAppbar(
        paciente: widget.paciente,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshEcomapas,
        child: FutureBuilder(
            future: futureEcomapas,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Erro ao carregar ecomapas'));
              } else {
                return ValueListenableBuilder(
                  valueListenable: isRemovingNotifier,
                  builder: (context, bool isRemoving, _) {
                    return Stack(
                      children: [
                        ListaGenogramaEcomapa(
                          isRemoving: isRemovingNotifier.value,
                          elementos: snapshot.data ?? [],
                          paciente: widget.paciente,
                          isGenograma: false,
                          refreshFunction: _refreshEcomapas,
                        ),
                        snapshot.data != null && snapshot.data!.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: FloatingActionButton(
                                      heroTag: null,
                                      child: Icon(isRemovingNotifier.value
                                          ? Icons.close
                                          : Icons.delete_outlined),
                                      onPressed: () {
                                        isRemovingNotifier.value =
                                            !isRemovingNotifier.value;
                                      },
                                    )),
                              )
                            : Container(),
                      ],
                    );
                  },
                );
              }
            }),
      ),
      floatingActionButton: FloatingActionButton(
          heroTag: null,
          child: const Icon(Icons.add),
          onPressed: () async {
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EcomapaScreen(
                        paciente: widget.paciente, isEditable: true)));

            _refreshEcomapas();
          }),
    );
  }
}
