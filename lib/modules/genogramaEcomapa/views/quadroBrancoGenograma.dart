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
  final ValueNotifier<List<Offset>> pontosDeConexao;
  final ValueNotifier<Offset> ultimoPontoConexao;
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
        if(elementoEncontrado != null && elementoEncontrado.tipo != TipoDesenho.caneta){
          temDesenho.value = true;
          desenhoAtual.value = elementoEncontrado;
          tipoDesenho.value = elementoEncontrado.tipo;
          textoCirculo.value = elementoEncontrado.texto ?? "";
          id = elementoEncontrado.id;
          // print(elementoEncontrado.pontos);
          // print(pontosIniciais);
          // print("asda");
          // pontosIniciais.add(Offset(elementoEncontrado.pontos[0].dx, elementoEncontrado.pontos[0].dy));
          // print(pontosIniciais);

          final newEcomapa = genograma.value.copyWith(
            elementos: genograma.value.removeDesenho(elementoEncontrado.pontos[0])
          ); 
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

    if(desenhoAtivo.value && temDesenho.value && !edicaoTextoAtiva.value){
      borrachaAtiva.value = false;
      if(tipoDesenho.value == TipoDesenho.linha){
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
          pontos: pontos,
          tipo: tipoDesenho.value,
          tamanho: tipoDesenho.value == TipoDesenho.texto ? 5 : 20,
          texto: textoCirculo.value,
          cor: corDesenho.value,
          isPaciente: temIndice.value && edicaoAtiva.value,
        );
      }
    }
    id = id != 0 ? id : genograma.value.elementos.length + 1;
  }
  

  void onPointerUp(PointerUpEvent details, BuildContext context) {
    final box = context.findRenderObject() as RenderBox;
    final offset = box.globalToLocal(details.position);

    if(desenhoAtivo.value && temDesenho.value){
      genograma.value = genograma.value.addDesenho(desenhoAtual.value);
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
        if(elementoEncontrado.isPaciente) {
          temIndice.value = false;
        }
        final newGenograma = genograma.value.copyWith(
          elementos: genograma.value.removeDesenho(elementoEncontrado.pontos[0])
        );
        genograma.value = newGenograma;
      }
    } else {
      ElementosDesenho? elementoEncontrado = genograma.value.editDesenho(offset);
      if(
        elementoEncontrado != null && 
        elementoEncontrado.tipo != TipoDesenho.caneta && 
        elementoEncontrado.tipo != TipoDesenho.linha &&
        elementoEncontrado.tipo != TipoDesenho.texto &&
        elementoEncontrado.tipo != TipoDesenho.circuloFalecido &&
        elementoEncontrado.tipo != TipoDesenho.circuloDesconhecido &&
        elementoEncontrado.tipo != TipoDesenho.quadradoDesconhecido &&
        elementoEncontrado.tipo != TipoDesenho.quadradoFalecido &&
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