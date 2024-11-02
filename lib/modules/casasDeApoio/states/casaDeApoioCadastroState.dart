import 'package:acolherconsultas/modules/casasDeApoio/models/casaDeApoio.dart';
import 'package:flutter/material.dart';

class CasaDeApoioCadastroState {
  final nome = TextEditingController();
  final cep = TextEditingController();
  final rua = TextEditingController();
  final numero = TextEditingController();
  final bairro = TextEditingController();
  final cidade = TextEditingController();
  Color cor = Colors.transparent;

  // Função para limpar os campos de cadastro
  void limparCampos() {
    nome.clear();
    cep.clear();
    rua.clear();
    numero.clear();
    bairro.clear();
    cidade.clear();
    cor = Colors.transparent;
  }

  // Função para criar um objeto de usuário
  CasaDeApoio cadastroCasaDeApoio() {    
    final casaDeApoio = CasaDeApoio(
      nome: nome.text.trim(),
      cep: cep.text.trim(),
      rua: rua.text.trim(),
      numero: numero.text.trim(),
      bairro: bairro.text.trim(),
      cidade: cidade.text.trim(),
      cor: cor.value,
    );
    
    return casaDeApoio;
  }
}