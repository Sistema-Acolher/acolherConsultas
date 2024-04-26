import 'package:flutter/material.dart';

// Classe que cria um campo de entrada de texto com "options.lenght" radio buttons.

class InputRadioButtonsCadastroPaciente extends StatefulWidget {
  const InputRadioButtonsCadastroPaciente({super.key, required this.options, required this.label, required this.controller});

  // Atributos do componente.
  final List<String> options;
  final String label;
  final TextEditingController controller;

  @override
  State<InputRadioButtonsCadastroPaciente> createState() => _InputRadioButtonsCadastroPacienteState();
}

class _InputRadioButtonsCadastroPacienteState extends State<InputRadioButtonsCadastroPaciente> {
  @override
  Widget build(BuildContext context) {
    // Row é um widget que organiza os widgets filhos em uma linha horizontal.
    return Row(
      children: [
        // Expanded é um widget que expande o widget filho para preencher o espaço disponível.
        Expanded(
          // A propriedade flex define a fração do espaço disponível que o widget filho deve ocupar.
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
            // RadioListTile é um widget que implementa um item de lista com um botão de rádio.
            // De acordo com o index, o RadioListTile é construído com o valor correspondente da lista de opções.
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
                  // Atribui o valor selecionado ao controller de texto.
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