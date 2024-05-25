import 'package:acolherconsultas/modules/casasDeApoio/models/casaDeApoio.dart';
import 'package:acolherconsultas/shared/databases/dataSources/dataSourceCasaDeApoio.dart';
import 'package:acolherconsultas/shared/databases/firebase/dataSourceFirebaseCasaDeApoio.dart';

// Repositório de pacientes cadastrados, com métodos de CRUD e controle de qual fonte de dados será utilizada.

class CasaDeApoioRepository{

  // Instância da classe DataSourceCasaDeApoio que será utilizada, inicializada com a classe DataSourceFirebaseCasaDeApoio.
  final DataSourceCasaDeApoio _dbFirebase = DataSourceFirebaseCasaDeApoio();
  // Posteriormente será adicionada uma variável de um banco de dados local.
  
  // CRUD de pacientes cadastrados, no caso, está sendo utilizado apenas o firebase.

  Future<String> criar(CasaDeApoio casaDeApoio) async {
    return _dbFirebase.criar(casaDeApoio.toMap());
  }

  Future<void> atualizar(Map<String, dynamic> casaDeApoio) async {

  }

  Future<void> remover(CasaDeApoio casaDeApoioDeletada) async {

  }
  Future<List<Map<String, dynamic>>> selecionarTodos() async {
    return _dbFirebase.selecionarTodos();
  }  
}