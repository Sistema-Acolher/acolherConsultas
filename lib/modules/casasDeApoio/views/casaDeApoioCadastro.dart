import 'package:acolherconsultas/modules/casasDeApoio/models/casaDeApoio.dart';
import 'package:acolherconsultas/modules/casasDeApoio/states/casaDeApoioCadastroState.dart';
import 'package:acolherconsultas/shared/colors.dart';
import 'package:acolherconsultas/shared/components/bars/pacienteAppbar.dart';
import 'package:acolherconsultas/shared/components/buttons/standartRoundButton.dart';
import 'package:acolherconsultas/shared/components/inputs/inputTexto.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask/mask/mask.dart';
import 'package:mask/models/hashtag_is.dart';
import 'package:material_symbols_icons/symbols.dart';

class CadastroCasaDeApoioScreen extends StatefulWidget {
  const CadastroCasaDeApoioScreen({super.key, this.casaDeApoio});

  final CasaDeApoio? casaDeApoio;

  @override
  State<CadastroCasaDeApoioScreen> createState() => _CadastroCasaDeApoioScreenState();
}

class _CadastroCasaDeApoioScreenState extends State<CadastroCasaDeApoioScreen> {
  final _formKey = GlobalKey<FormState>();
  final _casaDeApoioState = CasaDeApoioCadastroState();
  bool mostrarErro = false;
  String erro = "";

