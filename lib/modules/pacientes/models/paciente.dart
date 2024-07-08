// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:acolherconsultas/modules/pacientes/models/historiaPregressa.dart';

// A classe Paciente é a classe que representa um paciente.
// Ela contém os atributos nome, gênero, número do cartão do SUS, RG, CPF, observações, encaminhamentos, motivo do acolhimento, acolhimento anterior e data de nascimento.
// Gerada automaticamente pela extensão "Dart Data Class Generator".
// Possui métodos para converter um objeto Paciente em um Map e vice-versa, além de converter um objeto Paciente em JSON e vice-versa.
// Além disso, possui um método copyWith para copiar um objeto Paciente e alterar seus atributos, e o método toString, alteração da função == e definição do hashCode.
class Paciente {
  String? id;
  String nome;
  bool ativo;
  String? cpf;
  String? rg;
  String? numeroCartaoSus;
  DateTime? dataNasc;
  String sexo;
  String motivoAcolhimento;
  String? acolhimentoAnterior;
  HistoriaPregressa? historiaPregressa;
  String? orientacoes;
  String? encaminhamentos;
  String casaDeApoioId;

  Paciente({
    this.id,
    required this.nome,
    required this.ativo,
    this.cpf,
    this.rg,
    this.numeroCartaoSus,
    this.dataNasc,
    required this.sexo,
    required this.motivoAcolhimento,
    this.acolhimentoAnterior,
    this.historiaPregressa,
    this.orientacoes,
    this.encaminhamentos,
    required this.casaDeApoioId,
  });

  // Método que calcula a idade do paciente a partir da data de nascimento e retorna uma string com a idade formatada.
  static String calcularIdade(DateTime dataNascimento) {
    final DateTime agora = DateTime.now();
    final int idade = agora.year - dataNascimento.year;
    final int mesAtual = agora.month;
    final int mesNascimento = dataNascimento.month;
    final int diaAtual = agora.day;
    final int diaNascimento = dataNascimento.day;

    String idadeString = "";
    int anos = 0;
    int dias = 0;
    int meses = 0;

    if (mesAtual < mesNascimento) {
      anos = idade - 1;
      meses = mesAtual - mesNascimento + 12;
      if (diaAtual < diaNascimento) {
        dias = diaAtual - diaNascimento + 30;
      } else {
        dias = diaAtual - diaNascimento;
      }
    } else if (mesAtual == mesNascimento) {
      if (diaAtual < diaNascimento) {
        anos = idade - 1;
        meses = mesAtual - mesNascimento + 11;
        dias = diaAtual - diaNascimento + 30;
      } else {
        anos = idade;
        meses = mesAtual - mesNascimento;
        dias = diaAtual - diaNascimento;
      }
    } else {
      anos = idade;
      if (diaAtual >= diaNascimento) {
        meses = mesAtual - mesNascimento;
        dias = diaAtual - diaNascimento;
      } else {
        meses = mesAtual - mesNascimento - 1;
        dias = diaAtual - diaNascimento + 30;
      }
    }

    if (anos > 0) idadeString += "${anos}a ";
    if (meses > 0) idadeString += "${meses}m ";
    if (dias > 0) idadeString += "${dias}d";

    if (idadeString.isEmpty) idadeString = "Menos de 1 dia";

    return idadeString;
  }

  // Este método foi substituído pelo método acima pois é menos preciso
  // static String calcularIdade(DateTime dataNascimento){
  //   final DateTime agora = DateTime.now();
  //   int dias = agora.difference(dataNascimento).inDays;
  //   final int anos = (dias / 365).floor();
  //   final int meses = ((dias % 365) / 30).floor();
  //   dias = (dias % 365) % 30;

  //   String idadeString = "";
  //   if (anos > 0) idadeString += "${anos}a ";
  //   if (meses > 0) idadeString += "${meses}m ";
  //   if (dias > 0) idadeString += "${dias}d";

  //   return idadeString;
  // }

  factory Paciente.fromDocument(DocumentSnapshot doc) {
    return Paciente(
      nome: doc['nome'] as String,
      sexo: doc['sexo'] as String,
      numeroCartaoSus: doc['numeroCartaoSus'] as String,
      rg: doc['rg'] as String,
      cpf: doc['cpf'] as String,
      orientacoes: doc['orientacoes'] as String,
      encaminhamentos: doc['encaminhamentos'] as String,
      motivoAcolhimento: doc['motivoAcolhimento'] as String,
      acolhimentoAnterior: doc['acolhimentoAnterior'] as String,
      dataNasc: doc['dataNascimento'].toDate() as DateTime,
      ativo: doc['ativo'] as bool,
      historiaPregressa: doc['historiaPregressa'] as HistoriaPregressa,
      casaDeApoioId: doc['casaDeApoioId'] as String,
    );
  }

