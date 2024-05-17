import 'package:acolherconsultas/modules/consultas/models/consulta.dart';
import 'package:acolherconsultas/modules/pacientes/models/pacienteCadastro.dart';
import 'package:acolherconsultas/shared/databases/dataSources/dataSourceConsulta.dart';
import 'package:acolherconsultas/shared/databases/firebase/dataSourceFirebaseConsulta.dart';

// Repositório de pacientes cadastrados, com métodos de CRUD e controle de qual fonte de dados será utilizada.

class ConsultaRepository{

  // Instância da classe DataSourceConsulta que será utilizada, inicializada com a classe DataSourceFirebaseConsulta.
  final DataSourceConsulta _dbFirebase = DataSourceFirebaseConsulta();
  // Posteriormente será adicionada uma variável de um banco de dados local.
  
  // CRUD de pacientes cadastrados, no caso, está sendo utilizado apenas o firebase.

  Future<String> criar(Consulta consulta) async {
    return _dbFirebase.criar(consulta.toMap());
  }

  Future<void> atualizar(Map<String, dynamic> paciente) async {

  }

  Future<void> remover(CadastroPaciente pacienteDeletado) async {

  }
  Future<List<Map<String, dynamic>>> selecionarTodos() async {
    return _dbFirebase.selecionarTodos();
  }  
}