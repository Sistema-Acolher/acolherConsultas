import 'package:flutter/material.dart';

// Classe que cria um campo de entrada de texto com checkboxes.
class InputCheckBoxAcolher extends StatefulWidget {
  const InputCheckBoxAcolher({
    super.key,
    required this.options,
    this.label,
    required this.controller,
  });

  // Atributos do componente.
  final List<String> options;
  final String? label;
  final TextEditingController controller;

  @override
  State<InputCheckBoxAcolher> createState() => _InputCheckBoxAcolherState();
}

class _InputCheckBoxAcolherState extends State<InputCheckBoxAcolher> {
  bool checkboxValue = false;
  bool _isValid = true; // Campo para controlar a validação

  // Método para validar se pelo menos um checkbox está marcado
  void validate() {
    setState(() {
      _isValid = widget.controller.text.isNotEmpty;
    });
  }

  Color checkboxColor(String casa){
    if (casa == "Maria Paola") {
      return const Color.fromRGBO(255, 0, 0, 100);
    }
    if (casa == "Servos") {
      return const Color.fromRGBO(34, 119, 174, 100);
    }
    if (casa == "Santa Isabel") {
      return const Color.fromRGBO(120, 177, 88, 100);
    }
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "${widget.label}:",
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      // List.generate é uma função que gera uma lista de widgets a partir de uma lista de dados.
      ...List.generate(
        // Definição do tamanho da lista de widgets.
        widget.options.length,
        (index) => Row(
          children: [
            Checkbox(
              value: widget.controller.text.contains(widget.options[index]),
              onChanged: (value) {
                setState(() {
                  // Adiciona ou remove o valor selecionado ao controller de texto.
                  if (value == true) {
                    widget.controller.text += "${widget.options[index]},";
                  } else {
                    widget.controller.text =
                        widget.controller.text.replaceAll("${widget.options[index]},", "");
                  }
                  validate(); // Chama o método de validação quando o valor muda
                });
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.options[index],
                  style: const TextStyle(
                    fontFamily: 'BobbyJonesSoft',
                    fontSize: 20,
                  ),
                ),
                const SizedBox(width: 4.0),
                Icon(
                  size: 30,
                  Icons.cottage_outlined,
                  color: checkboxColor(widget.options[index]),
                )
              ],
            ),
          ],
        ),
      ),
      if (!_isValid)
        const Text(
          'Selecione pelo menos uma opção.',
          style: TextStyle(
            color: Colors.red,
            fontSize: 13,
          ),
        ),
      ],
    );
  }    
}
