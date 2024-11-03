import 'package:acolherconsultas/modules/pacientes/models/paciente.dart';
import 'package:acolherconsultas/modules/pacientes/states/pacienteHistoriaPregressaState.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// A classe CadastroPacienteState é a classe que controla os campos do cadastro de pacientes.
class CadastroPacienteState extends ChangeNotifier {
  // Campos do cadastro de pacientes
  final nome = TextEditingController();
  final cpf = TextEditingController();
  final rg = TextEditingController();
  final numeroCartaoSus = TextEditingController();
  final sexo = TextEditingController();
  final dataNascimento = TextEditingController();
  final nomeMae = TextEditingController();
  final cidadeOrigem = TextEditingController();
  final motivoAcolhimento = TextEditingController();
  bool acolhimentoAnterior = false;
    final localAcolhimentoAnterior = TextEditingController();
  final dataAcolhimentoAnterior = TextEditingController();
  final nomeEscola = TextEditingController();
  final serieTurnoEscola = TextEditingController();
  final dificuldadesEscolares = TextEditingController();
  final acompanhamentoProfissionalDeSaude = TextEditingController();
  final observacoes = TextEditingController();
  final idade = TextEditingController();
  final medicamentosUsados = TextEditingController();
  final vacinasFaltando = TextEditingController();

  // Historial pregressa state
  final historiaPregressa = HistoriaPregressaState();

  // Listas e dados adicionais
  List<AulasEspecializadas> aulasEspecializadas = [];
  // Adicionar uma nova aula especializada
  void adicionarAulaEspecializada(AulasEspecializadas aula) {
    aulasEspecializadas.add(aula);
    notifyListeners();
  }

  // Método para criar CadastroPaciente com os dados atuais
  CadastroPaciente cadastro() {
    Paciente paciente = Paciente(
      nome: nome.text.trim(),
      cpf: cpf.text.trim(),
      rg: rg.text.trim(),
      ativo: true,
      numeroCartaoSus: numeroCartaoSus.text.trim(),
      sexo: sexo.text.trim(),
      dataNasc: DateFormat('dd/MM/yyyy').parse(dataNascimento.text),
      nomeMae: nomeMae.text.trim(),
      cidadeOrigem: cidadeOrigem.text.trim(),
      motivoAcolhimento: motivoAcolhimento.text.trim(),
      acolhimentoAnterior: acolhimentoAnterior,
      localAcolhimentoAnterior: localAcolhimentoAnterior.text.trim().isEmpty
          ? null
          : localAcolhimentoAnterior.text.trim(),
      dataAcolhimentoAnterior: dataAcolhimentoAnterior.text.trim().isEmpty
          ? null
          : dataAcolhimentoAnterior.text.trim(),
      nomeEscola: nomeEscola.text.trim(),
      serieTurnoEscola: serieTurnoEscola.text.trim().isEmpty
          ? null
          : serieTurnoEscola.text.trim(),
      dificuldadesEscolares: dificuldadesEscolares.text.trim().isEmpty
          ? null
          : dificuldadesEscolares.text.trim(),
      aulasEspecializadas: aulasEspecializadas,
      medicamentosUsados: medicamentosUsados.text.trim(),
      acompanhamentoProfissionalDeSaude: acompanhamentoProfissionalDeSaude.text.trim().isEmpty
          ? null
          : acompanhamentoProfissionalDeSaude.text.trim(),
      vacinasFaltando: vacinasFaltando.text.trim(),
      observacoes: observacoes.text.trim().isEmpty
          ? null
          : observacoes.text.trim(),
      historiaPregressa: historiaPregressa.cadastro(),
      casaDeApoioId: '', // Atualize conforme necessário
    );

    return CadastroPaciente(
      paciente: paciente,
      dataCadastro: DateTime.now(),
      dataAtualizacao: DateTime.now(),
    );
  }
}
