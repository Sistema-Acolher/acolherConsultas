import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Classe que cria um campo de entrada de texto com checkboxes.
class InputCheckBoxAcolher extends StatefulWidget {
  const InputCheckBoxAcolher({
    super.key,
    required this.options,
    this.label,
    required this.controller,
    this.icones,
    required this.labelPosition
  });

  // Atributos do componente.
  final List<String> options;
  final String? label;
  final TextEditingController controller;
  final List<String>? icones;
  final String labelPosition;

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

  @override
  Widget build(BuildContext context) {
    // Column é um widget que organiza os widgets filhos em uma coluna vertical.
    if (widget.labelPosition == "down"){
      return Column(
        children: [
          ...List.generate(
          // Definição do tamanho da lista de widgets.
          widget.options.length,
          (index) => Column(
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
              Text(
                widget.options[index],
                style: const TextStyle(
                  fontFamily: 'BobbyJonesSoft',
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
        ],
      );
    }
    else{
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
                  SvgPicture.asset(
                    widget.icones![index], // Usando o caminho do ícone da lista de caminhos
                    width: 24.0,
                    height: 24.0,
                  ),
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
}
