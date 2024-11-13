import 'package:acolherconsultas/modules/genogramaEcomapa/models/ecomapa.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PacienteEcomapaController extends ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // salva um ecomapa no banco de dados
  Future<String> saveEcomapa(Ecomapa ecomapa, String pacienteId) async{
    try{
      ecomapa.dataCriacao = DateTime.now();
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      Map<String, dynamic> ecomapaMap = ecomapa.toMap();
      ecomapaMap['idPaciente'] = pacienteId;

      String id = ecomapaMap['id'];
      ecomapaMap.remove('id');

      await firestore.collection("ecomapa").doc(id).update(ecomapaMap);
      return "Ecomapa atualizado com sucesso!";
    }catch(e){
      return "Erro ao cadastrar ecomapa!";
    }
  }

  // salva um novo ecomapa no banco de dados
  Future<String> saveNewEcomapa(Ecomapa ecomapa, String pacienteId) async{
    try{
      ecomapa.dataCriacao = DateTime.now();
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      Map<String, dynamic> ecomapaMap = ecomapa.toMap();
      ecomapaMap['idPaciente'] = pacienteId;

      ecomapaMap.remove('id');
      
      await firestore.collection("ecomapa").add(ecomapaMap);
      return "Ecomapa cadastrado com sucesso!";
    }catch(e){
      return "Erro ao cadastrar ecomapa!";
    }
  }
  
  // retorna todos os ecomapas do paciente em questão
  Future<List<Ecomapa>> getEcomapasPaciente(String idPaciente) async{
    QuerySnapshot<Map> querySnapshot = await firestore.collection("ecomapa").where("idPaciente", isEqualTo: idPaciente).get();
    List<Ecomapa> listEcomapas = [];

    for (var element in querySnapshot.docs) {
      var ecomapaMap = element.data() as Map<String, dynamic>;
      ecomapaMap['id'] = element.id;

      listEcomapas.add(Ecomapa.fromMap(ecomapaMap));
    }

    return listEcomapas;
  }

  // remove um ecomapa do banco de dados
  Future<String> removeEcomapa(String idEcomapa) async{
    try{
      await firestore.collection("ecomapa").doc(idEcomapa).delete();
      return "Ecomapa removido com sucesso!";
    }catch(e){
      return "Erro ao remover ecomapa!";
    }
  }
}