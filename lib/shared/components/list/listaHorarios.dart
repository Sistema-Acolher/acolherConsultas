import 'package:acolherconsultas/modules/consultas/models/consulta.dart';
import 'package:acolherconsultas/modules/pacientes/controllers/pacienteCadastradoController.dart';
import 'package:acolherconsultas/modules/pacientes/models/paciente.dart';
import 'package:acolherconsultas/modules/pacientes/models/pacienteCadastro.dart';
import 'package:acolherconsultas/shared/components/text/confirmacao.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ListaHorario extends StatefulWidget {
  final DateTime? dia;
  final List<Consulta> consultasDoDia;
  final Paciente? paciente;
  final bool fundo;

  const ListaHorario({
    super.key, required this.consultasDoDia, this.paciente, this.dia, this.fundo =false
  });

  @override
  State<ListaHorario> createState() => _ListaHorarioState();
}

class _ListaHorarioState extends State<ListaHorario> {

  @override
  void initState() {
    super.initState();
    context.read<PacientesCadastradosController>().getPacientes();
  }

  List<Widget> data(List<CadastroPaciente> pacientes) {
    List<DateTime> horarios = [];
    int consultaAtual=0;
    for (var i = 7; i < 18; i++) {
      horarios.add(DateTime.utc(DateTime.now().year,DateTime.now().month,DateTime.now().day,i));
    }
    List<Widget> list = [];
    for (var item in horarios) {
      String? nome;
      if (widget.consultasDoDia.isNotEmpty && consultaAtual<widget.consultasDoDia.length && widget.consultasDoDia[consultaAtual].dataHorario.difference(item)<const Duration(minutes: 5)) {
        nome=pacientes.where((paciente) => paciente.id==widget.consultasDoDia[consultaAtual].pacienteId).firstOrNull
          ?.paciente.nome;
        consultaAtual++;
      }else {
        nome=null;
      }
      if(nome != null){
        List<String> parts = nome.split(' ');
        if (parts.length > 2) {
          nome = '${parts[0]} ${parts[1]}';
        }
      }
      list.add(Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () { 
                    if (nome==null && widget.paciente!=null) {
                      _dialogBuilder(context, widget.paciente?.nome ?? "",item);
                    }
                  },
                  child: Text(
                    nome??"Vago",
                    style: TextStyle(color: nome==null?const Color(0xFF0AEC57):Colors.black,fontFamily: "MontSerrat",fontSize: 20)
                  ),
                ),
                Text(
                  DateFormat.Hm().format(item),
                  style: const TextStyle(fontFamily: "MontSerrat",fontSize: 20, fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
          item!=horarios.last?const Divider(height: 2,color: Colors.black,):const SizedBox.shrink()
        ],
      ));
    }
    return list;// all widget added now retrun the list here 
  }

  @override
  Widget build(BuildContext context) {
    var pacientes=Provider.of<PacientesCadastradosController>(context).pacientes;
    widget.consultasDoDia.sort((a,b)=>a.dataHorario.compareTo(b.dataHorario));
    
    return Container(
      decoration: BoxDecoration(
        color: widget.fundo?Colors.white:null,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: data(pacientes)
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context, String pacienteNome, DateTime horario) {
    if(widget.dia !=null){
      horario = DateTime(
        widget.dia!.year,
        widget.dia!.month,
        widget.dia!.day,
        horario.hour,
        horario.minute
      );
    }
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.only(top: 10,left: 10,right: 10),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
          content: Confirmacao(nome: pacienteNome, dataHorario: horario)
        );
      },
    );
  }
}
