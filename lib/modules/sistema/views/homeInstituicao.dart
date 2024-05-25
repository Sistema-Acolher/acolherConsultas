import 'package:acolherconsultas/modules/pacientes/views/pacienteCadastro.dart';
import 'package:acolherconsultas/modules/pacientes/views/pacienteLista.dart';
import 'package:acolherconsultas/modules/sistema/views/agenda.dart';
import 'package:acolherconsultas/shared/colors.dart';
import 'package:acolherconsultas/shared/components/bars/homeAppbar.dart';
import 'package:acolherconsultas/shared/components/buttons/homeButton.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class HomeInstituicao extends StatelessWidget {
  const HomeInstituicao({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: const HomeAppbar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            HomeButton(text: "Cadastros", icon: Icons.menu_book_outlined, backgroundColor: verde,
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder:(context) => const PacienteLista()))),
            HomeButton(text: "Cadastrar", icon: Symbols.list_alt_add,     backgroundColor: vermelho, iconOnRight: true,
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder:(context) => const CadastroPacienteScreen()))),
            HomeButton(text: "Agenda",    icon: Icons.date_range,         backgroundColor: azul,
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder:(context) => const Agenda()))),
          ],
        ),
      )
    );
  }
}