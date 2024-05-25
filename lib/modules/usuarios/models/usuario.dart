// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

enum NivelAcesso { admin, acolher, casaDeApoio }

class Usuario {
  String? id;
  String nome;
  String email;
  NivelAcesso nivelAcesso;
  String? casaDeApoioId;

  Usuario({
    this.id,
    required this.nome,
    required this.email,
    required this.nivelAcesso,
    this.casaDeApoioId,
  });

  Usuario copyWith({
    String? id,
    String? nome,
    String? email,
    NivelAcesso? nivelAcesso,
    String? casaDeApoioId,
  }) {
    return Usuario(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      nivelAcesso: nivelAcesso ?? this.nivelAcesso,
      casaDeApoioId: casaDeApoioId ?? this.casaDeApoioId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
      'email': email,
      'nivelAcesso': nivelAcesso.name,
      'casaDeApoioId': casaDeApoioId,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'] != null ? map['id'] as String : null,
      nome: map['nome'] as String,
      email: map['email'] as String,
      nivelAcesso: NivelAcesso.values.firstWhere((element) => element.name == map['nivelAcesso'] as String),
      casaDeApoioId: map['casaDeApoioId'] != null ? map['casaDeApoioId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Usuario.fromJson(String source) => Usuario.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Usuario(id: $id, nome: $nome, email: $email, nivelAcesso: $nivelAcesso, casaDeApoioId: $casaDeApoioId)';
  }

  @override
  bool operator ==(covariant Usuario other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.nome == nome &&
      other.email == email &&
      other.nivelAcesso == nivelAcesso &&
      other.casaDeApoioId == casaDeApoioId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      nome.hashCode ^
      email.hashCode ^
      nivelAcesso.hashCode ^
      casaDeApoioId.hashCode;
  }
}
