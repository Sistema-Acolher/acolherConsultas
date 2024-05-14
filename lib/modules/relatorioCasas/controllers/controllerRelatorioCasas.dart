import 'package:acolherconsultas/modules/relatorioCasas/models/relatorioCasas.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ControllerRelatorioCasas extends ChangeNotifier {

  final periodoInicial = TextEditingController();
  final periodoFinal = TextEditingController();
  final casas = TextEditingController();

  RelatorioCasas relatorio(){
    RelatorioCasas relatorio = RelatorioCasas(
      periodoInicial: DateFormat('dd/MM/yyyy').parse(periodoInicial.text),
      periodoFinal: DateFormat('dd/MM/yyyy').parse(periodoFinal.text),
      casas: casas.text.trim()
    );

    return relatorio;
  }
}