import 'package:acolherconsultas/modules/relatorioCasas/controllers/controllerRelatorioCasas.dart';
import 'package:acolherconsultas/shared/components/bars/pageAppBar.dart';
import 'package:acolherconsultas/shared/components/inputs/inputCheckBox.dart';
import 'package:acolherconsultas/shared/components/inputs/inputTexto.dart';
import 'package:flutter/material.dart';
import 'package:mask/mask/mask.dart';

class RelatorioCasasScreen extends StatefulWidget {
  const RelatorioCasasScreen({super.key});

  @override
  State<RelatorioCasasScreen> createState() => _RelatorioCasasScreenState();
}

class _RelatorioCasasScreenState extends State<RelatorioCasasScreen> {
  final _controllerRelatorioCasas = ControllerRelatorioCasas();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PageAppBar(titulo: "Relatorios",),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(                
                    child: InputTextoAcolher(
                        label: "De",
                        hintText: "    /    /",
                        controller:_controllerRelatorioCasas.periodoInicial,
                        keyboardType: TextInputType.datetime,
                        icone: Icons.date_range_outlined,
                        validation: (value) => Mask.validations.date(value),
                        inputFormatter: [Mask.date()],
                        readOnly: true,
                    ),
                  ),
                  const SizedBox(width: 40),
                  Expanded(
                    child: InputTextoAcolher(
                        label: "Até",
                        hintText: "    /    /",
                        controller:_controllerRelatorioCasas.periodoFinal,
                        keyboardType: TextInputType.datetime,
                        icone: Icons.date_range_outlined,
                        validation: (value) => Mask.validations.date(value),
                        inputFormatter: [Mask.date()],
                        readOnly: true,
                    ),
                  ),
                ],
              ),         
              InputCheckBoxAcolher(
                options: const ["Servos", "Maria Paola", "Santa Isabel"],
                label: "Casas",
                controller: _controllerRelatorioCasas.casas,
                icones: const ['src/icons/servos.svg', 'src/icons/mariaPaola.svg', 'src/icons/santaIsabel.svg'],
              )
            ],
          ),
        ),
      ),
    );
  }
}