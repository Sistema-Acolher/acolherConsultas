import 'package:acolherconsultas/modules/casasDeApoio/models/casaDeApoio.dart';
import 'package:acolherconsultas/shared/databases/repositories/casaDeApoioRepository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// A classe CasaDeApoioController é a classe que controla os casasDeApoio.
class CasaDeApoioController extends ChangeNotifier {
  // Repositório de casasDeApoio, com métodos de CRUD.
  final _repository = CasaDeApoioRepository();

  // Lista de casasDeApoio.
  final List<CasaDeApoio> _casasDeApoio = [];
  List<CasaDeApoio> get casasDeApoio => _casasDeApoio;

  // Casa de apoio selecionada.
  ValueNotifier<CasaDeApoio> _casaDeApoioSelecionada = ValueNotifier<CasaDeApoio>(CasaDeApoio.vazio());
  ValueNotifier<CasaDeApoio> get casaDeApoioSelecionada => _casaDeApoioSelecionada;

  // Método que busca a lista de casasDeApoio e notifica os 'ouvintes'.
  Future<List<CasaDeApoio>?> getCasasDeApoio() async {
    _casasDeApoio.clear();

    // Busca a lista de casasDeApoio no repositório de casasDeApoio e adiciona na lista de casasDeApoio do provedor.
    for(var casaDeApoio in await _repository.selecionarTodos()){
      CasaDeApoio c = CasaDeApoio.fromMap(casaDeApoio);
      c.id = casaDeApoio["id"];
      _casasDeApoio.add(c);
    }
    notifyListeners();
    return _casasDeApoio;
  }

  // Método que seleciona uma casaDeApoio.
  void selecionarCasaDeApoio(CasaDeApoio casaDeApoio){
    _casaDeApoioSelecionada.value = casaDeApoio;
    //notifyListeners();
  }
}