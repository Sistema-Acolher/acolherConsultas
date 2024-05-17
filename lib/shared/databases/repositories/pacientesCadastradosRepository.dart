import 'package:acolherconsultas/modules/pacientes/models/pacienteCadastro.dart';
import 'package:acolherconsultas/shared/databases/dataSources/dataSourceCadastroPacientes.dart';
import 'package:acolherconsultas/shared/databases/firebase/dataSourceFirebaseCadastroPacientes.dart';

// Repositório de pacientes cadastrados, com métodos de CRUD e controle de qual fonte de dados será utilizada.

class PacientesCadastradosRepository{

  // Instância da classe DataSourcePacientes que será utilizada, inicializada com a classe DataSourceFirebasePacientes.
  final DataSourcePacientes _dbFirebase = DataSourceFirebasePacientes();
  // Posteriormente será adicionada uma variável de um banco de dados local.
  
  // CRUD de pacientes cadastrados, no caso, está sendo utilizado apenas o firebase.

  Future<String> criar(CadastroPaciente pacienteCadastrado) async {
    return _dbFirebase.criar(pacienteCadastrado.toMap());
  }

  Future<void> atualizar(Map<String, dynamic> paciente) async {

  }

  Future<void> remover(CadastroPaciente pacienteDeletado) async {

  }

  Future<Map<String, dynamic>?> selecionar(String cpf, String rg, String numeroCartaoSus) async {
    return _dbFirebase.selecionar(cpf, rg, numeroCartaoSus);
  }

  Future<Map<String, dynamic>?> selecionarCpf(String cpf) async {
    return _dbFirebase.selecionarCpf(cpf);
  }

  Future<Map<String, dynamic>?> selecionarRg(String rg) async {
    return _dbFirebase.selecionarRg(rg);
  }

  Future<Map<String, dynamic>?> selecionarNumeroCartaoSus(String numeroCartaoSus) async {
    return _dbFirebase.selecionarNumeroCartaoSus(numeroCartaoSus);
  }

  Future<List<Map<String, dynamic>>> selecionarTodos() async {
    return _dbFirebase.selecionarTodos();
  }  
}