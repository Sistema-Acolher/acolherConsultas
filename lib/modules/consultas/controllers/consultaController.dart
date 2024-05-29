import 'dart:async';

import 'package:acolherconsultas/modules/consultas/models/consulta.dart';
import 'package:acolherconsultas/modules/pacientes/models/paciente.dart';
import 'package:acolherconsultas/shared/databases/repositories/consultaRepository.dart';
import 'package:flutter/foundation.dart';

// A classe ConsultaController é a classe que controla os consultas.
class ConsultaController extends ChangeNotifier {
  // Repositório de consultas, com métodos de CRUD.
  final _repository = ConsultaRepository();

  // Lista de consultas.
  final List<Consulta> _consultas = [];
  List<Consulta> get consultas => _consultas;

  final _consultasStreamController = StreamController<List<Consulta>>.broadcast();

  // Stream getter para mandar a consulta stream
  Stream<List<Consulta>> get streamConsultas => _consultasStreamController.stream;

  void _updateConsultas(List<Consulta> consultas) {
    _consultas.clear();
    _consultas.addAll(consultas);
    _consultasStreamController.add(_consultas);
    notifyListeners();
  }

  // Método que busca a lista de consultas e notifica os 'ouvintes'.
  Future<void> getConsultas() async {
    // Limpa a lista de consultas.
    _consultas.clear();

    // Busca a lista de consultas no repositório de consultas e adiciona na lista de consultas do provedor.
    for(var consulta in await _repository.selecionarTodos()){
      Consulta c = Consulta.fromMap(consulta);
      c.id = consulta["id"];
      _consultas.add(c);
    }

    notifyListeners();
  }

  // Método que remove uma consulta a partir do seu id
  Future<void> remover(String consultaId) async {
    await _repository.remover(consultaId);
      notifyListeners();
  }

  // Método que verifica se o CPF já está cadastrado.
  Future<bool> horarioOcupado(String casaApoioId, DateTime dataHorario) async {
    return await _repository.horarioOcupado(casaApoioId,dataHorario) != null;
  }

  // Método que reagenda uma consulta, removendo a anterior e criando uma nova
  Future<String> reagendar(DateTime dataHorario, Consulta consulta) async {
    try {
      if(consulta.id==null) {
        throw Exception("Id da consulta não está presente");
      }
      else if(await horarioOcupado(consulta.casaDeApoioId, dataHorario)) {
        throw Exception("Horário já está ocupado");
      }
      consulta.dataHorario=DateTime(dataHorario.year,dataHorario.month,dataHorario.day,dataHorario.hour);
      consulta.estado="agendada";

      await _repository.atualizar(consulta, consulta.id!);
      notifyListeners();
      return "Consulta alterada com sucesso";
    } on Exception catch (e) {
      return "Erro ao cadastrar: $e";
    } 
  }

  // Método que cria uma nova consulta e notifica os 'ouvintes'.
  Future<String> cadastrarConsulta(Paciente paciente,DateTime dataHorario) async {
    try {
      if(paciente.id==null) {
        throw Exception("Id do paciente não está presente");
      }
      else if(await horarioOcupado(paciente.casaDeApoioId, dataHorario)) {
        throw Exception("Horário já está ocupado");
      }
      Consulta novaConsulta = Consulta(casaDeApoioId: paciente.casaDeApoioId, pacienteId: paciente.id!, dataHorario: dataHorario, estado: "agendada");

      String id = await _repository.criar(novaConsulta);
      novaConsulta.id = id;

      _consultas.add(novaConsulta);
      notifyListeners();
      return "Consulta cadastrada com sucesso";
    } on Exception catch (e) {
      return "Erro ao cadastrar: $e";
    }
  }
}