import 'package:acolherconsultas/modules/consultas/models/consulta.dart';
import 'package:acolherconsultas/modules/consultas/models/consultaRelatorio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ConsultaRelatorioController extends ChangeNotifier {

  final periodoInicial = TextEditingController();
  final periodoFinal = TextEditingController();
  final casas = TextEditingController();
  final consultasEncontradas = ValueNotifier<List<ConsultaCadastro>>([]);

  ConsultaRelatorio relatorio(){
    var casasList = casas.text.trim().split(',');
    casasList.removeLast();
    ConsultaRelatorio relatorio = ConsultaRelatorio(
      periodoInicial: DateFormat('dd/MM/yyyy').parse(periodoInicial.text),
      periodoFinal: DateFormat('dd/MM/yyyy').parse(periodoFinal.text),
      casas: casasList
    );

    return relatorio;
  }

  realizarBusca(ConsultaRelatorio relatorio, context) {
    final consultas = Provider.of<List<ConsultaCadastro>>(context, listen: false).toList();
    relatorio.periodoFinal = relatorio.periodoFinal.add(const Duration(hours: 23, minutes: 59, seconds: 59));

    final consultasFiltradas = consultas.where((consulta) {
      return 
        consulta.dataHorario.isAfter(relatorio.periodoInicial) &&
        consulta.dataHorario.isBefore(relatorio.periodoFinal) &&
        consulta.estado == "concluida" &&
        consulta.dadosConsulta != null &&
        relatorio.casas.contains(consulta.casaDeApoioId);
    }).toList();
    
    consultasFiltradas.sort((a, b) => a.dataHorario.compareTo(b.dataHorario));

    consultasEncontradas.value = consultasFiltradas;
  }
}