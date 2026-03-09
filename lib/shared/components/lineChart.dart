import 'dart:math';

import 'package:acolherconsultas/modules/casasDeApoio/models/casaDeApoio.dart';
import 'package:acolherconsultas/modules/consultas/models/consulta.dart';
import 'package:acolherconsultas/shared/colors.dart';
import "package:collection/collection.dart";
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ConsultasLineChart extends StatefulWidget {
  const ConsultasLineChart({super.key, required this.casaDeApoioSelecionada});
  final CasaDeApoio casaDeApoioSelecionada;

  @override
  State<ConsultasLineChart> createState() => _ConsultasLineChartState();
}

class _ConsultasLineChartState extends State<ConsultasLineChart> {
  // Data de hoje
  DateTime endDate = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  late DateTime startDate;

  // Intervalo da legenda do eixo x do gráfico de acordo com a quantidade de dias
  Map<int, double> intervalGraph = { 10: 1.5, 11: 1.7, 12: 1.9, 13: 2.0, 14: 2.2, 15: 2.4, 16: 2.5, 17: 2.7, 18: 2.9, 19: 3.0, 20: 3.2, 21: 3.4, 22: 3.5, 23: 3.7, 24: 3.9, 25: 4.1, 26: 4.3, 27: 4.5, 28: 4.7, 29: 4.7,};
  late ValueNotifier<List<FlSpot>> displayedData;
  late Map<DateTime,double> consultasPdia = {};
  String dropdownValue = 'Mensal';

  @override
  void initState() {
    super.initState();
    displayedData = ValueNotifier([]);
    startDate = DateTime(endDate.year, endDate.month, 1);
  }

  void loadConsultas(){
    // Mapeia as consultas do banco em quantidade por dia
    consultasPdia = Provider.of<List<ConsultaCadastro>>(context)
      .where((element) => 
        element.dataHorario.isAfter(startDate) && 
        element.dataHorario.isBefore(endDate) &&
        element.estado == "concluida" &&
        element.casaDeApoioId == widget.casaDeApoioSelecionada.id)
      .sorted((a, b) => a.dataHorario.compareTo(b.dataHorario))
      .groupListsBy((element) => DateTime(element.dataHorario.year, element.dataHorario.month, element.dataHorario.day))
      .map((key, value) => MapEntry(key, value.length.toDouble()));
      
    Map<DateTime, double> consultas={};
    consultas=consultasPdia;
    consultas.removeWhere((key, value) => key.isBefore(startDate));

    int numberOfDays = endDate.difference(startDate).inDays + 2;
    var displayedDias = List.generate(numberOfDays, (index) => startDate.add(Duration(days: index)));

    List<FlSpot> listaTemp = [];
    int counter = 0;
    // Transforma map em lista de pontos, adicionando dias não presentes como 0
    for (var element in displayedDias) {
      listaTemp.add(FlSpot(counter.toDouble(), consultas[element]??0));
      counter++;
    }

    // Reseta os dados carregados
    displayedData.value.clear();
    displayedData.value=listaTemp;
  }

