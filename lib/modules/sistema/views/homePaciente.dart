import 'package:acolherconsultas/modules/consultas/views/consultaAgendar.dart';
import 'package:acolherconsultas/modules/consultas/views/consultaLista.dart';
import 'package:acolherconsultas/modules/pacientes/models/paciente.dart';
import 'package:acolherconsultas/modules/pacientes/views/pacienteCadastro.dart';
import 'package:acolherconsultas/modules/pacientes/views/pacienteGenograma.dart';
import 'package:acolherconsultas/modules/pacientes/views/pacienteObservacoes.dart';
import 'package:acolherconsultas/shared/colors.dart';
import 'package:acolherconsultas/shared/components/bars/principalNavbar.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

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
        PacienteGenograma     (paciente: paciente),    
        PacienteObservacoes   (paciente: paciente),  
        CadastroPacienteScreen(paciente: paciente),      
        ConsultaLista         (paciente: paciente),  
        ConsultaAgendar       (paciente: paciente)], 
    );
  }
}