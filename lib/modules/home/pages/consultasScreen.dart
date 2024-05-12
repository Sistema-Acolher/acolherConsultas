import 'package:acolherconsultas/modules/pacientes/pages/pacientesCadastradosScreen.dart';
import 'package:acolherconsultas/shared/colors.dart';
import 'package:acolherconsultas/shared/components/buttons/circleButton.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class ConsultasScreen extends StatefulWidget {
  const ConsultasScreen({super.key});

  @override
  State<ConsultasScreen> createState() => _ConsultasScreenState();
}

class _ConsultasScreenState extends State<ConsultasScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          CircleButton(
            title: 'Genograma',
            icon: Symbols.family_history,
            onPressed: () {
              // FUnção que o botão executa
            },
          ),
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
