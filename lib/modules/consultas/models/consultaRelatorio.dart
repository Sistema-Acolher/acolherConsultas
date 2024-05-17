// ignore_for_file: public_member_api_docs, sort_constructors_first

class ConsultaRelatorio {
  DateTime? periodoInicial;
  DateTime? periodoFinal;
  String? casas;

  ConsultaRelatorio({
    this.periodoInicial,
    this.periodoFinal,
    this.casas,
  });
  
  ConsultaRelatorio copyWith({    
    DateTime? periodoInicial,
    DateTime? periodoFinal,
    String? casas,
  }) {
    return ConsultaRelatorio(
      periodoInicial: periodoInicial ?? this.periodoInicial,
      periodoFinal: periodoFinal ?? this.periodoFinal,
      casas: casas ?? this.casas,
    );
  }
}