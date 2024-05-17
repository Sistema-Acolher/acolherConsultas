import 'package:acolherconsultas/modules/consultas/models/consultaRelatorio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConsultaRelatorioController extends ChangeNotifier {

  final periodoInicial = TextEditingController();
  final periodoFinal = TextEditingController();
  final casas = TextEditingController();

  ConsultaRelatorio relatorio(){
    ConsultaRelatorio relatorio = ConsultaRelatorio(
      periodoInicial: DateFormat('dd/MM/yyyy').parse(periodoInicial.text),
      periodoFinal: DateFormat('dd/MM/yyyy').parse(periodoFinal.text),
      casas: casas.text.trim()
    );

    return relatorio;
  }
}