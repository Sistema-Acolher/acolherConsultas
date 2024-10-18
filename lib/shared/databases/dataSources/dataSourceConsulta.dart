// Classe abstrata que define os métodos necessários para a comunicação com os banco de dados da "tabela" de consultas (CRUD completo).

abstract class DataSourceConsulta{
  Future<String> criar(Map<String, dynamic> consulta);

  Future<void> remover(String consultaId);

  Future<void> atualizar(Map<String, dynamic> consulta, String consultaId);

  Future<Map<String, dynamic>?> buscarConsulta(String consultaId);

  Future<Map<String, dynamic>?> horarioOcupado(String casaApoioId, DateTime dataHorario);

  Future<List<Map<String, dynamic>>> selecionarTodos();
}