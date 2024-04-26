import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Widget de input de texto para o cadastro de pacientes.

class InputTextCadastroPaciente extends StatefulWidget {
  const InputTextCadastroPaciente({
    super.key, 
    required this.label,
    required this.controller, 
    this.obscureText, 
    this.validation,
    this.inputFormatter,
    required this.keyboardType
  });

  // Atributos do componente.
  final String label;
  final TextEditingController controller;
  final bool? obscureText;
  final Function? validation;
  final List<TextInputFormatter>? inputFormatter;
  final TextInputType? keyboardType;

  @override
  State<InputTextCadastroPaciente> createState() => _InputTextCadastroPacienteState();
}

class _InputTextCadastroPacienteState extends State<InputTextCadastroPaciente> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          label: Text(widget.label),
          border: const OutlineInputBorder(),
          errorStyle: const TextStyle(
                  fontSize: 10,
                  height: 1
                ),
          alignLabelWithHint: true,
        ),
        controller: widget.controller,
        obscureText: widget.obscureText ?? false,
        // Função de validação do campo de texto.
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Informe o ${widget.label} do paciente";
          } 
          if(widget.validation != null) {
            return widget.validation!(widget.controller.text);
          }
          return null;
        },
        // Propiedade de formatação (máscara e formato) do campo de texto.
        inputFormatters: widget.inputFormatter,
        // Tipo de teclado que será exibido ao tocar no campo de texto.
        keyboardType: widget.keyboardType ?? TextInputType.text,
      ),
    );
  }
}