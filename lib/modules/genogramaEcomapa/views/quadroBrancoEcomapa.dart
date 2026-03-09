import 'package:acolherconsultas/modules/genogramaEcomapa/models/ecomapa.dart';
import 'package:acolherconsultas/modules/genogramaEcomapa/models/elementosDesenho.dart';
import 'package:acolherconsultas/modules/genogramaEcomapa/models/tipoDesenho.dart';
import 'package:acolherconsultas/modules/genogramaEcomapa/models/undoRedoPilha.dart';
import 'package:acolherconsultas/modules/genogramaEcomapa/views/quadroBrancoEcomapaPainter.dart';
import 'package:acolherconsultas/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class QuadroBrancoEcomapa extends HookWidget {
  final ValueNotifier<Ecomapa> ecomapa;
  final ValueNotifier<ElementosDesenho> desenhoAtual;
  final ValueNotifier<MapEntry<ElementosDesenho, Operacoes>> desenhoEditado;
  final ValueNotifier<bool> desenhoAtivo;
  final ValueNotifier<bool> borrachaAtiva;
  final ValueNotifier<bool> edicaoAtiva;
  final ValueNotifier<bool> edicaoTextoAtiva;
  final ValueNotifier<TipoDesenho> tipoDesenho;
  final ValueNotifier<List<Offset>> pontosDeConexao;
  final ValueNotifier<Offset> ultimoPontoConexao;
  final ValueNotifier<String> textoCirculo;
  final ValueNotifier<String?>? ligacao;
  final ValueNotifier<String?>? energiaGastaPaciente;
  final ValueNotifier<String?>? energiaGastaParte;
  final GlobalKey canvasGlobalKey;
  final ValueNotifier<bool> temDesenho;

  const QuadroBrancoEcomapa({
    super.key,
    required this.ecomapa,
    required this.desenhoAtual,
    required this.desenhoEditado,
    required this.desenhoAtivo,
    required this.tipoDesenho,
    required this.borrachaAtiva,
    required this.edicaoAtiva,
    required this.edicaoTextoAtiva,
    required this.pontosDeConexao,
    required this.ultimoPontoConexao,
    required this.textoCirculo,
    required this.canvasGlobalKey,
    required this.temDesenho,
    this.ligacao,
    this.energiaGastaPaciente,
    this.energiaGastaParte,
  });

  @override
  Widget build(BuildContext context) {
    // Use hooks to manage mutable state
    final id = useState(0);
    final pontosIniciais = useState<List<Offset>>([]);

    void onPointerDown(PointerDownEvent details) {
      id.value = ecomapa.value.elementos.length + 1;
      final box = context.findRenderObject() as RenderBox;
      final offset = box.globalToLocal(details.position);

      if (desenhoAtivo.value && !edicaoTextoAtiva.value) {
        borrachaAtiva.value = false;

        if (edicaoAtiva.value) {
          ElementosDesenho? elementoEncontrado = ecomapa.value.editDesenho(offset);

          if (elementoEncontrado != null &&
              elementoEncontrado.tipo != TipoDesenho.caneta &&
              elementoEncontrado.id != 1) {
            temDesenho.value = true;
            desenhoAtual.value = elementoEncontrado;
            tipoDesenho.value = elementoEncontrado.tipo;
            textoCirculo.value = elementoEncontrado.texto ?? "";
            ligacao?.value = elementoEncontrado.ligacao;
            energiaGastaPaciente?.value = elementoEncontrado.energiaGastaPaciente;
            energiaGastaParte?.value = elementoEncontrado.energiaGastaParte;
            id.value = elementoEncontrado.id;

            pontosIniciais.value = [
              Offset(elementoEncontrado.pontos[0].dx, elementoEncontrado.pontos[0].dy)
            ];

            final newEcomapa = ecomapa.value.copyWith(
                elementos: ecomapa.value.removeDesenho(elementoEncontrado.pontos[0]));
            ecomapa.value = newEcomapa;
            desenhoAtual.value = ElementosDesenho(
              id: id.value,
              pontos: [offset],
              tipo: tipoDesenho.value,
              cor: tipoDesenho.value == TipoDesenho.caneta ? vermelho : preto,
              tamanho: tipoDesenho.value == TipoDesenho.texto ? 25 : 80,
              texto: tipoDesenho.value == TipoDesenho.texto || tipoDesenho.value == TipoDesenho.circuloEcomapa
                  ? textoCirculo.value
                  : null,
              ligacao: ligacao?.value,
              energiaGastaPaciente: energiaGastaPaciente?.value,
              energiaGastaParte: energiaGastaParte?.value,
            );
          } else {
            temDesenho.value = false;
            desenhoAtivo.value = false;
          }
        } else {
          temDesenho.value = true;
          desenhoAtual.value = ElementosDesenho(
            id: id.value != 0 ? id.value : ecomapa.value.elementos.length + 1,
            pontos: [offset],
            tipo: tipoDesenho.value,
            cor: tipoDesenho.value == TipoDesenho.caneta ? vermelho : preto,
            tamanho: tipoDesenho.value == TipoDesenho.texto ? 25 : 80,
            texto: tipoDesenho.value == TipoDesenho.texto || tipoDesenho.value == TipoDesenho.circuloEcomapa
                ? textoCirculo.value
                : null,
            ligacao: ligacao?.value,
            energiaGastaPaciente: energiaGastaPaciente?.value,
            energiaGastaParte: energiaGastaParte?.value,
          );
          id.value = id.value != 0 ? id.value : ecomapa.value.elementos.length + 1;
        }
      }
    }

    void onPointerMove(PointerMoveEvent details) {
      final box = context.findRenderObject() as RenderBox;
      final offset = box.globalToLocal(details.position);
      var pontos = [offset];
      if (tipoDesenho.value == TipoDesenho.caneta) {
        pontos = List<Offset>.from(desenhoAtual.value.pontos)..add(offset);
      }

      if (desenhoAtivo.value && temDesenho.value && !edicaoTextoAtiva.value) {
        borrachaAtiva.value = false;
        desenhoAtual.value = ElementosDesenho(
          id: id.value != 0 ? id.value : ecomapa.value.elementos.length + 1,
          pontos: pontos,
          cor: tipoDesenho.value == TipoDesenho.caneta ? vermelho : preto,
          tipo: tipoDesenho.value,
          tamanho: tipoDesenho.value == TipoDesenho.texto ? 25 : 80,
          texto: tipoDesenho.value == TipoDesenho.texto || tipoDesenho.value == TipoDesenho.circuloEcomapa
              ? textoCirculo.value
              : null,
          ligacao: ligacao?.value,
          energiaGastaPaciente: energiaGastaPaciente?.value,
          energiaGastaParte: energiaGastaParte?.value,
        );
      }
      id.value = id.value != 0 ? id.value : ecomapa.value.elementos.length + 1;
    }

    void onPointerUp(PointerUpEvent details) {
      final box = context.findRenderObject() as RenderBox;
      final offset = box.globalToLocal(details.position);

      if (desenhoAtivo.value && temDesenho.value) {
        borrachaAtiva.value = false;

        if (edicaoTextoAtiva.value) {
          ElementosDesenho? elementoEncontrado = ecomapa.value.editDesenho(offset);

          if (elementoEncontrado != null &&
              elementoEncontrado.tipo != TipoDesenho.caneta &&
              elementoEncontrado.id != 1) {
            temDesenho.value = true;
            desenhoAtual.value = elementoEncontrado;
            tipoDesenho.value = elementoEncontrado.tipo;
            textoCirculo.value = elementoEncontrado.texto ?? "";
            ligacao?.value = elementoEncontrado.ligacao;
            energiaGastaPaciente?.value = elementoEncontrado.energiaGastaPaciente;
            energiaGastaParte?.value = elementoEncontrado.energiaGastaParte;

            showDialog(
                context: context,
                builder: (context) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(viewInsets: EdgeInsets.zero),
                    child: AlertDialog(
                      title: const Text('Altere o Texto:'),
                      content: TextFormField(
                        onChanged: (value) => textoCirculo.value = value,
                        initialValue: textoCirculo.value,
                        maxLines: tipoDesenho.value == TipoDesenho.texto ? 5 : 1,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.multiline,
                        textCapitalization: TextCapitalization.sentences,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                        ),
                        cursorColor: preto,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: 'Alteração',
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 13,
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => {Navigator.of(context).pop()},
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () {
                            desenhoEditado.value =
                                MapEntry(ElementosDesenho(id: 0, pontos: [], tipo: TipoDesenho.semDesenho, tamanho: 5), Operacoes.edicao);
                            final newEcomapa = ecomapa.value.copyWith(
                                elementos: ecomapa.value.removeDesenho(elementoEncontrado.pontos[0]));
                            ecomapa.value = newEcomapa;
                            desenhoAtual.value = ElementosDesenho(
                              id: elementoEncontrado.id,
                              pontos: elementoEncontrado.pontos,
                              cor: elementoEncontrado.cor,
                              tipo: elementoEncontrado.tipo,
                              tamanho: elementoEncontrado.tamanho,
                              texto: textoCirculo.value,
                              ligacao: ligacao?.value,
                              energiaGastaPaciente: energiaGastaPaciente?.value,
                              energiaGastaParte: energiaGastaParte?.value,
                            );
                            desenhoEditado.value = MapEntry(elementoEncontrado, Operacoes.edicao);
                            ecomapa.value = ecomapa.value.addDesenho(desenhoAtual.value);
                            desenhoAtivo.value = false;
                            Navigator.of(context).pop();
                          },
                          child: const Text('Confirmar'),
                        ),
                      ],
                    ),
                  );
                });
          } else {
            temDesenho.value = false;
            desenhoAtivo.value = false;
          }
        } else {
          if (edicaoAtiva.value) {
            desenhoEditado.value =
                MapEntry(desenhoAtual.value.copyWith(pontos: pontosIniciais.value), Operacoes.edicao);
          } else {
            desenhoEditado.value = MapEntry(desenhoAtual.value, Operacoes.adicao);
          }
          ecomapa.value = ecomapa.value.addDesenho(desenhoAtual.value);
          desenhoAtual.value = ElementosDesenho(
            id: 0,
            pontos: [],
            tipo: tipoDesenho.value,
            tamanho: 5,
          );
          if (!edicaoAtiva.value) {
            desenhoAtivo.value = false;
          }
          id.value = ecomapa.value.elementos.length + 1;
        }
      } else if (borrachaAtiva.value) {
        desenhoAtual.value = ElementosDesenho(
          id: 0,
          pontos: [],
          tipo: tipoDesenho.value,
          tamanho: 5,
        );

        desenhoEditado.value = MapEntry(
            ecomapa.value.editDesenho(offset) ??
                ElementosDesenho(
                  id: 0,
                  pontos: [],
                  tipo: tipoDesenho.value,
                  tamanho: 5,
                ),
            Operacoes.remocao);

        final newEcomapa = ecomapa.value.copyWith(elementos: ecomapa.value.removeDesenho(offset));
        ecomapa.value = newEcomapa;
      }
    }

    return Stack(
      children: [
        buildAllSketches(context),
        buildCurrentPath(context, onPointerDown, onPointerMove, onPointerUp),
      ],
    );
  }

  Widget buildAllSketches(BuildContext context) {
    return ValueListenableBuilder<Ecomapa>(
      valueListenable: ecomapa,
      builder: (context, ecomapa, _) {
        return RepaintBoundary(
          key: canvasGlobalKey,
          child: SizedBox(
            width: 4000,
            height: 2000,
            child: CustomPaint(
              painter: QuadroBrancoEcomapaPainter(
                ecomapa: ecomapa.elementos,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildCurrentPath(BuildContext context, void Function(PointerDownEvent) onPointerDown,
      void Function(PointerMoveEvent) onPointerMove, void Function(PointerUpEvent) onPointerUp) {
    return Listener(
      onPointerDown: onPointerDown,
      onPointerMove: onPointerMove,
      onPointerUp: onPointerUp,
      child: ValueListenableBuilder(
        valueListenable: desenhoAtual,
        builder: (context, desenho, child) {
          return RepaintBoundary(
            child: SizedBox(
              width: 4000,
              height: 2000,
              child: CustomPaint(
                painter: QuadroBrancoEcomapaPainter(
                  ecomapa: desenho.pontos.isEmpty ? [] : [desenho],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
