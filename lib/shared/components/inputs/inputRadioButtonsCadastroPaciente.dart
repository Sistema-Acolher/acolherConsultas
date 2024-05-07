import 'package:acolherconsultas/shared/components/inputs/inputCaixaDeTextoAcolhimento.dart';
import 'package:flutter/material.dart';

class InputRadioButtonsCadastroPaciente extends StatefulWidget {
  const InputRadioButtonsCadastroPaciente({super.key, required this.options, required this.label, required this.controller, this.optionalController, required this.isChecked});

  final List<String> options;
  final String label;
  final TextEditingController controller;
  final TextEditingController? optionalController;
  final bool isChecked;

  @override
  State<InputRadioButtonsCadastroPaciente> createState() => _InputRadioButtonsCadastroPacienteState();
}

class _InputRadioButtonsCadastroPacienteState extends State<InputRadioButtonsCadastroPaciente> {
  bool showTextBox = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                "${widget.label}:",
                style: const TextStyle(
                  fontSize: 10.2,
                  fontWeight: FontWeight.bold
                )
              ),
            ),
            ...List.generate(
              widget.options.length, 
              (index) => Expanded(
                flex: 3,
                child: Opacity(
                  opacity: widget.controller.text == widget.options[index] ? 1.0 : 0.5,
                  child: RadioListTile(
                    title: Text(
                      widget.options[index],
                      style: const TextStyle(
                        fontSize: 12
                      )
                    ),
                    value: widget.options[index],
                    groupValue: widget.controller.text,
                    visualDensity: const VisualDensity(horizontal: -4.0),
                    dense: true,
                    onChanged: (value) {
                      setState(() {
                        widget.controller.text = value!;
                        if (value == 'Sim') {
                          showTextBox = true;                          
                        } else {
                          showTextBox = false;
                        }
                      });
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        // Aqui a caixa de texto está abaixo do Row, mas ainda dentro da mesma coluna
        if (showTextBox)
          InputCaixaDeTextoAcolhimento(controller: widget.optionalController!)
      ],
    );
  }
}
