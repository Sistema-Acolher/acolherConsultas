import 'package:acolherconsultas/modules/pacientes/models/cadastroPaciente.dart';
import 'package:acolherconsultas/modules/pacientes/models/paciente.dart';
import 'package:acolherconsultas/shared/databases/repositories/pacientesCadastradosRepository.dart';
import 'package:flutter/foundation.dart';

class PacientesCadastradosProvider extends ChangeNotifier {
  final _repository = PacientesCadastradosRepository();

  final List<CadastroPaciente> _pacientes = [];
  List<CadastroPaciente> get pacientes => _pacientes;

  CadastroPaciente? _pacienteCadastrado;
  CadastroPaciente? get pacienteCadastrado => _pacienteCadastrado;

  Future<void> getPacientes() async {
    _pacientes.clear();

    for(var paciente in await _repository.selecionarTodos()){
      CadastroPaciente p = CadastroPaciente.fromMap(paciente);
      p.id = paciente["id"];
      _pacientes.add(p);
    }
    notifyListeners();
  }

  Future<bool> cpfCadastrado(String cpf) async {
    return await _repository.selecionarCpf(cpf) != null;
  }

  Future<bool> rgCadastrado(String rg) async {
    return await _repository.selecionarRg(rg) != null;
  }

  Future<bool> numeroCartaoSusCadastrado(String numeroCartaoSus) async {
    return await _repository.selecionarNumeroCartaoSus(numeroCartaoSus) != null;
  }

  Future<String> cadastrarPaciente(CadastroPaciente pacienteCadastro) async {
    try {
      Paciente paciente = pacienteCadastro.paciente;

      if(await cpfCadastrado(paciente.cpf)){
        return "Erro ao cadastrar: CPF já cadastrado";
      } else if(await rgCadastrado(paciente.rg)){
        return "Erro ao cadastrar: RG já cadastrado";
      } else if(await numeroCartaoSusCadastrado(paciente.numeroCartaoSus)){
        return "Erro ao cadastrar: Número do cartão do SUS já cadastrado";
      } else  {
        String id = await _repository.criar(pacienteCadastro);
        pacienteCadastro.id = id;

        _pacientes.add(pacienteCadastro);
        _pacienteCadastrado = pacienteCadastro;
        notifyListeners();

        return "Paciente cadastrado com sucesso";
      }
    } on Exception catch (e) {
      return "Erro ao cadastrar: $e";
    }
  }
}