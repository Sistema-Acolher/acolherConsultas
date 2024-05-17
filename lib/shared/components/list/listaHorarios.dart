import 'package:acolherconsultas/modules/consultas/models/consulta.dart';
import 'package:acolherconsultas/modules/pacientes/controllers/pacienteCadastradoController.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ListaHorario extends StatefulWidget {
  final List<Consulta> consultasDoDia;

  const ListaHorario({
    super.key, required this.consultasDoDia
  });

  @override
  State<ListaHorario> createState() => _ListaHorarioState();
}

class _ListaHorarioState extends State<ListaHorario> {
  List<DateTime> horarios = [];

  @override
  void initState() {
    super.initState();
    context.read<PacientesCadastradosController>().getPacientes();
  }

  @override
  Widget build(BuildContext context) {
    int consultaAtual=0;
    widget.consultasDoDia.sort((a,b)=>a.dataHorario.compareTo(b.dataHorario));

    for (var i = 7; i < 18; i++) {
      horarios.add(DateTime.utc(DateTime.now().year,DateTime.now().month,DateTime.now().day,i));
    }

    return Container(
      padding: EdgeInsets.all(4),
      child: ListView.separated(
        itemCount: 11,
        separatorBuilder: (context, index) {
          return const Divider(height: 2,color: Colors.black,);
        },
        itemBuilder: (BuildContext context, int index) {
          final item = horarios[index];
          String? nome;
          if (widget.consultasDoDia.isNotEmpty && consultaAtual<widget.consultasDoDia.length && widget.consultasDoDia[consultaAtual].dataHorario.difference(item)<const Duration(minutes: 5)) {
            nome=Provider.of<PacientesCadastradosController>(context).pacientes
                                                                      .where((paciente) => paciente.id==widget.consultasDoDia[consultaAtual].pacienteId).first
                                                                      .paciente.nome;
            consultaAtual++;
          }else {
            nome=null;
          }
          return Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Text(
                nome??"Vago",
                style: TextStyle(color: nome==null?const Color(0xFF0AEC57):Colors.black,fontFamily: "MontSerrat",fontSize: 20)
              ),
              Text(
                DateFormat.Hm().format(item),
                style: const TextStyle(fontFamily: "MontSerrat",fontSize: 20, fontWeight: FontWeight.w500),
              )
              ],
            ),
          );
        },
      ),
    );
  }
}
