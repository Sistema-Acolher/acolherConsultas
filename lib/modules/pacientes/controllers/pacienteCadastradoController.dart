import 'package:acolherconsultas/modules/casasDeApoio/models/casaDeApoio.dart';
import 'package:acolherconsultas/modules/pacientes/models/pacienteCadastro.dart';
import 'package:acolherconsultas/modules/pacientes/models/paciente.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// A classe PacientesCadastradosController é a classe que controla os pacientes cadastrados.
class PacientesCadastradosController extends ChangeNotifier {
  // Instância do Firestore, que é a classe responsável por realizar a comunicação com o banco de dados Firebase Firestore.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Lista de pacientes cadastrados.
  final List<CadastroPaciente> _pacientes = [];
  List<CadastroPaciente> get pacientes => _pacientes;

  // Último paciente cadastrado.
  CadastroPaciente? _pacienteCadastrado;
  CadastroPaciente? get pacienteCadastrado => _pacienteCadastrado;

  // CRUD -----------------------------------
  Future<String> criarPaciente(CadastroPaciente paciente) async {
    DocumentReference<Map<String, dynamic>> pacienteAdicionado = await _firestore.collection("pacientes").add(paciente.toMap());

    return pacienteAdicionado.id;
  }

  Future<List<Map<String, dynamic>>> selecionarTodosPaciente() async {
    QuerySnapshot querySnapshot = await _firestore.collection("pacientes").get();
    List<Map<String, dynamic>> pacientes = [];

    for (var element in querySnapshot.docs) {
      var paciente = element.data() as Map<String, dynamic>;
      paciente["id"] = element.id;
      pacientes.add(paciente);
    }

    return pacientes;
  }
  
  Future<void> atualizarPaciente(CadastroPaciente paciente, String id) async {
    Map<String, dynamic> pacienteMap = paciente.toMap();
    pacienteMap.remove('dataCadastro');
    await _firestore.collection("pacientes").doc(id).update(pacienteMap);
  }
  
  Future<void> removerPaciente(Map<String, dynamic> paciente) async {
  }

  // Funções extras do banco -----------------------------------
  // Quatro métodos que realizam uma query no banco de dados do Firebase Firestore para encontrar um paciente em específico, utilizando diferentes parâmetros.
  Future<Map<String, dynamic>?> selecionar(String cpf, String rg, String numeroCartaoSus) async {
    QuerySnapshot querySnapshot = await _firestore.collection("pacientes")
                                          .where("paciente.cpf", isEqualTo: cpf)
                                          .where("paciente.rg", isEqualTo: rg)
                                          .where("paciente.numeroCartaoSus", isEqualTo: numeroCartaoSus)
                                          .get();

    if(querySnapshot.docs.isEmpty){
      return null;
    }
    
    return querySnapshot.docs.first.data() as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>?> selecionarCpf(String cpf) async {
    QuerySnapshot querySnapshot = await _firestore.collection("pacientes").where("paciente.cpf", isEqualTo: cpf).get();

    if(querySnapshot.docs.isEmpty){
      return null;
    }
    
    return querySnapshot.docs.first.data() as Map<String, dynamic>;
  }
  
  Future<Map<String, dynamic>?> selecionarNumeroCartaoSus(String numeroCartaoSus) async {
    QuerySnapshot querySnapshot = await _firestore.collection("pacientes").where("paciente.numeroCartaoSus", isEqualTo: numeroCartaoSus).get();

    if(querySnapshot.docs.isEmpty){
      return null;
    }

    return querySnapshot.docs.first.data() as Map<String, dynamic>;
  }
  
  Future<Map<String, dynamic>?> selecionarRg(String rg) async {
    QuerySnapshot querySnapshot = await _firestore.collection("pacientes").where("paciente.rg", isEqualTo: rg).get();

    if(querySnapshot.docs.isEmpty){
      return null;
    }

    return querySnapshot.docs.first.data() as Map<String, dynamic>;
  }

  // Funções da controller -----------------------------------
  // Método que busca a lista de pacientes cadastrados e notifica os 'ouvintes'.
  Future<void> getPacientes() async {
    _pacientes.clear();

    for (var paciente in await selecionarTodosPaciente()) {
      CadastroPaciente p = CadastroPaciente.fromMap(paciente);
      p.id = paciente["id"];
      _pacientes.add(p);
    }

    notifyListeners();
  }

  // Método que cadastra um paciente, atualiza a lista de pacientes e notifica os 'ouvintes'.
  Future<String> cadastrarPaciente(
      CadastroPaciente cadastroPaciente, CasaDeApoio casaDeApoio) async {
    try {
      Paciente paciente = cadastroPaciente.paciente;
      paciente.casaDeApoioId = casaDeApoio.id!;
      if (await selecionarCpf(paciente.cpf??"") != null) {
        throw CadastroPacienteExpection("CPF já cadastrado");
      } else if (await selecionarRg(paciente.rg??"") != null) {
        throw CadastroPacienteExpection("RG já cadastrado");
      } else if (await selecionarNumeroCartaoSus(paciente.numeroCartaoSus??"") != null) {
        throw CadastroPacienteExpection(
            "Número do cartão do SUS já cadastrado");
      } else {
        // Caso o paciente não esteja cadastrado, o cadastro é requisitado para o repositório de pacientes.
        // No caso, cadastra diretamente para o Firebase.
        String id = await criarPaciente(cadastroPaciente);
        cadastroPaciente.id = id;

        _pacientes.add(cadastroPaciente);
        _pacienteCadastrado = cadastroPaciente;
        notifyListeners();
        return "Paciente cadastrado!";
      }
    } on CadastroPacienteExpection catch (e) {
      return Future.error("Erro ao cadastrar: $e");
    }
  }

  Future<String> atualizaPaciente(CadastroPaciente atualizaPaciente, String id,
      String casaDeApoioId) async {
    try {
      //Paciente paciente = atualizaPaciente.paciente;

      /* if (await cpfCadastrado(paciente.cpf)) {
        return "Erro ao cadastrar: CPF já cadastrado";
      } else if (await rgCadastrado(paciente.rg)) {
        return "Erro ao cadastrar: RG já cadastrado";
      } else if (await numeroCartaoSusCadastrado(paciente.numeroCartaoSus)) {
        return "Erro ao cadastrar: Número do cartão do SUS já cadastrado";
      } else {*/
      atualizaPaciente.paciente.casaDeApoioId = casaDeApoioId;
      await atualizarPaciente(atualizaPaciente, id);

      return "Paciente atualizado com sucesso";
    } on Exception catch (e) {
      return "Erro ao cadastrar: $e";
    }
  }
}

class CadastroPacienteExpection implements Exception {
  final String message;

  CadastroPacienteExpection(this.message); // Pass your message in constructor.

  @override
  String toString() {
    return message;
  }
}
