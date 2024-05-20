import 'package:acolherconsultas/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Confirmacao extends StatelessWidget {
  final String nome;
  final DateTime dataHorario;

  const Confirmacao({super.key, required this.nome, required this.dataHorario});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Você confirma?",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontSize: 24,
            fontWeight: FontWeight.bold
          )
        ),
        const Divider(height: 3,color: Colors.black,),
        Row(
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Paciente:", style: TextStyle(fontFamily: "Montserrat", fontSize: 20)),
                Text("Dia:",      style: TextStyle(fontFamily: "Montserrat", fontSize: 20)),
                Text("Horário:",  style: TextStyle(fontFamily: "Montserrat", fontSize: 20)),
              ],
            ),
            const SizedBox(width: 8,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nome,                                        style: const TextStyle(fontFamily: "BobbyJonesSoft", fontSize: 20)),
                Text(DateFormat.yMd("pt_BR").format(dataHorario), style: const TextStyle(fontFamily: "BobbyJonesSoft", fontSize: 20)),
                Text(DateFormat.Hm("pt_BR").format(dataHorario),  style: const TextStyle(fontFamily: "BobbyJonesSoft", fontSize: 20)),
              ],
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(onPressed: (){Navigator.of(context, rootNavigator: true).pop(false);}, icon: const Icon(Icons.dangerous_outlined,   color: vermelho)),
            IconButton(onPressed: (){}, icon: const Icon(Icons.check_circle_outline, color: verde)),
          ],
        )
      ],
    );
  }
}