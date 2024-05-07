import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class InputCaixaDeTextoAcolhimento extends StatefulWidget {
  const InputCaixaDeTextoAcolhimento({super.key, this.label, required this.controller});

  final String? label;
  final TextEditingController controller;


  @override
  State<InputCaixaDeTextoAcolhimento> createState() => _InputCaixaDeTextoAcolhimentoState();
}

class _InputCaixaDeTextoAcolhimentoState extends State<InputCaixaDeTextoAcolhimento> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            widget.label ?? ""
          ),
        ),
        TextFormField(              
            controller: widget.controller,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.zero),
                borderSide: BorderSide(width: 1.2)
              ),
              errorStyle: TextStyle(
                fontSize: 10,
                height: 1
              ),
              alignLabelWithHint: true,
            ),
          ),
      ],
    );
  }
}