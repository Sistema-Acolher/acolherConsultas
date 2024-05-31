import 'package:acolherconsultas/shared/colors.dart';
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
  Color corDaCaixa = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12,right: 12,top: 6,bottom: 0),
      decoration: BoxDecoration(
        border: Border(
          top:    BorderSide(width:1.2, color: corDaCaixa),
          left:   BorderSide(width:1.2, color: corDaCaixa),
          right:  BorderSide(width:1.2, color: corDaCaixa),
          bottom: BorderSide(width:2,   color: corDaCaixa),
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
            validator: (value) {
              if (value == null || value.isEmpty){
                return 'Informe o ${widget.label} por favor.';
              }              
              return null;
            },
            controller: widget.controller,
            maxLines: null,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.multiline,
            textCapitalization: TextCapitalization.sentences,
            style: const TextStyle(
              fontSize: 13,
            ),
            cursorColor: preto,            
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
