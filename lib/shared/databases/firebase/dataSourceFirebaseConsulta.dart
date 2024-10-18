import 'package:acolherconsultas/shared/databases/dataSources/dataSourceConsulta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Class que implementa a classe abstrata DataSourceConsulta, e é responsável por realizar a comunicação com o banco de dados Firebase.

class DataSourceFirebaseConsulta extends DataSourceConsulta {
  // Instância do Firestore, que é a classe responsável por realizar a comunicação com o banco de dados Firebase Firestore.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> atualizar(Map<String, dynamic> consulta,String consultaId) async {
    await _firestore.collection("consultas").doc(consultaId).update(consulta);
  }

  @override
  Future<String> criar(Map<String, dynamic> consulta) async {
    DocumentReference<Map<String, dynamic>> consultaAdicionada = await _firestore.collection("consultas").add(consulta);

    return consultaAdicionada.id;
  }

  @override
  Future<Map<String, dynamic>?> buscarConsulta(String consultaId) async {
    DocumentSnapshot docsSnapshot = await _firestore.collection("consultas").doc(consultaId).get();

    if(!docsSnapshot.exists){
      return null;
    }
    
    return docsSnapshot.data() as Map<String, dynamic>;
  }

  @override
  Future<void> remover(String consultaId) async {
    await _firestore.collection("consultas").doc(consultaId).delete();
  }

  @override
  Future<Map<String, dynamic>?> horarioOcupado(String casaApoioId, DateTime dataHorario) async {
    QuerySnapshot querySnapshot = await _firestore.collection("consultas")
      .where("casaDeApoioId", isEqualTo: casaApoioId)
      .where("dataHorario", isGreaterThanOrEqualTo: dataHorario)
      .where("dataHorario", isLessThan: DateTime(dataHorario.year,dataHorario.month,dataHorario.day,dataHorario.hour+1))
      .get();

    if(querySnapshot.docs.isEmpty){
      return null;
    }
    
    return querySnapshot.docs.first.data() as Map<String, dynamic>;
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