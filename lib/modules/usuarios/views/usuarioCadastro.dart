import 'package:acolherconsultas/modules/casasDeApoio/controller/casaDeApoioController.dart';
import 'package:acolherconsultas/modules/casasDeApoio/models/casaDeApoio.dart';
import 'package:acolherconsultas/modules/usuarios/controllers/usuarioController.dart';
import 'package:acolherconsultas/modules/usuarios/states/usuarioCadastroState.dart';
import 'package:acolherconsultas/shared/components/bars/pacienteAppbar.dart';
import 'package:acolherconsultas/shared/components/buttons/standartRoundButton.dart';
import 'package:acolherconsultas/shared/components/dropdown/inputDropdown.dart';
import 'package:acolherconsultas/shared/components/inputs/inputRadioButtons.dart';
import 'package:acolherconsultas/shared/components/inputs/inputTexto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mask/mask/mask.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';

class CadastroUsuarioScreen extends StatefulWidget {
  const CadastroUsuarioScreen({super.key});

  @override
  State<CadastroUsuarioScreen> createState() => _CadastroUsuarioScreenState();
}

class _CadastroUsuarioScreenState extends State<CadastroUsuarioScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usuarioCadastroState = UsuarioCadastroState();
  List<CasaDeApoio> casasDeApoioCadastradas = [];
  ValueNotifier<bool> radiobuttonNotifier = ValueNotifier<bool>(false);
  ValueNotifier<bool> dropdownNotifier = ValueNotifier<bool>(false);
  ValueNotifier<String> nivelSelecionadoNotifier = ValueNotifier<String>("");
  // Variáveis para mostrar erro do firebase
  bool mostrarErroFirebase = false;
  String erroFirebase = "";

  @override
  void initState() {
    super.initState();
    _usuarioCadastroState.nivelAcesso.addListener(() {
      nivelSelecionadoNotifier.value = _usuarioCadastroState.nivelAcesso.text;
    });
    casasDeApoioCadastradas = context.read<CasaDeApoioController>().casasDeApoio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PacienteAppbar(admin: true),
      resizeToAvoidBottomInset: false,
      floatingActionButton: StandartRoundButton(
        text: "Salvar",
        icon: Symbols.book,
        onPressed: (){
          if (radiobuttonNotifier.value == false) {
              setState(() {
                radiobuttonNotifier.value = true;
              });
          }
          if (dropdownNotifier.value == false) {
            setState(() {
              dropdownNotifier.value = true;
            });
          }
          if (_formKey.currentState!.validate() && _usuarioCadastroState.nivelAcesso.text.isNotEmpty && (_usuarioCadastroState.casaDeApoio.text.isNotEmpty || _usuarioCadastroState.nivelAcesso.text != "Instituição")) {
            if(_usuarioCadastroState.senha.text != _usuarioCadastroState.confirmarSenha.text){
              setState(() {
                erroFirebase = "As senhas não coincidem";
                mostrarErroFirebase = true;
              });
            }else {
              setState(() {
                erroFirebase = "";
                mostrarErroFirebase = false;
              });
              cadastrar();
            }
            setState(() {
              dropdownNotifier.value = false;
              radiobuttonNotifier.value = false;
            });            
          }
        },
      ),
      body: ValueListenableBuilder(
        valueListenable: nivelSelecionadoNotifier,
        builder: (context, value, child) => Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Form(
              autovalidateMode: AutovalidateMode.disabled,
              key: _formKey,
              child: ListView(
                children: [
                  InputTextoAcolher(
                    label: "Nome",
                    controller: _usuarioCadastroState.nome,
                    keyboardType: TextInputType.name,
                    validation: (value) => Mask.validations
                        .generic(value, error: "Nome inválido", min: 3),
                    inputFormatter: [
                      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                      LengthLimitingTextInputFormatter(50),
                    ],
                    emptyMessage: "Informe o nome",
                  ),
                  InputTextoAcolher(
                    label: "Email",
                    controller: _usuarioCadastroState.email,
                    validation: (value) => Mask.validations.email(
                      value,
                      error: "Email inválido"
                    ),
                    emptyMessage: "Informe o email",
                    keyboardType: TextInputType.emailAddress,
                  ),
                  if(mostrarErroFirebase && erroFirebase.contains("Email"))
                    Text(
                      erroFirebase,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 13
                      ),
                    ),
                  InputTextoAcolher(
                    label: "Senha ",
                    controller: _usuarioCadastroState.senha,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    emptyMessage: "Informe a senha",
                  ),
                  InputTextoAcolher(
                    label: "Confirmar Senha",
                    controller: _usuarioCadastroState.confirmarSenha,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    emptyMessage: "Informe a senha",
                  ),
                  if(mostrarErroFirebase && erroFirebase.contains("senha"))
                    Text(
                      erroFirebase,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 13
                      ),
                    ),
                  InputRadioButtonsCadastroPaciente(
                    options: const [
                      "Admin",
                      "Acolher",
                      "Instituição",
                    ], 
                    label: "Nível de Acesso", 
                    controller: _usuarioCadastroState.nivelAcesso, 
                    isChecked: radiobuttonNotifier
                  ),
                  if(_usuarioCadastroState.nivelAcesso.text == "Instituição")
                    InputDropdown(
                      // lista de casasDeApoio.nome a partir da lista de casasDeApoio.data
                      list: casasDeApoioCadastradas.map((e) => e.toMap()["nome"] as String).toList(),
                      label: "Casa de Apoio", 
                      checkNotifier: dropdownNotifier, 
                      controller: _usuarioCadastroState.casaDeApoio
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  cadastrar() async{
    try {
      // Cria um objeto de usuário e tenta cadastrar no firebase
      final cadastro = _usuarioCadastroState.cadastroUsuario(casasDeApoioCadastradas);
      await context.read<UsuarioController>().cadastrar(cadastro, _usuarioCadastroState.senha.text).then((value) => Navigator.of(context).pop());
    } on FirebaseAuthException catch (e) {
      if(e.code.contains("email-already-in-use")){
        setState(() {
          erroFirebase = "Email já cadastrado";
          mostrarErroFirebase = true;
        });
      } else if(e.code.contains("weak-password")){
        setState(() {
          erroFirebase = "A senha deve ter no mínimo 6 caracteres";
          mostrarErroFirebase = true;
        });
      } else {
        setState(() {
          erroFirebase = "Erro ao cadastrar";
          mostrarErroFirebase = true;
        });
      }
    }
  }
}