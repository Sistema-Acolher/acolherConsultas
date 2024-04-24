import 'package:acolherconsultas/shared/databases/dataSources/dataSourceCadastroPacientes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataSourceFirebasePacientes extends DataSourcePacientes {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<void> atualizar(Map<String, dynamic> paciente) async {
  }

  @override
  Future<String> criar(Map<String, dynamic> paciente) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference<Map<String, dynamic>> pacienteAdicionado = await firestore.collection("pacientes").add(paciente);

    return pacienteAdicionado.id;
  }

  @override
  Future<void> remover(Map<String, dynamic> paciente) async {
  }

  @override
  Future<Map<String, dynamic>?> selecionar(String cpf, String rg, String numeroCartaoSus) async {
    QuerySnapshot querySnapshot = await firestore.collection("pacientes")
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
    QuerySnapshot querySnapshot = await firestore.collection("pacientes").where("paciente.cpf", isEqualTo: cpf).get();

    if(querySnapshot.docs.isEmpty){
      return null;
    }
    
    return querySnapshot.docs.first.data() as Map<String, dynamic>;
  }
  
  @override
  Future<Map<String, dynamic>?> selecionarNumeroCartaoSus(String numeroCartaoSus) async {
    QuerySnapshot querySnapshot = await firestore.collection("pacientes").where("paciente.numeroCartaoSus", isEqualTo: numeroCartaoSus).get();

    if(querySnapshot.docs.isEmpty){
      return null;
    }

    return querySnapshot.docs.first.data() as Map<String, dynamic>;
  }
  
  @override
  Future<Map<String, dynamic>?> selecionarRg(String rg) async {
    QuerySnapshot querySnapshot = await firestore.collection("pacientes").where("paciente.rg", isEqualTo: rg).get();

    if(querySnapshot.docs.isEmpty){
      return null;
    }

    return querySnapshot.docs.first.data() as Map<String, dynamic>;
  }

  @override
  Future<List<Map<String, dynamic>>> selecionarTodos() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await firestore.collection("pacientes").get();
    List<Map<String, dynamic>> pacientes = [];

    for (var element in querySnapshot.docs) {
      pacientes.add(element.data() as Map<String, dynamic>);
    }

    return pacientes;
  }
}