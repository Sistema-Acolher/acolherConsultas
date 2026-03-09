import 'package:acolherconsultas/modules/usuarios/controllers/usuarioController.dart';
import 'package:acolherconsultas/modules/usuarios/states/usuarioLoginState.dart';
import 'package:acolherconsultas/shared/colors.dart';
import 'package:acolherconsultas/shared/components/buttons/loginButton.dart';
import 'package:acolherconsultas/shared/components/inputs/inputTexto.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mask/mask/mask.dart';
import 'package:provider/provider.dart';

class UsuarioRecuperaSenhaScreen extends StatefulWidget {
  const UsuarioRecuperaSenhaScreen({super.key});

  @override
  State<UsuarioRecuperaSenhaScreen> createState() =>
      _UsuarioRecuperaSenhaScreenState();
}

class _UsuarioRecuperaSenhaScreenState
    extends State<UsuarioRecuperaSenhaScreen> {
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
          Hero(
            tag: "gradienteCima",
            child: Container(
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
          ),
          Container(
              margin: EdgeInsets.symmetric(horizontal: size.width * 0.15),
              child: const Hero(
                  tag: "logo",
                  child: Image(image: AssetImage('src/images/logo.gif')))),
          Stack(
            children: [
              Hero(
                tag: "containerLogin",
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    height: size.height * 0.45,
                    padding: const EdgeInsets.all(20),
                    margin: EdgeInsets.symmetric(horizontal: size.width * 0.07),
                    decoration: const BoxDecoration(
                        color: amareloEscuro,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(25),
                            topRight: Radius.circular(25))),
                  ),
                ),
              ),
              Container(
                height: size.height * 0.45,
                padding: const EdgeInsets.all(20),
                margin: EdgeInsets.symmetric(horizontal: size.width * 0.07),
                child: Form(
                  autovalidateMode: AutovalidateMode.disabled,
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          const Hero(
                            tag: "tituloLogin",
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: AutoSizeText("Recuperação de Senha",
                                maxLines: 1,
                                style: TextStyle(
                                    fontFamily: "BobbyJonesSoft",
                                    fontWeight: FontWeight.bold,
                                    color: preto,
                                    decoration: TextDecoration.none),
                                minFontSize: 20,
                              ),      
                            ),
                          ),
                          Hero(
                            tag: "inputLogin",
                            child: Material(
                              color: Colors.transparent,
                              child: InputTextoAcolher(
                                label: "Usuário",
                                placeHolder: "Email",
                                controller: _usuarioLoginController.email,
                                validation: (value) => Mask.validations
                                    .email(value, error: "Email inválido"),
                                keyboardType: TextInputType.emailAddress,
                                emptyMessage:
                                    "Informe um email para recuperação de senha",
                              ),
                            ),
                          ),
                          if (mostrarErroFirebase && erroFirebase != "")
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: size.height * 0.008),
                              child: Center(
                                child: Text(
                                  erroFirebase,
                                  style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          if (!mostrarErroFirebase && erroFirebase == "")
                            SizedBox(height: size.height * 0.03),
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Hero(
                              tag: "botaoInfoLogin",
                              child: IconButton(
                                  iconSize: 34,
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                  },
                                  icon: const Icon(
                                    Icons.arrow_circle_left_outlined,
                                    color: preto,
                                  )),
                            ),
                            Hero(
                              tag: "botaoEnviarLogin",
                              child: LoginButton(
                                text: "Enviar e-mail",
                                onPressed: () {
                                  // Se os campos estiverem válidos, tenta realizar o login
                                  if (_formKey.currentState!.validate()) {
                                    recuperarSenha();
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: size.height * 0.075,
          ),
          Hero(
            tag: "gradienteBaixo",
            child: Container(
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
          ),
        ],
      ),
    );
  }

  
  void recuperarSenha() async {
    try {
      // 1. Espera o Firebase enviar o email
      await context.read<UsuarioController>().auth.sendPasswordResetEmail(email: _usuarioLoginController.email.text);

      // 2. Trava de segurança: verifica se a tela ainda existe antes de usar o context
      if (!mounted) return;

      // 3. Cria o SnackBar
      const snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Informe',
          message: 'Um link de recuperação foi enviado para o e-mail indicado.',
          contentType: ContentType.help,
        ),
        duration: Duration(seconds: 10),
      );

      // 4. Mostra o SnackBar PRIMEIRO
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);

      // 5. Fecha a tela DEPOIS
      Navigator.pop(context, true);

    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        setState(() {
          erroFirebase = "Email inválido";
          mostrarErroFirebase = true;
        });
      } else {
        setState(() {
          erroFirebase = "Erro: ${e.code}";
          mostrarErroFirebase = true;
        });
      }
    }
  }

}