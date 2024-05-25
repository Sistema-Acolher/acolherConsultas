import 'package:acolherconsultas/modules/usuarios/controllers/usuarioController.dart';
import 'package:acolherconsultas/modules/usuarios/states/usuarioLoginState.dart';
import 'package:acolherconsultas/shared/colors.dart';
import 'package:acolherconsultas/shared/components/buttons/loginButton.dart';
import 'package:acolherconsultas/shared/components/inputs/inputTexto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mask/mask/mask.dart';
import 'package:provider/provider.dart';

class UsuarioLoginScreen extends StatefulWidget {
  const UsuarioLoginScreen({super.key});

  @override
  State<UsuarioLoginScreen> createState() => _UsuarioLoginScreenState();
}

class _UsuarioLoginScreenState extends State<UsuarioLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usuarioLoginController = UsuarioLoginState();

  // Cores do "gradiente" de cima
  final listaCoresCima = [
    verdeEscuro,
    const Color(0xFF363636),
    const Color(0xFF363636),
    amarelo,
    amarelo,
    azul,
  ];
  // Cores do "gradiente" de baixo
  final listaCoresBaixo = [
    vermelho,
    verdeEscuro,
    verdeEscuro,
    azul,
    azul,
    amarelo,
  ];

  // Paradas do "gradiente" 
  final listaParadas = [0.25, 0.25, 0.5, 0.5, 0.75, 0.75];

  // Variáveis para mostrar erro do firebase
  bool mostrarErroFirebase = false;
  String erroFirebase = "";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double paddingtop = MediaQuery.of(context).padding.top;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: paddingtop + (size.height * 0.065),
            width: size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: listaCoresCima,
                stops: listaParadas,
                end: Alignment.centerRight,
                begin: Alignment.centerLeft,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: size.width * 0.15),
            child: const Image(image: AssetImage('src/images/logo.gif'))
          ),
          Container(
            padding: const EdgeInsets.all(20),
            margin: EdgeInsets.symmetric(horizontal: size.width * 0.07),
            decoration: const BoxDecoration(
              color: amareloEscuro,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                topRight: Radius.circular(25)
              )
            ),
            child: Form(
              autovalidateMode: AutovalidateMode.disabled,
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "LOGIN",
                    style: TextStyle(
                      fontFamily: "BobbyJonesSoft",
                      fontSize: 26,
                      fontWeight: FontWeight.bold
                    )
                  ),
                  InputTextoAcolher(
                    label: "Usuário",
                    placeHolder: "Email",
                    controller: _usuarioLoginController.email,
                    validation: (value) => Mask.validations.email(
                      value,
                      error: "Email inválido"
                    ),
                    keyboardType: TextInputType.emailAddress,
                    emptyMessage: "Informe o email",
                  ),
                  InputTextoAcolher(
                    label: "Senha", 
                    placeHolder: "Senha",
                    controller: _usuarioLoginController.senha,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    emptyMessage: "Informe a senha",
                  ),
                  if (mostrarErroFirebase && erroFirebase != "")
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: size.height * 0.008),
                          child: Center(
                            child: Text(
                              erroFirebase,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 13,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                  if (!mostrarErroFirebase && erroFirebase == "")
                    SizedBox(height: size.height * 0.04),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: LoginButton(
                      text: "Entrar", 
                      onPressed: () {
                        // Se os campos estiverem válidos, tenta realizar o login
                        if(_formKey.currentState!.validate()){
                          login();
                        }
                      },
                    ),
                  ),
                ],
              ),
            )
          ),
          SizedBox(
            height: size.height * 0.075,
          ),
          Container(
            height: size.height * 0.065,
            width: size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: listaCoresBaixo,
                stops: listaParadas,
                end: Alignment.centerRight,
                begin: Alignment.centerLeft,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Função que faz a requisição no firebase para realizar o login
  // Loga com sucesso ou mostra mensagem de erro
  login() async{
    try {
        await context.read<UsuarioProvider>().login(
          _usuarioLoginController.email.text.trim().toLowerCase(),
          _usuarioLoginController.senha.text
        );
        _usuarioLoginController.limparCampos();
      } on FirebaseAuthException catch (e) {
        if (e.code.contains("invalid-credential")) {
          setState(() {
            erroFirebase = "Usuário ou senha inválidos";
            mostrarErroFirebase = true;
          });
        } else {
          setState(() {
            erroFirebase = "Erro ao realizar login";
            mostrarErroFirebase = true;
          });
        }
    }
  }
}