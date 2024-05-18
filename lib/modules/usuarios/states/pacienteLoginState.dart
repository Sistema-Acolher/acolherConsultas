import 'package:acolherconsultas/modules/usuarios/models/usuario.dart';
import 'package:flutter/material.dart';

class UsuarioLoginState {
  final email = TextEditingController();
  final senha = TextEditingController();

  void limparCampos() {
    email.clear();
    senha.clear();
  }
}