import 'package:acolherconsultas/modules/casasDeApoio/controller/casaDeApoioController.dart';
import 'package:acolherconsultas/shared/components/bars/pageAppBar.dart';
import 'package:acolherconsultas/shared/components/calendario.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Agenda extends StatelessWidget {
  const Agenda({super.key, this.cor = 0xFF2277AE});
  final int cor;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: context.read<CasaDeApoioController>().casaDeApoioSelecionada,
      builder: (context, casaDeApoio, child) {
        return Scaffold(
          appBar: PageAppBar(titulo: "Agenda", casaDeApoioSelecionada: casaDeApoio),
          body: const Calendario()
        );
      }
    );
  }
}