import 'dart:math';
import 'dart:ui';

import 'package:acolherconsultas/modules/genogramaEcomapa/models/elementosDesenho.dart';
import 'package:acolherconsultas/modules/genogramaEcomapa/models/tipoDesenho.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class QuadroBrancoGenogramaPainter extends CustomPainter {
  final List<ElementosDesenho> genograma;

  QuadroBrancoGenogramaPainter({
    required this.genograma,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for(ElementosDesenho elemento in genograma){
      for(Offset pontoConexao in elemento.pontosConexao){
        canvas.drawCircle(
          pontoConexao, 
          2,
          Paint()
        );
      }
      switch(elemento.tipo){
        case TipoDesenho.circulo:
          canvas.drawCircle(
            elemento.pontos[0], 
            elemento.tamanho, 
            Paint()
            ..color = elemento.cor
            ..strokeWidth = 2
            ..style = PaintingStyle.stroke
          );
          break;
        case TipoDesenho.circuloFalecido:
          //circulo com um x no meio
          canvas.drawCircle(
            elemento.pontos[0], 
            elemento.tamanho, 
            Paint()
            ..color = elemento.cor
            ..strokeWidth = 2
            ..style = PaintingStyle.stroke
          );
          canvas.drawLine(
            Offset(elemento.pontos[0].dx - (elemento.tamanho* cos(pi/4)), elemento.pontos[0].dy - (elemento.tamanho* sin(pi/4))),
            Offset(elemento.pontos[0].dx + (elemento.tamanho* cos(pi/4)), elemento.pontos[0].dy + (elemento.tamanho* sin(pi/4))),
            Paint()
            ..color = Colors.black
            ..strokeWidth = 2
          );
          canvas.drawLine(
            Offset(elemento.pontos[0].dx - (elemento.tamanho* cos(pi/4)), elemento.pontos[0].dy + (elemento.tamanho* sin(pi/4))),
            Offset(elemento.pontos[0].dx + (elemento.tamanho* cos(pi/4)), elemento.pontos[0].dy - (elemento.tamanho* sin(pi/4))),
            Paint()
            ..color = Colors.black
            ..strokeWidth = 2
          );
          break;
        case TipoDesenho.circuloDesconhecido:
          // Circulo com um ponto de interrogação no meio
          canvas.drawCircle(
            elemento.pontos[0], 
            elemento.tamanho, 
            Paint()
            ..color = elemento.cor
            ..strokeWidth = 2
            ..style = PaintingStyle.stroke
          );
          // ponto de interrogação no centro do circulo
          final textPainter = TextPainter(
            text: const TextSpan(
              text: "?",
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
              ),
            ),
            textDirection: TextDirection.ltr,
          );
          textPainter.layout();
          textPainter.paint(
            canvas,
            Offset(
              elemento.pontos[0].dx - (textPainter.width / 2), 
              elemento.pontos[0].dy - (textPainter.height / 2),
            ),
          );

          break;
        case TipoDesenho.quadrado:
          canvas.drawRect(
            Rect.fromCenter(
              center: elemento.pontos[0],
              width: elemento.tamanho*2,
              height: elemento.tamanho*2,
            ),
            Paint()
            ..color = elemento.cor
            ..strokeWidth = 2
            ..style = PaintingStyle.stroke
          );
          break;
        case TipoDesenho.quadradoFalecido:
          // TODO: Handle this case.
        case TipoDesenho.quadradoDesconhecido:
          // TODO: Handle this case.
        case TipoDesenho.linhaHorizontal:
          // linha horizontal
          canvas.drawLine(
            elemento.pontos[0],
            elemento.pontos[1],
            Paint()
            ..color = elemento.cor
            ..strokeWidth = 2
          );
          break;
        case TipoDesenho.linhaVertical:
          // linha vertical
          canvas.drawLine(
            elemento.pontos[0],
            elemento.pontos[1],
            Paint()
            ..color = elemento.cor
            ..strokeWidth = 2
          );
          break;
        case TipoDesenho.linhaSeparacao:
          // TODO: Handle this case.
        case TipoDesenho.texto:
          // TODO: Handle this case.
        case TipoDesenho.semDesenho:
          // TODO: Handle this case.
        case TipoDesenho.circuloEcomapa:
          // TODO: Handle this case.
        case TipoDesenho.linha:
          // TODO: Handle this case.
        case TipoDesenho.linhaPontilhada:
          // TODO: Handle this case.
        case TipoDesenho.seta:
          // TODO: Handle this case.
        case TipoDesenho.caneta:
          // TODO: Handle this case.
      }
    }
    //desenhar circulo no centro
    // canvas.drawCircle(
    //   Offset(size.width/2, size.height/2), 
    //   10, 
    //   Paint()
    //   ..color = Colors.red
    //   ..strokeWidth = 2
    //   ..style = PaintingStyle.stroke
    // );
    // //linha horizontal e vertical no centro
    // canvas.drawLine(
    //   Offset(0, size.height/2),
    //   Offset(size.width, size.height/2),
    //   Paint()
    //   ..color = Colors.red
    //   ..strokeWidth = 2
    // );
    // canvas.drawLine(
    //   Offset(size.width/2, 0),
    //   Offset(size.width/2, size.height),
    //   Paint()
    //   ..color = Colors.red
    //   ..strokeWidth = 2
    // );
  }

  @override
  bool shouldRepaint(covariant QuadroBrancoGenogramaPainter oldDelegate) {
    return listEquals(genograma, oldDelegate.genograma);
  }

}