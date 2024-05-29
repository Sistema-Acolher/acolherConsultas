// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Consulta {
  String? id;
  String casaDeApoioId;
  String? pacienteNome;
  String pacienteId;
  DateTime dataHorario;
  String estado;
  Consulta({
    this.id,
    required this.casaDeApoioId,
    this.pacienteNome,
    required this.pacienteId,
    required this.dataHorario,
    required this.estado,
  });

  Consulta copyWith({
    String? id,
    String? casaDeApoioId,
    String? pacienteNome,
    String? pacienteId,
    DateTime? dataHorario,
    String? estado,
  }) {
    return Consulta(
      id: id ?? this.id,
      casaDeApoioId: casaDeApoioId ?? this.casaDeApoioId,
      pacienteNome: pacienteNome ?? this.pacienteNome,
      pacienteId: pacienteId ?? this.pacienteId,
      dataHorario: dataHorario ?? this.dataHorario,
      estado: estado ?? this.estado,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'casaDeApoioId': casaDeApoioId,
      'pacienteId': pacienteId,
      'dataHorario': dataHorario,
      'estado': estado,
    };
  }

  factory Consulta.fromMap(Map<String, dynamic> map) {
    return Consulta(
      id: map['id'] != null ? map['id'] as String : null,
      casaDeApoioId: map['casaDeApoioId'] as String,
      pacienteNome: map['pacienteNome'] != null ? map['pacienteNome'] as String : null,
      pacienteId: map['pacienteId'] as String,
      dataHorario: (map['dataHorario'] as Timestamp).toDate(),
      estado: map['estado'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Consulta.fromJson(String source) => Consulta.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Consulta(id: $id, casaDeApoioId: $casaDeApoioId, pacienteNome: $pacienteNome, pacienteId: $pacienteId, dataHorario: $dataHorario, estado: $estado)';
  }

  @override
  bool operator ==(covariant Consulta other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.casaDeApoioId == casaDeApoioId &&
      other.pacienteNome == pacienteNome &&
      other.pacienteId == pacienteId &&
      other.dataHorario == dataHorario &&
      other.estado == estado;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      casaDeApoioId.hashCode ^
      pacienteNome.hashCode ^
      pacienteId.hashCode ^
      dataHorario.hashCode ^
      estado.hashCode;
  }
}

