import 'package:acolherconsultas/modules/cadastroPaciente/models/paciente.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ControllerCadastroPaciente extends ChangeNotifier {
  final nome = TextEditingController();
  final genero = TextEditingController();
  final rg = TextEditingController();
  final numeroCartaoSus = TextEditingController();
  final cpf = TextEditingController();
  final dataNascimento = TextEditingController();

  Future<String> cadastro() async{
    try{
      Paciente paciente = Paciente.fromMap({
        "nome": nome.text,
        "genero": genero.text,
        "rg": rg.text,
        "numeroCartaoSus": numeroCartaoSus.text,
        "cpf": cpf.text,
        "dataNascimento": dataNascimento.text
      });

      FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection("pacientes").add(paciente.toMap());
      
      return "Paciente cadastrado com sucesso!";
    }catch(e){
      return "Erro ao cadastrar paciente!";
    }
  }
}