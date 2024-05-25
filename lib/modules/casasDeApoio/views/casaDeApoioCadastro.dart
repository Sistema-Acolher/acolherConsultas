import 'package:acolherconsultas/shared/components/bars/pacienteAppbar.dart';
import 'package:acolherconsultas/shared/components/buttons/standartRoundButton.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class CadastroCasaDeApoioScreen extends StatelessWidget {
  const CadastroCasaDeApoioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PacienteAppbar(admin: true),
      floatingActionButton: StandartRoundButton(
        text: "Salvar",
        icon: Symbols.book,
        onPressed: () {},
      ),
      body: const Center(child: Text("Casa de Apoio Cadastro")),
      
    );
  }
}