  @override
  void initState() {
    super.initState();
    if(widget.casaDeApoio != null){
      _casaDeApoioState.nome.text = widget.casaDeApoio!.nome ?? "";
      _casaDeApoioState.cep.text = widget.casaDeApoio!.cep ?? "";
      _casaDeApoioState.rua.text = widget.casaDeApoio!.rua ?? "";
      _casaDeApoioState.numero.text = widget.casaDeApoio!.numero ?? "";
      _casaDeApoioState.bairro.text = widget.casaDeApoio!.bairro ?? "";
      _casaDeApoioState.cidade.text = widget.casaDeApoio!.cidade ?? "";
      _casaDeApoioState.cor = Color(widget.casaDeApoio!.cor ?? 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PacienteAppbar(admin: true),
      resizeToAvoidBottomInset: false,
      floatingActionButton: Visibility(
        visible: infoAlterada(),
        child: StandartRoundButton(
          text: "Salvar",
          icon: Symbols.book,
          onPressed: (){
            if (_formKey.currentState!.validate()) {
              setState(() {
                erro = "";
                mostrarErro = false;
              });
              if(widget.casaDeApoio != null) {
                // atualizar();
              } else {
                // cadastrar();
              }
            }
            if(_casaDeApoioState.cor == Colors.transparent){
                setState(() {
                  erro = "Selecione uma cor para a instituição";
                  mostrarErro = true;
                });
              }
          },
        ),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Form(
            autovalidateMode: AutovalidateMode.disabled,
            key: _formKey,
            child: ListView(
              children: [
                InputTextoAcolher(
                  label: "Nome",
                  controller: _casaDeApoioState.nome,
                  keyboardType: TextInputType.name,
                  validation: (value) => Mask.validations
                      .generic(value, error: "Nome inválido", min: 3),
                  inputFormatter: [
                    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                    LengthLimitingTextInputFormatter(50),
                  ],
                  emptyMessage: "Informe o nome",
                  icone: widget.casaDeApoio != null ? Icons.edit : null,
                  checkEdit: () {
                    setState(() {});
                  },
                ),
                InputTextoAcolher(
                  label: "CEP",
                  controller: _casaDeApoioState.cep,
                  validation: (value) => Mask.validations
                      .generic(value, error: "CEP inválido", min: 8),
                  inputFormatter: [
                    Mask.generic(
                        masks: ["#####-###"],
                        hashtag: Hashtag.numbers)
                  ],
                  emptyMessage: "Informe o CEP",
                  keyboardType: TextInputType.number,
                  icone: widget.casaDeApoio != null ? Icons.edit : null,
                  checkEdit: () {
                    setState(() {});
                  },
                ),
                InputTextoAcolher(
                  label: "Rua",
                  controller: _casaDeApoioState.rua,
                  validation: (value) => Mask.validations
                      .generic(value, error: "Rua inválida", min: 1),
                  inputFormatter: [
                    // permite apenas letras, espaços e números
                    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9 ]")),
                    LengthLimitingTextInputFormatter(50),
                  ],
                  emptyMessage: "Informe a rua",
                  keyboardType: TextInputType.name,
                  icone: widget.casaDeApoio != null ? Icons.edit : null,
                  checkEdit: () {
                    setState(() {});
                  },
                ),
                InputTextoAcolher(
                  label: "Número",
                  controller: _casaDeApoioState.numero,
                  validation: (value) => Mask.validations
                      .generic(value, error: "Número inválido", min: 1),
                  inputFormatter: [
                    // permite apenas números
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  emptyMessage: "Informe o número",
                  keyboardType: TextInputType.number,
                  icone: widget.casaDeApoio != null ? Icons.edit : null,
                  checkEdit: () {
                    setState(() {});
                  },
                ),
                InputTextoAcolher(
                  label: "Bairro",
                  controller: _casaDeApoioState.bairro,
                  validation: (value) => Mask.validations
                      .generic(value, error: "Bairro inválido", min: 1),
                  inputFormatter: [
                    // permite apenas letras, espaços e números
                    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9 ]")),
                    LengthLimitingTextInputFormatter(50),
                  ],
                  emptyMessage: "Informe o bairro",
                  keyboardType: TextInputType.name,
                  icone: widget.casaDeApoio != null ? Icons.edit : null,
                  checkEdit: () {
                    setState(() {});
                  },
                ),
                InputTextoAcolher(
                  label: "Cidade",
                  controller: _casaDeApoioState.cidade,
                  validation: (value) => Mask.validations
                      .generic(value, error: "Cidade inválida", min: 3),
                  inputFormatter: [
                    // permite apenas letras e espaços
                    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                    LengthLimitingTextInputFormatter(60),
                  ],
                  emptyMessage: "Informe a cidade",
                  keyboardType: TextInputType.name,
                  icone: widget.casaDeApoio != null ? Icons.edit : null,
                  checkEdit: () {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  "Cor da instituição",
                  style: TextStyle(
                    color: preto,
                    fontFamily: "Montserrat",
                  ),
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                        color: _casaDeApoioState.cor,
                        border: Border.all(color: preto, width: 1.8),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      height: 35,
                      width: 35,
                    ),
                    onTap: () {
                      // mostrar ColorPicker para escolher a cor do desenho
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            surfaceTintColor: Colors.transparent,
                            backgroundColor: Colors.transparent,
                            scrollable: true,
                            content: ColorPicker(
                              enableShadesSelection: false,
                              color: _casaDeApoioState.cor,
                              onColorChanged: (Color color) {
                                setState(() {
                                  _casaDeApoioState.cor = color;
                                });
                              },
                              pickersEnabled: const <ColorPickerType, bool>{
                                ColorPickerType.accent: false,
                                ColorPickerType.bw: false,
                                ColorPickerType.primary: false,
                                ColorPickerType.wheel: true,
                                ColorPickerType.customSecondary: false,
                                ColorPickerType.both: false,
                                ColorPickerType.custom: false
                              },
                            ),
                          );
                        }
                      );
                    },
                  ),
                ),
                if(mostrarErro)
                  Text(
                    erro,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 13
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool infoAlterada(){
    if(widget.casaDeApoio == null){
      return true;
    }
    if(_casaDeApoioState.nome.text != widget.casaDeApoio!.nome){
      return true;
    }
    if(_casaDeApoioState.cep.text != widget.casaDeApoio!.cep){
      return true;
    }
    if(_casaDeApoioState.rua.text != widget.casaDeApoio!.rua){
      return true;
    }
    if(_casaDeApoioState.numero.text != widget.casaDeApoio!.numero){
      return true;
    }
    if(_casaDeApoioState.bairro.text != widget.casaDeApoio!.bairro){
      return true;
    }
    if(_casaDeApoioState.cidade.text != widget.casaDeApoio!.cidade){
      return true;
    }
    if(_casaDeApoioState.cor.value != widget.casaDeApoio!.cor){
      return true;
    }
    return false;
  }
}