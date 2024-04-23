import 'package:acolherconsultas/modules/cadastroPaciente/controllers/controllerCadastroPaciente.dart';
import 'package:acolherconsultas/shared/components/textfields/inputCadastroPaciente.dart';
import 'package:flutter/material.dart';

class CadastroPaciente extends StatefulWidget {
  const CadastroPaciente({super.key, required this.title});

  final String title;

  @override
  State<CadastroPaciente> createState() => _CadastroPacienteState();
}

class _CadastroPacienteState extends State<CadastroPaciente> {
  final _controllerCadastroPaciente = ControllerCadastroPaciente();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // go back button
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: ListView(
            children: [
              InputCadastroPaciente(
                label: "Nome", 
                controller: _controllerCadastroPaciente.nome, 
                obscureText: false
              ),
              InputCadastroPaciente(
                label: "Gênero", 
                controller: _controllerCadastroPaciente.genero, 
                obscureText: false
              ),
              InputCadastroPaciente(
                label: "RG", 
                controller: _controllerCadastroPaciente.rg, 
                obscureText: false
              ),
              InputCadastroPaciente(
                label: "Número do Cartão do SUS", 
                controller: _controllerCadastroPaciente.numeroCartaoSus, 
                obscureText: false
              ),
              InputCadastroPaciente(
                label: "CPF", 
                controller: _controllerCadastroPaciente.cpf, 
                obscureText: false
              ),
              InputCadastroPaciente(
                label: "Data de Nascimento", 
                controller: _controllerCadastroPaciente.dataNascimento, 
                obscureText: false
              ),
              ElevatedButton(
                onPressed: () => _controllerCadastroPaciente.cadastro(), 
                child: const Text("Cadastrar")
              )
            ],
          ),
        ),
      )
    );
  }
}