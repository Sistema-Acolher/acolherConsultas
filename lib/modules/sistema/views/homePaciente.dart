import 'package:acolherconsultas/modules/consultas/views/consultaAgendar.dart';
import 'package:acolherconsultas/modules/consultas/views/consultaLista.dart';
import 'package:acolherconsultas/modules/pacientes/models/paciente.dart';
import 'package:acolherconsultas/modules/pacientes/views/pacienteEcomapa.dart';
import 'package:acolherconsultas/modules/pacientes/views/pacienteGenograma.dart';
import 'package:acolherconsultas/modules/pacientes/views/pacienteObservacoes.dart';
import 'package:acolherconsultas/modules/pacientes/views/pacienteScreen.dart';
import 'package:acolherconsultas/shared/colors.dart';
import 'package:acolherconsultas/shared/components/bars/pacienteAppbar.dart';
import 'package:acolherconsultas/shared/components/bars/principalNavbar.dart';
import 'package:acolherconsultas/shared/components/buttons/circleButton.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

// A classe HomePaciente é a classe que representa a página inicial do aplicativo.
class HomePaciente extends StatelessWidget {
  final Paciente paciente;
  const HomePaciente({super.key, required this.paciente});

  // O método createState é responsável por criar o estado da página inicial.
  @override
  Widget build(BuildContext context) {
    return CustomNavbar(
      icons:              const [ Symbols.family_history, Icons.comment_outlined, Icons.home,     Symbols.book_2,   Icons.edit_calendar_outlined], 
      titles:             const [ "Genog./Eco.",          "Obs.",                 " ",            "Consultas",      "Agendar"], 
      activeIconColors:   const [ verdeEscuro,            vermelhoEscuro,         amarelo,        azulEscuro,       cinza], 
      inactiveIconColors: const [ verdeIcon,              vermelhoIcon,           amareloEscuro,  azulIcon,         cinzaIcon],
      screens:            [ 
        OpcaoGenograma      (paciente: paciente),
        PacienteObservacoes (paciente: paciente, eInstituicao: false),  
        PacienteScreen      (paciente: paciente),      
        ConsultaLista       (paciente: paciente),  
        ConsultaAgendar     (paciente: paciente)], 
    );
  }
}

class OpcaoGenograma extends StatelessWidget {
  final Paciente paciente;
  const OpcaoGenograma({super.key, required this.paciente});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PacienteAppbar(paciente: paciente),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 60),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: CircleButton(title: "Genograma", icon: Symbols.family_history, onPressed: (){
                  pushWithoutNavBar(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PacienteGenograma(paciente: paciente)
                    )
                  );
                }),
              ),
              CircleButton(title: "Ecomapa", icon: Symbols.network_node, onPressed: (){
                pushWithoutNavBar(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PacienteEcomapa(paciente: paciente)
                  )
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}