abstract class DataSourcePacientes{
  Future<String> criar(Map<String, dynamic> paciente);

  Future<void> remover(Map<String, dynamic> paciente);

  Future<void> atualizar(Map<String, dynamic> paciente);

  Future<Map<String, dynamic>?> selecionar(String cpf, String rg, String numeroCartaoSus);

  Future<Map<String, dynamic>?> selecionarCpf(String cpf);

  Future<Map<String, dynamic>?> selecionarRg(String rg);

  Future<Map<String, dynamic>?> selecionarNumeroCartaoSus(String numeroCartaoSus);

  Future<List<Map<String, dynamic>>> selecionarTodos();
}