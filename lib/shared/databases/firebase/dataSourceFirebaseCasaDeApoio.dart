import 'package:acolherconsultas/shared/databases/dataSources/dataSourceCasaDeApoio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Class que implementa a classe abstrata DataSourceCasaDeApoio, e é responsável por realizar a comunicação com o banco de dados Firebase.

class DataSourceFirebaseCasaDeApoio extends DataSourceCasaDeApoio {
  // Instância do Firestore, que é a classe responsável por realizar a comunicação com o banco de dados Firebase Firestore.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> atualizar(Map<String, dynamic> casaDeApoio) async {
  }

  @override
  Future<String> criar(Map<String, dynamic> casaDeApoio) async {
    return "";
  }

  @override
  Future<void> remover(Map<String, dynamic> casaDeApoio) async {
  }

  @override
  Future<List<Map<String, dynamic>>> selecionarTodos() async {
    QuerySnapshot querySnapshot = await _firestore.collection("casasDeApoio").get();
    List<Map<String, dynamic>> casasDeApoio = [];

    for (var element in querySnapshot.docs) {
      var casaDeApoio = element.data() as Map<String, dynamic>;
      casaDeApoio["id"] = element.id;
      casasDeApoio.add(casaDeApoio);
    }

    return casasDeApoio;
  }
}