  void updateDisplayedData() {
    setState(() {
      var mesAtual = endDate.month;
      switch (dropdownValue) {
        case 'Mensal':
          startDate = DateTime(endDate.year, endDate.month, 1);
          break;
        case 'Semestral':
          if(endDate.month > 6) {
            startDate = DateTime(endDate.year, mesAtual - 6, endDate.day);
          } else {
            startDate = DateTime(endDate.year, 1, 1);
          }
          break;
        case 'Anual':
          startDate = DateTime(endDate.year, 1, 1);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    loadConsultas();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8)
      ),
      padding: const EdgeInsets.only(right: 20,top: 4,bottom: 12),
      child: Column(
        children: [
          // Titulo e dropdown
          Padding(
            padding: const EdgeInsets.only(bottom: 8,left: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Período:",
                  style: TextStyle(fontSize: 22),
                ),
                // Dropdown que controla o período
                DropdownButton<String>(
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Color(widget.casaDeApoioSelecionada.cor??azul.value),
                  ),
                  style: const TextStyle(
                    fontFamily: "Montserrat",
                    color: Colors.black,
                    fontSize: 20,
                  ),
                  alignment: AlignmentDirectional.center,
                  dropdownColor: branco,
                  underline: const SizedBox(),
                  // underline: Divider(
                  //   color: Color(widget.casaDeApoioSelecionada.cor??azul.value),
                  //   height: 4,
                  // ),
                  padding: const EdgeInsets.only(left: 8),
                  elevation: 5,
                  value: dropdownValue,
                  // Atualiza o estado dropdownValue
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                      updateDisplayedData();
                    });
                  },
                  items: <String>['Mensal','Semestral','Anual'].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Center(child: Text(value)),
                    );
                  }).toList(),
                  borderRadius: BorderRadius.circular(8),
                )
              ],
            ),
          ),
          // Grafico
          ValueListenableBuilder<List<FlSpot>>(
            valueListenable: displayedData,
            builder: (context, data, child) {
              return AspectRatio(
                // Mantem a proporção do gráfico
                aspectRatio: 1.4,
                // Grafico
                child: LineChart(
                  // Retira a animação, pq é bugada
                  duration: Duration.zero,
                  LineChartData(
                    // Funções das linhas do gráfico
                    gridData: FlGridData(
                      // Desenha linhas horizontais fixas
                      getDrawingHorizontalLine: (value) => const FlLine(
                        color: Color(0xFFAAAAAA),
                        strokeWidth: 1                    
                      ),
                      // Coloca o intervalo de cada linha em 1 unidade
                      horizontalInterval: 1,
                      // Remove as linhas verticais
                      drawVerticalLine: false
                    ),
                    // Define o máximo do gráfico como o teto do maior valor da lista + 10%
                    maxY: data.map((e) => e.y).reduce(max)+(0.1*data.map((e) => e.y).reduce(max)).ceil(),
                    // Define o comportamento ao encostar no gráfico (Mostra a quantidade daquele ponto)
                    lineTouchData: LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        tooltipBorder: const BorderSide(color: Colors.black),
                        getTooltipItems: (touchedSpots) => 
                                [
                                  LineTooltipItem(
                                    "${DateFormat('dd/MM', "pt_BR").format(endDate.subtract(Duration(days: data.length - touchedSpots.first.x.toInt() - 1)))} - ${touchedSpots.first.y.toStringAsFixed(0)}", 
                                    TextStyle(
                                      color: Color(widget.casaDeApoioSelecionada.cor ?? azul.value).withOpacity(.7), 
                                      fontSize: 14
                                    )
                                  ),
                                ],
                        getTooltipColor: (touchedSpot) => Colors.white,
                        tooltipPadding: const EdgeInsets.symmetric(vertical: 2,horizontal: 8)
                      )
                    ),
                    // Define os titulos dos eixos
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      // Legenda da esquerda
                      leftTitles:  AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          // Define que o titulo será vazio quando for 0
                          getTitlesWidget: (value, meta) {
                            return SideTitleWidget(
                              axisSide: AxisSide.bottom,
                              child: Text(
                                value==0?"":value.toStringAsFixed(0),
                                style: const TextStyle(fontSize: 12),
                              )
                            );
                          },
                        )
                      ),
                      // Legenda de baixo
                      bottomTitles: AxisTitles(
                        sideTitles:  SideTitles(
                          interval: 1,
                          showTitles: true,
                          // Define a legenda de baixo baseado nos dias carregados
                          getTitlesWidget: (value,meta) {
                            String label = "";
                            if(data.length <= 5){
                              label = dropdownValue == "Mensal" ? 
                                  DateFormat('dd/MM', "pt_BR").format(endDate.subtract(Duration(days: data.length - value.toInt() - 1))):
                                  dropdownValue == "Semestral" ?
                                  // Cada um dos meses no intervalo dado
                                  DateFormat('MMM', "pt_BR").format(endDate.subtract(Duration(days: data.length - value.toInt() - 1))):
                                  // Cada um dos meses no intervalo dado
                                  DateFormat('MMM', "pt_BR").format(endDate.subtract(Duration(days: data.length - value.toInt() - 1)));
                            } else {
                              int porcentagem25 = ((data.length - 1)*0.25).toInt();
                              int porcentagem50 = ((data.length - 1)*0.5).toInt();
                              int porcentagem75 = ((data.length - 1)*0.75).toInt();
                              if(value == data[0].x || value == data[porcentagem25].x || value == data[porcentagem50].x || value == data[porcentagem75].x || value == data[data.length-1].x){
                                label = dropdownValue == "Mensal" ? 
                                  DateFormat('dd/MM', "pt_BR").format(endDate.subtract(Duration(days: data.length - value.toInt() - 1))):
                                  dropdownValue == "Semestral" ?
                                  // Cada um dos meses no intervalo dado
                                  DateFormat('MMM', "pt_BR").format(endDate.subtract(Duration(days: data.length - value.toInt() - 1))):
                                  // Cada um dos meses no intervalo dado
                                  DateFormat('MMM', "pt_BR").format(endDate.subtract(Duration(days: data.length - value.toInt() - 1)));
                              } else {
                                label = "";
                              }
                            }

                            return SideTitleWidget(
                              axisSide: AxisSide.bottom,
                              fitInside: const SideTitleFitInsideData(
                                enabled: false, 
                                axisPosition: 2, 
                                parentAxisSize: 0, 
                                distanceFromEdge: 0
                              ),
                              child: Text(
                                label.isNotEmpty ? "${label[0].toUpperCase()}${label.substring(1)}" : label,
                                style: const TextStyle(fontSize: 12),
                              ),
                            );
                          },
                        )
                      ),
                    ),
                    //Define a barra do gráfico
                    lineBarsData: [
                      LineChartBarData(
                        isStrokeCapRound: true,
                        color: Color(widget.casaDeApoioSelecionada.cor??azul.value).withOpacity(0.7),
                        // Usa os dias carregados como dados para criar os pontos
                        spots: data,
                        // Não mostra os pontos
                        dotData: const FlDotData(show: false),
                        // Define tracejado que vai até o ponto
                        belowBarData: BarAreaData(
                          color: Colors.transparent,
                          show: true,
                          spotsLine: const BarAreaSpotsLine(
                            show: true,
                            flLineStyle: FlLine(color: Colors.black, strokeWidth: 1, dashArray: [2,2])
                          )
                        )
                      ),
                    ],
                  )
                ),
              );
            }
          )
        ],
      ),
    );
  }
}