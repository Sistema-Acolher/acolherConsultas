// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:acolherconsultas/modules/genogramaEcomapa/models/tipoDesenho.dart';
import 'package:flutter/material.dart';

class ElementosDesenho {
  final int id;
  final List<Offset> pontos;
  final Color cor;
  final double tamanho;
  final TipoDesenho tipo;
  final String? texto;
  final String? ligacao;
  final String? energiaGastaPaciente;
  final String? energiaGastaParte;
  List<Offset> pontosConexao;
  final bool isPaciente;

  
  ElementosDesenho({
    required this.id,
    required this.pontos,
    this.cor = Colors.black,
    required this.tipo,
    required this.tamanho,
    this.texto = "?,?",
    this.pontosConexao = const [],
    this.ligacao,
    this.energiaGastaPaciente,
    this.energiaGastaParte,
    this.isPaciente = false,
  }){
    if(tipo == TipoDesenho.linha){
      if(pontos.length == 2) {
        pontosConexao = [pontos[0], pontos[1]];
      }
    } else if(tipo == TipoDesenho.linhaSeparacao){
      pontosConexao = pontos;
    } else if(tipo == TipoDesenho.caneta){
      pontosConexao = [];
    } else if(pontos.length == 1) {
      final pontoSuperior = Offset(pontos[0].dx, pontos[0].dy + tamanho);
      final pontoInferior = Offset(pontos[0].dx, pontos[0].dy - tamanho);
      final pontoDireita = Offset(pontos[0].dx + tamanho, pontos[0].dy);
      final pontoEsquerda = Offset(pontos[0].dx - tamanho, pontos[0].dy);
      pontosConexao = [pontoSuperior, pontoDireita, pontoInferior, pontoEsquerda];
    }
  }

  Map<String, dynamic> toMap() {
    List<Map> pontosMap = pontos.map((e) => {'dx': e.dx, 'dy': e.dy}).toList();
    List<Map> pontosConexaoMap = pontosConexao.map((e) => {'dx': e.dx, 'dy': e.dy}).toList();
    return <String, dynamic>{
      'id': id,
      'pontos': pontosMap,
      'cor': cor.value,
      'tamanho': tamanho,
      'tipo': tipo.toString(),
      'texto': texto ?? '?,?',
      'pontosConexao': pontosConexaoMap,
      'ligacao': ligacao ?? "",
      'energiaGastaPaciente': energiaGastaPaciente ?? "",
      'energiaGastaParte': energiaGastaParte ?? "",
      'isPaciente': isPaciente,
    };
  }

  factory ElementosDesenho.fromMap(Map<String, dynamic> map) {
    // print("PONTOSOSOSOS: " + map['pontos'][0].toString());
    List<Offset> pontos = 
      (map['pontos'] as List).map((e) => Offset(e['dx'].toDouble(), e['dy'].toDouble())).toList();
    List<Offset> pontosConexao =
      (map['pontosConexao'] as List).map((e) => Offset(e['dx'].toDouble(), e['dy'].toDouble())).toList();
    return ElementosDesenho(
      id: map['id'],
      pontos: pontos,
      cor: Color(map['cor']),
      tamanho: map['tamanho'].toDouble(),
      tipo: TipoDesenho.values.firstWhere((element) => element.toString() == map['tipo']),
      texto: map['texto'],
      pontosConexao: pontosConexao,
      ligacao: map['ligacao'] ?? "",
      energiaGastaPaciente: map['energiaGastaPaciente'],
      energiaGastaParte: map['energiaGastaParte'],
      isPaciente: map['isPaciente'],
    );
  }

  String toJson() {
    List<Map> pontosMap = pontos.map((e) => {'dx': e.dx, 'dy': e.dy}).toList();
    List<Map> pontosConexaoMap = pontosConexao.map((e) => {'dx': e.dx, 'dy': e.dy}).toList();
    return json.encode({
      'id': id,
      'pontos': pontosMap,
      'cor': cor.value,
      'tamanho': tamanho,
      'tipo': tipo.toString(),
      'texto': texto ?? '?,?',
      'pontosConexao': pontosConexaoMap,
      'ligacao': ligacao ?? "",
      'energiaGastaPaciente': energiaGastaPaciente ?? "",
      'energiaGastaParte': energiaGastaParte ?? "",
      'isPaciente': isPaciente,
    });
  }

  factory ElementosDesenho.fromJson(Map<String, dynamic> json) {
    List<Offset> pontos = 
      (json['pontos'] as List).map((e) => Offset(e['dx'], e['dy'])).toList();
    List<Offset> pontosConexao =
      (json['pontosConexao'] as List).map((e) => Offset(e['dx'], e['dy'])).toList();
    return ElementosDesenho(
      id: json['id'],
      pontos: pontos,
      cor: Color(json['cor']),
      tamanho: json['tamanho'],
      tipo: TipoDesenho.values.firstWhere((element) => element.toString() == json['tipo']),
      texto: json['texto'],
      pontosConexao: pontosConexao,
      ligacao: json['ligacao'] ?? "",
      energiaGastaPaciente: json['energiaGastaPaciente'],
      energiaGastaParte: json['energiaGastaParte'],
      isPaciente: json['isPaciente'],
    );
  }

  // make copyWith method
  ElementosDesenho copyWith({
    int? id,
    List<Offset>? pontos,
    Color? cor,
    double? tamanho,
    TipoDesenho? tipo,
    String? texto,
    List<Offset>? pontosConexao,
    String? ligacao,
    String? energiaGastaPaciente,
    String? energiaGastaParte,
    bool? isPaciente,
  }) {
    return ElementosDesenho(
      id: id ?? this.id,
      pontos: pontos ?? this.pontos,
      cor: cor ?? this.cor,
      tamanho: tamanho ?? this.tamanho,
      tipo: tipo ?? this.tipo,
      texto: texto ?? this.texto,
      pontosConexao: pontosConexao ?? this.pontosConexao,
      ligacao: ligacao ?? this.ligacao,
      energiaGastaPaciente: energiaGastaPaciente ?? this.energiaGastaPaciente,
      energiaGastaParte: energiaGastaParte ?? this.energiaGastaParte,
      isPaciente: isPaciente ?? this.isPaciente,
    );
  }

}
