import 'package:acolherconsultas/modules/genogramaEcomapa/models/elementosDesenho.dart';
import 'package:acolherconsultas/modules/genogramaEcomapa/models/genograma.dart';
import 'package:acolherconsultas/modules/genogramaEcomapa/models/tipoDesenho.dart';
import 'package:acolherconsultas/modules/genogramaEcomapa/views/quadroBrancoGenogramaPainter.dart';
import 'package:acolherconsultas/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class QuadroBrancoGenograma extends HookWidget {
  final ValueNotifier<Genograma> genograma;
  final ValueNotifier<ElementosDesenho> desenhoAtual;
  final ValueNotifier<bool> desenhoAtivo;
  final ValueNotifier<bool> borrachaAtiva;
  final ValueNotifier<bool> edicaoAtiva;
  final ValueNotifier<bool> edicaoTextoAtiva;
  final ValueNotifier<TipoDesenho> tipoDesenho;
  final ValueNotifier<Map<Offset, TipoDesenho>> pontosDeConexao;
  final ValueNotifier<MapEntry<Offset, TipoDesenho>> ultimoPontoConexao;
  final ValueNotifier<String> textoCirculo;
  final ValueNotifier<Color> corDesenho;
  final ValueNotifier<bool> temDesenho;
  final ValueNotifier<bool> temIndice;
  final GlobalKey canvasGlobalKey;
  int id = 0;

  QuadroBrancoGenograma({
    super.key,
    required this.genograma,
    required this.desenhoAtual,
    required this.canvasGlobalKey,
    required this.desenhoAtivo,
    required this.tipoDesenho,
    required this.borrachaAtiva,
    required this.edicaoAtiva,
    required this.edicaoTextoAtiva,
    required this.pontosDeConexao,
    required this.ultimoPontoConexao,
    required this.textoCirculo,
    required this.corDesenho,
    required this.temDesenho,
    required this.temIndice,
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

      if(edicaoAtiva.value){
        ElementosDesenho? elementoEncontrado = genograma.value.editDesenho(offset);
        if(elementoEncontrado != null && elementoEncontrado.tipo != TipoDesenho.caneta && elementoEncontrado.tipo != TipoDesenho.linha){
          temDesenho.value = true;
          desenhoAtual.value = elementoEncontrado;
          tipoDesenho.value = elementoEncontrado.tipo;
          textoCirculo.value = elementoEncontrado.texto ?? "";
          id = elementoEncontrado.id;
          
          final newEcomapa = genograma.value.copyWith(
            elementos: genograma.value.removeDesenho(elementoEncontrado.pontos[0])
          );

          for (var element in elementoEncontrado.pontosConexao) {
            pontosDeConexao.value.remove(Offset(element.dx, element.dy));
          }

          for(var elemento in genograma.value.elementos){
            for (var element in elemento.pontosConexao) {
              pontosDeConexao.value.putIfAbsent(element, () => elemento.tipo);
            }
          }

          genograma.value = newEcomapa;
          desenhoAtual.value = ElementosDesenho(
            id: id,
            pontos: [offset],
            tipo: tipoDesenho.value,
            cor: corDesenho.value,
            tamanho: tipoDesenho.value == TipoDesenho.texto ? 5 : 20,
            texto: textoCirculo.value,
            isPaciente: elementoEncontrado.isPaciente,
          );
        } else {
          temDesenho.value = false;
          desenhoAtivo.value = false;
        }
      } else if(tipoDesenho.value == TipoDesenho.linha){
        temDesenho.value = true;
        double distanciaPontoDeConexao = double.infinity;
        Offset pontoDeConexaoMaisProximo = Offset.zero;
        for (MapEntry<Offset, TipoDesenho> pontoDeConexao in pontosDeConexao.value.entries) {
          double distancia = (pontoDeConexao.key - offset).distance;
          if (distancia <= 6*desenhoAtual.value.tamanho && distancia < distanciaPontoDeConexao) {
            distanciaPontoDeConexao = distancia;
            pontoDeConexaoMaisProximo = pontoDeConexao.key;
          }
        }
        if(pontoDeConexaoMaisProximo != Offset.zero){
          desenhoAtual.value = ElementosDesenho(
            id: id != 0 ? id : genograma.value.elementos.length + 1,
            pontos: [pontoDeConexaoMaisProximo],
            tipo: tipoDesenho.value,
            tamanho: tipoDesenho.value == TipoDesenho.texto ? 5 : 20,
            texto: textoCirculo.value,
            cor: corDesenho.value,
          );
        }
        id = id != 0 ? id : genograma.value.elementos.length + 1;
      } else {
        temDesenho.value = true;
        desenhoAtual.value = ElementosDesenho(
          id: id != 0 ? id : genograma.value.elementos.length + 1,
          pontos: [offset],
          tipo: tipoDesenho.value,
          tamanho: tipoDesenho.value == TipoDesenho.texto ? 5 : 20,
          texto: textoCirculo.value,
          cor: corDesenho.value,
        );
        id = id != 0 ? id : genograma.value.elementos.length + 1;
      }
    }
  }

  void onPointerMove(PointerMoveEvent details, BuildContext context) {
    final box = context.findRenderObject() as RenderBox;
    final offset = box.globalToLocal(details.position);
    var pontos = [offset];
    if(tipoDesenho.value == TipoDesenho.caneta){
      pontos = List<Offset>.from(desenhoAtual.value.pontos)
       ..add(offset);
    }
    double distanciaPontoDeConexao = double.infinity;
    MapEntry<Offset, TipoDesenho> pontoDeConexaoMaisProximo = const MapEntry(Offset.zero, TipoDesenho.semDesenho);
    MapEntry<Offset, TipoDesenho> pontoDeConexaoMaisProximoDesenho = const MapEntry(Offset.zero, TipoDesenho.semDesenho);
    final List listaPontos = List.from(genograma.value.elementos.map((e) => e.pontos)).expand((e) => e).toList();
    if(ultimoPontoConexao.value.key == Offset.zero){
      for (MapEntry<Offset, TipoDesenho> pontoDeConexao in pontosDeConexao.value.entries) {
        int i = 0;
        for (Offset ponto in desenhoAtual.value.pontosConexao) {
          double distancia = (ponto - pontoDeConexao.key).distance;
          double distanciaOffset = (offset - pontoDeConexao.key).distance;
          if (!listaPontos.contains(offset) && distanciaOffset < 4*desenhoAtual.value.tamanho && distancia <= 2*desenhoAtual.value.tamanho && distancia > 0 && (distancia < distanciaPontoDeConexao || distanciaPontoDeConexao == double.infinity)) {
            distanciaPontoDeConexao = distancia;
            pontoDeConexaoMaisProximo = MapEntry(ponto, desenhoAtual.value.tipo);
            if(desenhoAtual.value.pontosConexao.length == 1){
              pontoDeConexaoMaisProximoDesenho = pontoDeConexao;
            } else{
              pontoDeConexaoMaisProximoDesenho = 
                i == 0 ? 
                  MapEntry(pontoDeConexao.key - Offset(0, desenhoAtual.value.tamanho), pontoDeConexao.value) :
                i == 1 ?
                  MapEntry(pontoDeConexao.key - Offset(desenhoAtual.value.tamanho, 0), pontoDeConexao.value) :
                i == 2 ?
                  MapEntry(pontoDeConexao.key + Offset(0, desenhoAtual.value.tamanho), pontoDeConexao.value) :
                i == 3 ?
                  MapEntry(pontoDeConexao.key + Offset(desenhoAtual.value.tamanho, 0), pontoDeConexao.value) :
                MapEntry(offset, TipoDesenho.semDesenho);
            }
          }
          i++;
        }
      }
    }

    if(desenhoAtivo.value && temDesenho.value && !edicaoTextoAtiva.value){
      borrachaAtiva.value = false;
      if(tipoDesenho.value == TipoDesenho.linha){
        if(desenhoAtual.value.pontos.isNotEmpty){
          desenhoAtual.value = ElementosDesenho(
            id: id != 0 ? id : genograma.value.elementos.length + 1,
            pontos: [desenhoAtual.value.pontos[0], Offset(offset.dx, offset.dy)],
            tipo: tipoDesenho.value,
            tamanho: 5,
            cor: corDesenho.value,
          );
        } else {
          desenhoAtual.value = ElementosDesenho(
            id: id != 0 ? id : genograma.value.elementos.length + 1,
            pontos: [offset],
            tipo: tipoDesenho.value,
            tamanho: 5,
            cor: corDesenho.value,
          );
        }
      } else if(tipoDesenho.value == TipoDesenho.caneta){
        desenhoAtual.value = ElementosDesenho(
          id: id != 0 ? id : genograma.value.elementos.length + 1,
          pontos: pontos,
          tipo: tipoDesenho.value,
          tamanho: tipoDesenho.value == TipoDesenho.texto ? 5 : 20,
          texto: textoCirculo.value,
          cor: corDesenho.value,
          isPaciente: false
        );
      } else if(!listaPontos.contains(pontoDeConexaoMaisProximoDesenho) && !listaPontos.contains(pontoDeConexaoMaisProximoDesenho)) {
        if(
          pontoDeConexaoMaisProximoDesenho.value == TipoDesenho.linha &&
          desenhoAtual.value.pontos != [pontoDeConexaoMaisProximoDesenho.key] && 
          distanciaPontoDeConexao < 4* desenhoAtual.value.tamanho && 
          pontoDeConexaoMaisProximo.key != Offset.zero
        ){
          ultimoPontoConexao.value = pontoDeConexaoMaisProximo;
          desenhoAtual.value = ElementosDesenho(
            id: genograma.value.elementos.length + 1,
            pontos: [pontoDeConexaoMaisProximoDesenho.key],
            tipo: tipoDesenho.value,
            tamanho: tipoDesenho.value == TipoDesenho.texto ? 5 : 20,
            texto: textoCirculo.value,
            cor: corDesenho.value,
            isPaciente: desenhoAtual.value.isPaciente,
          );
        } else if((offset - ultimoPontoConexao.value.key).distance > 2* desenhoAtual.value.tamanho){
          ultimoPontoConexao.value = const MapEntry(Offset.zero, TipoDesenho.semDesenho);
          desenhoAtual.value = ElementosDesenho(
            id: genograma.value.elementos.length + 1,
            pontos: [offset],
            tipo: tipoDesenho.value,
            tamanho: tipoDesenho.value == TipoDesenho.texto ? 5 : 20,
            texto: textoCirculo.value,
            cor: corDesenho.value,
            isPaciente: desenhoAtual.value.isPaciente,
          );
        }
      } 
    }
    id = id != 0 ? id : genograma.value.elementos.length + 1;
  }
  

  void onPointerUp(PointerUpEvent details, BuildContext context) {
    final box = context.findRenderObject() as RenderBox;
    final offset = box.globalToLocal(details.position);

    if(desenhoAtivo.value && temDesenho.value){
      genograma.value = genograma.value.addDesenho(desenhoAtual.value);
      if(desenhoAtual.value.tipo == TipoDesenho.linha){
        // adicionar o meio da linha como ponto de conexao
        desenhoAtual.value.pontosConexao.add(Offset(
          (desenhoAtual.value.pontos[0].dx + desenhoAtual.value.pontos[1].dx) / 2,
          (desenhoAtual.value.pontos[0].dy + desenhoAtual.value.pontos[1].dy) / 2,
        ));
      }
      for (var element in desenhoAtual.value.pontosConexao) { 
        pontosDeConexao.value[Offset(element.dx, element.dy)] = desenhoAtual.value.tipo;
      }
      desenhoAtual.value = 
      ElementosDesenho(
        id: 0,
        pontos: [],
        tipo: tipoDesenho.value,
        tamanho: 5,
        cor: preto,
      );
      if(!edicaoAtiva.value) {
        desenhoAtivo.value = false;
      }
      id = genograma.value.elementos.length + 1;
    } else if(borrachaAtiva.value){
      ElementosDesenho? elementoEncontrado = genograma.value.editDesenho(offset);
      if(elementoEncontrado != null){
        for (var element in elementoEncontrado.pontosConexao) {
          pontosDeConexao.value.remove(Offset(element.dx, element.dy));
        }
        if(elementoEncontrado.isPaciente) {
          temIndice.value = false;
        }
        final newGenograma = genograma.value.copyWith(
          elementos: genograma.value.removeDesenho(elementoEncontrado.pontos[0])
        );
        genograma.value = newGenograma;
        for(var elemento in genograma.value.elementos){
          for (var element in elemento.pontosConexao) {
            pontosDeConexao.value.putIfAbsent(element, () => elemento.tipo);
          }
        }
      }
    } else {
      ElementosDesenho? elementoEncontrado = genograma.value.editDesenho(offset);
      if(
        elementoEncontrado != null && 
        (elementoEncontrado.tipo == TipoDesenho.circulo || 
        elementoEncontrado.tipo == TipoDesenho.quadrado) &&
        temIndice.value == false
        ){
        temDesenho.value = true;
        desenhoAtual.value = elementoEncontrado;
        tipoDesenho.value = elementoEncontrado.tipo;
        textoCirculo.value = elementoEncontrado.texto ?? "";

        // ler o texto alterado que o usuario digitar e alterar o original
        showDialog(
          context: context, 
          builder: (context) {
            return AlertDialog(
              title: const Text('Confirmação'),
              content: const Text("Deseja marcar este elemento como índice?"),
              actions: [
                TextButton(
                  onPressed: () => {
                    Navigator.of(context).pop()
                  },
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    final newEcomapa = genograma.value.copyWith(
                      elementos: genograma.value.removeDesenho(elementoEncontrado.pontos[0])
                    );
                    var idade =  !genograma.value.pacienteRaiz['idade'].contains("dia") ? 
                    genograma.value.pacienteRaiz['idade'][0] + genograma.value.pacienteRaiz['idade'][1] : 
                    genograma.value.pacienteRaiz['idade'];
                    
                    genograma.value = newEcomapa;
                    desenhoAtual.value = ElementosDesenho(
                      id: elementoEncontrado.id,
                      pontos: elementoEncontrado.pontos,
                      cor: elementoEncontrado.cor,
                      tipo: elementoEncontrado.tipo,
                      tamanho: elementoEncontrado.tamanho,
                      texto: "${genograma.value.pacienteRaiz['nome'][0]}, ${idade}",
                      isPaciente: true,
                    );
                    genograma.value = genograma.value.addDesenho(desenhoAtual.value);
                    temIndice.value = true;
                    Navigator.of(context).pop();
                  },
                  child: const Text('Confirmar'),
                ),
              ],
            );
          }
        );
      }
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