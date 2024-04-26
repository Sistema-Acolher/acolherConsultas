// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:acolherconsultas/modules/pacientes/models/paciente.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// A classe CadastroPaciente é a classe que representa o cadastro de um paciente.
// Ela contém um objeto Paciente, um id, a data de cadastro e a data de atualização.
// Gerada automaticamente pela extensão "Dart Data Class Generator".
// Possui métodos para converter um objeto CadastroPaciente em um Map e vice-versa, além de converter um objeto CadastroPaciente em JSON e vice-versa.
// Além disso, possui um método copyWith para copiar um objeto CadastroPaciente e alterar seus atributos, e o métodos toString, alteração da função == e definição do hashCode.
class CadastroPaciente {
  Paciente paciente;
  String? id;
  DateTime dataCadastro;
  DateTime dataAtualizacao;

  CadastroPaciente({
    required this.paciente,
    this.id,
    required this.dataCadastro,
    required this.dataAtualizacao,
  });
  
  CadastroPaciente copyWith({
    Paciente? paciente,
    String? id,
    DateTime? dataCadastro,
    DateTime? dataAtualizacao,
  }) {
    return CadastroPaciente(
      paciente: paciente ?? this.paciente,
      id: id ?? this.id,
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
      paciente: Paciente.fromMap(map['paciente'] as Map<String,dynamic>),
      dataCadastro: (map['dataCadastro'] as Timestamp).toDate(),
      dataAtualizacao: (map['dataAtualizacao'] as Timestamp).toDate(),
    );
  }

  String toJson() => json.encode(toMap());

  factory CadastroPaciente.fromJson(String source) => CadastroPaciente.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CadastroPaciente(paciente: $paciente, id: $id, dataCadastro: $dataCadastro, dataAtualizacao: $dataAtualizacao)';
  }

  @override
  bool operator ==(covariant CadastroPaciente other) {
    if (identical(this, other)) return true;
  
    return 
      other.paciente == paciente &&
      other.id == id &&
      other.dataCadastro == dataCadastro &&
      other.dataAtualizacao == dataAtualizacao;
  }

  @override
  int get hashCode {
    return paciente.hashCode ^
      id.hashCode ^
      dataCadastro.hashCode ^
      dataAtualizacao.hashCode;
  }
}
