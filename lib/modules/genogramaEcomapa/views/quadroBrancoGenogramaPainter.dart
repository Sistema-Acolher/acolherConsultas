import 'dart:math';

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
      switch(elemento.tipo){
        case TipoDesenho.circulo:
          canvas.drawCircle(
            elemento.pontos[0], 
            elemento.tamanho, 
            Paint()
            ..color = elemento.cor
            ..strokeWidth = 3
            ..style = PaintingStyle.stroke
          );

          if(elemento.isPaciente){
            // desenhar um circulo maior em volta do circulo do paciente
            canvas.drawCircle(
              elemento.pontos[0], 
              elemento.tamanho + 22, 
              Paint()
              ..color = elemento.cor
              ..strokeWidth = 3
              ..style = PaintingStyle.stroke
            );
          }

          // desenhar texto abaixo do circulo elemento
          if(elemento.texto != ""){
            TextSpan span = TextSpan(
              style: TextStyle(color: elemento.cor, fontSize: elemento.tamanho),
              text: elemento.texto,
            );
            TextPainter tp = TextPainter(
              text: span,
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
            );
            tp.layout();
            tp.paint(canvas, Offset(elemento.pontos[0].dx - (tp.width / 2), elemento.isPaciente ? elemento.pontos[0].dy + elemento.tamanho + 28  : elemento.pontos[0].dy + elemento.tamanho + 5));
          }

          break;
        case TipoDesenho.circuloFalecido:
          //circulo com um x no meio
          canvas.drawCircle(
            elemento.pontos[0], 
            elemento.tamanho, 
            Paint()
            ..color = elemento.cor
            ..strokeWidth = 3
            ..style = PaintingStyle.stroke
          );
          canvas.drawLine(
            Offset(elemento.pontos[0].dx - (elemento.tamanho* cos(pi/4)), elemento.pontos[0].dy - (elemento.tamanho* sin(pi/4))),
            Offset(elemento.pontos[0].dx + (elemento.tamanho* cos(pi/4)), elemento.pontos[0].dy + (elemento.tamanho* sin(pi/4))),
            Paint()
            ..color = Colors.black
            ..strokeWidth = 3
          );
          canvas.drawLine(
            Offset(elemento.pontos[0].dx - (elemento.tamanho* cos(pi/4)), elemento.pontos[0].dy + (elemento.tamanho* sin(pi/4))),
            Offset(elemento.pontos[0].dx + (elemento.tamanho* cos(pi/4)), elemento.pontos[0].dy - (elemento.tamanho* sin(pi/4))),
            Paint()
            ..color = Colors.black
            ..strokeWidth = 3
          );

          if(elemento.texto != ""){
            TextSpan span = TextSpan(
              style: TextStyle(color: elemento.cor, fontSize: elemento.tamanho),
              text: elemento.texto,
            );
            TextPainter tp = TextPainter(
              text: span,
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
            );
            tp.layout();
            tp.paint(canvas, Offset(elemento.pontos[0].dx - (tp.width / 2), elemento.pontos[0].dy + elemento.tamanho + 5));
          }

          break;
        case TipoDesenho.circuloDesconhecido:
          // Circulo com um ponto de interrogação no meio
          canvas.drawCircle(
            elemento.pontos[0], 
            elemento.tamanho, 
            Paint()
            ..color = elemento.cor
            ..strokeWidth = 3
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

          if(elemento.texto != ""){
            TextSpan span = TextSpan(
              style: TextStyle(color: elemento.cor, fontSize: elemento.tamanho),
              text: elemento.texto,
            );
            TextPainter tp = TextPainter(
              text: span,
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
            );
            tp.layout();
            tp.paint(canvas, Offset(elemento.pontos[0].dx - (tp.width / 2), elemento.pontos[0].dy + elemento.tamanho + 5));
          }

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
            ..strokeWidth = 3
            ..style = PaintingStyle.stroke
          );

          if(elemento.isPaciente){
            // desenhar um quadrado maior em volta do circulo do paciente
            canvas.drawRect(
              Rect.fromCenter(
                center: elemento.pontos[0],
                width: elemento.tamanho*2 + 30,
                height: elemento.tamanho*2 + 30,
              ),
              Paint()
              ..color = elemento.cor
              ..strokeWidth = 3
              ..style = PaintingStyle.stroke
            );
          }

          if(elemento.texto != ""){
            TextSpan span = TextSpan(
              style: TextStyle(color: elemento.cor, fontSize: elemento.tamanho),
              text: elemento.texto,
            );
            TextPainter tp = TextPainter(
              text: span,
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
            );
            tp.layout();
            tp.paint(canvas, Offset(elemento.pontos[0].dx - (tp.width / 2), elemento.isPaciente ? elemento.pontos[0].dy + elemento.tamanho + 25  : elemento.pontos[0].dy + elemento.tamanho + 5));
          }

          break;
        case TipoDesenho.quadradoFalecido:
          //quadrado com um x no meio
          canvas.drawRect(
            Rect.fromCenter(
              center: elemento.pontos[0],
              width: elemento.tamanho*2,
              height: elemento.tamanho*2,
            ),
            Paint()
            ..color = elemento.cor
            ..strokeWidth = 3
            ..style = PaintingStyle.stroke
          );
          canvas.drawLine(
            Offset(elemento.pontos[0].dx - (elemento.tamanho), elemento.pontos[0].dy - (elemento.tamanho)),
            Offset(elemento.pontos[0].dx + (elemento.tamanho), elemento.pontos[0].dy + (elemento.tamanho)),
            Paint()
            ..color = Colors.black
            ..strokeWidth = 3
          );
          canvas.drawLine(
            Offset(elemento.pontos[0].dx - (elemento.tamanho), elemento.pontos[0].dy + (elemento.tamanho)),
            Offset(elemento.pontos[0].dx + (elemento.tamanho), elemento.pontos[0].dy - (elemento.tamanho)),
            Paint()
            ..color = Colors.black
            ..strokeWidth = 3
          );
          
          if(elemento.texto != ""){
            TextSpan span = TextSpan(
              style: TextStyle(color: elemento.cor, fontSize: elemento.tamanho),
              text: elemento.texto,
            );
            TextPainter tp = TextPainter(
              text: span,
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
            );
            tp.layout();
            tp.paint(canvas, Offset(elemento.pontos[0].dx - (tp.width / 2), elemento.pontos[0].dy + elemento.tamanho + 5));
          }
          break;
        case TipoDesenho.quadradoDesconhecido:
          // Quadrado com um ponto de interrogação no meio
          canvas.drawRect(
            Rect.fromCenter(
              center: elemento.pontos[0],
              width: elemento.tamanho*2,
              height: elemento.tamanho*2,
            ),
            Paint()
            ..color = elemento.cor
            ..strokeWidth = 3
            ..style = PaintingStyle.stroke
          );
          // ponto de interrogação no centro do quadrado
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

          if(elemento.texto != ""){
            TextSpan span = TextSpan(
              style: TextStyle(color: elemento.cor, fontSize: elemento.tamanho),
              text: elemento.texto,
            );
            TextPainter tp = TextPainter(
              text: span,
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
            );
            tp.layout();
            tp.paint(canvas, Offset(elemento.pontos[0].dx - (tp.width / 2), elemento.pontos[0].dy + elemento.tamanho + 5));
          }

          break;
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
        case TipoDesenho.texto:
          TextSpan span = TextSpan(
            style: TextStyle(color: elemento.cor, fontSize: elemento.tamanho * 2),
            text: elemento.texto,
          );
          TextPainter tp = TextPainter(
            text: span,
            textAlign: TextAlign.justify,
            textDirection: TextDirection.ltr,
          );
          tp.layout();
          tp.paint(canvas, elemento.pontos[0]);
          break;
        case TipoDesenho.linhaSeparacao:
          // desenha duas linhas na diagonal lado a lado
          // o ponto elemento.pontos[0] estará no centro das duas linhas
          canvas.drawLine(
            Offset(elemento.pontos[0].dx - 15, elemento.pontos[0].dy + 15), // DE BAIXO
            Offset(elemento.pontos[0].dx + 10, elemento.pontos[0].dy - 22.5), // DE CIMA
            Paint()
            ..color = elemento.cor
            ..strokeWidth = 2
          );

          canvas.drawLine(
            Offset(elemento.pontos[0].dx - 3.75, elemento.pontos[0].dy + 15), // DE BAIXO
            Offset(elemento.pontos[0].dx + 21.25, elemento.pontos[0].dy - 22.5), // DE CIMA
            Paint()
            ..color = elemento.cor
            ..strokeWidth = 2
          );

          break;
        case TipoDesenho.semDesenho:
          // TODO: Handle this case.
        case TipoDesenho.circuloEcomapa:
          // TODO: Handle this case.
        case TipoDesenho.linha:
          canvas.drawLine(
            elemento.pontos[0],
            elemento.pontos[1],
            Paint()
            ..color = elemento.cor
            ..strokeWidth = 2
          );
          break;
        case TipoDesenho.linhaPontilhada:
          // TODO: Handle this case.
        case TipoDesenho.seta:
          // TODO: Handle this case.
        case TipoDesenho.caneta:
          final path = Path();
          

          path.moveTo(elemento.pontos[0].dx, elemento.pontos[0].dy);
          
          for (int i = 1; i < elemento.pontos.length - 1; ++i) {
            final p0 = elemento.pontos[i];
            final p1 = elemento.pontos[i + 1];
            path.quadraticBezierTo(
              p0.dx,
              p0.dy,
              (p0.dx + p1.dx) / 2,
              (p0.dy + p1.dy) / 2,
            );
          }

          Paint paint = Paint()
            ..color = elemento.cor
            ..strokeCap = StrokeCap.round;


          paint.style = PaintingStyle.stroke;
          paint.strokeWidth = 2;

          canvas.drawPath(path, paint);

          break;
      }
    }
  }

  @override
  bool shouldRepaint(covariant QuadroBrancoGenogramaPainter oldDelegate) {
    return listEquals(genograma, oldDelegate.genograma);
  }

}