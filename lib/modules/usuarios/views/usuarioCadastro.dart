import 'package:acolherconsultas/modules/usuarios/controllers/usuarioController.dart';
import 'package:acolherconsultas/modules/usuarios/states/usuarioCadastroState.dart';
import 'package:acolherconsultas/shared/components/bars/pacienteAppbar.dart';
import 'package:acolherconsultas/shared/components/buttons/standartRoundButton.dart';
import 'package:acolherconsultas/shared/components/inputs/inputRadioButtons.dart';
import 'package:acolherconsultas/shared/components/inputs/inputTexto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  ValueNotifier<bool> isCheckedNotifier = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PacienteAppbar(),
      resizeToAvoidBottomInset: false,
      floatingActionButton: StandartRoundButton(
        text: "Cadastrar",
        icon: Symbols.book,
        onPressed: (){
          if (isCheckedNotifier.value == false){
            setState(() {
              isCheckedNotifier.value = true;
            });
          }
          if (_formKey.currentState!.validate()) {
            if(_usuarioCadastroState.senha.text != _usuarioCadastroState.confirmarSenha.text){
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("As senhas devem ser idênticas"),
                  backgroundColor: Colors.red,
                )
              );
            }else {
              cadastrar();
            }
          }
        },
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
                InputRadioButtonsCadastroPaciente(
                  options: const [
                    "Admin",
                    "Acolher",
                    "Instituição",
                  ], 
                  label: "Nível de Acesso", 
                  controller: _usuarioCadastroState.nivelAcesso, 
                  isChecked: isCheckedNotifier
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  cadastrar() async{
    try {
      // Cria um objeto de usuário e tenta cadastrar no firebase
      final cadastro = _usuarioCadastroState.cadastroUsuario();
      await context.read<UsuarioProvider>().cadastrar(cadastro, _usuarioCadastroState.senha.text);
    } on FirebaseAuthException catch (e) {
      if(e.code.contains("email-already-in-use")){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Email já cadastrado"),
            backgroundColor: Colors.red,
          )
        );
      }
    }
  }
}