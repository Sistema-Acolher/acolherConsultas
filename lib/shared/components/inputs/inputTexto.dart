import 'package:acolherconsultas/shared/colors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

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
    this.emptyMessage,
    this.checkEdit,
    this.defaultValue,
    this.firstDate,
    this.lastDate,
  });

  final String label;
  final String? placeHolder;
  final TextEditingController controller;
  final bool? obscureText;
  final Function? validation;
  final List<TextInputFormatter>? inputFormatter;
  final TextInputType? keyboardType;
  final IconData? icone;
  final bool? readOnly;
  final String? emptyMessage;
  final Function? checkEdit;
  final String? defaultValue;
  final DateTime? firstDate;
  final DateTime? lastDate;

  @override
  State<InputTextoAcolher> createState() => _InputTextoAcolherState();
}

class _InputTextoAcolherState extends State<InputTextoAcolher> {
  bool _isSenha = false, _isEditing = false;
  IconData? _iconeFinal;
  String _textoInicial = "";

  bool calculateReadOnly() {
    if (_iconeFinal == Icons.edit) {
      return !_isEditing;
    } else {
      return widget.readOnly ?? false;
    }
  }

  @override
  void initState() {
    super.initState();
    _isSenha = widget.obscureText ?? false;
    _isEditing = false;
    _iconeFinal = _isSenha ? Icons.visibility : widget.icone;
    _textoInicial = widget.controller.text;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: preto,
          selectionColor: preto.withOpacity(.2),
          selectionHandleColor: preto,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            widget.label,
            style: const TextStyle(
              color: preto,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
            maxLines: 1,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: TextFormField(
              initialValue: widget.defaultValue,
              readOnly: calculateReadOnly(),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              style: TextStyle(
                fontFamily: "Montserrat",
                color: calculateReadOnly() ? Colors.grey : Colors.black,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: branco,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: preto, width: 2),
                ),
                hintText: widget.placeHolder ?? "",
                errorStyle: const TextStyle(
                  fontSize: 10,
                ),
                contentPadding: widget.label.toLowerCase() == "usuário" ||
                        widget.label.toLowerCase() == "senha"
                    ? EdgeInsets.fromLTRB(
                        8,
                        _iconeFinal == Icons.visibility ||
                                _iconeFinal == Icons.visibility_off
                            ? 12
                            : 0,
                        0,
                        0)
                    : const EdgeInsets.fromLTRB(8, 12, 8, 12),
                suffixIcon: _iconeFinal != null
                    ? _iconeFinal != Icons.edit
                        ? IconButton(
                            icon: Icon(_iconeFinal, color: preto),
                            onPressed: _iconeFinal == Icons.date_range_outlined
                                ? pickDate
                                : changeVisibility,
                          )
                        : !_isEditing
                            ? ConstrainedBox(
                                constraints:
                                    const BoxConstraints.tightFor(width: 36),
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(50),
                                    splashColor: preto.withOpacity(.2),
                                    onTap: () {
                                      setState(() {
                                        _isEditing = true;
                                      });
                                    },
                                    child: Container(
                                      constraints:
                                          const BoxConstraints.tightFor(
                                              height: 30, width: 30),
                                      child: Icon(_iconeFinal, color: preto),
                                    ),
                                  ),
                                ),
                              )
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
                                      constraints:
                                          const BoxConstraints.tightFor(
                                              height: 30, width: 30),
                                      child: const Icon(
                                        Icons.dangerous_outlined,
                                        color: vermelho,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    child: Container(
                                      constraints:
                                          const BoxConstraints.tightFor(
                                              height: 30, width: 30),
                                      child: InkWell(
                                        splashColor: verde.withOpacity(.2),
                                        splashFactory: InkRipple.splashFactory,
                                        borderRadius: BorderRadius.circular(50),
                                        onTap: () {
                                          setState(() {
                                            _isEditing = false;
                                            if (widget.checkEdit != null) {
                                              widget.checkEdit!();
                                            }
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
                    : null,
              ),
              onTap: _iconeFinal == Icons.date_range_outlined ? pickDate : null,
              controller: widget.controller,
              obscureText: _isSenha,
              validator: (value) {
                if (widget.validation != null && value!.isEmpty == false) {
                  return widget.validation!(widget.controller.text);
                }
                if (widget.emptyMessage == null) {
                  return null;
                }
                if (value == null || value.isEmpty) {
                  return widget.emptyMessage;
                }
                return null;
              },
              inputFormatters: widget.inputFormatter,
              keyboardType: widget.keyboardType ?? TextInputType.text,
              onChanged: (_) => setState(() {}),
            ),
          ),
        ],
      ),
    );
  }

  pickDate() async {
    final DateTime? data = await showDatePicker(
      keyboardType: TextInputType.datetime,
      context: context,
      locale: const Locale('pt', "BR"),
      initialDate: widget.controller.text.isNotEmpty
          ? DateFormat('dd/MM/yyyy').parse(widget.controller.text)
          : widget.lastDate ?? DateTime.now(),
      firstDate: widget.firstDate ?? DateTime(2000),
      lastDate: widget.lastDate ?? DateTime.now(),
    );

    if (data != null) {
      setState(() {
        widget.controller.text = DateFormat('dd/MM/yyyy').format(data);
        if (widget.checkEdit != null) {
          widget.checkEdit!();
        }
      });
    }
  }

  changeVisibility() {
    setState(() {
      _isSenha = !_isSenha;
      _iconeFinal = _isSenha ? Icons.visibility : Icons.visibility_off;
    });
  }
}
