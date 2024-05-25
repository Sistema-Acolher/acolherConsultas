// Classe abstrata que define os métodos necessários para a comunicação com os banco de dados da "tabela" de consultas (CRUD completo).

abstract class DataSourceCasaDeApoio{
  Future<String> criar(Map<String, dynamic> casaDeApoio);

  Future<void> remover(Map<String, dynamic> casaDeApoio);

  Future<void> atualizar(Map<String, dynamic> casaDeApoio);

  Future<List<Map<String, dynamic>>> selecionarTodos();
}