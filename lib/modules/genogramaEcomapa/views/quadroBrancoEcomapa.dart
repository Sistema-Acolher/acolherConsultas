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
  int id = 0;
  List<Offset> pontosIniciais = [];

  QuadroBrancoEcomapa({
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
    return Stack(
      children: [
        buildAllSketches(context),
        buildCurrentPath(context),
      ],
    );
  }

  void onPointerDown(PointerDownEvent details, BuildContext context) {
    id = ecomapa.value.elementos.length + 1;
    final box = context.findRenderObject() as RenderBox;
    final offset = box.globalToLocal(details.position);
    print(id);
    
    if(desenhoAtivo.value && !edicaoTextoAtiva.value){
      borrachaAtiva.value = false;

      if(edicaoAtiva.value){
        ElementosDesenho? elementoEncontrado = ecomapa.value.editDesenho(offset);
        print(elementoEncontrado?.texto);

        if(elementoEncontrado != null && elementoEncontrado.tipo != TipoDesenho.caneta && elementoEncontrado.id != 1){
          temDesenho.value = true;
          desenhoAtual.value = elementoEncontrado;
          tipoDesenho.value = elementoEncontrado.tipo;
          textoCirculo.value = elementoEncontrado.texto ?? "";
          ligacao?.value = elementoEncontrado.ligacao;
          energiaGastaPaciente?.value = elementoEncontrado.energiaGastaPaciente;
          energiaGastaParte?.value = elementoEncontrado.energiaGastaParte;
          id = elementoEncontrado.id;
          print(elementoEncontrado.pontos);
          print(pontosIniciais);
          print("asda");
          pontosIniciais.add(Offset(elementoEncontrado.pontos[0].dx, elementoEncontrado.pontos[0].dy));
          print(pontosIniciais);

          final newEcomapa = ecomapa.value.copyWith(
            elementos: ecomapa.value.removeDesenho(elementoEncontrado.pontos[0])
          ); 
          ecomapa.value = newEcomapa;
          desenhoAtual.value = ElementosDesenho(
            id: id,
            pontos: [offset],
            tipo: tipoDesenho.value,
            cor: tipoDesenho.value == TipoDesenho.caneta ? vermelho : preto,
            tamanho: tipoDesenho.value == TipoDesenho.texto ? 25 : 80,
            texto: tipoDesenho.value == TipoDesenho.texto || tipoDesenho.value == TipoDesenho.circuloEcomapa ? textoCirculo.value : null,
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
          id: id != 0 ? id : ecomapa.value.elementos.length + 1,
          pontos: [offset],
          tipo: tipoDesenho.value,
          cor: tipoDesenho.value == TipoDesenho.caneta ? vermelho : preto,
          tamanho: tipoDesenho.value == TipoDesenho.texto ? 25 : 80,
          texto: tipoDesenho.value == TipoDesenho.texto || tipoDesenho.value == TipoDesenho.circuloEcomapa ? textoCirculo.value : null,
          ligacao: ligacao?.value,
          energiaGastaPaciente: energiaGastaPaciente?.value,
          energiaGastaParte: energiaGastaParte?.value,
        );
        id = id != 0 ? id : ecomapa.value.elementos.length + 1;
      }
      
    }
    print("AAAAAAAAAAAAAAAAAAAAdadada");
    print(pontosIniciais);
  }

  void onPointerMove(PointerMoveEvent details, BuildContext context) {
    final box = context.findRenderObject() as RenderBox;
    final offset = box.globalToLocal(details.position);
    var pontos = [offset];
    if(tipoDesenho.value == TipoDesenho.caneta){
      pontos = List<Offset>.from(desenhoAtual.value.pontos)
       ..add(offset);
    }
    // print(pontosIniciais);
    // print("asda222");
    print(temDesenho.value);

    if(desenhoAtivo.value && temDesenho.value && !edicaoTextoAtiva.value){
      borrachaAtiva.value = false;
      desenhoAtual.value = ElementosDesenho(
        id: id != 0 ? id : ecomapa.value.elementos.length + 1,
        pontos: pontos,
        cor: tipoDesenho.value == TipoDesenho.caneta ? vermelho : preto,
        tipo: tipoDesenho.value,
        tamanho: tipoDesenho.value == TipoDesenho.texto ? 25 : 80,
        texto: tipoDesenho.value == TipoDesenho.texto || tipoDesenho.value == TipoDesenho.circuloEcomapa ? textoCirculo.value : null,
        ligacao: ligacao?.value,
        energiaGastaPaciente: energiaGastaPaciente?.value,
        energiaGastaParte: energiaGastaParte?.value,
      );
    }
      id = id != 0 ? id : ecomapa.value.elementos.length + 1;
  }

  void onPointerUp(PointerUpEvent details, BuildContext context) {
    final box = context.findRenderObject() as RenderBox;
    final offset = box.globalToLocal(details.position);

    if(desenhoAtivo.value && temDesenho.value){
      borrachaAtiva.value = false;

      if(edicaoTextoAtiva.value){
        ElementosDesenho? elementoEncontrado = ecomapa.value.editDesenho(offset);
        print(elementoEncontrado?.texto);

        if(elementoEncontrado != null && elementoEncontrado.tipo != TipoDesenho.caneta && elementoEncontrado.id != 1){
          temDesenho.value = true;
          desenhoAtual.value = elementoEncontrado;
          tipoDesenho.value = elementoEncontrado.tipo;
          textoCirculo.value = elementoEncontrado.texto ?? "";
          ligacao?.value = elementoEncontrado.ligacao;
          energiaGastaPaciente?.value = elementoEncontrado.energiaGastaPaciente;
          energiaGastaParte?.value = elementoEncontrado.energiaGastaParte;

          // ler o texto alterado que o usuario digitar e alterar o original
          showDialog(
            context: context, 
            builder: (context) {
              return AlertDialog(
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
                    onPressed: () => {
                      Navigator.of(context).pop()
                    },
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () {
                      desenhoEditado.value = MapEntry(ElementosDesenho(
                        id: 0,
                        pontos: [],
                        tipo: TipoDesenho.semDesenho,
                        tamanho: 5,
                      ), Operacoes.edicao);
                      final newEcomapa = ecomapa.value.copyWith(
                        elementos: ecomapa.value.removeDesenho(elementoEncontrado.pontos[0])
                      ); 
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
                      print("EDITOU");
                      Navigator.of(context).pop();
                    },
                    child: const Text('Confirmar'),
                  ),
                ],
              );
            }
          );
          
        } else {
          temDesenho.value = false;
          desenhoAtivo.value = false;
        }
      } else {
        if(edicaoAtiva.value){
          print("aadçç");
          print(pontosIniciais);
          desenhoEditado.value = MapEntry(desenhoAtual.value.copyWith(pontos: pontosIniciais), Operacoes.edicao);
        } else {
          desenhoEditado.value = MapEntry(desenhoAtual.value, Operacoes.adicao);
        }
        ecomapa.value = ecomapa.value.addDesenho(desenhoAtual.value);
        desenhoAtual.value = 
        ElementosDesenho(
          id: 0,
          pontos: [],
          tipo: tipoDesenho.value,
          tamanho: 5,
        );
        if(!edicaoAtiva.value) {
          desenhoAtivo.value = false;
        }
        id = ecomapa.value.elementos.length + 1;
      }
    } else if(borrachaAtiva.value){
      desenhoAtual.value = ElementosDesenho(
        id: 0,
        pontos: [],
        tipo: tipoDesenho.value,
        tamanho: 5,
      );

      ecomapa.value.elementos.forEach((el) {
        print("[${el.id}] ");
      }
      );

      print(ecomapa.value.editDesenho(offset)?.id);

      desenhoEditado.value = MapEntry(ecomapa.value.editDesenho(offset) ?? ElementosDesenho(
        id: 0,
        pontos: [],
        tipo: tipoDesenho.value,
        tamanho: 5,
      ), Operacoes.remocao);

      print(desenhoEditado.value.key.id);

      final newEcomapa = ecomapa.value.copyWith(
        elementos: ecomapa.value.removeDesenho(offset)
      ); 
      ecomapa.value = newEcomapa;
      id = ecomapa.value.elementos.length + 1;
      print(desenhoEditado.value.key.id);
    }
    print(pontosIniciais); 
    // pontosIniciais = [];
    print(ecomapa.value.elementos);
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