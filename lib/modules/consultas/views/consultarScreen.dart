import 'package:acolherconsultas/modules/casasDeApoio/models/casaDeApoio.dart';
import 'package:acolherconsultas/modules/consultas/models/consulta.dart';
import 'package:acolherconsultas/modules/pacientes/models/paciente.dart';
import 'package:acolherconsultas/modules/pacientes/states/pacienteCadastroState.dart';
import 'package:acolherconsultas/modules/pacientes/views/pacienteScreen.dart';
import 'package:acolherconsultas/shared/components/bars/pacienteAppbar.dart';
import 'package:acolherconsultas/shared/components/bars/pageAppBar.dart';
import 'package:acolherconsultas/shared/components/buttons/bigRoundButton.dart';
import 'package:acolherconsultas/shared/components/list/listaHorarios.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConsultarScreen extends StatefulWidget {
  const ConsultarScreen({super.key, this.pacienteConsulta, this.dadosConsulta});
  
  final Paciente? pacienteConsulta;
  final ConsultaCadastro? dadosConsulta;

  @override
  State<ConsultarScreen> createState() => _ConsultarScreenState();
}

class _ConsultarScreenState extends State<ConsultarScreen> {
  final CadastroPacienteState _cadastroPacienteState = CadastroPacienteState();
  // Usado para selecionar o paciente e trocar o menu que aparece
  Paciente? pacienteSelecionado;
  late List<ConsultaCadastro> consultasDia;

  void loadConsultas() {
    consultasDia = Provider.of<List<ConsultaCadastro>>(context).where((element) => 
      element.dataHorario.day == DateTime.now().day &&
      element.casaDeApoioId == Provider.of<CasaDeApoio>(context).id
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    loadConsultas();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        // Caso venha a partir da pagina do paciente, troca a appbar
        child: widget.pacienteConsulta==null? PageAppBar(titulo: "Consultar", casaDeApoioSelecionada: Provider.of<CasaDeApoio>(context)): PacienteAppbar(paciente: widget.pacienteConsulta)
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
          // ConsultaCadastro caso possua paciente setado
          const Center(
            //IconButton(onPressed: () => ConsultaController().atualizarConsulta(widget.state, widget.dadosConsulta?.casaDeApoioId), icon: Icon())
            child: Text(
              "Consultar",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          )
          :
          Column(
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
          )
      )
    );
  }
}
