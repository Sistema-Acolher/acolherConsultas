import 'package:flutter/material.dart';

class UsuarioLoginState {
  final email = TextEditingController();
  final senha = TextEditingController();

  void limparCampos() {
    email.clear();
    senha.clear();
  }
}