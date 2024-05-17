import 'package:acolherconsultas/modules/consultas/models/consulta.dart';
import 'package:acolherconsultas/shared/databases/repositories/consultaRepository.dart';
import 'package:flutter/foundation.dart';

// A classe ConsultaController é a classe que controla os consultas.
class ConsultaController extends ChangeNotifier {
  // Repositório de consultas, com métodos de CRUD.
  final _repository = ConsultaRepository();

  // Lista de consultas.
  final List<Consulta> _consultas = [];
  List<Consulta> get consultas => _consultas;

  // Último consulta cadastrado.
  Consulta? _pacienteCadastrado;
  Consulta? get pacienteCadastrado => _pacienteCadastrado;

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
}