import 'package:acolherconsultas/shared/components/bars/pageAppBar.dart';
import 'package:acolherconsultas/shared/components/calendario.dart';
import 'package:flutter/material.dart';

class Agenda extends StatelessWidget {
  const Agenda({super.key, this.cor = 0xFF2277AE});
  final int cor;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PageAppBar(titulo: "Agenda"),
      body: Calendario()
    );
  }
}