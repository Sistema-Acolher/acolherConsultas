import 'package:acolherconsultas/modules/pacientes/models/historiaPregressa.dart';
import 'package:flutter/material.dart';

// A classe HistoriaPregressaState é a classe que controla os campos do cadastro de pacientes.
class HistoriaPregressaState extends ChangeNotifier {
  // Campos do cadastro de pacientes.
  final pesoNasc = TextEditingController();
  final estatura = TextEditingController();
  final pc = TextEditingController();
  final pt = TextEditingController();
  final testeApgar = TextEditingController();
  final ictericia = TextEditingController();
  final testeOrelhinha = TextEditingController();
  final testePezinho = TextEditingController();
  final rn = TextEditingController();
  final intercorrencia = TextEditingController();
  final idadeGestacional = TextEditingController();

  // Método que retorna um objeto HistoriaPregressa com os dados preenchidos nos campos e com as datas de cadastro e atualização.
  HistoriaPregressa cadastro() {
    HistoriaPregressa historiaPregressa = HistoriaPregressa(
      pesoNasc: pesoNasc.text.trim(),
      estatura: estatura.text.trim(),
      pc: pc.text.trim(),
      pt: pt.text.trim(),
      testeApgar: testeApgar.text.trim(),
      ictericia: ictericia.text.trim(),
      testeOrelhinha: testeOrelhinha.text.trim(),
      testePezinho: testePezinho.text.trim(), 
      rn: rn.text.trim(), 
      intercorrencia: intercorrencia.text.trim(),
      idadeGestacional: idadeGestacional.text.trim()
    );
    return historiaPregressa;
  }
}