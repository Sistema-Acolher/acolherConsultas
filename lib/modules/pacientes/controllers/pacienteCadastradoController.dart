import 'package:acolherconsultas/modules/casasDeApoio/models/casaDeApoio.dart';
import 'package:acolherconsultas/modules/pacientes/models/pacienteCadastro.dart';
import 'package:acolherconsultas/modules/pacientes/models/paciente.dart';
import 'package:acolherconsultas/shared/databases/repositories/pacienteRepository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// A classe PacientesCadastradosController é a classe que controla os pacientes cadastrados.
class PacientesCadastradosController extends ChangeNotifier {
  // Repositório de pacientes cadastrados, com métodos de CRUD.
  final _repository = PacientesCadastradosRepository();

  // Lista de pacientes cadastrados.
  final List<CadastroPaciente> _pacientes = [];
  List<CadastroPaciente> get pacientes => _pacientes;

  // Último paciente cadastrado.
  CadastroPaciente? _pacienteCadastrado;
  CadastroPaciente? get pacienteCadastrado => _pacienteCadastrado;

  // Método que busca a lista de pacientes cadastrados e notifica os 'ouvintes'.
  Future<void> getPacientes() async {
    // Limpa a lista de pacientes.
    _pacientes.clear();

    // Busca a lista de pacientes cadastrados no repositório de pacientes e adiciona na lista de pacientes do provedor.
    for (var paciente in await _repository.selecionarTodos()) {
      CadastroPaciente p = CadastroPaciente.fromMap(paciente);
      p.id = paciente["id"];
      _pacientes.add(p);
    }

    notifyListeners();
  }

  // Método que verifica se o CPF já está cadastrado.
  Future<bool> cpfCadastrado(String? cpf) async {
    if (cpf == null) return false;
    return await _repository.selecionarCpf(cpf) != null;
  }

  // Método que verifica se o RG já está cadastrado.
  Future<bool> rgCadastrado(String? rg) async {
    if (rg == null) return false;
    return await _repository.selecionarRg(rg) != null;
  }

  // Método que verifica se o número do cartão do SUS já está cadastrado.
  Future<bool> numeroCartaoSusCadastrado(String? numeroCartaoSus) async {
    if (numeroCartaoSus == null) return false;
    return await _repository.selecionarNumeroCartaoSus(numeroCartaoSus) != null;
  }

  // Método que cadastra um paciente, atualiza a lista de pacientes e notifica os 'ouvintes'.
  Future<String> cadastrarPaciente(
      CadastroPaciente cadastroPaciente, CasaDeApoio casaDeApoio) async {
    try {
      Paciente paciente = cadastroPaciente.paciente;
      paciente.casaDeApoioId = casaDeApoio.id!;
      if (await cpfCadastrado(paciente.cpf)) {
        return "Erro ao cadastrar: CPF já cadastrado";
      } else if (await rgCadastrado(paciente.rg)) {
        return "Erro ao cadastrar: RG já cadastrado";
      } else if (await numeroCartaoSusCadastrado(paciente.numeroCartaoSus)) {
        return "Erro ao cadastrar: Número do cartão do SUS já cadastrado";
      } else {
        // Caso o paciente não esteja cadastrado, o cadastro é requisitado para o repositório de pacientes.
        // No caso, cadastra diretamente para o Firebase.
        String id = await _repository.criar(cadastroPaciente);
        cadastroPaciente.id = id;

        _pacientes.add(cadastroPaciente);
        _pacienteCadastrado = cadastroPaciente;
        notifyListeners();
        return "Paciente cadastrado com sucesso";
      }
    } on Exception catch (e) {
      return "Erro ao cadastrar: $e";
    }
  }
}
