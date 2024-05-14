// ignore_for_file: public_member_api_docs, sort_constructors_first

class RelatorioCasas {
  DateTime? periodoInicial;
  DateTime? periodoFinal;
  String? casas;

  RelatorioCasas({
    this.periodoInicial,
    this.periodoFinal,
    this.casas,
  });
  
  RelatorioCasas copyWith({    
    DateTime? periodoInicial,
    DateTime? periodoFinal,
    String? casas,
  }) {
    return RelatorioCasas(
      periodoInicial: periodoInicial ?? this.periodoInicial,
      periodoFinal: periodoFinal ?? this.periodoFinal,
      casas: casas ?? this.casas,
    );
  }
}