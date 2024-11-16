class ConsultaRelatorio {
  DateTime periodoInicial;
  DateTime periodoFinal;
  List<String> casas;

  ConsultaRelatorio({
    required this.periodoInicial,
    required this.periodoFinal,
    required this.casas,
  });
  
  ConsultaRelatorio copyWith({    
    DateTime? periodoInicial,
    DateTime? periodoFinal,
    List<String>? casas,
  }) {
    return ConsultaRelatorio(
      periodoInicial: periodoInicial ?? this.periodoInicial,
      periodoFinal: periodoFinal ?? this.periodoFinal,
      casas: casas ?? this.casas,
    );
  }
}