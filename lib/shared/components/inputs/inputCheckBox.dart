import 'package:acolherconsultas/modules/casasDeApoio/models/casaDeApoio.dart';
import 'package:acolherconsultas/shared/colors.dart';
import 'package:flutter/material.dart';

// Classe que cria um campo de entrada de texto com checkboxes.
class InputCheckBoxAcolher extends StatefulWidget {
  const InputCheckBoxAcolher({
    super.key,
    required this.options,
    this.label,
    required this.controller,
    required this.isChecked
  });

  // Atributos do componente.
  final List<CasaDeApoio> options;
  final String? label;
  final TextEditingController controller;
  final ValueNotifier<bool> isChecked;

  @override
  State<InputCheckBoxAcolher> createState() => _InputCheckBoxAcolherState();
}

class _InputCheckBoxAcolherState extends State<InputCheckBoxAcolher> {
  bool checkboxValue = false;
  // bool _isValid = true; // Campo para controlar a validação

  // Método para validar se pelo menos um checkbox está marcado
  void validate() {
    setState(() {
        widget.isChecked.value = true;
    });
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
              activeColor: preto,
              value: widget.controller.text.contains(widget.options[index].id ?? ""),
              onChanged: (value) {
                setState(() {
                  // Adiciona ou remove o valor selecionado ao controller de texto.
                  if (value == true) {
                    widget.controller.text += "${widget.options[index].id},";
                  } else {
                    widget.controller.text =
                        widget.controller.text.replaceAll("${widget.options[index].id},", "");
                  }
                  validate(); // Chama o método de validação quando o valor muda
                });
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.options[index].nome ?? "Sem Nome",
                  style: const TextStyle(
                    fontFamily: 'BobbyJonesSoft',
                    fontSize: 20,
                  ),
                ),
                const SizedBox(width: 4.0),
                Icon(
                  size: 30,
                  Icons.cottage_outlined,
                  color: Color(widget.options[index].cor ?? 0),
                )
              ],
            ),
          ],
        ),
      ),
      if (widget.isChecked.value && widget.controller.text.isEmpty)
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
