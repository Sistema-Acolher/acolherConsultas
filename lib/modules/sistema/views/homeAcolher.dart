import 'package:acolherconsultas/modules/sistema/views/agenda.dart';
import 'package:acolherconsultas/modules/consultas/views/consultarScreen.dart';
import 'package:acolherconsultas/modules/sistema/views/sumario.dart';
import 'package:acolherconsultas/modules/pacientes/views/pacienteLista.dart';
import 'package:acolherconsultas/modules/consultas/views/consultaRelatorioScreen.dart';
import 'package:acolherconsultas/shared/colors.dart';
import 'package:acolherconsultas/shared/components/bars/principalNavbar.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

// A classe HomeAcolher é a classe que representa a página inicial do aplicativo.
class HomeAcolher extends StatelessWidget {
  const HomeAcolher({super.key});

  // O método createState é responsável por criar o estado da página inicial.
  @override
  Widget build(BuildContext context) {
    return const CustomNavbar(
        icons:              [ Symbols.stethoscope,  Icons.date_range, Icons.home,         Icons.menu_book,          Icons.description], 
        titles:             [ "Consultar",          "Agenda",         " ",                "Cadastro",               "Relatório"], 
        screens:            [ ConsultarScreen(), Agenda(),         Sumario(),          PacienteLista(),          RelatorioCasasScreen()], 
        activeIconColors:   [ verdeEscuro,          vermelhoEscuro,   amarelo,            azulEscuro,               cinza], 
        inactiveIconColors: [ verdeIcon,            vermelhoIcon,     amareloEscuro,      azulIcon,                 cinzaIcon]
      );
  }
}