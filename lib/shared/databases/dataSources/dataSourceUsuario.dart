// Classe abstrata que define os métodos necessários para a comunicação com os banco de dados da "tabela" de usuarios (CRUD completo).

abstract class DataSourceUsuario{
  Future<Map<String, dynamic>?> criar(Map<String, dynamic> usuario);

  Future<void> remover(Map<String, dynamic> usuario);

  Future<void> atualizar(Map<String, dynamic> usuario);

  Future<List<Map<String, dynamic>>> selecionarTodos();

  Future<Map<String, dynamic>?> selecionar(String uid);
}