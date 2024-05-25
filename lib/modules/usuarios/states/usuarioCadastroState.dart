import 'package:acolherconsultas/modules/casasDeApoio/models/casaDeApoio.dart';
import 'package:acolherconsultas/modules/usuarios/models/usuario.dart';
import 'package:flutter/material.dart';

class UsuarioCadastroState {
  final nome = TextEditingController();
  final email = TextEditingController();
  final senha = TextEditingController();
  final confirmarSenha = TextEditingController();
  final nivelAcesso = TextEditingController();
  final casaDeApoio = TextEditingController();

  // Função para limpar os campos de cadastro
  void limparCampos() {
    nome.clear();
    email.clear();
    senha.clear();
    confirmarSenha.clear();
    nivelAcesso.clear();
    casaDeApoio.clear();
  }

  // Função para criar um objeto de usuário
  Usuario cadastroUsuario(List<CasaDeApoio> casasDeApoioCadastradas) {
    String nivelAcessoString = nivelAcesso.text.trim().toLowerCase();
    if(nivelAcessoString == "instituição"){
      nivelAcessoString = "casaDeApoio";
    }
    String? casaDeApoioId;

    if(casasDeApoioCadastradas.isNotEmpty && nivelAcessoString == "casaDeApoio"){
      casaDeApoioId = casasDeApoioCadastradas.firstWhere((element) => element.nome == casaDeApoio.text.trim()).id;
    }
    
    final usuario = Usuario(
      nome: nome.text.trim(),
      email: email.text.trim().toLowerCase(),
      nivelAcesso: NivelAcesso.values.firstWhere((element) => element.name == nivelAcessoString),
      casaDeApoioId: casaDeApoioId,
    );
    
    return usuario;
  }
}