import 'package:acolherconsultas/modules/pacientes/views/pacienteLista.dart';
import 'package:acolherconsultas/shared/colors.dart';
import 'package:acolherconsultas/shared/components/bars/homeAppbar.dart';
import 'package:acolherconsultas/shared/components/buttons/circleButton.dart';
import 'package:acolherconsultas/shared/components/buttons/loginButton.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class Sumario extends StatelessWidget {
  const Sumario({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppbar(),
      body: Center(
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
                      builder: (context) => const PacienteListaScreen())),
              child: const Text(
                "Lista de Pacientes Cadastrados",
                style: TextStyle(
                  fontFamily: "BobbyJonesSoft",
                  color: verdeEscuro,
                ),
              ),
            ),
            const LoginButton(text: "ENTRAR")
          ],
        ),
      ),
    );
  }
}