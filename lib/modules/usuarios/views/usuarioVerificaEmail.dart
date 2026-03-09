import 'dart:async';

import 'package:acolherconsultas/modules/usuarios/controllers/usuarioController.dart';
import 'package:acolherconsultas/shared/colors.dart';
import 'package:acolherconsultas/shared/components/buttons/loginButton.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerificaEmailScreen extends StatefulWidget {
  const VerificaEmailScreen({super.key});

  @override
  State<VerificaEmailScreen> createState() => _VerificaEmailScreenState();
}

class _VerificaEmailScreenState extends State<VerificaEmailScreen> {
  bool reenviarEmail = false;
  bool erroFirebase = false;
  String? erroFirebaseMsg;

  late Timer _timer;
  int _start = 60;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            reenviarEmail = true;
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    enviaEmail();
    context.read<UsuarioController>().timerRedirect(context);
    startTimer();
  }

  enviaEmail(){
    try {
      context.read<UsuarioController>().enviarEmailVerificacao();
    } on Exception catch (e) {
      setState(() {
        erroFirebase = true;
        erroFirebaseMsg = "Erro ao enviar o email de verificação: ${e.toString()}";
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () async {
              await context.read<UsuarioController>().logout();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: size.height * 0.06),
            Container(
              margin: EdgeInsets.symmetric(horizontal: size.width * 0.15),
              child: const Hero(
                  tag: "logo",
                  child: Image(image: AssetImage('src/images/logo.gif'))
              )
            ),
            SizedBox(height: size.height * 0.12),
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
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Hero(
                      tag: "tituloLogin",
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 20, top: 10),
                        child: AutoSizeText("Verifique o seu e-mail",
                          maxLines: 1,
                          style: TextStyle(
                              fontFamily: "BobbyJonesSoft",
                              fontWeight: FontWeight.bold,
                              color: preto,
                              decoration: TextDecoration.none),
                          minFontSize: 21,
                        ),      
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LoginButton(
                          onPressed: reenviarEmail ? () async {
                            await context.read<UsuarioController>().enviarEmailVerificacao().then((value) {
                              const snackBar = SnackBar(
                                elevation: 0,
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.transparent,
                                content: AwesomeSnackbarContent(
                                  title: 'Atenção',
                                  message:
                                      'Outro e-mail de verificação foi enviado para o e-mail cadastrado.',
                                  contentType: ContentType.help,
                                ),
                                duration: Duration(seconds: 10),
                              );
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(snackBar);
                            });
                            setState(() {
                              _start = 60;
                              reenviarEmail = false;
                              startTimer();
                            });
                          } : null,
                          text:
                            _start == 0 && reenviarEmail ? "Reenviar email" :
                            "Reenviar email: $_start s",
                          fontSizeFactor: .65,
                          verticalPaddingFactor: .8,
                          horizontalPaddingFactor: .8,
                        ),
                        const SizedBox(width: 10),
                        LoginButton(
                          onPressed: () async {
                            await context.read<UsuarioController>().verificarEmail(context);
                          },
                          text: "Continuar",
                          fontSizeFactor: .65,
                          verticalPaddingFactor: .8,
                          horizontalPaddingFactor: .8,
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    if(erroFirebase)
                      Text(
                        erroFirebaseMsg!,
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}