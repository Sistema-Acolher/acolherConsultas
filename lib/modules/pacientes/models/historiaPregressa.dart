// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class HistoriaPregressa {
  String pesoNasc;
  String estatura;
  String pc;
  String pt;
  String testeApgar;
  String ictericia;
  String testeOrelhinha;
  String testePezinho;
  String rn;
  String idadeGestacional;
  String intercorrencia;
  HistoriaPregressa({
    required this.pesoNasc,
    required this.estatura,
    required this.pc,
    required this.pt,
    required this.testeApgar,
    required this.ictericia,
    required this.testeOrelhinha,
    required this.testePezinho,
    required this.rn,
    required this.idadeGestacional,
    required this.intercorrencia,
  });

  HistoriaPregressa copyWith({
    String? pesoNasc,
    String? estatura,
    String? pc,
    String? pt,
    String? testeApgar,
    String? ictericia,
    String? testeOrelhinha,
    String? testePezinho,
    String? rn,
    String? idadeGestacional,
    String? intercorrencia,
  }) {
    return HistoriaPregressa(
      pesoNasc: pesoNasc ?? this.pesoNasc,
      estatura: estatura ?? this.estatura,
      pc: pc ?? this.pc,
      pt: pt ?? this.pt,
      testeApgar: testeApgar ?? this.testeApgar,
      ictericia: ictericia ?? this.ictericia,
      testeOrelhinha: testeOrelhinha ?? this.testeOrelhinha,
      testePezinho: testePezinho ?? this.testePezinho,
      rn: rn ?? this.rn,
      idadeGestacional: idadeGestacional ?? this.idadeGestacional,
      intercorrencia: intercorrencia ?? this.intercorrencia,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pesoNasc': pesoNasc,
      'estatura': estatura,
      'pc': pc,
      'pt': pt,
      'testeApgar': testeApgar,
      'ictericia': ictericia,
      'testeOrelhinha': testeOrelhinha,
      'testePezinho': testePezinho,
      'rn': rn,
      'idadeGestacional': idadeGestacional,
      'intercorrencia': intercorrencia,
    };
  }

  factory HistoriaPregressa.fromMap(Map<String, dynamic> map) {
    return HistoriaPregressa(
      pesoNasc: map['pesoNasc'] as String,
      estatura: map['estatura'] as String,
      pc: map['pc'] as String,
      pt: map['pt'] as String,
      testeApgar: map['testeApgar'] as String,
      ictericia: map['ictericia'] as String,
      testeOrelhinha: map['testeOrelhinha'] as String,
      testePezinho: map['testePezinho'] as String,
      rn: map['rn'] as String,
      idadeGestacional: map['idadeGestacional'] as String,
      intercorrencia: map['intercorrencia'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory HistoriaPregressa.fromJson(String source) => HistoriaPregressa.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'HistoriaPregressa(pesoNasc: $pesoNasc, estatura: $estatura, pc: $pc, pt: $pt, testeApgar: $testeApgar, ictericia: $ictericia, testeOrelhinha: $testeOrelhinha, testePezinho: $testePezinho, rn: $rn, idadeGestacional: $idadeGestacional, intercorrencia: $intercorrencia)';
  }

  @override
  bool operator ==(covariant HistoriaPregressa other) {
    if (identical(this, other)) return true;
  
    return 
      other.pesoNasc == pesoNasc &&
      other.estatura == estatura &&
      other.pc == pc &&
      other.pt == pt &&
      other.testeApgar == testeApgar &&
      other.ictericia == ictericia &&
      other.testeOrelhinha == testeOrelhinha &&
      other.testePezinho == testePezinho &&
      other.rn == rn &&
      other.idadeGestacional == idadeGestacional &&
      other.intercorrencia == intercorrencia;
  }

  @override
  int get hashCode {
    return pesoNasc.hashCode ^
      estatura.hashCode ^
      pc.hashCode ^
      pt.hashCode ^
      testeApgar.hashCode ^
      ictericia.hashCode ^
      testeOrelhinha.hashCode ^
      testePezinho.hashCode ^
      rn.hashCode ^
      idadeGestacional.hashCode ^
      intercorrencia.hashCode;
  }
}
