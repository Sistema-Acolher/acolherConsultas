import 'package:acolherconsultas/shared/colors.dart';
import 'package:acolherconsultas/shared/components/inputs/inputTexto.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class InputRadioButtonsCadastroPaciente extends StatefulWidget {
  const InputRadioButtonsCadastroPaciente({
    super.key,
    required this.options,
    required this.label,
    required this.controller,
    this.secondController,
    this.thirdController,
    required this.isChecked,
    this.readOnly = false,
  });

  final List<String> options;
  final String label;
  final TextEditingController controller;
  final TextEditingController? secondController;
  final TextEditingController? thirdController;
  final ValueNotifier<bool> isChecked;
  final bool readOnly;

  @override
  State<InputRadioButtonsCadastroPaciente> createState() =>
      _InputRadioButtonsCadastroPacienteState();
}

class _InputRadioButtonsCadastroPacienteState
    extends State<InputRadioButtonsCadastroPaciente> {
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
            widget.label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Row(
          children: [
            ...List.generate(
              widget.options.length,
              (index) => Expanded(
                child: Opacity(
                  opacity: widget.controller.text == widget.options[index]
                      ? 1.0
                      : 0.5,
                  child: RadioListTile(
                    activeColor: preto,
                    title: AutoSizeText(
                      maxLines: 1,
                      widget.options[index],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      minFontSize: 8,
                    ),
                    value: widget.options[index],
                    contentPadding: const EdgeInsets.all(0),
                    groupValue: widget.controller.text,
                    visualDensity: const VisualDensity(horizontal: -4.0),
                    dense: true,
                    onChanged: widget.readOnly
                        ? null
                        : (value) {
                            setState(() {
                              widget.controller.text = value as String;
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
        if (mostrarErro && widget.isChecked.value && !widget.readOnly)
          const Text(
            'Selecione pelo menos uma opção.',
            style: TextStyle(
              color: Colors.red,
              fontSize: 13,
            ),
          ),
        if (showTextBox && widget.secondController != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: InputTextoAcolher(
                  label:"Data: ",
                  controller: widget.secondController!,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: InputTextoAcolher(
                  label: "Local: ",
                  controller: widget.thirdController!,
                ),
              ),
            ],
          ),

      ],
    );
  }
}
