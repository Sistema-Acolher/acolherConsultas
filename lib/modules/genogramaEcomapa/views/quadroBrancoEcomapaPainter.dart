import 'dart:math';

import 'package:acolherconsultas/modules/genogramaEcomapa/models/elementosDesenho.dart';
import 'package:acolherconsultas/modules/genogramaEcomapa/models/tipoDesenho.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class QuadroBrancoEcomapaPainter extends CustomPainter {
  final List<ElementosDesenho> ecomapa;

  QuadroBrancoEcomapaPainter({
    required this.ecomapa,
  });

  bool isPointInCircle(Offset point, Offset center, double radius) {
    final dx = point.dx - center.dx;
    final dy = point.dy - center.dy;
    return (dx * dx + dy * dy) <= (radius * radius);
  }

  @override
  void paint(Canvas canvas, Size size) {
    for(ElementosDesenho elemento in ecomapa){
      switch(elemento.tipo){
        case TipoDesenho.circuloEcomapa:
          //circulo com um texto no meio
          canvas.drawCircle(
            elemento.pontos[0], 
            elemento.tamanho, 
            Paint()
            ..color = elemento.cor
            ..strokeWidth = 2
            ..style = PaintingStyle.stroke
          );

          TextSpan span = TextSpan(
            style: TextStyle(color: elemento.cor, fontSize: elemento.tamanho / 4),
            text: elemento.texto,
          );
          TextPainter tp = TextPainter(
            text: span,
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
            maxLines: 4
          );
          tp.layout(maxWidth: elemento.tamanho * 1.6);
          //centralizar o texto
          tp.paint(canvas, Offset(elemento.pontos[0].dx - tp.width/2, elemento.pontos[0].dy - tp.height/2));

          // desenhar a linha de ligação com o centro do quadro
          // essa linha começa na borda do circulo e vai até a borda do circulo central
          final centerX = size.width / 2;
          final centerY = size.height / 2;
          final angulo = atan2(elemento.pontos[0].dy - centerY, elemento.pontos[0].dx - centerX);
          final pontoCirculoNovo = Offset(elemento.pontos[0].dx - elemento.tamanho * cos(angulo), elemento.pontos[0].dy - elemento.tamanho * sin(angulo));

          final raio = elemento.tamanho;

          final pontoCirculoCentral = Offset(
            centerX + raio * cos(angulo) + 2,
            centerY + raio * sin(angulo) + 2,
          );

          if(!elemento.isPaciente){
            if(elemento.ligacao != "fraca"){
              canvas.drawLine(
                pontoCirculoCentral,
                pontoCirculoNovo,
                Paint()
                ..color = elemento.cor
                ..strokeWidth = elemento.ligacao == "media" ? 2 : 6
              );
            } else {
              // desenhar uma linha tracejada com ponto, linha, ponto, linha
              final double distancia = (pontoCirculoNovo - pontoCirculoCentral).distance;
              final double angulo = atan2(pontoCirculoNovo.dy - pontoCirculoCentral.dy, pontoCirculoNovo.dx - pontoCirculoCentral.dx);
              const double espaco = 5;
              const double tamanhoPonto = .5;
              for (double i = 0; i <= distancia; i += espaco) {
                // para i's impares desenhar um ponto
                // para i's pares desenhar uma linha
                if(i % (2 * espaco) != 0){
                  // colocar o ponto no meio do espaço
                  final ponto = Offset(pontoCirculoCentral.dx + (i + espaco * 1.5) * cos(angulo), pontoCirculoCentral.dy + (i + espaco * 1.5) * sin(angulo));
                  if(!isPointInCircle(ponto, Offset(centerX, centerY), raio) && !isPointInCircle(ponto, elemento.pontos[0], raio)){
                    canvas.drawCircle(
                      ponto,
                      tamanhoPonto,
                      Paint()
                      ..color = elemento.cor
                      ..strokeWidth = 1
                    );
                  }
                } else {
                  // saltar um espaço para desenhar a linha
                  final ponto1 = Offset(pontoCirculoCentral.dx + (i - espaco) * cos(angulo), pontoCirculoCentral.dy + (i - espaco) * sin(angulo));
                  final ponto2 = Offset(pontoCirculoCentral.dx + i * cos(angulo), pontoCirculoCentral.dy + i * sin(angulo));
                  // se o ponto1 ou ponto2 estiverem contidos na área total do circulo central, nao desenhar a linha
                  if (!isPointInCircle(ponto1, Offset(centerX, centerY), raio) &&
                          !isPointInCircle(ponto2, elemento.pontos[0], raio)){
                    canvas.drawLine(
                      ponto1,
                      ponto2,
                      Paint()
                      ..color = elemento.cor
                      ..strokeWidth = 1
                    );
                  }
                }

                
              }
              
            }

            final double forcaEnergiaPaciente = 
              elemento.energiaGastaPaciente == "fraca" ? 0.2 
              : elemento.energiaGastaPaciente == "media" ? 0.6 
              : 0.95;
            
            final double forcaEnergiaParte = 
              elemento.energiaGastaParte == "fraca" ? 0.2
              : elemento.energiaGastaParte == "media" ? 0.6 
              : 0.95;

            // adicionar duas linhas paralelas à linha de ligação para indicar a energia gasta pelo paciente
            // ambas com uma seta no final apontando para o circulo
            // o tamanho da linha é proporcional à força da energia

            const double distancia = 20;
            final double angulo = atan2(pontoCirculoNovo.dy - pontoCirculoCentral.dy, pontoCirculoNovo.dx - pontoCirculoCentral.dx);
            
            // pontos de energia do paciente, um na borda do circulo do paciente e outro a uma distancia proporcional à força da energia
            final Offset pontoEnergiaPaciente1 = Offset(
              pontoCirculoCentral.dx + distancia * cos(angulo + pi / 2),
              pontoCirculoCentral.dy + distancia * sin(angulo + pi / 2)
            );

            final Offset pontoEnergiaParte2 = Offset(
              pontoCirculoNovo.dx + distancia * cos(angulo - pi / 2), 
              pontoCirculoNovo.dy + distancia * sin(angulo - pi / 2)
            );

            // pontoEnergiaPaciente2 deve ser movido radialmente de acordo com a força da energia do paciente
            final Offset pontoEnergiaPaciente2 = Offset(
              pontoCirculoCentral.dx + (pontoCirculoNovo.dx - pontoCirculoCentral.dx) * forcaEnergiaPaciente + distancia * cos(angulo + pi / 2),
              pontoCirculoCentral.dy + (pontoCirculoNovo.dy - pontoCirculoCentral.dy) * forcaEnergiaPaciente + distancia * sin(angulo + pi / 2)
            );

            // pontoEnergiaParte1 deve ser movido radialmente de acordo com a força da energia da parte
            final Offset pontoEnergiaParte1 = Offset(
              pontoCirculoNovo.dx + (pontoCirculoCentral.dx - pontoCirculoNovo.dx) * forcaEnergiaParte + distancia * cos(angulo - pi / 2),
              pontoCirculoNovo.dy + (pontoCirculoCentral.dy - pontoCirculoNovo.dy) * forcaEnergiaParte + distancia * sin(angulo - pi / 2)
            );

            canvas.drawLine(
              pontoEnergiaPaciente1,
              pontoEnergiaPaciente2,
              Paint()
              ..color = elemento.cor
              ..strokeWidth = 1
            );

            canvas.drawLine(
              pontoEnergiaParte1,
              pontoEnergiaParte2,
              Paint()
              ..color = elemento.cor
              ..strokeWidth = 1
            );

            // desenhar a seta apontando para o circulo correspondente
            final double anguloSeta = atan2(pontoEnergiaPaciente1.dy - pontoEnergiaPaciente2.dy, pontoEnergiaPaciente1.dx - pontoEnergiaPaciente2.dx);
            const double tamanhoSeta = 10;
            final Offset pontoSeta1 = Offset(
              pontoEnergiaPaciente2.dx + tamanhoSeta * cos(anguloSeta + pi / 6),
              pontoEnergiaPaciente2.dy + tamanhoSeta * sin(anguloSeta + pi / 6)
            );

            final Offset pontoSeta2 = Offset(
              pontoEnergiaPaciente2.dx + tamanhoSeta * cos(anguloSeta - pi / 6),
              pontoEnergiaPaciente2.dy + tamanhoSeta * sin(anguloSeta - pi / 6)
            );

            canvas.drawLine(
              pontoEnergiaPaciente2,
              pontoSeta1,
              Paint()
              ..color = elemento.cor
              ..strokeWidth = 1
            );

            canvas.drawLine(
              pontoEnergiaPaciente2,
              pontoSeta2,
              Paint()
              ..color = elemento.cor
              ..strokeWidth = 1
            );

            // desenhar a seta apontando para o circulo correspondente

            final double anguloSetaParte = atan2(pontoEnergiaParte2.dy - pontoEnergiaParte1.dy, pontoEnergiaParte2.dx - pontoEnergiaParte1.dx);
            final Offset pontoSetaParte1 = Offset(
              pontoEnergiaParte1.dx + tamanhoSeta * cos(anguloSetaParte + pi / 6),
              pontoEnergiaParte1.dy + tamanhoSeta * sin(anguloSetaParte + pi / 6)
            );

            final Offset pontoSetaParte2 = Offset(
              pontoEnergiaParte1.dx + tamanhoSeta * cos(anguloSetaParte - pi / 6),
              pontoEnergiaParte1.dy + tamanhoSeta * sin(anguloSetaParte - pi / 6)
            );

            canvas.drawLine(
              pontoEnergiaParte1,
              pontoSetaParte1,
              Paint()
              ..color = elemento.cor
              ..strokeWidth = 1
            );

            canvas.drawLine(
              pontoEnergiaParte1,
              pontoSetaParte2,
              Paint()
              ..color = elemento.cor
              ..strokeWidth = 1
            );
          }

          break;
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
          paint.strokeWidth = 3;

          canvas.drawPath(path, paint);

          break;
        case TipoDesenho.texto:
          TextSpan span = TextSpan(
            style: TextStyle(color: elemento.cor, fontSize: elemento.tamanho),
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
        case TipoDesenho.linha:
          
          break;
        case TipoDesenho.linhaPontilhada:
          
          break;
        case TipoDesenho.seta:
          
          break;
        case TipoDesenho.circulo:
          break;
        case TipoDesenho.circuloFalecido:
          //circulo com um x no meio
          break;
        case TipoDesenho.circuloDesconhecido:
          // Circulo com um ponto de interrogação no meio
          break;
        case TipoDesenho.quadrado:
          break;
        case TipoDesenho.quadradoFalecido:
        case TipoDesenho.quadradoDesconhecido:
        case TipoDesenho.linhaHorizontal:
          break;
        case TipoDesenho.linhaVertical:
          break;
        case TipoDesenho.linhaSeparacao:
          // TODO: Handle this case.
        case TipoDesenho.semDesenho:
          // TODO: Handle this case.
      }
    }
  }

  @override
  bool shouldRepaint(covariant QuadroBrancoEcomapaPainter oldDelegate) {
    return listEquals(ecomapa, oldDelegate.ecomapa);
  }

}