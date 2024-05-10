import 'package:acolherconsultas/modules/home/pages/consultasScreen.dart';
import 'package:acolherconsultas/modules/pacientes/pages/cadastroPacienteScreen.dart';
import 'package:acolherconsultas/shared/colors.dart';
import 'package:acolherconsultas/shared/components/bars/homeAppbar.dart';
import 'package:acolherconsultas/shared/components/bars/principalNavbar.dart';
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppbar(),
      //Navbar
      body: CustomNavbar(icons: const [
        Icons.medical_information,
        Icons.date_range,
        Icons.menu_book,
        Icons.description,
      ], titles: const [
        "Consultas",
        "Agenda",
        "Cadastro",
        "Relatório",
      ], screens: [
        const ConsultasScreen(),
        _buildPage('Agenda'),
        const CadastroPacienteScreen(title: "Cadastro de Pacientes"),
        _buildPage('Relatório'),
      ], activeIconColors: const [
        verdeEscuro,
        vermelhoEscuro,
        azulEscuro,
        cinza
      ], inactiveIconColors: const [
        verdeIcon,
        vermelhoIcon,
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
