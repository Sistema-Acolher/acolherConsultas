import 'dart:collection';

import 'package:acolherconsultas/modules/genogramaEcomapa/models/elementosDesenho.dart';
import 'package:acolherconsultas/modules/genogramaEcomapa/models/tipoDesenho.dart';
import 'package:flutter/material.dart';

class UndoRedoPilha {
  UndoRedoPilha({
    required this.desenhosNotifier,
    required this.desenhoAtualNotifier,
    required this.desenhoEditadoNotifier,
  }) {
    _desenhoCount = desenhosNotifier.value.elementos.length;
    desenhosNotifier.addListener(_desenhosCountListener);
  }

  final ValueNotifier<dynamic> desenhosNotifier;
  final ValueNotifier<ElementosDesenho> desenhoAtualNotifier;
  final ValueNotifier<MapEntry<ElementosDesenho, Operacoes>> desenhoEditadoNotifier;

  late final Queue<MapEntry<ElementosDesenho, Operacoes>> _undoRedoPilha = Queue();

  ValueNotifier<bool> get canRedo => _canRedo;
  final ValueNotifier<bool> _canRedo = ValueNotifier(false);

  ValueNotifier<bool> get canUndo => _canUndo;
  final ValueNotifier<bool> _canUndo = ValueNotifier(false);

  late int _desenhoCount;
  late int _operacaoAtual = -1;

  void _desenhosCountListener() {
      // print("asdkasdjas");
    if(_desenhoCount != desenhosNotifier.value.elementos.length && desenhoEditadoNotifier.value.key.id != 0) {
      // print(desenhoEditadoNotifier.value.key.id);
      _desenhoCount = desenhosNotifier.value.elementos.length;
      // remove operações que não foram feitas de _operacaoAtual em diante
      // print("opAtual: $_operacaoAtual");
      // print("Tamanho: ${_undoRedoPilha.length}");
      while(_undoRedoPilha.length > _operacaoAtual + 1) {
        // print("Removeurr");
        _undoRedoPilha.removeLast();
      }
      // print("Operação: ${desenhoEditadoNotifier.value.value}");
      _undoRedoPilha.addLast(MapEntry(desenhoEditadoNotifier.value.key, desenhoEditadoNotifier.value.value));
      _operacaoAtual++;
      _canUndo.value = true;
      _canRedo.value = false;
      // print("canRedo: ${_canRedo.value}");
      // print("canUndo: ${_canUndo.value}");
      // print("opAtual: $_operacaoAtual");
      // print("Tamanho: ${_undoRedoPilha.length}");
      desenhoEditadoNotifier.value = MapEntry(ElementosDesenho(
          id: 0,
          pontos: [],
          tipo: TipoDesenho.semDesenho,
          tamanho: 5,
        ), Operacoes.adicao);
    }
  }

  void undo() {
    desenhoEditadoNotifier.value = MapEntry(ElementosDesenho(
          id: 0,
          pontos: [],
          tipo: TipoDesenho.semDesenho,
          tamanho: 5,
        ), Operacoes.adicao);
    // print(_operacaoAtual);
    // print("Tamanho: ${_undoRedoPilha.length}");
    // _undoRedoPilha.toList().forEach((element) {
    //   print(element.key.id);
    //   print(element.value);
    // });
    var op = _undoRedoPilha.elementAt(_operacaoAtual);
    var estrutura = desenhosNotifier.value;
    // print(op.key.id);
    // print(op.value);
    switch(op.value) {
      case Operacoes.adicao:
        // print(desenhosNotifier.value.elementos.length);
        estrutura = estrutura.copyWith(
          elementos: estrutura.elementos..removeWhere((element) => element.id == op.key.id)
        );
        desenhosNotifier.value = estrutura;
        // print(desenhosNotifier.value.elementos.length);
        // print("Removeu");
        break;
      case Operacoes.edicao:
        var opEdited = desenhosNotifier.value.elementos.where((element) => element.id == op.key.id);

        // print(opEdited.first.pontos);
        // print(op.key.pontos);
        // print("Editou");

        // print(desenhosNotifier.value.elementos);
        estrutura = estrutura.copyWith(
          elementos: estrutura.elementos..removeWhere((element) => element.id == op.key.id)
        );

        estrutura = estrutura.copyWith(
          elementos: estrutura.elementos..add(op.key)
        );
        desenhosNotifier.value = estrutura;
        
        // print(desenhosNotifier.value.elementos);
        
        // print(_undoRedoPilha.toList());
        _undoRedoPilha.toList()[_operacaoAtual] = MapEntry(opEdited.first, Operacoes.edicao);
        // print(_undoRedoPilha.toList());
        break;
      case Operacoes.remocao:
        estrutura = estrutura.copyWith(
          elementos: estrutura.elementos..add(op.key)
        );
        desenhosNotifier.value = estrutura;
        break;
    }
    _operacaoAtual--;

    if(_operacaoAtual == -1) _canUndo.value = false;
    _canRedo.value = true;
  }

  void redo() {
    desenhoEditadoNotifier.value = MapEntry(ElementosDesenho(
          id: 0,
          pontos: [],
          tipo: TipoDesenho.semDesenho,
          tamanho: 5,
        ), Operacoes.adicao);
    var op = _undoRedoPilha.elementAt(++_operacaoAtual);
    var estrutura = desenhosNotifier.value;
    switch(op.value) {
      case Operacoes.adicao:
        estrutura = estrutura.copyWith(
          elementos: estrutura.elementos..add(op.key)
        );
        desenhosNotifier.value = estrutura;
        break;
      case Operacoes.edicao:
        var opEdited = desenhosNotifier.value.elementos.where((element) => element.id == op.key.id);

        estrutura = estrutura.copyWith(
          elementos: estrutura.elementos..removeWhere((element) => element.id == op.key.id)
        );

        estrutura = estrutura.copyWith(
          elementos: estrutura.elementos..add(op.key)
        );

        desenhosNotifier.value = estrutura;

        _undoRedoPilha.toList()[_operacaoAtual] = MapEntry(opEdited.first, Operacoes.edicao);
        break;
      case Operacoes.remocao:
        estrutura = estrutura.copyWith(
          elementos: estrutura.elementos..removeWhere((element) => element.id == op.key.id)
        );
        desenhosNotifier.value = estrutura;
        break;
    }
    if(_operacaoAtual > -1) _canUndo.value = true;

    if(_operacaoAtual + 1 < _undoRedoPilha.length) {
     _canRedo.value = true;
    } else {
      _canRedo.value = false;
    }
  }

  void dispose() {
    desenhosNotifier.removeListener(_desenhosCountListener);
  }
}

enum Operacoes {
  adicao,
  edicao,
  remocao
}