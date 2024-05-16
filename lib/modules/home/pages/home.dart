import 'package:acolherconsultas/modules/home/pages/agenda.dart';
import 'package:acolherconsultas/modules/home/pages/consultasScreen.dart';
import 'package:acolherconsultas/modules/home/pages/sumario.dart';
import 'package:acolherconsultas/modules/pacientes/pages/pacienteLista.dart';
import 'package:acolherconsultas/modules/relatorioCasas/pages/relatorioCasasScreen.dart';
import 'package:acolherconsultas/shared/colors.dart';
import 'package:acolherconsultas/shared/components/bars/principalNavbar.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

// A classe HomePage é a classe que representa a página inicial do aplicativo.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // O método createState é responsável por criar o estado da página inicial.
  @override
  Widget build(BuildContext context) {
    return const CustomNavbar(
        icons:              [ Symbols.stethoscope,  Icons.date_range, Icons.home,         Icons.menu_book,          Icons.description], 
        titles:             [ "Consultas",          "Agenda",         " ",                "Cadastro",               "Relatório"], 
        screens:            [ ConsultasScreen(),    Agenda(),         Sumario(),          PacientesCadastradosScreen(), RelatorioCasasScreen()], 
        activeIconColors:   [ verdeEscuro,          vermelhoEscuro,   amarelo,            azulEscuro,               cinza], 
        inactiveIconColors: [ verdeIcon,            vermelhoIcon,     amareloEscuro,      azulIcon,                 cinzaIcon]
      );
  }
}