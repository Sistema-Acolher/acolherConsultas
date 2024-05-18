import 'package:acolherconsultas/shared/databases/dataSources/dataSourceConsulta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Class que implementa a classe abstrata DataSourceConsulta, e é responsável por realizar a comunicação com o banco de dados Firebase.

class DataSourceFirebaseConsulta extends DataSourceConsulta {
  // Instância do Firestore, que é a classe responsável por realizar a comunicação com o banco de dados Firebase Firestore.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> atualizar(Map<String, dynamic> consulta) async {
  }

  @override
  Future<String> criar(Map<String, dynamic> consulta) async {
    return "";
  }

  @override
  Future<void> remover(Map<String, dynamic> consulta) async {
  }

  @override
  Future<List<Map<String, dynamic>>> selecionarTodos() async {
    QuerySnapshot querySnapshot = await _firestore.collection("consultas").get();
    List<Map<String, dynamic>> consultas = [];

    for (var element in querySnapshot.docs) {
      var consulta = element.data() as Map<String, dynamic>;
      consulta["id"] = element.id;
      consultas.add(consulta);
    }

    return consultas;
  }
}