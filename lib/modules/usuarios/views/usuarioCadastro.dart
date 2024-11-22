import 'dart:async';

import 'package:acolherconsultas/modules/casasDeApoio/models/casaDeApoio.dart';
import 'package:acolherconsultas/modules/usuarios/controllers/usuarioController.dart';
import 'package:acolherconsultas/modules/usuarios/models/usuario.dart';
import 'package:acolherconsultas/modules/usuarios/states/usuarioCadastroState.dart';
import 'package:acolherconsultas/shared/components/bars/pacienteAppbar.dart';
import 'package:acolherconsultas/shared/components/buttons/standartRoundButton.dart';
import 'package:acolherconsultas/shared/components/dropdown/inputDropdown.dart';
import 'package:acolherconsultas/shared/components/inputs/inputRadioButtons.dart';
import 'package:acolherconsultas/shared/components/inputs/inputTexto.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask/mask/mask.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';

class CadastroUsuarioScreen extends StatefulWidget {
  const CadastroUsuarioScreen({super.key, this.usuario});

  final Usuario? usuario;

  @override
  State<CadastroUsuarioScreen> createState() => _CadastroUsuarioScreenState();
}

class _CadastroUsuarioScreenState extends State<CadastroUsuarioScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usuarioCadastroState = UsuarioCadastroState();
  ValueNotifier<List<CasaDeApoio>> casasDeApoioCadastradas = ValueNotifier<List<CasaDeApoio>>([]);
  ValueNotifier<bool> radiobuttonNotifier = ValueNotifier<bool>(false);
  ValueNotifier<bool> dropdownNotifier = ValueNotifier<bool>(false);
  ValueNotifier<String> nivelSelecionadoNotifier = ValueNotifier<String>("");
  // Variáveis para mostrar erro do firebase
  bool mostrarErroFirebase = false;
  String erroFirebase = "";
  bool isButtonEnabled = true;

  @override
  void initState() {
    super.initState();
    _usuarioCadastroState.nivelAcesso.addListener(() {
      setState(() {
        nivelSelecionadoNotifier.value = _usuarioCadastroState.nivelAcesso.text;
      });
    });

    _usuarioCadastroState.casaDeApoio.addListener(() {
      setState(() {});
    });

    switch(widget.usuario?.nivelAcesso.name){
      case "admin":
        _usuarioCadastroState.nivelAcesso.text = "Admin";
        break;
      case "acolher":
        _usuarioCadastroState.nivelAcesso.text = "Acolher";
        break;
      case "casaDeApoio":
        _usuarioCadastroState.nivelAcesso.text = "Instituição";
        break;
      default:
        _usuarioCadastroState.nivelAcesso.text = "";
    }
    _usuarioCadastroState.nome.text = widget.usuario?.nome ?? "";
    _usuarioCadastroState.email.text = widget.usuario?.email ?? "";

    radiobuttonNotifier = ValueNotifier<bool>(false);
    dropdownNotifier = ValueNotifier<bool>(false);
    nivelSelecionadoNotifier = ValueNotifier<String>(_usuarioCadastroState.nivelAcesso.text);
  }

  void _buscarCasasDeApoio() {
    casasDeApoioCadastradas.value = Provider.of<List<CasaDeApoio>>(context)
      .toList();
    // Seleciona a casa de apoio do usuário
    if(widget.usuario != null && widget.usuario?.nivelAcesso == NivelAcesso.casaDeApoio){
      _usuarioCadastroState.casaDeApoio.text = casasDeApoioCadastradas.value.firstWhere((element) => element.id == widget.usuario?.casaDeApoioId).nome ?? "";
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _buscarCasasDeApoio();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PacienteAppbar(admin: true),
      resizeToAvoidBottomInset: false,
      floatingActionButton: Visibility(
        visible: infoAlterada(),
        child: StandartRoundButton(
          text: widget.usuario != null ? "Salvar" : "Cadastrar",
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
                if(widget.usuario != null) {
                  atualizar();
                } else {
                  cadastrar();
                }
              }
              setState(() {
                dropdownNotifier.value = false;
                radiobuttonNotifier.value = false;
              });            
            }
          },
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: nivelSelecionadoNotifier,

        builder: (context, value, child) {
          return Center(
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
                      icone: widget.usuario != null ? Icons.edit : null,
                      checkEdit: () {
                        setState(() {
                          _usuarioCadastroState.nome.text = _usuarioCadastroState.nome.text.trim();
                        });
                      },
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
                      readOnly: widget.usuario != null,
                    ),
                    if(mostrarErroFirebase && erroFirebase.contains("Email"))
                      Text(
                        erroFirebase,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 13
                        ),
                      ),
                    widget.usuario == null ? InputTextoAcolher(
                      label: "Senha ",
                      controller: _usuarioCadastroState.senha,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      emptyMessage: "Informe a senha",
                    ) : const SizedBox(),
                    widget.usuario == null ? InputTextoAcolher(
                      label: "Confirmar Senha",
                      controller: _usuarioCadastroState.confirmarSenha,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      emptyMessage: "Informe a senha",
                    ) : const SizedBox(),
                    if(mostrarErroFirebase && erroFirebase.contains("senha") && widget.usuario != null)
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
                        list: casasDeApoioCadastradas.value.map((e) => e.toMap()["nome"] as String).toList(),
                        label: "Casa de Apoio", 
                        checkNotifier: dropdownNotifier, 
                        controller: _usuarioCadastroState.casaDeApoio
                      ),
                    if(mostrarErroFirebase && erroFirebase.contains("Erro"))
                      Center(
                        child: Text(
                          erroFirebase,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 13
                          ),
                        ),
                      ),
                    // Botão para enviar email de recuperação de senha
                    if(widget.usuario != null)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            const Text(
                              "Caso precise alterar a senha:",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            const SizedBox(height: 20),
                            StandartRoundButton(
                              text: "Enviar e-mail",
                              icon: Symbols.email,
                              onPressed: isButtonEnabled ? () async {
                                setState(() {
                                  isButtonEnabled = false;
                                });
                                
                                Timer(const Duration(seconds: 30), () {
                                  setState(() {
                                    isButtonEnabled = true;
                                  });
                                });
                                context.read<UsuarioController>().showLoading(context);
                                try {
                                  await context.read<UsuarioController>().enviarEmailRecuperacaoSenha(widget.usuario?.email ?? "").then(
                                    (value) {
                                      Navigator.of(context).pop();
                                      final snackBar = SnackBar(
                                        elevation: 0,
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.transparent,
                                        content: AwesomeSnackbarContent(
                                          title: 'Sucesso',
                                          message:
                                              'Email de recuperação de senha enviado para ${widget.usuario?.email}',
                                          contentType: ContentType.success,
                                        ),
                                        duration: const Duration(seconds: 10),
                                      );
                                      ScaffoldMessenger.of(context)
                                        ..hideCurrentSnackBar()
                                        ..showSnackBar(snackBar);
                                    }
                                  );
                                } on FirebaseAuthException catch (e) {
                                  if(e.code.contains("user-not-found")){
                                    setState(() {
                                      erroFirebase = "Usuário não encontrado";
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
                              } : null
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }

  bool infoAlterada(){
    if(widget.usuario == null){
      return true;
    }
    if(_usuarioCadastroState.nome.text.trim() != widget.usuario?.nome){
      return true;
    }
    if(_usuarioCadastroState.email.text.trim() != widget.usuario?.email){
      return true;
    }
    String nivelAcesso;
    switch(widget.usuario?.nivelAcesso){
      case NivelAcesso.admin:
        nivelAcesso = "Admin";
        break;
      case NivelAcesso.acolher:
        nivelAcesso = "Acolher";
        break;
      case NivelAcesso.casaDeApoio:
        nivelAcesso = "Instituição";
        break;
      default:
        nivelAcesso = "";
    }
    
    if(_usuarioCadastroState.nivelAcesso.text != nivelAcesso){
      return true;
    }
    
    if(_usuarioCadastroState.casaDeApoio.text != casasDeApoioCadastradas.value.firstWhere(
      (element) => element.id == widget.usuario?.casaDeApoioId,
      orElse: () => CasaDeApoio(
        nome: "",
        cep: "",
        rua: "",
        numero: "",
        bairro: "",
        cidade: "",
        cor: 0
      )
    ).nome){
      return true;
    }
    return false;
  }

  cadastrar() async{
    context.read<UsuarioController>().showLoading(context);
    try {
      // Cria um objeto de usuário e tenta cadastrar no firebase
      final cadastro = _usuarioCadastroState.cadastroUsuario(casasDeApoioCadastradas.value);
      await context.read<UsuarioController>().cadastrar(cadastro, _usuarioCadastroState.senha.text).then(
        (value) {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          // Snackbar informando que um email de verificação foi enviado
          const snackBar = SnackBar(
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  content: AwesomeSnackbarContent(
                    title: 'Atenção',
                    message:
                        'Um e-mail de verificação foi enviado para o e-mail cadastrado.',
                    contentType: ContentType.help,
                  ),
                  duration: Duration(seconds: 10),
                );
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
        }
        );
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
  }

  atualizar() async{
    context.read<UsuarioController>().showLoading(context);
    try {
      // Cria um objeto de usuário e tenta atualizar no firebase
      final cadastro = _usuarioCadastroState.cadastroUsuario(casasDeApoioCadastradas.value);
      cadastro.id = widget.usuario?.id;
      await context.read<UsuarioController>().atualizarUsuario(cadastro.toMap()).then(
        (value) {
          Navigator.of(context).pop();
          Navigator.of(context).pop();

          const snackBar = SnackBar(
                elevation: 0,
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.transparent,
                content: AwesomeSnackbarContent(
                  title: 'Sucesso',
                  message:
                      'Usuário atualizado com sucesso!',
                  contentType: ContentType.success,
                ),
                duration: Duration(seconds: 10),
              );
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
        }
      );
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
  }
}