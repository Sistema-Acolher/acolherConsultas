import 'dart:async';

import 'package:acolherconsultas/modules/casasDeApoio/models/casaDeApoio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// A classe CasaDeApoioController é a classe que controla os casasDeApoio.
class CasaDeApoioController extends ChangeNotifier {
  // Instância do Firestore, que é a classe responsável por realizar a comunicação com o banco de dados Firebase Firestore.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Lista de casasDeApoio.
  final List<CasaDeApoio> _casasDeApoio = [];
  List<CasaDeApoio> get casasDeApoio => _casasDeApoio;

  // Casa de apoio selecionada.
  final StreamController<CasaDeApoio> casaDeApoioSelecionadaStream = StreamController<CasaDeApoio>();
  final ValueNotifier<CasaDeApoio> _casaDeApoioSelecionada = ValueNotifier<CasaDeApoio>(CasaDeApoio.vazio());
  ValueNotifier<CasaDeApoio> get casaDeApoioSelecionada => _casaDeApoioSelecionada;

  // CRUD -----------------------------------
  Future<String> criarCasaDeApoio(Map<String, dynamic> casaDeApoio) async {
    return "";
  }

  Future<void> atualizarCasaDeApoio(Map<String, dynamic> casaDeApoio) async {
  }

  Future<List<Map<String, dynamic>>> selecionarTodosCasaDeApoio() async {
    QuerySnapshot querySnapshot = await _firestore.collection("casasDeApoio").get();
    List<Map<String, dynamic>> casasDeApoio = [];

    for (var element in querySnapshot.docs) {
      var casaDeApoio = element.data() as Map<String, dynamic>;
      casaDeApoio["id"] = element.id;
      casasDeApoio.add(casaDeApoio);
    }

    return casasDeApoio;
  }

  Future<void> removerCasaDeApoio(Map<String, dynamic> casaDeApoio) async {
  }

  // Funções extras do banco -----------------------------------
  Stream<List<CasaDeApoio>> get casasDeApoioStream {
    return _firestore.collection('casasDeApoio').snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          var temp = doc.data();
          temp.addAll({'id':doc.id});
          return CasaDeApoio.fromMap(temp);
        }).toList();
      },
    );
  }

  // Funções da controller -----------------------------------
  // Método que seleciona uma casaDeApoio.
  void selecionarCasaDeApoio(CasaDeApoio casaDeApoio){
    casaDeApoioSelecionadaStream.sink.add(casaDeApoio);
  }
}