import 'package:acolherconsultas/modules/usuarios/models/usuario.dart';
import 'package:acolherconsultas/shared/databases/dataSources/dataSourceUsuario.dart';
import 'package:acolherconsultas/shared/databases/firebase/dataSourceFirebaseUsuario.dart';

class UsuarioRepository {

  // Instância da classe DataSourceConsulta que será utilizada, inicializada com a classe DataSourceFirebaseConsulta.
  final DataSourceUsuario _dbFirebase = DataSourceFirebaseUsuario();
  // Posteriormente será adicionada uma variável de um banco de dados local.
  
  // CRUD de pacientes cadastrados, no caso, está sendo utilizado apenas o firebase.

  Future<String> criar(Usuario usuario) async {
    return _dbFirebase.criar(usuario.toMap());
  }

  Future<void> atualizar(Usuario usuario) async {

  }

  Future<void> remover(Usuario usuarioDeletado) async {

  }

  Future<Usuario?> selecionar(String uid) async {
    final user = await _dbFirebase.selecionar(uid);
    
    if (user != null) {
      return Usuario.fromMap(user);
    }

    return null;
  }

  Future<List<Usuario>> selecionarTodos() async {
    return List.from(await _dbFirebase.selecionarTodos());
  }  
}