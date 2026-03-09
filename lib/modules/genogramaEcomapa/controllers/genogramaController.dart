import 'package:acolherconsultas/modules/genogramaEcomapa/models/genograma.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PacienteGenogramaController extends ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // salva um genograma no banco de dados
  Future<String> saveGenograma(Genograma genograma, String pacienteId) async{
    try{
      genograma.dataCriacao = DateTime.now();
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      Map<String, dynamic> genogramaMap = genograma.toMap();
      genogramaMap['idPaciente'] = pacienteId;
      
      String id = genogramaMap['id'];
      genogramaMap.remove('id');

      await firestore.collection("genograma").doc(id).update(genogramaMap);
      return "Genograma atualizado com sucesso!";
    }catch(e){
      return "Erro ao cadastrar genograma!";
    }
  }

  //salva um novo genograma no banco de dados
  Future<String> saveNewGenograma(Genograma genograma, String pacienteId) async{
    try{
      genograma.dataCriacao = DateTime.now();
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      Map<String, dynamic> genogramaMap = genograma.toMap();
      genogramaMap['idPaciente'] = pacienteId;

      genogramaMap.remove('id');
      
      await firestore.collection("genograma").add(genogramaMap);
      return "Genograma cadastrado com sucesso!";
    }catch(e){
      return "Erro ao cadastrar genograma!";
    }
  }
  
  // retorna todos os genogramas do paciente em questão
  Future<List<Genograma>> getGenogramasPaciente(String idPaciente) async{
    QuerySnapshot<Map> querySnapshot = await firestore.collection("genograma").where("idPaciente", isEqualTo: idPaciente).get();
    List<Genograma> listGenogramas = [];

    for (var element in querySnapshot.docs) {
      var genogramaMap = element.data() as Map<String, dynamic>;
      genogramaMap['id'] = element.id;

      listGenogramas.add(Genograma.fromMap(genogramaMap));
    }

    return listGenogramas;
  }

  // remove um genograma do banco de dados
  Future<String> removeGenograma(String idGenograma) async{
    try{
      await firestore.collection("genograma").doc(idGenograma).delete();
      return "Genograma removido com sucesso!";
    }catch(e){
      return "Erro ao remover genograma!";
    }
  }
}