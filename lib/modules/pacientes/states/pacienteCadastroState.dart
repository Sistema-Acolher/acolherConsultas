import 'package:acolherconsultas/modules/pacientes/models/historiaPregressa.dart';
import 'package:acolherconsultas/modules/pacientes/models/pacienteCadastro.dart';
import 'package:acolherconsultas/modules/pacientes/models/paciente.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// A classe CadastroPacienteState é a classe que controla os campos do cadastro de pacientes.
class CadastroPacienteState extends ChangeNotifier {
  // Campos do cadastro de pacientes.
  final nome = TextEditingController();
  final genero = TextEditingController();
  final rg = TextEditingController();
  final numeroCartaoSus = TextEditingController();
  final cpf = TextEditingController();
  final motivoAcolhimento = TextEditingController();
  final acolhimentoAnterior = TextEditingController();
  final dataNascimento = TextEditingController();
  final idade = TextEditingController();

  // Método que retorna um objeto CadastroPaciente com os dados preenchidos nos campos e com as datas de cadastro e atualização.
  CadastroPaciente cadastro() {
    Paciente paciente = Paciente(
      nome: nome.text.trim(),
      genero: genero.text.trim(),
      rg: rg.text.trim(),
      numeroCartaoSus: numeroCartaoSus.text.trim(),
      cpf: cpf.text.trim(),
      motivoAcolhimento: motivoAcolhimento.text.trim(),
      acolhimentoAnterior: acolhimentoAnterior.text.trim(),
      dataNasc: DateFormat('dd/MM/yyyy').parse(dataNascimento.text), 
      ativo: true, 
      orientacoes: '', 
      encaminhamentos: '', 
      casaDeApoioId: '',
    );

    CadastroPaciente cadastroPaciente = CadastroPaciente(
      paciente: paciente,
      dataCadastro: DateTime.now(),
      dataAtualizacao: DateTime.now(),
    );

    return cadastroPaciente;
  }
}