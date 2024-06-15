import 'package:acolherconsultas/modules/casasDeApoio/controller/casaDeApoioController.dart';
import 'package:acolherconsultas/modules/consultas/controllers/consultaController.dart';
import 'package:acolherconsultas/modules/consultas/models/consulta.dart';
import 'package:acolherconsultas/modules/pacientes/models/paciente.dart';
import 'package:acolherconsultas/modules/pacientes/states/pacienteCadastroState.dart';
import 'package:acolherconsultas/modules/pacientes/states/pacienteHistoriaPregressaState.dart';
import 'package:acolherconsultas/modules/pacientes/views/pacienteScreen.dart';
import 'package:acolherconsultas/shared/components/bars/pacienteAppbar.dart';
import 'package:acolherconsultas/shared/components/bars/pageAppBar.dart';
import 'package:acolherconsultas/shared/components/buttons/bigRoundButton.dart';
import 'package:acolherconsultas/shared/components/list/listaHorarios.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConsultaNovaScreen extends StatefulWidget {
  const ConsultaNovaScreen({super.key, this.pacienteConsulta});
  
  final Paciente? pacienteConsulta;

  @override
  State<ConsultaNovaScreen> createState() => _ConsultaNovaScreenState();
}

class _ConsultaNovaScreenState extends State<ConsultaNovaScreen> {
  final CadastroPacienteState _cadastroPacienteState = CadastroPacienteState();
  // Usado para selecionar o paciente e trocar o menu que aparece
  late Paciente? pacienteSelecionado = null;
  // Responsavel por tornar o loadConsultas como assincrono, trazendo os dados corretamente
  late Future<void> _loadConsultasFuture;
  late List<Consulta> consultasDia;

  @override
  void initState() {
    _loadConsultasFuture = loadConsultas();
    super.initState();
  }

  Future<void> loadConsultas() async{
    await context.read<ConsultaController>().getConsultas();
    consultasDia = Provider.of<ConsultaController>(context,listen: false).consultas.where((element) => 
      element.dataHorario.day == DateTime.now().day &&
      element.casaDeApoioId == Provider.of<CasaDeApoioController>(context,listen: false).casaDeApoioSelecionada.value.id
    ).toList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Listen to changes in casaDeApoio and update state accordingly
    context.read<CasaDeApoioController>().casaDeApoioSelecionada.addListener(_onCasaDeApoioChanged);
  }

  void _onCasaDeApoioChanged(){
    setState(() {
      pacienteSelecionado=null;
      _loadConsultasFuture=loadConsultas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: context.read<CasaDeApoioController>().casaDeApoioSelecionada,
      builder: (context, casaDeApoio, child) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            // Caso venha a partir da pagina do paciente, troca a appbar
            child: widget.pacienteConsulta==null? PageAppBar(titulo: "Consultar", casaDeApoioSelecionada: casaDeApoio): PacienteAppbar(paciente: widget.pacienteConsulta)
          ),
          floatingActionButtonLocation: widget.pacienteConsulta!=null||pacienteSelecionado!=null?
            FloatingActionButtonLocation.endFloat:null,
          floatingActionButton:         widget.pacienteConsulta!=null||pacienteSelecionado!=null?
            BigRoundButton(
              text: "Historia Pregressa", 
              icon: Icons.history_edu,
              onPressed: () => Navigator.of(context,rootNavigator: true).push(
                MaterialPageRoute(builder:(context) => Scaffold(
                  appBar: PacienteAppbar(paciente: widget.pacienteConsulta??pacienteSelecionado),
                  body: HistPregressa(cadastroPacienteState: _cadastroPacienteState),
                ))
              ),
            ):null,
          body: Padding(
            padding: const EdgeInsets.only(bottom: 60,left: 10,right: 10),
            child: widget.pacienteConsulta!=null||pacienteSelecionado!=null?
              // Consulta caso possua paciente setado
              const Center(
                child: Text(
                  "Consultar",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              )
              :
              // Lista de horarios caso não possua paciente
              FutureBuilder(
                future: _loadConsultasFuture,
                builder: (context,snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erro ao carregar consultas: ${snapshot.error}'));
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Selecione uma consulta:",
                          style: TextStyle(
                            fontSize: 20,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Center(
                          child: Container(
                            margin: const EdgeInsets.only(top: 20),
                            decoration: BoxDecoration(
                              color: Colors.amber[100],
                              borderRadius: BorderRadius.circular(15)
                            ),
                            child: ListaHorario(consultasDoDia: consultasDia, onSelect: (p) => setState(() {
                              pacienteSelecionado=p;
                            }),),
                          ),
                        ),
                      ],
                    );
                  }
                }
              ),
          )
        );
      }
    );
  }
}
