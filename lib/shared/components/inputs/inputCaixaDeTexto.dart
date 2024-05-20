import 'package:flutter/material.dart';

class BotaoConfig {
  void Function() onPressed;
  String label;

  BotaoConfig({
    required this.onPressed,
    required this.label,
  });
}

class InputCaixaDeTexto extends StatefulWidget {
  const InputCaixaDeTexto({super.key, this.label, required this.controller, this.botao});

  final BotaoConfig? botao;
  final String? label;
  final TextEditingController controller;

  @override
  State<InputCaixaDeTexto> createState() => _InputCaixaDeTextoState();
}

class _InputCaixaDeTextoState extends State<InputCaixaDeTexto> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12,right: 12,top: 6,bottom: 0),
      decoration: const BoxDecoration(
        border: Border(
          top:    BorderSide(width:1.2, color: Colors.black),
          left:   BorderSide(width:1.2, color: Colors.black),
          right:  BorderSide(width:1.2, color: Colors.black),
          bottom: BorderSide(width:2, color: Colors.black),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [      
          Text(
            widget.label ?? "", // Rótulo novamente para aparecer dentro da caixa
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          TextFormField(
            controller: widget.controller,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            textCapitalization: TextCapitalization.sentences,
            style: const TextStyle(
              fontSize: 13,
            ),
            cursorColor: Colors.blue,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: '', // Removido o hintText para não duplicar o rótulo
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 13,
              ),
            ),
          ),
          if(widget.botao != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: widget.botao!.onPressed, 
                  child: Text(
                    widget.botao!.label.toUpperCase(),
                    style: const TextStyle(
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: "Roboto",
                      fontSize: 14
                    ),
                  ),
                )
              ],
            ),
        ],
      ),
    );
  }
}
