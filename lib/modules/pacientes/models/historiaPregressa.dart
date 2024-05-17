// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class HistoriaPregressa {
  double pesoNasc;
  double estatura;
  String pc;
  String pt;
  String apgar;
  bool icteria;
  String orelhinha;
  String pezinho;
  String rn;
  String idadeGestacional;
  String intercorrencia;
  HistoriaPregressa({
    required this.pesoNasc,
    required this.estatura,
    required this.pc,
    required this.pt,
    required this.apgar,
    required this.icteria,
    required this.orelhinha,
    required this.pezinho,
    required this.rn,
    required this.idadeGestacional,
    required this.intercorrencia,
  });

  HistoriaPregressa copyWith({
    double? pesoNasc,
    double? estatura,
    String? pc,
    String? pt,
    String? apgar,
    bool? icteria,
    String? orelhinha,
    String? pezinho,
    String? rn,
    String? idadeGestacional,
    String? intercorrencia,
  }) {
    return HistoriaPregressa(
      pesoNasc: pesoNasc ?? this.pesoNasc,
      estatura: estatura ?? this.estatura,
      pc: pc ?? this.pc,
      pt: pt ?? this.pt,
      apgar: apgar ?? this.apgar,
      icteria: icteria ?? this.icteria,
      orelhinha: orelhinha ?? this.orelhinha,
      pezinho: pezinho ?? this.pezinho,
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
      'apgar': apgar,
      'icteria': icteria,
      'orelhinha': orelhinha,
      'pezinho': pezinho,
      'rn': rn,
      'idadeGestacional': idadeGestacional,
      'intercorrencia': intercorrencia,
    };
  }

  factory HistoriaPregressa.fromMap(Map<String, dynamic> map) {
    return HistoriaPregressa(
      pesoNasc: map['pesoNasc'] as double,
      estatura: map['estatura'] as double,
      pc: map['pc'] as String,
      pt: map['pt'] as String,
      apgar: map['apgar'] as String,
      icteria: map['icteria'] as bool,
      orelhinha: map['orelhinha'] as String,
      pezinho: map['pezinho'] as String,
      rn: map['rn'] as String,
      idadeGestacional: map['idadeGestacional'] as String,
      intercorrencia: map['intercorrencia'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory HistoriaPregressa.fromJson(String source) => HistoriaPregressa.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'HistoriaPregressa(pesoNasc: $pesoNasc, estatura: $estatura, pc: $pc, pt: $pt, apgar: $apgar, icteria: $icteria, orelhinha: $orelhinha, pezinho: $pezinho, rn: $rn, idadeGestacional: $idadeGestacional, intercorrencia: $intercorrencia)';
  }

  @override
  bool operator ==(covariant HistoriaPregressa other) {
    if (identical(this, other)) return true;
  
    return 
      other.pesoNasc == pesoNasc &&
      other.estatura == estatura &&
      other.pc == pc &&
      other.pt == pt &&
      other.apgar == apgar &&
      other.icteria == icteria &&
      other.orelhinha == orelhinha &&
      other.pezinho == pezinho &&
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
      apgar.hashCode ^
      icteria.hashCode ^
      orelhinha.hashCode ^
      pezinho.hashCode ^
      rn.hashCode ^
      idadeGestacional.hashCode ^
      intercorrencia.hashCode;
  }
}
