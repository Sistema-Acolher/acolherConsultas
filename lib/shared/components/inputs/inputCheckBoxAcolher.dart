import 'package:flutter/material.dart';

// Classe que cria um campo de entrada de texto com checkboxes.

class InputCheckBoxAcolher extends StatefulWidget {
  const InputCheckBoxAcolher({Key? key, required this.options, required this.label, required this.controller});

  // Atributos do componente.
  final List<String> options;
  final String label;
  final TextEditingController controller;

  @override
  State<InputCheckBoxAcolher> createState() => _InputCheckBoxAcolherState();
}

class _InputCheckBoxAcolherState extends State<InputCheckBoxAcolher> {
  @override
  Widget build(BuildContext context) {
    // Column é um widget que organiza os widgets filhos em uma coluna vertical.
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        // List.generate é uma função que gera uma lista de widgets a partir de uma lista de dados.
        ...List.generate(
          // Definição do tamanho da lista de widgets.
          widget.options.length, 
          (index) => Expanded(
            flex: 3,
            child: CheckboxListTile(
              title: Text(
                widget.options[index],
                style: const TextStyle(
                  fontSize: 12
                )
              ),
              value: widget.controller.text.contains(widget.options[index]),
              onChanged: (value) {
                setState(() {
                  // Adiciona ou remove o valor selecionado ao controller de texto.
                  if (value == true) {
                    widget.controller.text += "${widget.options[index]},";
                  } else {
                    widget.controller.text = widget.controller.text.replaceAll("${widget.options[index]},", "");
                  }
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
