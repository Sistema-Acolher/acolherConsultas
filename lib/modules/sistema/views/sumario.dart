import 'package:acolherconsultas/modules/consultas/controllers/consultaController.dart';
import 'package:acolherconsultas/shared/components/bars/homeAppbar.dart';
import 'package:acolherconsultas/shared/components/lineChart.dart';
import 'package:acolherconsultas/shared/components/list/listaHorarios.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Sumario extends StatefulWidget {
  final int cor;
  const Sumario({super.key, this.cor = 0xFF2277AE});

  @override
  State<Sumario> createState() => _SumarioState();
}

class _SumarioState extends State<Sumario> {
  @override
  void initState() {
    context.read<ConsultaController>().getConsultas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var consultasDia = Provider.of<ConsultaController>(context).consultas.where((element) => element.dataHorario.day==DateTime.now().day).toList();
    return Scaffold(
      appBar: const HomeAppbar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 50),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Color(widget.cor),
                  borderRadius: BorderRadius.circular(16)
                ),
                padding: const EdgeInsets.all(8),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Frequência de consultas",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 7, right: 7,bottom: 5,top: 3),
                      child: ConsultasLineChart(),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color(widget.cor),
                  borderRadius: BorderRadius.circular(16)
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Consultas hoje",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                        fontSize: 18
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