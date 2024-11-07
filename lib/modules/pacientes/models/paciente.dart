import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:acolherconsultas/modules/pacientes/models/historiaPregressa.dart';

// A classe Paciente é a classe que representa um paciente.
// Ela contém os atributos nome, gênero, número do cartão do SUS, RG, CPF, observações, encaminhamentos, motivo do acolhimento, acolhimento anterior e data de nascimento.
// Gerada automaticamente pela extensão "Dart Data Class Generator".
// Possui métodos para converter um objeto Paciente em um Map e vice-versa, além de converter um objeto Paciente em JSON e vice-versa.
// Além disso, possui um método copyWith para copiar um objeto Paciente e alterar seus atributos, e o método toString, alteração da função == e definição do hashCode.
class Paciente {
  String? id;
  String casaDeApoioId;
  String nome;
  String cpf;
  String rg;
  bool ativo;
  String numeroCartaoSus;
  String sexo;
  DateTime dataNasc;
  String nomeMae;
  String cidadeOrigem;
  String motivoAcolhimento;
  bool acolhimentoAnterior;
  String? localAcolhimentoAnterior;
  String? dataAcolhimentoAnterior;
  String nomeEscola;
  String? serieTurnoEscola;
  String? dificuldadesEscolares;
  String? aulasEspecializadas;
  String? medicamentosUsados;
  String? acompanhamentoProfissionalDeSaude;
  String? vacinasFaltando;
  String? observacoes;
  HistoriaPregressa? historiaPregressa;
  Paciente({
    this.id,
    required this.casaDeApoioId,
    required this.nome,
    required this.cpf,
    required this.rg,
    required this.ativo,
    required this.numeroCartaoSus,
    required this.sexo,
    required this.dataNasc,
    required this.nomeMae,
    required this.cidadeOrigem,
    required this.motivoAcolhimento,
    required this.acolhimentoAnterior,
    this.localAcolhimentoAnterior,
    this.dataAcolhimentoAnterior,
    required this.nomeEscola,
    this.serieTurnoEscola,
    this.dificuldadesEscolares,
    this.aulasEspecializadas,
    this.medicamentosUsados,
    this.acompanhamentoProfissionalDeSaude,
    this.vacinasFaltando,
    this.observacoes,
    this.historiaPregressa,
  });

  Paciente copyWith({
    String? id,
    String? casaDeApoioId,
    String? nome,
    String? cpf,
    String? rg,
    bool? ativo,
    String? numeroCartaoSus,
    String? sexo,
    DateTime? dataNasc,
    String? nomeMae,
    String? cidadeOrigem,
    String? motivoAcolhimento,
    bool? acolhimentoAnterior,
    String? localAcolhimentoAnterior,
    String? dataAcolhimentoAnterior,
    String? nomeEscola,
    String? serieTurnoEscola,
    String? dificuldadesEscolares,
    String? aulasEspecializadas,
    String? medicamentosUsados,
    String? acompanhamentoProfissionalDeSaude,
    String? vacinasFaltando,
    String? observacoes,
    HistoriaPregressa? historiaPregressa,
  }) {
    return Paciente(
      id: id ?? this.id,
      casaDeApoioId: casaDeApoioId ?? this.casaDeApoioId,
      nome: nome ?? this.nome,
      cpf: cpf ?? this.cpf,
      rg: rg ?? this.rg,
      ativo: ativo ?? this.ativo,
      numeroCartaoSus: numeroCartaoSus ?? this.numeroCartaoSus,
      sexo: sexo ?? this.sexo,
      dataNasc: dataNasc ?? this.dataNasc,
      nomeMae: nomeMae ?? this.nomeMae,
      cidadeOrigem: cidadeOrigem ?? this.cidadeOrigem,
      motivoAcolhimento: motivoAcolhimento ?? this.motivoAcolhimento,
      acolhimentoAnterior: acolhimentoAnterior ?? this.acolhimentoAnterior,
      localAcolhimentoAnterior:
          localAcolhimentoAnterior ?? this.localAcolhimentoAnterior,
      dataAcolhimentoAnterior:
          dataAcolhimentoAnterior ?? this.dataAcolhimentoAnterior,
      nomeEscola: nomeEscola ?? this.nomeEscola,
      serieTurnoEscola: serieTurnoEscola ?? this.serieTurnoEscola,
      dificuldadesEscolares:
          dificuldadesEscolares ?? this.dificuldadesEscolares,
      aulasEspecializadas: aulasEspecializadas ?? this.aulasEspecializadas,
      medicamentosUsados: medicamentosUsados ?? this.medicamentosUsados,
      acompanhamentoProfissionalDeSaude: acompanhamentoProfissionalDeSaude ??
          this.acompanhamentoProfissionalDeSaude,
      vacinasFaltando: vacinasFaltando ?? this.vacinasFaltando,
      observacoes: observacoes ?? this.observacoes,
      historiaPregressa: historiaPregressa ?? this.historiaPregressa,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'casaDeApoioId': casaDeApoioId,
      'nome': nome,
      'cpf': cpf,
      'rg': rg,
      'ativo': ativo,
      'numeroCartaoSus': numeroCartaoSus,
      'sexo': sexo,
      'dataNasc': dataNasc,
      'nomeMae': nomeMae,
      'cidadeOrigem': cidadeOrigem,
      'motivoAcolhimento': motivoAcolhimento,
      'acolhimentoAnterior': acolhimentoAnterior,
      'localAcolhimentoAnterior': localAcolhimentoAnterior,
      'dataAcolhimentoAnterior': dataAcolhimentoAnterior,
      'nomeEscola': nomeEscola,
      'serieTurnoEscola': serieTurnoEscola,
      'dificuldadesEscolares': dificuldadesEscolares,
      'aulasEspecializadas': aulasEspecializadas,
      'medicamentosUsados': medicamentosUsados,
      'acompanhamentoProfissionalDeSaude': acompanhamentoProfissionalDeSaude,
      'vacinasFaltando': vacinasFaltando,
      'observacoes': observacoes,
      'historiaPregressa': historiaPregressa?.toMap(),
    };
  }

