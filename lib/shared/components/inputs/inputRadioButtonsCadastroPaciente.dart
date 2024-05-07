import 'package:flutter/material.dart';

class InputRadioButtonsCadastroPaciente extends StatefulWidget {
  const InputRadioButtonsCadastroPaciente({required this.options, required this.label, required this.controller});

  final List<String> options;
  final String label;
  final TextEditingController controller;

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
            Text(
              "${widget.label}:",
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold
              )
            ),
            ...List.generate(
              widget.options.length, 
              (index) => Expanded(
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
                    onChanged: (value) {
                      setState(() {
                        widget.controller.text = value!;
                        if (value == 'Sim') {
                          showTextBox = true;
                          widget.controller.text = '';
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
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: TextFormField(              
              controller: widget.controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                errorStyle: TextStyle(
                  fontSize: 10,
                  height: 1
                ),
                alignLabelWithHint: true,
              ),
            ),
          ),
      ],
    );
  }
}
