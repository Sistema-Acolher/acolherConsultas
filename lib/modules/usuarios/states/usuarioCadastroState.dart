import 'package:acolherconsultas/modules/usuarios/models/usuario.dart';
import 'package:flutter/material.dart';

class UsuarioCadastroState {
  final nome = TextEditingController();
  final email = TextEditingController();
  final senha = TextEditingController();
  final confirmarSenha = TextEditingController();
  final nivelAcesso = TextEditingController();
  final casaDeApoioId = TextEditingController();

  // Função para limpar os campos de cadastro
  void limparCampos() {
    nome.clear();
    email.clear();
    senha.clear();
    confirmarSenha.clear();
    nivelAcesso.clear();
    casaDeApoioId.clear();
  }

  // Função para criar um objeto de usuário
  Usuario cadastroUsuario() {
    String nivelAcessoString = nivelAcesso.text.trim().toLowerCase();
    if(nivelAcessoString == "instituição"){
      nivelAcessoString = "casaDeApoio";
    }

    final usuario = Usuario(
      nome: nome.text.trim(),
      email: email.text.trim().toLowerCase(),
      nivelAcesso: NivelAcesso.values.firstWhere((element) => element.name == nivelAcesso.text.trim().toLowerCase()),
      casaDeApoioId: casaDeApoioId.text.isEmpty ? null : casaDeApoioId.text.trim(),
    );
    
    return usuario;
  }
}