  factory Paciente.fromMap(Map<String, dynamic> map, {String? id}) {
    return Paciente(
      id: id ?? "",
      casaDeApoioId: map['casaDeApoioId'] as String,
      nome: map['nome'] as String,
      cpf: map['cpf'] as String,
      rg: map['rg'] as String,
      ativo: map['ativo'] as bool,
      numeroCartaoSus: map['numeroCartaoSus'] as String,
      sexo: map['sexo'] as String,
      dataNasc: (map['dataNasc'] as Timestamp).toDate(),
      nomeMae: map['nomeMae'] as String,
      cidadeOrigem: map['cidadeOrigem'] as String,
      motivoAcolhimento: map['motivoAcolhimento'] as String,
      acolhimentoAnterior: map['acolhimentoAnterior'] as bool,
      localAcolhimentoAnterior: map['localAcolhimentoAnterior'] != null
          ? map['localAcolhimentoAnterior'] as String
          : null,
      dataAcolhimentoAnterior: map['dataAcolhimentoAnterior'] != null
          ? map['dataAcolhimentoAnterior'] as String
          : null,
      nomeEscola: map['nomeEscola'] as String,
      serieTurnoEscola: map['serieTurnoEscola'] != null ? map['serieTurnoEscola'] as String : null,
      dificuldadesEscolares: map['dificuldadesEscolares'] != null ? map['dificuldadesEscolares'] as String : null,
      aulasEspecializadas: map['aulasEspecializadas'] as String,
      medicamentosUsados: map['medicamentosUsados'] as String,
      acompanhamentoProfissionalDeSaude:
          map['acompanhamentoProfissionalDeSaude'] != null
              ? map['acompanhamentoProfissionalDeSaude'] as String
              : null,
      vacinasFaltando: map['vacinasFaltando'] as String,
      observacoes:
          map['observacoes'] != null ? map['observacoes'] as String : null,
      historiaPregressa: map['historiaPregressa'] != null
          ? HistoriaPregressa.fromMap(
              map['historiaPregressa'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  bool operator ==(covariant Paciente other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.casaDeApoioId == casaDeApoioId &&
        other.cpf == cpf &&
        other.rg == rg;
  }

  @override
  int get hashCode {
    return id.hashCode ^ casaDeApoioId.hashCode;
  }
}

class AulasEspecializadas {
  String nomeAula;
  String localAula;
  String horarioAula;

  AulasEspecializadas({
    required this.nomeAula,
    required this.localAula,
    required this.horarioAula,
  });

  AulasEspecializadas copyWith({
    String? nomeAula,
    String? localAula,
    String? horarioAula,
  }) {
    return AulasEspecializadas(
      nomeAula: nomeAula ?? this.nomeAula,
      localAula: localAula ?? this.localAula,
      horarioAula: horarioAula ?? this.horarioAula,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nomeAula': nomeAula,
      'localAula': localAula,
      'horarioAula': horarioAula,
    };
  }

  factory AulasEspecializadas.fromMap(Map<String, dynamic> map) {
    return AulasEspecializadas(
      nomeAula: map['nomeAula'] as String,
      localAula: map['localAula'] as String,
      horarioAula: map['horarioAula'] as String,
    );
  }

  @override
  bool operator ==(covariant AulasEspecializadas other) {
    if (identical(this, other)) return true;

    return other.nomeAula == nomeAula &&
        other.localAula == localAula &&
        other.horarioAula == horarioAula;
  }

  @override
  int get hashCode =>
      nomeAula.hashCode ^ localAula.hashCode ^ horarioAula.hashCode;
}

class CadastroPaciente {
  Paciente paciente;
  DateTime dataCadastro;
  DateTime dataAtualizacao;

  CadastroPaciente({
    required this.paciente,
    required this.dataCadastro,
    required this.dataAtualizacao,
  });

  CadastroPaciente copyWith({
    Paciente? paciente,
    DateTime? dataCadastro,
    DateTime? dataAtualizacao,
  }) {
    return CadastroPaciente(
      paciente: paciente ?? this.paciente,
      dataCadastro: dataCadastro ?? this.dataCadastro,
      dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'paciente': paciente.toMap(),
      'dataCadastro': dataCadastro,
      'dataAtualizacao': dataAtualizacao,
    };
  }

  factory CadastroPaciente.fromMap(Map<String, dynamic> map) {
    return CadastroPaciente(
      paciente: Paciente.fromMap(map['paciente'] as Map<String, dynamic>,
          id: map['id'] as String),
      dataCadastro: (map['dataCadastro'] as Timestamp).toDate(),
      dataAtualizacao: (map['dataAtualizacao'] as Timestamp).toDate(),
    );
  }

  @override
  bool operator ==(covariant CadastroPaciente other) {
    if (identical(this, other)) return true;

    return other.paciente == paciente &&
        other.dataCadastro == dataCadastro &&
        other.dataAtualizacao == dataAtualizacao;
  }

  @override
  int get hashCode {
    return paciente.hashCode ^ dataCadastro.hashCode ^ dataAtualizacao.hashCode;
  }
}
