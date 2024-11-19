import 'package:acolherconsultas/modules/casasDeApoio/models/casaDeApoio.dart';
import 'package:acolherconsultas/modules/consultas/models/consulta.dart';
import 'package:acolherconsultas/shared/colors.dart';
import 'package:acolherconsultas/shared/components/bars/homeAppbar.dart';
import 'package:acolherconsultas/shared/components/lineChart.dart';
import 'package:acolherconsultas/shared/components/list/listaHorarios.dart';
import 'package:acolherconsultas/shared/components/tabela.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Sumario extends StatefulWidget {
  const Sumario({super.key});

  @override
  State<Sumario> createState() => _SumarioState();
}

class _SumarioState extends State<Sumario> {
  // Responsavel por tornar o loadConsultas como assincrono, trazendo os dados corretamente
  late List<ConsultaCadastro> consultasDia = [];
  bool _isExpandedTabela = false;
  bool _isExpandedGrafico = false;

  void loadConsultas(){
    consultasDia = Provider.of<List<ConsultaCadastro>>(context).where((element) =>
      element.dataHorario.day == DateTime.now().day &&
      element.casaDeApoioId == Provider.of<CasaDeApoio>(context).id
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    loadConsultas();
    final casaDeApoioListener=Provider.of<CasaDeApoio>(context);

    return Scaffold(
      appBar: const HomeAppbar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: kBottomNavigationBarHeight),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              // Grafico
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Color(casaDeApoioListener.cor ?? Colors.blue.value).withOpacity(0.7),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isExpandedGrafico = !_isExpandedGrafico;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 7),
                            child: Text(
                              "Frequência de consultas",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Icon(
                            _isExpandedGrafico ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: _isExpandedGrafico
                        ? Padding(
                            padding: const EdgeInsets.only(left: 7, right: 7, bottom: 5, top: 3),
                            child: ConsultasLineChart(
                              casaDeApoioSelecionada: casaDeApoioListener,
                            ),
                          )
                        : const SizedBox.shrink(), // Placeholder para manter o tamanho vazio.
                    ),
                  ],
                ),
              ),
              // Tabela
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Color(casaDeApoioListener.cor ?? Colors.blue.value).withOpacity(0.7),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isExpandedTabela = !_isExpandedTabela;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 7),
                            child: Text(
                              "Tabela de consultas",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Icon(
                            _isExpandedTabela ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: _isExpandedTabela
                        ? Padding(
                          padding: const EdgeInsets.only(left: 7, right: 7, bottom: 5, top: 3),
                          child: casaDeApoioListener.id!=null ? ConsultasTabela(
                            casaDeApoioSelecionada: casaDeApoioListener,
                          ): const SizedBox(),
                        )
                        : const SizedBox.shrink(), // Placeholder para manter o tamanho vazio.
                    ),
                  ],
                ),
              ),
              // Consultas hoje
              Container(
                decoration: BoxDecoration(
                  color: Color(casaDeApoioListener.cor??azul.value).withOpacity(0.7),
                  borderRadius: BorderRadius.circular(16)
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 7),
                      child: Text(
                        "Consultas hoje",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5,bottom: 5,top: 3),
                      child: ListaHorario(consultasDoDia: consultasDia, fundo: true,),
                    ),
                  ],
                ),
              )
            ]
          )
        ),
      )
    );
  }
}