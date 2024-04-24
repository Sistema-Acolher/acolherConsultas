import 'package:acolherconsultas/modules/pacientes/controllers/pacientesCadastradosProvider.dart';
import 'package:acolherconsultas/modules/pacientes/models/cadastroPaciente.dart';
import 'package:acolherconsultas/modules/pacientes/models/paciente.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ControllerCadastroPaciente extends ChangeNotifier {
  final nome = TextEditingController();
  final genero = TextEditingController();
  final rg = TextEditingController();
  final numeroCartaoSus = TextEditingController();
  final cpf = TextEditingController();
  final motivoAcolhimento = TextEditingController();
  final acolhimentoAnterior = TextEditingController();
  final dataNascimento = TextEditingController();
  final idade = TextEditingController();

  CadastroPaciente cadastro() {
    Paciente paciente = Paciente(
      nome: nome.text.trim(),
      genero: genero.text.trim(),
      rg: rg.text.trim(),
      numeroCartaoSus: numeroCartaoSus.text.trim(),
      cpf: cpf.text.trim(),
      motivoAcolhimento: motivoAcolhimento.text.trim(),
      acolhimentoAnterior: acolhimentoAnterior.text.trim() == "Sim" ? true : false,
      dataNascimento: DateFormat('dd/MM/yyyy').parse(dataNascimento.text),
    );

    CadastroPaciente cadastroPaciente = CadastroPaciente(
      paciente: paciente,
      dataCadastro: DateTime.now(),
      dataAtualizacao: DateTime.now(),
    );

    return cadastroPaciente;
  }
}