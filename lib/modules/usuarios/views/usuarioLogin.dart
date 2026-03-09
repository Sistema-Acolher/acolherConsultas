import 'package:acolherconsultas/modules/sistema/views/infoScreen.dart';
import 'package:acolherconsultas/modules/usuarios/controllers/usuarioController.dart';
import 'package:acolherconsultas/modules/usuarios/states/usuarioLoginState.dart';
import 'package:acolherconsultas/modules/usuarios/views/usuarioRecuperaSenha.dart';
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

class _UsuarioLoginScreenState extends State<UsuarioLoginScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usuarioLoginController = UsuarioLoginState();
  AnimationController? _animacaoController;
  Animation<double>? _animacao;

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
  void dispose() {
    super.dispose();
    if(_animacaoController != null) {
      _animacaoController!.dispose();
    }
  }

  animacao(){
    if(_animacaoController != null) {
      _animacaoController!.reset();
    }
    _animacaoController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animacao = Tween(
      begin: 0.0,
      end: 1.0
    ).animate(_animacaoController!);
      _animacaoController!.forward();
  }

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
              child: Image(image: AssetImage('src/images/logo.gif'))
            )
          ),
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
                        topRight: Radius.circular(25)
                      )
                    ),
                  ),
                ),
              ),
              Container(
                height: size.height * 0.46,
                padding: const EdgeInsets.all(20),
                margin: EdgeInsets.symmetric(horizontal: size.width * 0.07),
                child: Material(
                  color: Colors.transparent,
                  child: Form(
                    autovalidateMode: AutovalidateMode.disabled,
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Hero(
                          tag: "tituloLogin",
                          child: Text(
                            "LOGIN",
                            style: TextStyle(
                              fontFamily: "BobbyJonesSoft",
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: preto,
                              decoration: TextDecoration.none
                            )
                          ),
                        ),
                        FadeTransition(
                          opacity: _animacao ?? const AlwaysStoppedAnimation(1),
                          child: InputTextoAcolher(
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
                        ),
                        Hero(
                          tag: "inputLogin",
                          child: Material(
                            color: Colors.transparent,
                            child: InputTextoAcolher(
                              label: "Senha", 
                              placeHolder: "Senha",
                              controller: _usuarioLoginController.senha,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              emptyMessage: "Informe a senha",
                            ),
                          ),
                        ),
                        FadeTransition(
                          opacity: _animacao ?? const AlwaysStoppedAnimation(1),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const UsuarioRecuperaSenhaScreen())
                                ).then((value) {
                                  if(value != null && value){
                                    setState(() {
                                      animacao();
                                    });
                                  }
                                });
                                _usuarioLoginController.limparCampos();
                                erroFirebase = "";
                                mostrarErroFirebase = false;
                              },
                              child: const Hero(
                                tag: "esqueciSenha",
                                child: Material(
                                  type: MaterialType.transparency,
                                  child: Text(
                                    "Esqueci minha senha",
                                    style: TextStyle(
                                      color: cinza,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Hero(
                              tag: "botaoInfoLogin",
                              child: IconButton(
                                iconSize: 34,
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => const InfoScreen()
                                  ));
                                }, 
                                icon: const Icon(Icons.info_outlined, color: preto,)
                              ),
                            ),
                            Hero(
                              tag: "botaoEnviarLogin",
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
                      ],
                    ),
                  ),
                ),
              )
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

  // Função que faz a requisição no firebase para realizar o login
  // Loga com sucesso ou mostra mensagem de erro
  login() async{
    context.read<UsuarioController>().showLoading(context);

    try {
        await context.read<UsuarioController>().login(
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
      } else if(e.code.contains("network-request-failed")) {
        setState(() {
          erroFirebase = "Erro: Sem conexão com a internet";
          mostrarErroFirebase = true;
        });
      } else {
        setState(() {
          erroFirebase = "Erro: ${e.code}";
          mostrarErroFirebase = true;
        });
      }
    }
    if(mounted) {
      Navigator.pop(context);
    }
  } 
}