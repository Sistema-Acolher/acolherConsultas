import 'package:acolherconsultas/modules/casasDeApoio/models/casaDeApoio.dart';
import 'package:acolherconsultas/modules/consultas/models/consulta.dart';
import 'package:acolherconsultas/shared/colors.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ConsultasTabela extends StatefulWidget {
  final CasaDeApoio casaDeApoioSelecionada;

  const ConsultasTabela({super.key, required this.casaDeApoioSelecionada});

  @override
  State<ConsultasTabela> createState() => _ConsultasTabelaState();
}

class _ConsultasTabelaState extends State<ConsultasTabela> {
  late DateTime startDate;
  late DateTime endDate;
  late Map<DateTime, int> consultasPdia ={};
  String periodoSelecionado = 'Mensal';

  @override
  void initState() {
    super.initState();
    definirPeriodo(periodoSelecionado);
  }

  void loadConsultasPorPeriodo() {
    // Filtra e agrupa consultas do banco
    consultasPdia = Provider.of<List<ConsultaCadastro>>(context)
        .where((consulta) =>
            consulta.dataHorario.isAfter(startDate) &&
            consulta.dataHorario.isBefore(endDate) &&
            consulta.estado == "concluida" &&
            consulta.casaDeApoioId == widget.casaDeApoioSelecionada.id)
        .sorted((a, b) => a.dataHorario.compareTo(b.dataHorario))
        .groupListsBy(
          (consulta) => DateTime(consulta.dataHorario.year, consulta.dataHorario.month, consulta.dataHorario.day),
        )
        .map((key, value) => MapEntry(key, value.length));

    // Adiciona dias sem consultas como 0
    int numberOfDays = endDate.difference(startDate).inDays + 1;
    var displayedDias = List.generate(numberOfDays, (index) => startDate.add(Duration(days: index)));

    consultasPdia = {for (var dia in displayedDias) dia: consultasPdia[dia] ?? 0};
  }
  
  List<Map<String, String>> agruparConsultas(Map<DateTime, int> consultasPdia) {
    List<DateTime> dias = consultasPdia.keys.toList()..sort();

    List<Map<String, String>> tabela = [];
    DateTime? inicio;
    DateTime? fim;
    int? consultasNoPeriodo;

    for (var dia in dias) {
      int consultasDia = consultasPdia[dia]!;
      if (inicio == null || consultasDia != consultasNoPeriodo) {
        if (inicio != null) {
          tabela.add({
            'intervalo': formatarIntervalo(inicio, fim!),
            'quantidade': '$consultasNoPeriodo consultas',
          });
        }
        inicio = dia;
        consultasNoPeriodo = consultasDia;
      }
      fim = dia;
    }

    if (inicio != null) {
      tabela.add({
        'intervalo': formatarIntervalo(inicio, fim!),
        'quantidade': '$consultasNoPeriodo consultas',
      });
    }

    return tabela;
  }

  String formatarIntervalo(DateTime inicio, DateTime fim) {
    final formatter = DateFormat('dd/MM');
    if (inicio == fim) {
      return formatter.format(inicio);
    } else {
      return '${formatter.format(inicio)}-${formatter.format(fim)}';
    }
  }

  void definirPeriodo(String periodo) {
    DateTime hoje = DateTime.now();
    switch (periodo) {
      case 'Mensal':
        startDate = DateTime(hoje.year, hoje.month, 1);
        endDate = DateTime(hoje.year, hoje.month + 1, 0);
        break;
      case 'Semestral':
        int semestreAtual = (hoje.month - 1) ~/ 6;
        startDate = DateTime(hoje.year, semestreAtual * 6 + 1, 1);
        endDate = DateTime(hoje.year, (semestreAtual + 1) * 6, 0);
        break;
      case 'Anual':
        startDate = DateTime(hoje.year, 1, 1);
        endDate = DateTime(hoje.year, 12, 31);
        break;
    }
    setState(() { });
  }

  @override
  Widget build(BuildContext context) {
    loadConsultasPorPeriodo();
    List<Map<String, String>> tabelaConsultas = agruparConsultas(consultasPdia);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8)
      ),
      padding: const EdgeInsets.only(top: 4,left: 10,right: 10,bottom: 1),
      child: Center(
        child: IntrinsicHeight(
          child: Column(
            children: [
              // Titulo e dropdown
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
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
                      padding: const EdgeInsets.only(left: 8),
                      elevation: 5,
                      value: periodoSelecionado,
                      // Atualiza o estado dropdownValue
                      onChanged: (novoPeriodo) {
                        if (novoPeriodo != null) {
                          periodoSelecionado = novoPeriodo;
                          definirPeriodo(novoPeriodo);
                        }
                      },
                      items: ['Mensal', 'Semestral', 'Anual']
                          .map((periodo) => DropdownMenuItem(value: periodo, child: Text(periodo)))
                          .toList(),
                      borderRadius: BorderRadius.circular(8),
                    )
                  ],
                ),
              ),
              // Separador
              const Divider(height: 1,color: preto,),
              // Container
              SizedBox(
                width: double.infinity,
                child: DataTable(
                  dataRowHeight: 35,
                  headingRowHeight: 30,
                  horizontalMargin: 10, // Minimizes margin around cells
                  columnSpacing: 60, // Minimizes space between columns
                  columns: const [
                    DataColumn(label: Text('Dia(s)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                    DataColumn(label: Text('Quantidade', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                  ],
                  rows: tabelaConsultas
                      .map(
                        (linha) => DataRow(
                          cells: [
                            DataCell(Text(linha['intervalo'] ?? '', style: const TextStyle(fontSize: 12))),
                            DataCell(Text(linha['quantidade'] ?? '', style: const TextStyle(fontSize: 12))),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
