import 'package:acolherconsultas/modules/home/pages/consultasScreen.dart';
import 'package:acolherconsultas/modules/relatorioCasas/pages/relatorioCasasScreen.dart';
import 'package:acolherconsultas/modules/pacientes/pages/pacienteCadastro.dart';
import 'package:acolherconsultas/shared/colors.dart';
import 'package:acolherconsultas/shared/components/bars/homeAppbar.dart';
import 'package:acolherconsultas/shared/components/bars/principalNavbar.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

// A classe HomePage é a classe que representa a página inicial do aplicativo.
class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  // O título da página inicial.
  final String title;

  // O método createState é responsável por criar o estado da página inicial.
  @override
  State<HomePage> createState() => _HomePageState();
}

// A classe _HomePageState é a classe que representa o estado da página inicial do aplicativo.
class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppbar(),
      //Navbar
      body: CustomNavbar(
      icons: const [
        Symbols.stethoscope,
        Icons.date_range,
        Icons.home,
        Icons.menu_book,
        Icons.description,
      ], titles: const [
        "Consultas",
        "Agenda",
        " ",
        "Cadastro",
        "Relatório",
      ], screens: [
        const ConsultasScreen(),
        _buildPage('Agenda'),
        const HomePage(title: "title"),
        const CadastroPacienteScreen(title: "Cadastro de Pacientes"),
        const RelatorioCasasScreen()
      ], activeIconColors: const [
        verdeEscuro,
        vermelhoEscuro,
        Colors.blueGrey,
        azulEscuro,
        cinza
      ], inactiveIconColors: const [
        verdeIcon,
        vermelhoIcon,
        Colors.grey,
        azulIcon,
        cinzaIcon,
      ]),
    );
  }
}

Widget _buildPage(String title) {
  return Center(
    child: Text(
      title,
      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    ),
  );
}