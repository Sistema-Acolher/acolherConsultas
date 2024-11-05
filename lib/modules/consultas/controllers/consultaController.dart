import 'dart:async';

import 'package:acolherconsultas/modules/consultas/models/consulta.dart';
import 'package:acolherconsultas/modules/pacientes/models/paciente.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

// A classe ConsultaController é a classe que controla os consultas.
class ConsultaController extends ChangeNotifier {
  // Instância do Firestore, que é a classe responsável por realizar a comunicação com o banco de dados Firebase Firestore.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // CRUD -----------------------------------
  Future<String> criarConsulta(ConsultaCadastro consulta) async {
    DocumentReference<Map<String, dynamic>> consultaAdicionada =
        await _firestore.collection("consultas").add(consulta.toMap());

    return consultaAdicionada.id;
  }

  Future<List<Map<String, dynamic>>> selecionarTodosConsulta() async {
    QuerySnapshot querySnapshot =
        await _firestore.collection("consultas").get();
    List<Map<String, dynamic>> consultas = [];

    for (var element in querySnapshot.docs) {
      var consulta = element.data() as Map<String, dynamic>;
      consulta["id"] = element.id;
      consultas.add(consulta);
    }

    return consultas;
  }

  Future<void> atualizarConsulta(
      ConsultaCadastro consulta, String consultaId) async {
    await _firestore
        .collection("consultas")
        .doc(consultaId)
        .update(consulta.toMap());
  }

  Future<void> remover(String consultaId) async {
    await _firestore.collection("consultas").doc(consultaId).delete();
  }

  // Funções extras do banco -----------------------------------
  // Busca uma stream de listas de consulta, esse método substitui getConsultas e atualizarConsultas
  // Ele busca a lista como primeiro evento do aplicativo, e ao atualizar, automaticamente atualiza o app
  Stream<List<ConsultaCadastro>> get consultasStream {
    return _firestore.collection('consultas').snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          var temp = doc.data();
          temp.addAll({'id': doc.id});
          return ConsultaCadastro.fromMap(temp);
        }).toList();
      },
    );
  }

  // Busca uma consulta a partir do Id da mesma
  Future<Map<String, dynamic>?> buscarConsulta(String consultaId) async {
    DocumentSnapshot docsSnapshot =
        await _firestore.collection("consultas").doc(consultaId).get();

    if (!docsSnapshot.exists) {
      return null;
    }

    return docsSnapshot.data() as Map<String, dynamic>;
  }

  // Busca todas as consultas com dataHorario menor que hore
  Future<String?> mudarEstadoConsultas() async {
    try {
      DateTime today = DateTime.now();
      QuerySnapshot docsSnapshot = await _firestore
          .collection("consultas")
          .where("dataHorario",
              isLessThan: DateTime(today.year, today.month, today.day))
          .where("estado", isEqualTo: "agendada")
          .get();

      if (docsSnapshot.size <= 0) {
        return null;
      }

      for (var consulta in docsSnapshot.docs) {
        await consulta.reference.update({"estado": "atrasada"});
      }
      return "Consulta realizada com sucesso";
    } on Exception catch (e) {
      return "Erro ao cadastrar: $e";
    }
  }

  // Vê se um horário naquela casa de apoio está ocupado, retorna null ou o horário
  Future<Map<String, dynamic>?> horarioOcupado(
      String casaApoioId, DateTime dataHorario) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection("consultas")
        .where("casaDeApoioId", isEqualTo: casaApoioId)
        .where("dataHorario", isGreaterThanOrEqualTo: dataHorario)
        .where("dataHorario",
            isLessThan: DateTime(dataHorario.year, dataHorario.month,
                dataHorario.day, dataHorario.hour + 1))
        .get();

    if (querySnapshot.docs.isEmpty) {
      return null;
    }

    return querySnapshot.docs.first.data() as Map<String, dynamic>;
  }

  // Funções da controller -----------------------------------
  // Busca consulta a partir do id da mesma
  Future<ConsultaCadastro> getConsulta(String consultaId) async {
    var consulta = await buscarConsulta(consultaId);
    if (consulta != null) {
      return ConsultaCadastro.fromMap(consulta);
    } else {
      throw Exception("Consulta não existe");
    }
  }

  Future<String> reagendar(
      DateTime dataHorario, ConsultaCadastro consulta) async {
    try {
      if (consulta.id == null) {
        throw Exception("Id da consulta não está presente");
      } else if (await horarioOcupado(consulta.casaDeApoioId, dataHorario) !=
          null) {
        throw Exception("Horário já está ocupado");
      }
      consulta.dataHorario = DateTime(dataHorario.year, dataHorario.month,
          dataHorario.day, dataHorario.hour);
      consulta.estado = "agendada";

      await atualizarConsulta(consulta, consulta.id!);
      return "ConsultaCadastro alterada com sucesso";
    } on Exception catch (e) {
      return "Erro ao cadastrar: $e";
    }
  }

  Future<String> cadastrarConsulta(
      Paciente paciente, DateTime dataHorario) async {
    try {
      if (paciente.id == null) {
        throw Exception("Id do paciente não está presente");
      } else if (await horarioOcupado(paciente.casaDeApoioId, dataHorario) !=
          null) {
        throw Exception("Horário já está ocupado");
      }
      ConsultaCadastro novaConsulta = ConsultaCadastro(
          casaDeApoioId: paciente.casaDeApoioId,
          pacienteId: paciente.id!,
          pacienteNome: paciente.nome,
          dataHorario: dataHorario,
          estado: "agendada",
          dadosConsulta: null);

      await criarConsulta(novaConsulta);
      return "ConsultaCadastro cadastrada com sucesso";
    } on Exception catch (e) {
      return "Erro ao cadastrar: $e";
    }
  }

  Future<String> realizarConsulta(
      String consultaId, Consulta consultaDados) async {
    try {
      var consulta = await getConsulta(consultaId);

      // Criar nova consulta com dados de criança
      consulta.dadosConsulta = consultaDados;

      await atualizarConsulta(consulta, consultaId);
      return "Consulta realizada com sucesso";
    } on Exception catch (e) {
      return "Erro ao cadastrar: $e";
    }
  }
}
