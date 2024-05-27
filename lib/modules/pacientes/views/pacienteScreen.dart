import 'package:acolherconsultas/modules/pacientes/models/paciente.dart';
import 'package:acolherconsultas/modules/pacientes/views/pacienteObservacoes.dart';
import 'package:acolherconsultas/modules/usuarios/controllers/usuarioController.dart';
import 'package:acolherconsultas/modules/usuarios/models/usuario.dart';
import 'package:acolherconsultas/shared/components/bars/pacienteAppbar.dart';
import 'package:acolherconsultas/shared/components/bars/tabBar.dart';
import 'package:acolherconsultas/shared/components/buttons/bigRoundButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PacienteScreen extends StatelessWidget {
  final Paciente? paciente;
  const PacienteScreen({super.key, this.paciente});

  @override
  Widget build(BuildContext context) {
    var usuario =context.read<UsuarioController>().usuarioAtual;
    return CustomTabBar(
      appBar: PacienteAppbar(paciente: paciente), 
      fabs_: usuario?.nivelAcesso==NivelAcesso.casaDeApoio?[
        BigRoundButton(text: "Observações", icon: Icons.comment_outlined, onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => PacienteObservacoes(paciente: paciente)))),
        BigRoundButton(text: "Observações", icon: Icons.comment_outlined, onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => PacienteObservacoes(paciente: paciente))))
      ]:null,
      tabs_: const [
        "Informações\n\t\t\tPessoais",
        "\t\tHistória\nPregressa"
      ], 
      views_: const [
        InfoPessoais(),
        HistPregressa()
      ]
    ); 
  }
}

class InfoPessoais extends StatelessWidget {
  const InfoPessoais({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Informações Pessoais"),);
  }
}

class HistPregressa extends StatelessWidget {
  const HistPregressa({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("História Pregressa"),);
  }
}

