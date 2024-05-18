import 'package:acolherconsultas/modules/sistema/views/home.dart';
import 'package:acolherconsultas/shared/colors.dart';
import 'package:acolherconsultas/shared/components/buttons/loginButton.dart';
import 'package:acolherconsultas/shared/components/inputs/inputTexto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask/mask/mask.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final listaCoresCima = [
    verdeEscuro,
    Color(0xFF363636),
    Color(0xFF363636),
    amarelo,
    amarelo,
    azul,
  ];
  final listaCoresBaixo = [
    vermelho,
    verdeEscuro,
    verdeEscuro,
    azul,
    azul,
    amarelo,
  ];

  final listaParadas = [0.25, 0.25, 0.5, 0.5, 0.75, 0.75];

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
                    controller: _emailController,
                    validation: (value) => Mask.validations.email(
                      value,
                      error: "Email inválido"
                    ),
                    emptyMessage: "Informe o email",
                  ),
                  InputTextoAcolher(
                    label: "Senha", 
                    placeHolder: "Senha",
                    controller: _senhaController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    emptyMessage: "Informe a senha",
                  ),
                  SizedBox(height: size.height * 0.01),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: LoginButton(
                      text: "Entrar", 
                      onPressed: () {
                        if(_formKey.currentState!.validate()){
                          Navigator.pushReplacement(
                            context, 
                            MaterialPageRoute(builder: (context) => const HomePage())
                          );
                        }
                      },
                      
                    ),
                  ),
                ],
              ),
            )
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
}