  Paciente copyWith({
    String? id,
    String? nome,
    bool? ativo,
    String? cpf,
    String? rg,
    String? numeroCartaoSus,
    DateTime? dataNasc,
    String? sexo,
    String? motivoAcolhimento,
    String? acolhimentoAnterior,
    HistoriaPregressa? historiaPregressa,
    String? orientacoes,
    String? encaminhamentos,
    String? casaDeApoioId,
  }) {
    return Paciente(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      ativo: ativo ?? this.ativo,
      cpf: cpf ?? this.cpf,
      rg: rg ?? this.rg,
      numeroCartaoSus: numeroCartaoSus ?? this.numeroCartaoSus,
      dataNasc: dataNasc ?? this.dataNasc,
      sexo: sexo ?? this.sexo,
      motivoAcolhimento: motivoAcolhimento ?? this.motivoAcolhimento,
      acolhimentoAnterior: acolhimentoAnterior ?? this.acolhimentoAnterior,
      historiaPregressa: historiaPregressa ?? this.historiaPregressa,
      orientacoes: orientacoes ?? this.orientacoes,
      encaminhamentos: encaminhamentos ?? this.encaminhamentos,
      casaDeApoioId: casaDeApoioId ?? this.casaDeApoioId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
      'ativo': ativo,
      'cpf': cpf,
      'rg': rg,
      'numeroCartaoSus': numeroCartaoSus,
      'dataNasc': dataNasc,
      'sexo': sexo,
      'motivoAcolhimento': motivoAcolhimento,
      'acolhimentoAnterior': acolhimentoAnterior,
      'historiaPregressa': historiaPregressa?.toMap(),
      'orientacoes': orientacoes,
      'encaminhamentos': encaminhamentos,
      'casaDeApoioId': casaDeApoioId,
    };
  }

  factory Paciente.fromMap(Map<String, dynamic> map, {String? id}) {
    return Paciente(
      id: id ?? "",
      nome: map['nome'] as String,
      ativo: map['ativo'] as bool,
      cpf: map['cpf'] != null ? map['cpf'] as String : null,
      rg: map['rg'] != null ? map['rg'] as String : null,
      numeroCartaoSus:
          map['rg'] != null ? map['numeroCartaoSus'] as String : null,
      dataNasc: map['dataNasc'] != null
          ? (map['dataNasc'] as Timestamp).toDate()
          : null,
      sexo: map['sexo'] != null ? map['sexo'] as String : '',
      motivoAcolhimento: map['motivoAcolhimento'] as String,
      acolhimentoAnterior: map['acolhimentoAnterior'] != null
          ? map['acolhimentoAnterior'] as String
          : null,
      historiaPregressa: map['historiaPregressa'] != null
          ? HistoriaPregressa.fromMap(
              map['historiaPregressa'] as Map<String, dynamic>)
          : null,
      orientacoes:
          map['orientacoes'] != null ? map['orientacoes'] as String : null,
      encaminhamentos: map['encaminhamentos'] != null
          ? map['encaminhamentos'] as String
          : null,
      casaDeApoioId: map['casaDeApoioId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Paciente.fromJson(String source) =>
      Paciente.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Paciente(id: $id, nome: $nome, ativo: $ativo, cpf: $cpf, rg: $rg, numeroCartaoSus: $numeroCartaoSus, dataNasc: $dataNasc, sexo: $sexo, motivoAcolhimento: $motivoAcolhimento, acolhimentoAnterior: $acolhimentoAnterior, historiaPregressa: $historiaPregressa, orientacoes: $orientacoes, encaminhamentos: $encaminhamentos, casaDeApoioId: $casaDeApoioId)';
  }

  @override
  bool operator ==(covariant Paciente other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.nome == nome &&
        other.ativo == ativo &&
        other.cpf == cpf &&
        other.rg == rg &&
        other.numeroCartaoSus == numeroCartaoSus &&
        other.dataNasc == dataNasc &&
        other.sexo == sexo &&
        other.motivoAcolhimento == motivoAcolhimento &&
        other.acolhimentoAnterior == acolhimentoAnterior &&
        other.historiaPregressa == historiaPregressa &&
        other.orientacoes == orientacoes &&
        other.encaminhamentos == encaminhamentos &&
        other.casaDeApoioId == casaDeApoioId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        nome.hashCode ^
        ativo.hashCode ^
        cpf.hashCode ^
        rg.hashCode ^
        numeroCartaoSus.hashCode ^
        dataNasc.hashCode ^
        sexo.hashCode ^
        motivoAcolhimento.hashCode ^
        acolhimentoAnterior.hashCode ^
        historiaPregressa.hashCode ^
        orientacoes.hashCode ^
        encaminhamentos.hashCode ^
        casaDeApoioId.hashCode;
  }
}
