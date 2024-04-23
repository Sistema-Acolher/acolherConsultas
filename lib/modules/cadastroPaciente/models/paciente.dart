import 'dart:convert';

class Paciente {
  String nome;
  String genero;
  String numeroCartaoSus;
  String rg;
  String cpf;
  String dataNascimento;

  Paciente({
    required this.nome,
    required this.genero,
    required this.numeroCartaoSus,
    required this.rg,
    required this.cpf,
    required this.dataNascimento,
  });

  Paciente copyWith({
    String? nome,
    String? genero,
    String? numeroCartaoSus,
    String? rg,
    String? cpf,
    String? dataNascimento,
  }) {
    return Paciente(
      nome: nome ?? this.nome,
      genero: genero ?? this.genero,
      numeroCartaoSus: numeroCartaoSus ?? this.numeroCartaoSus,
      rg: rg ?? this.rg,
      cpf: cpf ?? this.cpf,
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
      dataNascimento: map['dataNascimento'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Paciente.fromJson(String source) => Paciente.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Paciente(nome: $nome, genero: $genero, numeroCartaoSus: $numeroCartaoSus, rg: $rg, cpf: $cpf, dataNascimento: $dataNascimento)';
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
      other.dataNascimento == dataNascimento;
  }

  @override
  int get hashCode {
    return nome.hashCode ^
      genero.hashCode ^
      numeroCartaoSus.hashCode ^
      rg.hashCode ^
      cpf.hashCode ^
      dataNascimento.hashCode;
  }
}
