import 'package:acolherconsultas/modules/consultas/views/consultaRelatorioInstituicao.dart';
import "package:collection/collection.dart";
import 'package:acolherconsultas/modules/consultas/models/consulta.dart';
import 'package:acolherconsultas/modules/pacientes/models/paciente.dart';
import 'package:acolherconsultas/shared/components/bars/pacienteAppbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PacienteObservacoes extends StatefulWidget {
  final Paciente paciente;
  final bool? eInstituicao;
  const PacienteObservacoes({
    super.key,
    required this.paciente,
    this.eInstituicao,
  });

  @override
  State<PacienteObservacoes> createState() => _ConsultaListaState();
}

class _ConsultaListaState extends State<PacienteObservacoes> {
  late List<ConsultaCadastro> consultasPaciente;

  void loadConsultas() {
    consultasPaciente = Provider.of<List<ConsultaCadastro>>(context)
        .where((element) =>
            element.pacienteId == widget.paciente.id &&
            element.estado == "concluida")
        .sorted((a, b) => b.dataHorario.compareTo(a.dataHorario));
  }

  Widget _buildListItem(ConsultaCadastro item) {
    final formattedDate = DateFormat.yMMMd("pt_BR").format(item.dataHorario);
    final formattedTime = DateFormat.Hm().format(item.dataHorario);

    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(child: Text(formattedDate)),
          Text(formattedTime),
          Container(
            width: 2,
            height: 30,
            color: Colors.black,
            margin: const EdgeInsets.symmetric(horizontal: 8),
          ),
          IconButton(
            visualDensity: const VisualDensity(
                horizontal: VisualDensity.minimumDensity,
                vertical: VisualDensity.minimumDensity),
            padding: EdgeInsets.zero,
            icon: Icon(
              item.estado == "concluida" ? Icons.remove_red_eye : null,
              size: 30,
            ),
            onPressed: () {
              if (item.estado == "concluida") {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ConsultaRelatorioInstituicao(
                      consultaCadastro: item,
                      eInstituicao: widget.eInstituicao!,
                    ),
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    loadConsultas();
    return Scaffold(
        appBar: PacienteAppbar(
          paciente: widget.paciente,
        ),
        body: Padding(
          padding:
              const EdgeInsets.only(top: 10, left: 10, bottom: 10, right: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                for (var item in consultasPaciente) _buildListItem(item),
              ],
            ),
          ),
        ));
  }
}
