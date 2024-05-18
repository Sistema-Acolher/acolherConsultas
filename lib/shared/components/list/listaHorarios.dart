import 'package:acolherconsultas/modules/consultas/models/consulta.dart';
import 'package:acolherconsultas/modules/pacientes/controllers/pacienteCadastradoController.dart';
import 'package:acolherconsultas/modules/pacientes/models/paciente.dart';
import 'package:acolherconsultas/shared/components/text/confirmacao.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ListaHorario extends StatefulWidget {
  final List<Consulta> consultasDoDia;
  final bool admin;
  final Paciente? paciente;

  const ListaHorario({
    super.key, required this.consultasDoDia, required this.admin, this.paciente
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
    var pacientes=Provider.of<PacientesCadastradosController>(context).pacientes;
    int consultaAtual=0;
    widget.consultasDoDia.sort((a,b)=>a.dataHorario.compareTo(b.dataHorario));

    for (var i = 7; i < 18; i++) {
      horarios.add(DateTime.utc(DateTime.now().year,DateTime.now().month,DateTime.now().day,i));
    }

    return ListView.separated(
      itemCount: 11,
      separatorBuilder: (context, index) {
        return const Divider(height: 2,color: Colors.black,);
      },
      itemBuilder: (BuildContext context, int index) {
        final item = horarios[index];
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
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () { 
                  if (widget.admin && nome==null && widget.paciente!=null) {
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
        );
      },
    );
  }

  Future<void> _dialogBuilder(BuildContext context, String pacienteNome, DateTime horario) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.only(top: 10,left: 10,right: 10),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
          content: SizedBox(
            height: 150,
            child: Confirmacao(nome: pacienteNome, dataHorario: horario)
          )
        );
      },
    );
  }
}
