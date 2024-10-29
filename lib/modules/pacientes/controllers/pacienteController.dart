import 'package:acolherconsultas/modules/casasDeApoio/models/casaDeApoio.dart';
import 'package:acolherconsultas/modules/pacientes/models/paciente.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// A classe PacientesController é a classe que controla os pacientes cadastrados.
class PacientesController extends ChangeNotifier {
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
  // Busca uma stream de listas de pacientes, esse método substitui getPacientes
  // Ele busca a lista como primeiro evento do aplicativo, e ao atualizar, automaticamente atualiza o app 
  Stream<List<CadastroPaciente>> get pacientesStream {
    return _firestore.collection('pacientes').snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          var temp = doc.data();
          temp.addAll({'id':doc.id});
          return CadastroPaciente.fromMap(temp);
        }).toList();
      },
    );
  }

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
  // Método que cadastra um paciente, atualiza a lista de pacientes e notifica os 'ouvintes'.
  Future<String> cadastrarPaciente(
      CadastroPaciente cadastroPaciente, CasaDeApoio casaDeApoio) async {
    try {
      Paciente paciente = cadastroPaciente.paciente;
      paciente.casaDeApoioId = casaDeApoio.id!;
      if (await selecionarCpf(paciente.cpf) != null) {
        throw CadastroPacienteExpection("CPF já cadastrado");
      } else if (await selecionarRg(paciente.rg) != null) {
        throw CadastroPacienteExpection("RG já cadastrado");
      } else if (await selecionarNumeroCartaoSus(paciente.numeroCartaoSus) != null) {
        throw CadastroPacienteExpection(
            "Número do cartão do SUS já cadastrado");
      } else {
        // Caso o paciente não esteja cadastrado, o cadastro é requisitado para o repositório de pacientes.
        // No caso, cadastra diretamente para o Firebase.
        String id = await criarPaciente(cadastroPaciente);
        cadastroPaciente.paciente.id = id;

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
      atualizaPaciente.paciente.casaDeApoioId = casaDeApoioId;
      await atualizarPaciente(atualizaPaciente, id);

      return "Paciente atualizado com sucesso";
    } on Exception catch (e) {
      return "Erro ao cadastrar: $e";
    }
  }

  // Método que calcula a idade do paciente a partir da data de nascimento e retorna uma string com a idade formatada.
  static String calcularIdade(DateTime dataNascimento) {
    final DateTime agora = DateTime.now();
    final int idade = agora.year - dataNascimento.year;
    final int mesAtual = agora.month;
    final int mesNascimento = dataNascimento.month;
    final int diaAtual = agora.day;
    final int diaNascimento = dataNascimento.day;

    String idadeString = "";
    int anos = 0;
    int dias = 0;
    int meses = 0;

    if (mesAtual < mesNascimento) {
      anos = idade - 1;
      meses = mesAtual - mesNascimento + 12;
      if (diaAtual < diaNascimento) {
        dias = diaAtual - diaNascimento + 30;
      } else {
        dias = diaAtual - diaNascimento;
      }
    } else if (mesAtual == mesNascimento) {
      if (diaAtual < diaNascimento) {
        anos = idade - 1;
        meses = mesAtual - mesNascimento + 11;
        dias = diaAtual - diaNascimento + 30;
      } else {
        anos = idade;
        meses = mesAtual - mesNascimento;
        dias = diaAtual - diaNascimento;
      }
    } else {
      anos = idade;
      if (diaAtual >= diaNascimento) {
        meses = mesAtual - mesNascimento;
        dias = diaAtual - diaNascimento;
      } else {
        meses = mesAtual - mesNascimento - 1;
        dias = diaAtual - diaNascimento + 30;
      }
    }

    if (anos > 0) idadeString += "${anos}a ";
    if (meses > 0) idadeString += "${meses}m ";
    if (dias > 0) idadeString += "${dias}d";

    if (idadeString.isEmpty) idadeString = "Menos de 1 dia";

    return idadeString;
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
