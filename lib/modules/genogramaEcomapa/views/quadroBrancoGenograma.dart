import 'dart:ffi';

import 'package:acolherconsultas/modules/genogramaEcomapa/models/elementosDesenho.dart';
import 'package:acolherconsultas/modules/genogramaEcomapa/models/genograma.dart';
import 'package:acolherconsultas/modules/genogramaEcomapa/models/tipoDesenho.dart';
import 'package:acolherconsultas/modules/genogramaEcomapa/views/quadroBrancoGenogramaPainter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class QuadroBrancoGenograma extends HookWidget {
  final ValueNotifier<Genograma> genograma;
  final ValueNotifier<ElementosDesenho> desenhoAtual;
  final ValueNotifier<bool> desenhoAtivo;
  final ValueNotifier<bool> borrachaAtiva;
  final ValueNotifier<TipoDesenho> tipoDesenho;
  final ValueNotifier<List<Offset>> pontosDeConexao;
  final ValueNotifier<Offset> ultimoPontoConexao;
  final GlobalKey canvasGlobalKey;

  const QuadroBrancoGenograma({
    super.key,
    required this.genograma,
    required this.desenhoAtual,
    required this.canvasGlobalKey,
    required this.desenhoAtivo,
    required this.tipoDesenho,
    required this.borrachaAtiva,
    required this.pontosDeConexao,
    required this.ultimoPontoConexao,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        buildAllSketches(context),
        buildCurrentPath(context),
      ],
    );
  }

  void onPointerDown(PointerDownEvent details, BuildContext context) {
    final box = context.findRenderObject() as RenderBox;
    final offset = box.globalToLocal(details.position);
    
    if(desenhoAtivo.value){
      borrachaAtiva.value = false;

      if(tipoDesenho.value == TipoDesenho.linhaHorizontal || tipoDesenho.value == TipoDesenho.linhaVertical || tipoDesenho.value == TipoDesenho.linhaSeparacao){
        //linhas só serão desenhadas a partir de um ponto de conexao ja existente
        //selecionar o ponto de conexao mais proximo
        double distanciaPontoDeConexao = double.infinity;
        Offset pontoDeConexaoMaisProximo = Offset.zero;
        for (Offset pontoDeConexao in pontosDeConexao.value) {
          double distancia = (pontoDeConexao - offset).distance;
          if (distancia <= 4*desenhoAtual.value.tamanho && distancia < distanciaPontoDeConexao) {
            distanciaPontoDeConexao = distancia;
            pontoDeConexaoMaisProximo = pontoDeConexao;
          }
        }
        if(pontoDeConexaoMaisProximo != Offset.zero){
          desenhoAtual.value = ElementosDesenho(
            id: genograma.value.elementos.length + 1,
            pontos: [pontoDeConexaoMaisProximo],
            tipo: tipoDesenho.value,
            tamanho: 5,
          );
        }
      } else {
        desenhoAtual.value = ElementosDesenho(
          id: genograma.value.elementos.length + 1,
          pontos: [offset],
          tipo: tipoDesenho.value,
          tamanho: tipoDesenho.value == TipoDesenho.texto ? 5 : 20,
          texto: tipoDesenho.value == TipoDesenho.texto ? 'Texto' : null,
        );
        desenhoAtivo.value = true;
      }
    }
  }

  void onPointerMove(PointerMoveEvent details, BuildContext context) {
    final box = context.findRenderObject() as RenderBox;
    final offset = box.globalToLocal(details.position);
    //calcular distancia para o ponto de conexao mais proximo
    double distanciaPontoDeConexao = double.infinity;
    Offset pontoDeConexaoMaisProximo = Offset.zero;
    Offset pontoDeConexaoMaisProximoDesenho = Offset.zero;
    final List listaPontos = List.from(genograma.value.elementos.map((e) => e.pontos)).expand((e) => e).toList();
    if(ultimoPontoConexao.value == Offset.zero){
      for (Offset pontoDeConexao in pontosDeConexao.value) {
        int i = 0;
        for (Offset ponto in desenhoAtual.value.pontosConexao) {
          double distancia = (ponto - pontoDeConexao).distance;
          double distanciaOffset = (offset - pontoDeConexao).distance;
          if (!listaPontos.contains(offset) && distanciaOffset < 4*desenhoAtual.value.tamanho && distancia <= 2*desenhoAtual.value.tamanho && distancia > 0 && (distancia < distanciaPontoDeConexao || distanciaPontoDeConexao == double.infinity)) {
            distanciaPontoDeConexao = distancia;
            pontoDeConexaoMaisProximo = ponto;
            pontoDeConexaoMaisProximoDesenho = 
                i == 0 ? 
                  pontoDeConexao - Offset(0, desenhoAtual.value.tamanho) :
                i == 1 ?
                  pontoDeConexao - Offset(desenhoAtual.value.tamanho, 0) :
                i == 2 ?
                  pontoDeConexao + Offset(0, desenhoAtual.value.tamanho) :
                i == 3 ?
                  pontoDeConexao + Offset(desenhoAtual.value.tamanho, 0) :
                offset;
          }
          i++;
        }
      }
    }

    if(desenhoAtivo.value){
      borrachaAtiva.value = false;
      if((tipoDesenho.value == TipoDesenho.linhaHorizontal || tipoDesenho.value == TipoDesenho.linhaVertical || tipoDesenho.value == TipoDesenho.linhaSeparacao) && desenhoAtual.value.pontos.isNotEmpty){
        if(tipoDesenho.value == TipoDesenho.linhaHorizontal){
          desenhoAtual.value = ElementosDesenho(
            id: genograma.value.elementos.length + 1,
            pontos: [desenhoAtual.value.pontos[0], Offset(offset.dx, desenhoAtual.value.pontos[0].dy)],
            tipo: tipoDesenho.value,
            tamanho: 5,
          );
        } else if(tipoDesenho.value == TipoDesenho.linhaVertical){
          desenhoAtual.value = ElementosDesenho(
            id: genograma.value.elementos.length + 1,
            pontos: [desenhoAtual.value.pontos[0], Offset(desenhoAtual.value.pontos[0].dx, offset.dy)],
            tipo: tipoDesenho.value,
            tamanho: 5,
          );
        }
      } else if(!listaPontos.contains(pontoDeConexaoMaisProximoDesenho) && !listaPontos.contains(pontoDeConexaoMaisProximoDesenho)) {
        if(desenhoAtual.value.pontos != [pontoDeConexaoMaisProximoDesenho] && distanciaPontoDeConexao < 4* desenhoAtual.value.tamanho && pontoDeConexaoMaisProximo != Offset.zero){
          ultimoPontoConexao.value = pontoDeConexaoMaisProximo;
          desenhoAtual.value = ElementosDesenho(
            id: genograma.value.elementos.length + 1,
            pontos: [pontoDeConexaoMaisProximoDesenho],
            tipo: tipoDesenho.value,
            tamanho: tipoDesenho.value == TipoDesenho.texto ? 5 : 20,
            texto: tipoDesenho.value == TipoDesenho.texto ? 'Texto' : null,
          );
        } else if((offset - ultimoPontoConexao.value).distance > 2* desenhoAtual.value.tamanho){
          ultimoPontoConexao.value = Offset.zero;
          desenhoAtual.value = ElementosDesenho(
            id: genograma.value.elementos.length + 1,
            pontos: [offset],
            tipo: tipoDesenho.value,
            tamanho: tipoDesenho.value == TipoDesenho.texto ? 5 : 20,
            texto: tipoDesenho.value == TipoDesenho.texto ? 'Texto' : null,
          );
        }
      }
    }
  }

  void onPointerUp(PointerUpEvent details, BuildContext context) {
    final box = context.findRenderObject() as RenderBox;
    final offset = box.globalToLocal(details.position);

    if(desenhoAtivo.value){
      borrachaAtiva.value = false;
      genograma.value = genograma.value.addDesenho(desenhoAtual.value);
      pontosDeConexao.value = List.from(pontosDeConexao.value)..addAll(desenhoAtual.value.pontosConexao);
      desenhoAtual.value = 
      ElementosDesenho(
        id: 0,
        pontos: [],
        tipo: tipoDesenho.value,
        tamanho: 5,
      );
      desenhoAtivo.value = false;
    } else if(borrachaAtiva.value){
      final newGenograma = genograma.value.copyWith(
        elementos: genograma.value.removeDesenho(offset)
      ); 
      genograma.value = newGenograma;
    }
  }

  Widget buildAllSketches(BuildContext context) {
    return ValueListenableBuilder<Genograma>(
      valueListenable: genograma,
      builder: (context, genograma, _) {
        return RepaintBoundary(
          key: canvasGlobalKey,
          child: SizedBox(
            width: 4000,
            height: 2000,
            child: CustomPaint(
              painter: QuadroBrancoGenogramaPainter(
                genograma: genograma.elementos,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildCurrentPath(BuildContext context) {
    return Listener(
      onPointerDown: (details) => onPointerDown(details, context),
      onPointerMove: (details) => onPointerMove(details, context),
      onPointerUp: (details) => onPointerUp(details, context),
      child: ValueListenableBuilder(
        valueListenable: desenhoAtual,
        builder: (context, desenho, child) {
          return RepaintBoundary(
            child: SizedBox(
              width: 4000,
              height: 2000,
              child: CustomPaint(
                painter: QuadroBrancoGenogramaPainter(
                  genograma: desenho.pontos.isEmpty ? [] : [desenho],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}