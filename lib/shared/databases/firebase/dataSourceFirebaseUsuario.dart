import 'package:acolherconsultas/shared/databases/dataSources/dataSourceUsuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Class que implementa a classe abstrata DataSourceUsuario, e é responsável por realizar a comunicação com o banco de dados Firebase.

class DataSourceFirebaseUsuario extends DataSourceUsuario {
  // Instância do Firestore, que é a classe responsável por realizar a comunicação com o banco de dados Firebase Firestore.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> atualizar(Map<String, dynamic> usuario) async {
  }

  @override
  Future<Map<String, dynamic>?> criar(Map<String, dynamic> usuario) async {
    // Remove o id do map usuário, pois o id é gerado automaticamente pelo Firebase.
    final id = usuario["id"];
    usuario.remove("id");
    // Adiciona o usuário no banco de dados com o nome do documento sendo o id do usuário.
    await _firestore.collection("usuarios").doc(id).set(usuario);

    return usuario;
  }

  @override
  Future<void> remover(Map<String, dynamic> usuario) async {
  }

  @override
  Future<Map<String, dynamic>?> selecionar(String uid) async {
    DocumentSnapshot docSnapshot = await _firestore.collection("usuarios").doc(uid).get();

    return docSnapshot.data() as Map<String, dynamic>?;
  }

  @override
  Future<List<Map<String, dynamic>>> selecionarTodos() async {
    QuerySnapshot querySnapshot = await _firestore.collection("usuarios").get();
    List<Map<String, dynamic>> usuarios = [];

    for (var element in querySnapshot.docs) {
      var usuario = element.data() as Map<String, dynamic>;
      usuario["id"] = element.id;
      usuarios.add(usuario);
    }

    return usuarios;
  }
  
  
  
}