// Classe abstrata que define os métodos necessários para a comunicação com os banco de dados da "tabela" de consultas (CRUD completo).

abstract class DataSourceConsulta{
  Future<String> criar(Map<String, dynamic> consulta);

  Future<void> remover(Map<String, dynamic> consulta);

  Future<void> atualizar(Map<String, dynamic> consulta);

  Future<List<Map<String, dynamic>>> selecionarTodos();
}