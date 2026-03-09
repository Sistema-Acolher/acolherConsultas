import 'package:acolherconsultas/modules/casasDeApoio/models/casaDeApoio.dart';
import 'package:acolherconsultas/shared/components/bars/pageAppBar.dart';
import 'package:acolherconsultas/shared/components/calendario.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Agenda extends StatelessWidget {
  const Agenda({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageAppBar(titulo: "Agenda", casaDeApoioSelecionada: Provider.of<CasaDeApoio>(context)),
      body: Calendario(casaDeApoio: Provider.of<CasaDeApoio>(context),)
    );
  }
}