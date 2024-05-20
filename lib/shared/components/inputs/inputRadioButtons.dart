import 'package:acolherconsultas/shared/components/inputs/inputCaixaDeTexto.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class InputRadioButtonsCadastroPaciente extends StatefulWidget {
  const InputRadioButtonsCadastroPaciente({
    super.key,
    required this.options,
    required this.label,
    required this.controller,
    this.optionalController,
    required this.isChecked,
  });

  final List<String> options;
  final String label;
  final TextEditingController controller;
  final TextEditingController? optionalController;
  final ValueNotifier<bool> isChecked;

  @override
  State<InputRadioButtonsCadastroPaciente> createState() => _InputRadioButtonsCadastroPacienteState();
}

class _InputRadioButtonsCadastroPacienteState extends State<InputRadioButtonsCadastroPaciente> {
  bool showTextBox = false;
  bool mostrarErro = true;

  @override
  void initState() {
    super.initState();
    showTextBox = widget.controller.text == 'Sim';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            "${widget.label}:",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Row(
          children: [
            ...List.generate(
              widget.options.length,
              (index) => Expanded(
                child: Opacity(
                  opacity: widget.controller.text == widget.options[index] ? 1.0 : 0.5,
                  child: RadioListTile(
                    title: AutoSizeText(
                      maxLines: 1,
                      widget.options[index],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    value: widget.options[index],
                    contentPadding: const EdgeInsets.all(0),
                    groupValue: widget.controller.text,
                    visualDensity: const VisualDensity(horizontal: -4.0),
                    dense: true,
                    onChanged: (value) {
                      setState(() {
                        widget.controller.text = value!;
                        widget.isChecked.value = true;
                        mostrarErro = false;
                        showTextBox = value == 'Sim';
                      });
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        if (mostrarErro && widget.isChecked.value)
          const Text(
            'Selecione pelo menos uma opção.',
            style: TextStyle(
              color: Colors.red,
              fontSize: 13,
            ),
          ),
        if (showTextBox)
          InputCaixaDeTexto(
            label: widget.label,
            controller: widget.optionalController!,
          ),
      ],
    );
  }
}
