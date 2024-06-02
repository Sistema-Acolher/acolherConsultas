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
  const InputCaixaDeTexto({
    Key? key,
    this.label,
    required this.controller,
    this.botao,
    this.editable = false,
    this.isCadastro = false, // Novo parâmetro
  }) : super(key: key);

  final BotaoConfig? botao;
  final String? label;
  final TextEditingController controller;
  final bool editable;
  final bool isCadastro;

  @override
  State<InputCaixaDeTexto> createState() => _InputCaixaDeTextoState();
}

class _InputCaixaDeTextoState extends State<InputCaixaDeTexto> {
  Color corDaCaixa = Colors.black;
  final FocusNode _focusNode = FocusNode();
  bool isEditable = false;

  void toggleEditable() {
    setState(() {
      isEditable = !isEditable;
      if (isEditable) {
        _focusNode.requestFocus();
      } else {
        _focusNode.unfocus();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    isEditable = widget.isCadastro || false;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 6, bottom: 0),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 1.2, color: corDaCaixa),
          left: BorderSide(width: 1.2, color: corDaCaixa),
          right: BorderSide(width: 1.2, color: corDaCaixa),
          bottom: BorderSide(width: 2, color: corDaCaixa),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label ?? "",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  focusNode: _focusNode,
                  controller: widget.controller,
                  maxLines: null,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  style: TextStyle(
                    fontSize: 13,
                    color: isEditable ? Colors.black : Colors.grey,
                  ),
                  cursorColor: preto,
                  enabled: isEditable,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              if (!widget.isCadastro && widget.editable)
                GestureDetector(
                  onTap: toggleEditable,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      isEditable ? 'Salvar' : 'Editar',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          if (widget.botao != null && !isEditable && !widget.isCadastro)
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
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
