import 'package:acolherconsultas/modules/casasDeApoio/controller/casaDeApoioController.dart';
import 'package:acolherconsultas/modules/casasDeApoio/models/casaDeApoio.dart';
import 'package:acolherconsultas/modules/pacientes/controllers/pacienteCadastradoController.dart';
import 'package:acolherconsultas/modules/pacientes/models/pacienteCadastro.dart';
import 'package:acolherconsultas/modules/pacientes/views/pacienteCadastro.dart';
import 'package:acolherconsultas/shared/colors.dart';
import 'package:acolherconsultas/shared/components/bars/pageAppBar.dart';
import 'package:acolherconsultas/shared/components/buttons/searchButton.dart';
import 'package:acolherconsultas/shared/components/buttons/standartRoundButton.dart';
import 'package:acolherconsultas/shared/components/list/listaPacientes.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:provider/provider.dart';

class PacienteLista extends StatefulWidget {
  const PacienteLista({super.key});

  @override
  State<PacienteLista> createState() => _PacienteListaState();
}

class _PacienteListaState extends State<PacienteLista> {
  // Responsável pelo texto da barra de busca
  late TextEditingController _busca;
  // Responsável por armazenar os pacientes filtrados após a busca
  late ValueNotifier<List<CadastroPaciente>> _pacientesFiltrados;
  // Responsável por aguardar os dados vindos do banco
  late Future<void> _loadPacientesFuture;
  late CasaDeApoio casaDeApoioSelected;

  @override
  void initState() {
    super.initState();
    _busca = TextEditingController(text: "");
    _pacientesFiltrados = ValueNotifier<List<CadastroPaciente>>([]);
    _loadPacientesFuture = _filtrarPacientes();
  }

  // Carrega os pacientes do banco, busca todos os pacientes e os filtra de acordo com o campo _busca
  Future<void> _filtrarPacientes() async {
    List<CadastroPaciente> todosPacientes = Provider.of<PacientesCadastradosController>(context, listen: false).pacientes
      .where((element) => 
        element.paciente.casaDeApoioId==Provider.of<CasaDeApoioController>(context, listen: false).casaDeApoioSelecionada.value.id
      ).toList();
    String query = _busca.text.toLowerCase();

    if (query.isNotEmpty) {
      _pacientesFiltrados.value = todosPacientes
          .where((element) => element.paciente.nome.toLowerCase().contains(query))
          .toList();
    } else {
      _pacientesFiltrados.value = todosPacientes;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: context.read<CasaDeApoioController>().casaDeApoioSelecionada,
      builder: (context, casaDeApoio, child) {
        // Reinicializa o future quando casaDeApoio muda
        _loadPacientesFuture = _filtrarPacientes();

        return Scaffold(
          appBar: PageAppBar(titulo: "Pacientes", casaDeApoioSelecionada: casaDeApoio),
          body: FutureBuilder<void>(
            future: _loadPacientesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Erro ao carregar pacientes: ${snapshot.error}'));
              } else {
                return SingleChildScrollView(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 50),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Color(casaDeApoio.cor??azul.value))
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: TextFormField(
                                style: const TextStyle(
                                  fontFamily: "Montserrat",
                                  fontSize: 16,
                                  color: Colors.black
                                ),
                                decoration: const InputDecoration(
                                  hintStyle: TextStyle(color: Color(0xFF757575)),
                                  hintText: "Qual paciente...",
                                  contentPadding: EdgeInsets.only(left: 8, right: 4, bottom: 4),
                                  border: InputBorder.none
                                ),
                                controller: _busca,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                color: Color(casaDeApoio.cor??azul.value),
                                borderRadius: BorderRadius.circular(7),
                                border: Border.all(color: Color(casaDeApoio.cor??azul.value))
                              ),
                              child: Center(
                                child: SearchButton(
                                  backgroundColor: Color(casaDeApoio.cor??azul.value),
                                  icon: Icons.search,
                                  onPressed: _filtrarPacientes,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.14),
                              spreadRadius: 0,
                              blurRadius: 10,
                            )
                          ]
                        ),
                        child: ValueListenableBuilder<List<CadastroPaciente>>(
                          valueListenable: _pacientesFiltrados,
                          builder: (context, pacientes, child) => ListaDePacientes(listaObjeto: pacientes)
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
          floatingActionButton: StandartRoundButton(
              verticalPaddingFactor: 0.8,
              icon: Icons.add_box_outlined,
              text: "Novo cadastro",
              onPressed: () {
                pushWithoutNavBar(
                  context,
                  MaterialPageRoute(builder: (context) => const CadastroPacienteScreen())
                );
              }
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        );
      }
    );
  }
}
