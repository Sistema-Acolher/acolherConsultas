// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CasaDeApoio {
  String nome;
  String cep;
  String rua;
  String numero;
  String bairro;
  String cidade;
  int cor;
  CasaDeApoio({
    required this.nome,
    required this.cep,
    required this.rua,
    required this.numero,
    required this.bairro,
    required this.cidade,
    required this.cor,
  });

  CasaDeApoio copyWith({
    String? nome,
    String? cep,
    String? rua,
    String? numero,
    String? bairro,
    String? cidade,
    int? cor,
  }) {
    return CasaDeApoio(
      nome: nome ?? this.nome,
      cep: cep ?? this.cep,
      rua: rua ?? this.rua,
      numero: numero ?? this.numero,
      bairro: bairro ?? this.bairro,
      cidade: cidade ?? this.cidade,
      cor: cor ?? this.cor,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nome': nome,
      'cep': cep,
      'rua': rua,
      'numero': numero,
      'bairro': bairro,
      'cidade': cidade,
      'cor': cor,
    };
  }

  factory CasaDeApoio.fromMap(Map<String, dynamic> map) {
    return CasaDeApoio(
      nome: map['nome'] as String,
      cep: map['cep'] as String,
      rua: map['rua'] as String,
      numero: map['numero'] as String,
      bairro: map['bairro'] as String,
      cidade: map['cidade'] as String,
      cor: map['cor'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory CasaDeApoio.fromJson(String source) => CasaDeApoio.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CasaDeApoio(nome: $nome, cep: $cep, rua: $rua, numero: $numero, bairro: $bairro, cidade: $cidade, cor: $cor)';
  }

  @override
  bool operator ==(covariant CasaDeApoio other) {
    if (identical(this, other)) return true;
  
    return 
      other.nome == nome &&
      other.cep == cep &&
      other.rua == rua &&
      other.numero == numero &&
      other.bairro == bairro &&
      other.cidade == cidade &&
      other.cor == cor;
  }

  @override
  int get hashCode {
    return nome.hashCode ^
      cep.hashCode ^
      rua.hashCode ^
      numero.hashCode ^
      bairro.hashCode ^
      cidade.hashCode ^
      cor.hashCode;
  }
}
