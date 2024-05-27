import 'package:acolherconsultas/modules/casasDeApoio/controller/casaDeApoioController.dart';
import 'package:acolherconsultas/shared/components/bars/pageAppBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConsultaNovaScreen extends StatefulWidget {
  const ConsultaNovaScreen({super.key});

  @override
  State<ConsultaNovaScreen> createState() => _ConsultaNovaScreenState();
}

class _ConsultaNovaScreenState extends State<ConsultaNovaScreen> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: context.read<CasaDeApoioController>().casaDeApoioSelecionada,
      builder: (context, casaDeApoio, child) {
        return Scaffold(
            appBar: PageAppBar(titulo: "Consultar", casaDeApoioSelecionada: casaDeApoio),
            body: const Center(
              child: Text(
                "Consultar",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            )
        );
      }
    );
  }
}
