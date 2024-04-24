// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Paciente {
  String nome;
  String genero;
  String numeroCartaoSus;
  String rg;
  String cpf;
  String observacoes;
  String encaminhamentos;
  String motivoAcolhimento;
  bool acolhimentoAnterior;
  DateTime dataNascimento;

  Paciente({
    required this.nome,
    required this.genero,
    required this.numeroCartaoSus,
    required this.rg,
    required this.cpf,
    required this.dataNascimento,
    this.observacoes = "",
    this.encaminhamentos = "",
    required this.motivoAcolhimento,
    required this.acolhimentoAnterior,
  });

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
      if(diaAtual >= diaNascimento){
        meses = mesAtual - mesNascimento;
        dias = diaAtual - diaNascimento;
      }else{
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
      genero: doc['genero'] as String,
      numeroCartaoSus: doc['numeroCartaoSus'] as String,
      rg: doc['rg'] as String,
      cpf: doc['cpf'] as String,
      observacoes: doc['observacoes'] as String,
      encaminhamentos: doc['encaminhamentos'] as String,
      motivoAcolhimento: doc['motivoAcolhimento'] as String,
      acolhimentoAnterior: doc['acolhimentoAnterior'] as bool,
      dataNascimento: doc['dataNascimento'].toDate() as DateTime
    );
  }

  Paciente copyWith({
    String? nome,
    String? genero,
    String? numeroCartaoSus,
    String? rg,
    String? cpf,
    String? observacoes,
    String? encaminhamentos,
    String? motivoAcolhimento,
    bool? acolhimentoAnterior,
    DateTime? dataNascimento,
  }) {
    return Paciente(
      nome: nome ?? this.nome,
      genero: genero ?? this.genero,
      numeroCartaoSus: numeroCartaoSus ?? this.numeroCartaoSus,
      rg: rg ?? this.rg,
      cpf: cpf ?? this.cpf,
      observacoes: observacoes ?? this.observacoes,
      encaminhamentos: encaminhamentos ?? this.encaminhamentos,
      motivoAcolhimento: motivoAcolhimento ?? this.motivoAcolhimento,
      acolhimentoAnterior: acolhimentoAnterior ?? this.acolhimentoAnterior,
      dataNascimento: dataNascimento ?? this.dataNascimento,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nome': nome,
      'genero': genero,
      'numeroCartaoSus': numeroCartaoSus,
      'rg': rg,
      'cpf': cpf,
      'observacoes': observacoes,
      'encaminhamentos': encaminhamentos,
      'motivoAcolhimento': motivoAcolhimento,
      'acolhimentoAnterior': acolhimentoAnterior,
      'dataNascimento': dataNascimento,
    };
  }

  factory Paciente.fromMap(Map<String, dynamic> map) {
    return Paciente(
      nome: map['nome'] as String,
      genero: map['genero'] as String,
      numeroCartaoSus: map['numeroCartaoSus'] as String,
      rg: map['rg'] as String,
      cpf: map['cpf'] as String,
      observacoes: map['observacoes'] as String,
      encaminhamentos: map['encaminhamentos'] as String,
      motivoAcolhimento: map['motivoAcolhimento'] as String,
      acolhimentoAnterior: map['acolhimentoAnterior'] as bool,
      dataNascimento: (map['dataNascimento'] as Timestamp).toDate(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Paciente.fromJson(String source) => Paciente.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString(){
    return 'Paciente(nome: $nome, genero: $genero, numeroCartaoSus: $numeroCartaoSus, rg: $rg, cpf: $cpf, observacoes: $observacoes, encaminhamentos: $encaminhamentos, motivoAcolhimento: $motivoAcolhimento, acolhimentoAnterior: $acolhimentoAnterior, dataNascimento: $dataNascimento, idade: ${calcularIdade(dataNascimento)}';
  }

  @override
  bool operator ==(covariant Paciente other) {
    if (identical(this, other)) return true;
  
    return 
      other.nome == nome &&
      other.genero == genero &&
      other.numeroCartaoSus == numeroCartaoSus &&
      other.rg == rg &&
      other.cpf == cpf &&
      other.observacoes == observacoes &&
      other.encaminhamentos == encaminhamentos &&
      other.motivoAcolhimento == motivoAcolhimento &&
      other.acolhimentoAnterior == acolhimentoAnterior &&
      other.dataNascimento == dataNascimento;
  }

  @override
  int get hashCode {
    return nome.hashCode ^
      genero.hashCode ^
      numeroCartaoSus.hashCode ^
      rg.hashCode ^
      cpf.hashCode ^
      observacoes.hashCode ^
      encaminhamentos.hashCode ^
      motivoAcolhimento.hashCode ^
      acolhimentoAnterior.hashCode ^
      dataNascimento.hashCode;
  }
}
