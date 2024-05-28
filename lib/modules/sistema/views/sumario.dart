import 'package:acolherconsultas/modules/casasDeApoio/controller/casaDeApoioController.dart';
import 'package:acolherconsultas/modules/consultas/controllers/consultaController.dart';
import 'package:acolherconsultas/modules/consultas/models/consulta.dart';
import 'package:acolherconsultas/shared/colors.dart';
import 'package:acolherconsultas/shared/components/bars/homeAppbar.dart';
import 'package:acolherconsultas/shared/components/lineChart.dart';
import 'package:acolherconsultas/shared/components/list/listaHorarios.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Sumario extends StatefulWidget {
  const Sumario({super.key});

  @override
  State<Sumario> createState() => _SumarioState();
}

class _SumarioState extends State<Sumario> {
  // Responsavel por tornar o loadConsultas como assincrono, trazendo os dados corretamente
  late Future<void> _loadConsultasFuture;
  late List<Consulta> consultasDia;

  @override
  void initState() {
    super.initState();
    _loadConsultasFuture = loadConsultas();
  }

  Future<void> loadConsultas() async{
    await context.read<ConsultaController>().getConsultas();
    consultasDia = Provider.of<ConsultaController>(context,listen: false).consultas.where((element) => 
      element.dataHorario.day == DateTime.now().day &&
      element.casaDeApoioId == Provider.of<CasaDeApoioController>(context,listen: false).casaDeApoioSelecionada.value.id
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppbar(),
      body: ValueListenableBuilder(
          valueListenable: context.read<CasaDeApoioController>().casaDeApoioSelecionada,
          builder: (context, casaDeApoio, child) {
            // Reinicializa o future quando casaDeApoio muda
          _loadConsultasFuture = loadConsultas();

          return FutureBuilder(
            future: _loadConsultasFuture,
            builder: (context,snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erro ao carregar consultas: ${snapshot.error}'));
                  } else {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 50),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                color: Color(casaDeApoio.cor??azul.value).withOpacity(0.7),
                                borderRadius: BorderRadius.circular(16)
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Frequência de consultas",
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 7, right: 7,bottom: 5,top: 3),
                                    child: ConsultasLineChart(casaDeApoioSelecionada: casaDeApoio,),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Color(casaDeApoio.cor??azul.value).withOpacity(0.7),
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
                    );
                  }
            }
          );
        }
      )
    );
  }
}