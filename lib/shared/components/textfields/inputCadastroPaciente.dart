import 'package:flutter/material.dart';

class InputCadastroPaciente extends StatefulWidget {
  const InputCadastroPaciente({super.key, required this.label, required this.controller, required this.obscureText});

  final String label;
  final TextEditingController controller;
  final bool obscureText;

  @override
  State<InputCadastroPaciente> createState() => _InputCadastroPacienteState();
}

class _InputCadastroPacienteState extends State<InputCadastroPaciente> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15),
        TextFormField(
          decoration: InputDecoration(
            label: Text(widget.label),
            border: const OutlineInputBorder()
          ),
          controller: widget.controller,
          obscureText: widget.obscureText,
        ),
      ],
    );
  }
}