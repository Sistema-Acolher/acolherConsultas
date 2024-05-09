import 'package:acolherconsultas/modules/pacientes/pages/pacientesCadastradosScreen.dart';
import 'package:acolherconsultas/shared/colors.dart';
import 'package:acolherconsultas/shared/components/dropdown/casasDropdown.dart';
import 'package:acolherconsultas/shared/components/dropdown/perfilDropdown.dart';
import 'package:flutter/material.dart';

class ConsultasScreen extends StatefulWidget {
  const ConsultasScreen({super.key});

  @override
  State<ConsultasScreen> createState() => _ConsultasScreenState();
}

class _ConsultasScreenState extends State<ConsultasScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      // O Column é um widget que organiza os widgets filhos em uma coluna vertical e sem scroll.
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.topRight,
              child: UserDropdown(
                userName: "Nome usuário",
              ),
            ),
          ),
          const CasasDropdown(),
          /*TextButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CadastroPacienteScreen(
                        title: "Cadastro de Pacientes"))),
            child: const Text(
              "Cadastro de Pacientes",
              style: TextStyle(
                fontFamily: "BobbyJonesCondensed",
                color: vermelhoEscuro,
              ),
            ),
          ),*/
          TextButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PacientesCadastradosScreen())),
            child: const Text(
              "Lista de Pacientes Cadastrados",
              style: TextStyle(
                fontFamily: "BobbyJonesSoft",
                color: verdeEscuro,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
