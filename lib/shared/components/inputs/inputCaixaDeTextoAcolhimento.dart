import 'package:flutter/material.dart';

class InputCaixaDeTextoAcolhimento extends StatefulWidget {
  const InputCaixaDeTextoAcolhimento({super.key, this.label, required this.controller});

  final String? label;
  final TextEditingController controller;

  @override
  State<InputCaixaDeTextoAcolhimento> createState() => _InputCaixaDeTextoAcolhimentoState();
}

class _InputCaixaDeTextoAcolhimentoState extends State<InputCaixaDeTextoAcolhimento> {
  Color corDaCaixa = Colors.black;

  void validate(cor){
    setState(() {
      corDaCaixa = cor;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
            border: Border.all(width: 1.2, color: corDaCaixa),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                color: Colors.white, // Cor do fundo para cobrir a linha superior
                child: Text(
                  widget.label ?? "", // Rótulo novamente para aparecer dentro da caixa
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty){
                    validate(Colors.red);
                    return 'Informe o ${widget.label} por favor.';
                  }
                  validate(Colors.black);                
                  return null;
                },
                controller: widget.controller,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                style: const TextStyle(
                  fontSize: 13,
                ),
                cursorColor: Colors.blue,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: InputBorder.none,
                  hintText: '', // Removido o hintText para não duplicar o rótulo
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 13,
                  ),
                ),
              ),
              
            ],
          ),
        ),
      ],
    );
  }
}
