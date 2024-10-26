
import "package:collection/collection.dart";
import 'package:acolherconsultas/modules/consultas/models/consulta.dart';
import 'package:acolherconsultas/modules/pacientes/models/paciente.dart';
import 'package:acolherconsultas/shared/components/bars/pacienteAppbar.dart';
import 'package:acolherconsultas/shared/components/dropdown/consultaDropdown.dart';
import 'package:acolherconsultas/shared/components/list/listaComIcone.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConsultaLista extends StatefulWidget {
  final Paciente paciente;
  const ConsultaLista({super.key, required this.paciente});

  @override
  State<ConsultaLista> createState() => _ConsultaListaState();
}

class _ConsultaListaState extends State<ConsultaLista> {
  late List<ConsultaCadastro> consultasPaciente;
  
  // Carrega as consultas para a variavel kEvents, para ser usado na HASH de dias
  void loadConsultas(){ 
    consultasPaciente = Provider.of<List<ConsultaCadastro>>(context)
      .where((element) => element.pacienteId==widget.paciente.id)
      .sorted((a,b)=>a.dataHorario.compareTo(b.dataHorario));
  }

  @override
  Widget build(BuildContext context) {
    loadConsultas();
    return Scaffold(
      appBar: PacienteAppbar(paciente: widget.paciente,),
      body: Padding(
        padding: const EdgeInsets.only(top: 10,left: 10,bottom: 60),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ConsultaDropdown(
                text: "Consultas previstas", 
                child: ListaComIcone(
                  label: "Previstas",
                  paciente: widget.paciente,
                  listaConsulta: consultasPaciente.where((element) => element.estado=="agendada").toList()
                ),
              ),
              ConsultaDropdown(
                text: "Consultas atrasadas", 
                child: ListaComIcone(
                  label: "Atrasadas",
                  paciente: widget.paciente,
                  listaConsulta: consultasPaciente.where((element) => element.estado=="atrasada").toList()
                ),
              ),
              ConsultaDropdown(
                text: "Consultas prévias", 
                child: ListaComIcone(
                  label: "Prévias",
                  paciente: widget.paciente,
                  listaConsulta: consultasPaciente.where((element) => element.estado=="concluida").toList()
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}
