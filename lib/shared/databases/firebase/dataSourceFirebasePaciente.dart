import 'package:acolherconsultas/shared/databases/dataSources/dataSourcePaciente.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Class que implementa a classe abstrata DataSourcePacientes, e é responsável por realizar a comunicação com o banco de dados Firebase.

class DataSourceFirebasePacientes extends DataSourcePacientes {
  // Instância do Firestore, que é a classe responsável por realizar a comunicação com o banco de dados Firebase Firestore.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> atualizar(Map<String, dynamic> paciente, String id) async {
    // print(paciente);
    // print(id);
    paciente.remove('dataCadastro');
    await _firestore.collection("pacientes").doc(id).update(paciente).then(
        (value) => print("paciente atualizado"),
        onError: (e) => print("Erro ao atualizar: $e"));
  }
  @override
  Future<String> criar(Map<String, dynamic> paciente) async {
    DocumentReference<Map<String, dynamic>> pacienteAdicionado = await _firestore.collection("pacientes").add(paciente);

    return pacienteAdicionado.id;
  }

  @override
  Future<void> remover(Map<String, dynamic> paciente) async {
  }

  // Quatro métodos que realizam uma query no banco de dados do Firebase Firestore para encontrar um paciente em específico, utilizando diferentes parâmetros.
  @override
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

  @override
  Future<Map<String, dynamic>?> selecionarCpf(String cpf) async {
    QuerySnapshot querySnapshot = await _firestore.collection("pacientes").where("paciente.cpf", isEqualTo: cpf).get();

    if(querySnapshot.docs.isEmpty){
      return null;
    }
    
    return querySnapshot.docs.first.data() as Map<String, dynamic>;
  }
  
  @override
  Future<Map<String, dynamic>?> selecionarNumeroCartaoSus(String numeroCartaoSus) async {
    QuerySnapshot querySnapshot = await _firestore.collection("pacientes").where("paciente.numeroCartaoSus", isEqualTo: numeroCartaoSus).get();

    if(querySnapshot.docs.isEmpty){
      return null;
    }

    return querySnapshot.docs.first.data() as Map<String, dynamic>;
  }
  
  @override
  Future<Map<String, dynamic>?> selecionarRg(String rg) async {
    QuerySnapshot querySnapshot = await _firestore.collection("pacientes").where("paciente.rg", isEqualTo: rg).get();

    if(querySnapshot.docs.isEmpty){
      return null;
    }

    return querySnapshot.docs.first.data() as Map<String, dynamic>;
  }

  @override
  Future<List<Map<String, dynamic>>> selecionarTodos() async {
    QuerySnapshot querySnapshot = await _firestore.collection("pacientes").get();
    List<Map<String, dynamic>> pacientes = [];

    for (var element in querySnapshot.docs) {
      var paciente = element.data() as Map<String, dynamic>;
      paciente["id"] = element.id;
      pacientes.add(paciente);
    }

    return pacientes;
  }
}