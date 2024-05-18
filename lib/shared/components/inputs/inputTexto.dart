import 'package:acolherconsultas/shared/colors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

// Widget de input de texto para o cadastro de pacientes.

class InputTextoAcolher extends StatefulWidget {
  const InputTextoAcolher({
    super.key, 
    required this.label,
    required this.controller, 
    this.placeHolder,
    this.obscureText, 
    this.validation,
    this.inputFormatter,
    this.keyboardType,
    this.icone,
    this.readOnly,
    required this.emptyMessage
  });

  // Atributos do componente.
  final String label;
  final String? placeHolder;
  final TextEditingController controller;
  final bool? obscureText;
  final Function? validation;
  final List<TextInputFormatter>? inputFormatter;
  final TextInputType? keyboardType;
  final IconData? icone;
  final bool? readOnly;
  final String emptyMessage;

  @override
  State<InputTextoAcolher> createState() => _InputTextoAcolherState();
}

class _InputTextoAcolherState extends State<InputTextoAcolher> {
  //Campos de controle do estado do componente.
  bool _isSenha = false, _isEditing = false;
  IconData? _iconeFinal;
  String _textoInicial = "";

  @override
  void initState() {
    super.initState();
    // Inicialização dos campos de controle do estado do componente.
    _isSenha = widget.obscureText ?? false;
    _isEditing = false;
    _iconeFinal = _isSenha ? Icons.visibility : widget.icone;
    _textoInicial = widget.controller.text;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Padding = 15 para o topo do componente.
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: Theme(
        // Mudar a cor do cursor e do texto selecionado.
        data: Theme.of(context).copyWith(
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: preto,
            selectionColor: preto.withOpacity(.2),
            selectionHandleColor: preto
          )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label do campo de texto.
            AutoSizeText(
              widget.label, 
              // Estilo do texto do label.
              style: const TextStyle(
                color: preto,
                fontWeight: FontWeight.bold,
                fontSize: 13
              ),
              // Número máximo de linhas do label.
              maxLines: 1,
            ),
            TextFormField(
              // Define quando o campo de texto esta em modo de edição.
              readOnly: widget.readOnly ?? (_iconeFinal == Icons.edit ? !_isEditing : false),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              // Estilo do texto do campo de texto.
              style: const TextStyle(
                fontFamily: "Roboto"
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: branco,
                // Label estar sempre flutuando.
                floatingLabelBehavior:  FloatingLabelBehavior.always,
                // Cor da borda do campo de texto (no caso, a linhas inferior).
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: preto),
                ),
                // Texto de dica do campo de texto (placeholder).
                hintText: widget.placeHolder ?? "",
                // Estilo do texto de erro do campo de texto.
                errorStyle: const TextStyle(
                  fontSize: 10,
                ),
                // Padding do conteúdo do campo de texto.
                contentPadding: widget.label.toLowerCase() == "usuário" || widget.label.toLowerCase() == "senha" ? 
                                EdgeInsets.fromLTRB(8, _iconeFinal == Icons.visibility || _iconeFinal == Icons.visibility_off ? 12 : 0, 0, 0) :
                                const EdgeInsets.fromLTRB(0, 12, 0, 12),
                // Ícone ao final do campo de texto.
                suffixIcon: _iconeFinal != null ? 
                  _iconeFinal != Icons.edit ?
                  // Ícone de visibilidade da senha e de data.
                  IconButton(
                    icon: Icon(_iconeFinal, color: preto),
                    onPressed:  _iconeFinal == Icons.date_range_outlined ? 
                        pickDate : 
                        changeVisibility,
                  ) : 
                  !_isEditing ? 
                  // Ícone de edição.
                  ConstrainedBox(
                    constraints: const BoxConstraints.tightFor(width: 36),
                    // Alinhamento do ícone ao final do campo de texto.
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: InkWell(
                        // Estilo do botão de ícone.
                        borderRadius: BorderRadius.circular(50),
                        splashColor: preto.withOpacity(.2),
                        onTap: () {
                          setState(() {
                            _isEditing = true;
                          });
                        },
                        child: Container(
                          constraints: const BoxConstraints.tightFor(height: 30, width: 30),
                          child: Icon(_iconeFinal, color: preto)
                        )
                      ),
                    ),
                  )
                  // Ícones de confirmação e cancelamento de edição.
                  : Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            _isEditing = false;
                            widget.controller.text = _textoInicial;
                          });
                        },
                        splashColor: vermelho.withOpacity(.2),
                        borderRadius: BorderRadius.circular(50),
                        child: Container(
                          constraints: const BoxConstraints.tightFor(height: 30, width: 30),
                          child: const Icon(
                            Icons.dangerous_outlined,
                            color: vermelho,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: Container(
                          constraints: const BoxConstraints.tightFor(height: 30, width: 30),
                          child: InkWell(
                            splashColor: verde.withOpacity(.2),
                            splashFactory: InkRipple.splashFactory,
                            borderRadius: BorderRadius.circular(50),
                            onTap: () {
                              setState(() {
                                _isEditing = false;
                              });
                            },
                            child: const Icon(
                              Icons.check_circle_outline_outlined,
                              color: verde,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                  // Sem Ícone
                  : null,
              ),
              // Ação de toque no campo de texto, caso o ícone seja de data.
              onTap: _iconeFinal == Icons.date_range_outlined ? pickDate : null,
              controller: widget.controller,
              obscureText: _isSenha,
              // Função de validação do campo de texto.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return widget.emptyMessage;
                } 
                if(widget.validation != null) {
                  return widget.validation!(widget.controller.text);
                }
                return null;
              },
              // Propiedade de formatação (máscara e formato) do campo de texto.
              inputFormatters: widget.inputFormatter,
              // Tipo de teclado que será exibido ao tocar no campo de texto.
              keyboardType: widget.keyboardType ?? TextInputType.text,
              onChanged: (_) => setState(() {}),
            ),
          ],
        ),
      ),
    );
  }

  // Método para mostrar Widget de seleção de data.
  pickDate() async {
    // O showDatePicker é um método que exibe uma caixa/dialog de seleção de data e retorna a data selecionada.
    final DateTime? data = await showDatePicker(
      // Propriedades do showDatePicker de acordo com os atributos do componente.
      keyboardType: TextInputType.datetime,
      context: context,
      locale: const Locale('pt', "BR"),
      initialDate: widget.controller.text.isNotEmpty
                  ? DateFormat('dd/MM/yyyy').parse(widget.controller.text) 
                  : DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (data != null) {
      // O setState é um método que atualiza o estado do widget.
      setState(() {
        // Atribuição da data de nascimento do paciente aos respectivos campos.
        widget.controller.text = DateFormat('dd/MM/yyyy').format(data);
      });
    }
  }

  // Método para mostrar/esconder a senha e mudar o ícone.
  changeVisibility(){
      setState(() {
        _isSenha = !_isSenha;
        _iconeFinal = _isSenha ? Icons.visibility : Icons.visibility_off;
      });
    }  
}