import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class InputRadioButtonsCadastroPaciente extends StatefulWidget {
  const InputRadioButtonsCadastroPaciente({super.key, required this.options, required this.label, required this.controller});

  final List<String> options;
  final String label;
  final TextEditingController controller;

  @override
  State<InputRadioButtonsCadastroPaciente> createState() => _InputRadioButtonsCadastroPacienteState();
}

class _InputRadioButtonsCadastroPacienteState extends State<InputRadioButtonsCadastroPaciente> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            "${widget.label}:",
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold
            )
          )
        ),
        ...List.generate(
          widget.options.length, 
          (index) => Expanded(
            flex: 3,
            child: RadioListTile(
              title: Text(
                widget.options[index],
                style: const TextStyle(
                  fontSize: 12
                )
              ),
              value: widget.options[index],
              groupValue: widget.controller.text,
              onChanged: (value) {
                setState(() {
                  widget.controller.text = value!;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}