// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:math';

import 'package:acolherconsultas/modules/genogramaEcomapa/models/elementosDesenho.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Genograma {
  final List<ElementosDesenho> elementos;
  final String? id;
  final double height;
  final double width;
  final double scale;
  final Map<String, dynamic> pacienteRaiz;
  DateTime dataCriacao;

  Genograma({
    required this.elementos,
    this.id,
    required this.height,
    required this.width,
    required this.scale,
    required this.pacienteRaiz,
    required this.dataCriacao,
  });

  Genograma addDesenho(ElementosDesenho desenho) {
    return copyWith(
      elementos: [...elementos, desenho],
    );
  }

  List<ElementosDesenho> removeDesenho(Offset offset) {
    final newElementos = [];
    newElementos.addAll(elementos);
    double menorDistancia = 0;
    ElementosDesenho? desenhoMaisProximo;
    for (ElementosDesenho desenho in newElementos) {
      if(desenho.pontos.length == 1){
        for (Offset ponto in desenho.pontos) {
          double distancia = (ponto - offset).distance;
          if (distancia <= desenho.tamanho && (distancia < menorDistancia || menorDistancia == 0)) {
            menorDistancia = distancia;
            desenhoMaisProximo = desenho;
          }
        }
      } else if(desenho.pontos.length == 2){
        //considerar todos os pontos entre os dois pontos
        final ponto1 = desenho.pontos[0];
        final ponto2 = desenho.pontos[1];
        final distancia = (ponto1 - ponto2).distance;
        final angulo = atan2(ponto2.dy - ponto1.dy, ponto2.dx - ponto1.dx);
        for (double i = 0; i <= distancia; i++) {
          final ponto = Offset(ponto1.dx + i * cos(angulo), ponto1.dy + i * sin(angulo));
          double distancia = (ponto - offset).distance;
          if (distancia <= desenho.tamanho && (distancia < menorDistancia || menorDistancia == 0)) {
            menorDistancia = distancia;
            desenhoMaisProximo = desenho;
          }
        }
      } else {
        // considerar todos os pontos do elemento desenhado pela caneta
        for (int i = 0; i < desenho.pontos.length - 1; i++) {
          final ponto1 = desenho.pontos[i];
          final ponto2 = desenho.pontos[i + 1];
          final distancia = (ponto1 - ponto2).distance;
          final angulo = atan2(ponto2.dy - ponto1.dy, ponto2.dx - ponto1.dx);
          for (double i = 0; i <= distancia; i++) {
            final ponto = Offset(ponto1.dx + i * cos(angulo), ponto1.dy + i * sin(angulo));
            double distancia = (ponto - offset).distance;
            if (distancia <= desenho.tamanho && (distancia < menorDistancia || menorDistancia == 0)) {
              menorDistancia = distancia;
              desenhoMaisProximo = desenho;
            }
          }
        }
      }
    }
    if (desenhoMaisProximo != null) {
      newElementos.remove(desenhoMaisProximo);
    }
    return List.from(newElementos);
  }

  ElementosDesenho? editDesenho(Offset offset) {
    double menorDistancia = 0;
    ElementosDesenho? desenhoMaisProximo;
    for (ElementosDesenho desenho in elementos) {
      if(desenho.pontos.length == 1){
        for (Offset ponto in desenho.pontos) {
          double distancia = (ponto - offset).distance;
          if (distancia <= 80 && (distancia < menorDistancia || menorDistancia == 0)) {
            menorDistancia = distancia;
            desenhoMaisProximo = desenho;
          }
        }
      } else if(desenho.pontos.length == 2){
        //considerar todos os pontos entre os dois pontos
        final ponto1 = desenho.pontos[0];
        final ponto2 = desenho.pontos[1];
        final distancia = (ponto1 - ponto2).distance;
        final angulo = atan2(ponto2.dy - ponto1.dy, ponto2.dx - ponto1.dx);
        for (double i = 0; i <= distancia; i++) {
          final ponto = Offset(ponto1.dx + i * cos(angulo), ponto1.dy + i * sin(angulo));
          double distancia = (ponto - offset).distance;
          if (distancia <= desenho.tamanho && (distancia < menorDistancia || menorDistancia == 0)) {
            menorDistancia = distancia;
            desenhoMaisProximo = desenho;
          }
        }
      } else {
        // considerar todos os pontos do elemento desenhado pela caneta
        for (int i = 0; i < desenho.pontos.length - 1; i++) {
          final ponto1 = desenho.pontos[i];
          final ponto2 = desenho.pontos[i + 1];
          final distancia = (ponto1 - ponto2).distance;
          final angulo = atan2(ponto2.dy - ponto1.dy, ponto2.dx - ponto1.dx);
          for (double i = 0; i <= distancia; i++) {
            final ponto = Offset(ponto1.dx + i * cos(angulo), ponto1.dy + i * sin(angulo));
            double distancia = (ponto - offset).distance;
            if (distancia <= desenho.tamanho && (distancia < menorDistancia || menorDistancia == 0)) {
              menorDistancia = distancia;
              desenhoMaisProximo = desenho;
            }
          }
        }
      }
    }
    return desenhoMaisProximo;
  }

  Genograma copyWith({
    List<ElementosDesenho>? elementos,
    String? id,
    double? height,
    double? width,
    double? scale,
    Map<String, dynamic>? pacienteRaiz,
    DateTime? dataCriacao,
  }) {
    return Genograma(
      elementos: elementos ?? this.elementos,
      id: id ?? this.id,
      height: height ?? this.height,
      width: width ?? this.width,
      scale: scale ?? this.scale,
      pacienteRaiz: pacienteRaiz ?? this.pacienteRaiz,
      dataCriacao: dataCriacao ?? this.dataCriacao,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'elementos': elementos.map((x) => x.toMap()).toList(),
      'id': id,
      'height': height,
      'width': width,
      'scale': scale,
      'pacienteRaiz': pacienteRaiz,
      'dataCriacao': dataCriacao,
    };
  }

  factory Genograma.fromMap(Map<String, dynamic> map) {
    return Genograma(
      elementos: List<ElementosDesenho>.from((map['elementos']).map<ElementosDesenho>((x) => ElementosDesenho.fromMap(x as Map<String,dynamic>),),),
      id: map['id'] as String,
      height: map['height'] as double,
      width: map['width'] as double,
      scale: map['scale'] as double,
      pacienteRaiz: map['pacienteRaiz'] as Map<String, dynamic>,
      dataCriacao: (map['dataCriacao'] as Timestamp).toDate(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Genograma.fromJson(String source) => Genograma.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Genograma(elementos: $elementos, id: $id, height: $height, width: $width, scale: $scale, pacienteRaiz: $pacienteRaiz, dataCriacao: $dataCriacao)';
  }

  @override
  bool operator ==(covariant Genograma other) {
    if (identical(this, other)) return true;
  
    return 
      listEquals(other.elementos, elementos) &&
      other.id == id &&
      other.height == height &&
      other.width == width &&
      other.scale == scale &&
      other.pacienteRaiz == pacienteRaiz &&
      other.dataCriacao == dataCriacao;
  }

  @override
  int get hashCode {
    return elementos.hashCode ^
      id.hashCode ^
      height.hashCode ^
      width.hashCode ^
      scale.hashCode ^
      pacienteRaiz.hashCode ^
      dataCriacao.hashCode;
  }
}
