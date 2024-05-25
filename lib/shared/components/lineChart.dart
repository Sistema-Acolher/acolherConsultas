import 'dart:math';

import "package:collection/collection.dart";
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:acolherconsultas/modules/consultas/controllers/consultaController.dart';

class ConsultasLineChart extends StatefulWidget {
  const ConsultasLineChart({super.key});

  @override
  State<ConsultasLineChart> createState() => _ConsultasLineChartState();
}

class _ConsultasLineChartState extends State<ConsultasLineChart> {
  // Data de hoje
  DateTime endDate = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  // Intervalo da legenda do eixo x do gráfico de acordo com a quantidade de dias
  Map<int, double> intervalGraph = { 10: 1.5, 11: 1.7, 12: 1.9, 13: 2.0, 14: 2.2, 15: 2.4, 16: 2.5, 17: 2.7, 18: 2.9, 19: 3.0, 20: 3.2, 21: 3.4, 22: 3.5, 23: 3.7, 24: 3.9, 25: 4.1, 26: 4.3, 27: 4.5, 28: 4.7, 29: 4.7,};
  late ValueNotifier<List<FlSpot>> displayedData;
  late Map<DateTime,double> consultasPdia;
  String dropdownValue = '7 dias';

  @override
  void initState() {
    super.initState();
    displayedData = ValueNotifier([]);
    updateDisplayedData();
  }

  void loadConsultas(int diasAtras){
    DateTime startDate = endDate.subtract(Duration(days: diasAtras));
    // Mapeia as consultas do banco em quantidade por dia
    consultasPdia = Provider.of<ConsultaController>(context, listen: false).consultas
      .where((element) => 
        element.dataHorario.isAfter(startDate) && 
        element.dataHorario.isBefore(endDate) &&
        element.estado == "concluida")
      .sorted((a, b) => a.dataHorario.compareTo(b.dataHorario))
      .groupListsBy((element) => DateTime.utc(element.dataHorario.year,element.dataHorario.month,element.dataHorario.day))
      .map((key, value) => MapEntry(key, value.length.toDouble()));
      
    Map<DateTime, double> consultas={};
    consultas=consultasPdia;
    consultas.removeWhere((key, value) => key.isBefore(startDate));

    int numberOfDays = endDate.difference(startDate).inDays;
    var displayedDias = List.generate(numberOfDays, (index) => startDate.add(Duration(days: index)));

    List<FlSpot> listaTemp = [];
    double counter = 0;
    // Transforma map em lista de pontos, adicionando dias não presentes como 0
    for (var element in displayedDias) {
      listaTemp.add(FlSpot(counter, consultas[element]??0));
      counter++;
    }
    // Reseta os dados carregados
    displayedData.value.clear();
    displayedData.value=listaTemp;
  }

  void updateDisplayedData() {
    setState(() {
      switch (dropdownValue) {
        case 'Mês Atual':
          loadConsultas(DateTime.now().day-1);
          break;
        case '30 dias':
          loadConsultas(30);
          break;
        case '90 dias':
          loadConsultas(90);
          break;
        case '7 dias':
          loadConsultas(7);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8)
      ),
      padding: const EdgeInsets.only(right: 20,top: 4,bottom: 4),
      child: Column(
        children: [
          // Titulo e dropdown
          Padding(
            padding: const EdgeInsets.only(bottom: 8,left: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Período:",
                  style: TextStyle(fontSize: 22),
                ),
                // Dropdown que controla o período
                DropdownButton<String>(
                  style: const TextStyle(fontFamily: "Montserrat",color: Colors.black,fontSize: 20),
                  underline: const Divider(height: 5),
                  padding: const EdgeInsets.only(left: 8,top: 2),
                  isDense: true,
                  elevation: 5,
                  value: dropdownValue,
                  // Atualiza o estado dropdownValue
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                      updateDisplayedData();
                    });
                  },
                  items: <String>['7 dias','30 dias','90 dias','Mês Atual'].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                )
              ],
            ),
          ),
          ValueListenableBuilder<List<FlSpot>>(
            valueListenable: displayedData,
            builder: (context,data,child) {
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
                        getTooltipItems: (touchedSpots) => [LineTooltipItem(touchedSpots.first.y.toStringAsFixed(0), const TextStyle(color: Color(0xFF004AAD), fontSize: 14))],
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
                          interval: data.length>30?15:data.length>=10?intervalGraph[data.length]:1,
                          showTitles: true,
                          // Define a legenda de baixo baseado nos dias carregados
                          getTitlesWidget: (value,meta) {
                            return SideTitleWidget(
                              axisSide: AxisSide.bottom,
                              child: 
                                Text(DateFormat('dd/MM').format(endDate.subtract(Duration(days: data.length - value.toInt()))),
                                style: const TextStyle(fontSize: 12),
                              )
                            );
                          },
                        )
                      ),
                    ),
                    //Define a barra do gráfico
                    lineBarsData: [
                      LineChartBarData(
                        isStrokeCapRound: true,
                        color: const Color(0xFF004AAD),
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