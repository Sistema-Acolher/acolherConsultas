import 'package:acolherconsultas/modules/pacientes/models/pacienteCadastro.dart';
import 'package:acolherconsultas/modules/pacientes/models/paciente.dart';
import 'package:acolherconsultas/modules/pacientes/states/pacienteHistoriaPregressaState.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// A classe CadastroPacienteState é a classe que controla os campos do cadastro de pacientes.
class CadastroPacienteState extends ChangeNotifier {
  // Campos do cadastro de pacientes.
  final nome = TextEditingController();
  final sexo = TextEditingController();
  final rg = TextEditingController();
  final numeroCartaoSus = TextEditingController();
  final cpf = TextEditingController();
  final motivoAcolhimento = TextEditingController();
  final acolhimentoAnterior = TextEditingController();
  final dataNascimento = TextEditingController();
  final idade = TextEditingController();
  final historiaPregressa = HistoriaPregressaState();

  // Método que retorna um objeto CadastroPaciente com os dados preenchidos nos campos e com as datas de cadastro e atualização.
  CadastroPaciente cadastro() {
    Paciente paciente = Paciente(
      nome: nome.text.trim(),
      sexo: sexo.text.trim(),
      rg: rg.text.trim().isEmpty ? null : rg.text.trim(),
      numeroCartaoSus: numeroCartaoSus.text.trim().isEmpty
          ? null
          : numeroCartaoSus.text.trim(),
      cpf: cpf.text.trim().isEmpty ? null : cpf.text.trim(),
      motivoAcolhimento: motivoAcolhimento.text.trim(),
      acolhimentoAnterior: acolhimentoAnterior.text.trim().isEmpty
          ? null
          : acolhimentoAnterior.text.trim(),
      dataNasc: dataNascimento.text.trim().isEmpty
          ? null
          : DateFormat('dd/MM/yyyy').parse(dataNascimento.text),
      ativo: true,
      orientacoes: '',
      encaminhamentos: '',
      casaDeApoioId: '',
      historiaPregressa: historiaPregressa.cadastro(),
    );

    CadastroPaciente cadastroPaciente = CadastroPaciente(
      paciente: paciente,
      dataCadastro: DateTime.now(),
      dataAtualizacao: DateTime.now(),
    );

    return cadastroPaciente;
  }
}
