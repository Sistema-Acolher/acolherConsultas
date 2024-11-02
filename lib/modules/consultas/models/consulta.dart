import 'package:cloud_firestore/cloud_firestore.dart';

class Consulta {
  // Dados comuns entre crianças e adolescentes
  DateTime idade;
  String cuidadorPrincipal;
  String queixaPrincipal;
  String descricao;
  String? observacoesPaciente;
  int refeicoesComTecnologia;
  String refeicoesDuranteODia;
  int consumiuFeijao;
  int consumiuFrutas;
  int consumiuVerdurasLegumes;
  int consumiuEmbutidos;
  int consumiuBebidasAdocicadas;
  int consumiuMacarraoInstantaneoSalgado;
  int consumiuBiscoitoRecheado;
  String ingestaoHidrica;
  String suplementacao;
  String diurese;
  String evacuacoes;
  String itensHigiene;
  String higieneCorporal;
  String sono;
  int comprimento;
  double peso;
  int comprimentoPorIdade;
  int imcPorIdade;
  String frequenciaCardiaca;
  String saturacao;
  String auscultaCardiaca;
  String auscultaPulmonar;
  String pressaoArterial;
  double temperatura;
  String otoscopia;
  String orofaringe;
  String avaliacaoMuscoesqueletica;
  String avaliacaoPele;
  String marcosPresentes;
  String marcosAusentes;
  String? observacoesDesenvolvimento;
  String comoSeSenteHoje;
  String? observacoesPsicoemocionais;
  String analiseGeral;
  String avaliacoes;
  String intervencoes;

  // Dados somente crianças
  String? frequenciaRespiratoria;
  int? bregmatica;
  bool? bregmaticaCalcificada;
  int? lambdoide;
  bool? lambdoideCalcificada;
  String? avaliacaoLinguagem;
  int? reflexoBusca;
  int? reflexoSuccao;
  int? reflexoPreensaoPalmar;
  int? reflexoPreensaoPlantar;
  int? reflexoBabinski;
  int? reflexoTonicoCervical;
  int? reflexoMoro;
  int? reflexoMarcha;
  int? reflexoPiscarOptico;
  int? reflexoBuscaESuccao;
  int? movimentosSimetricosFaciais;
  int? reflexoPiscarAcustico;
  int? reflexoVomito;
  int? aperteNariz;

  // Dados somente adolescentes
  String? atividadesLazer;
  int? identidadeGenero;
  int? sexualidade;
  int? estagioTurnerMeninasMamas;
  int? estagioTurnerMeninasPelosPubianos;
  DateTime? dataUltimaMenstruacao;
  int? fluxoMenstrual;
  int? regularidadeMenstruacao;
  String? quaoIrregular;
  bool? dimenorreia;
  String? usoAbsorvente;
  bool? usaMedicamento;
  String? qualMedicamento;
  String? observacoesSaudeSexualEReprodutivaMeninas;
  bool? vidaSexualAtiva;
  bool? usaMetodoContraceptivo;
  String? qualMetodoContraceptivo;
  bool? jaFezPreventivo;
  DateTime? quandoFezPreventivo;
  bool? seMasturba;
  String? frequenciaMasturbacao;
  int? estagioTurnerMeninosGenitalia;
  int? estagioTurnerMeninosPelosPubianos;
  bool? semenarca;
  DateTime? quandoSemenarca;

  Consulta({
    // Dados somente crianças
    // Dados somente adolescentes
    required this.idade,
    required this.cuidadorPrincipal,
    required this.queixaPrincipal,
    required this.descricao,
    this.observacoesPaciente,
    required this.refeicoesComTecnologia,
    required this.refeicoesDuranteODia,
    required this.consumiuFeijao,
    required this.consumiuFrutas,
    required this.consumiuVerdurasLegumes,
    required this.consumiuEmbutidos,
    required this.consumiuBebidasAdocicadas,
    required this.consumiuMacarraoInstantaneoSalgado,
    required this.consumiuBiscoitoRecheado,
    required this.ingestaoHidrica,
    required this.suplementacao,
    required this.diurese,
    required this.evacuacoes,
    required this.itensHigiene,
    required this.higieneCorporal,
    required this.sono,
    required this.comprimento,
    required this.peso,
    required this.comprimentoPorIdade,
    required this.imcPorIdade,
    required this.frequenciaCardiaca,
    required this.saturacao,
    required this.auscultaCardiaca,
    required this.auscultaPulmonar,
    required this.pressaoArterial,
    required this.temperatura,
    required this.otoscopia,
    required this.orofaringe,
    required this.avaliacaoMuscoesqueletica,
    required this.avaliacaoPele,
    required this.marcosPresentes,
    required this.marcosAusentes,
    this.observacoesDesenvolvimento,
    required this.comoSeSenteHoje,
    this.observacoesPsicoemocionais,
    required this.analiseGeral,
    required this.avaliacoes,
    required this.intervencoes,
    this.frequenciaRespiratoria,
    this.bregmatica,
    this.bregmaticaCalcificada,
    this.lambdoide,
    this.lambdoideCalcificada,
    this.avaliacaoLinguagem,
    this.reflexoBusca,
    this.reflexoSuccao,
    this.reflexoPreensaoPalmar,
    this.reflexoPreensaoPlantar,
    this.reflexoBabinski,
    this.reflexoTonicoCervical,
    this.reflexoMoro,
    this.reflexoMarcha,
    this.reflexoPiscarOptico,
    this.reflexoBuscaESuccao,
    this.movimentosSimetricosFaciais,
    this.reflexoPiscarAcustico,
    this.reflexoVomito,
    this.aperteNariz,
    this.atividadesLazer,
    this.identidadeGenero,
    this.sexualidade,
    this.estagioTurnerMeninasMamas,
    this.estagioTurnerMeninasPelosPubianos,
    this.dataUltimaMenstruacao,
    this.fluxoMenstrual,
    this.regularidadeMenstruacao,
    this.quaoIrregular,
    this.dimenorreia,
    this.usoAbsorvente,
    this.usaMedicamento,
    this.qualMedicamento,
    this.observacoesSaudeSexualEReprodutivaMeninas,
    this.vidaSexualAtiva,
    this.usaMetodoContraceptivo,
    this.qualMetodoContraceptivo,
    this.jaFezPreventivo,
    this.quandoFezPreventivo,
    this.seMasturba,
    this.frequenciaMasturbacao,
    this.estagioTurnerMeninosGenitalia,
    this.estagioTurnerMeninosPelosPubianos,
    this.semenarca,
    this.quandoSemenarca,
  });

  Consulta copyWith({
    DateTime? idade,
    String? cuidadorPrincipal,
    String? queixaPrincipal,
    String? descricao,
    String? observacoesPaciente,
    int? refeicoesComTecnologia,
    String? refeicoesDuranteODia,
    int? consumiuFeijao,
    int? consumiuFrutas,
    int? consumiuVerdurasLegumes,
    int? consumiuEmbutidos,
    int? consumiuBebidasAdocicadas,
    int? consumiuMacarraoInstantaneoSalgado,
    int? consumiuBiscoitoRecheado,
    String? ingestaoHidrica,
    String? suplementacao,
    String? diurese,
    String? evacuacoes,
    String? itensHigiene,
    String? higieneCorporal,
    String? sono,
    int? comprimento,
    double? peso,
    int? comprimentoPorIdade,
    int? imcPorIdade,
    String? frequenciaCardiaca,
    String? saturacao,
    String? auscultaCardiaca,
    String? auscultaPulmonar,
    String? pressaoArterial,
    double? temperatura,
    String? otoscopia,
    String? orofaringe,
    String? avaliacaoMuscoesqueletica,
    String? avaliacaoPele,
    String? marcosPresentes,
    String? marcosAusentes,
    String? observacoesDesenvolvimento,
    String? comoSeSenteHoje,
    String? observacoesPsicoemocionais,
    String? analiseGeral,
    String? avaliacoes,
    String? intervencoes,
    String? frequenciaRespiratoria,
    int? bregmatica,
    bool? bregmaticaCalcificada,
    int? lambdoide,
    bool? lambdoideCalcificada,
    String? avaliacaoLinguagem,
    int? reflexoBusca,
    int? reflexoSuccao,
    int? reflexoPreensaoPalmar,
    int? reflexoPreensaoPlantar,
    int? reflexoBabinski,
    int? reflexoTonicoCervical,
    int? reflexoMoro,
    int? reflexoMarcha,
    int? reflexoPiscarOptico,
    int? reflexoBuscaESuccao,
    int? movimentosSimetricosFaciais,
    int? reflexoPiscarAcustico,
    int? reflexoVomito,
    int? aperteNariz,
    String? atividadesLazer,
    int? identidadeGenero,
    int? sexualidade,
    int? estagioTurnerMeninasMamas,
    int? estagioTurnerMeninasPelosPubianos,
    DateTime? dataUltimaMenstruacao,
    int? fluxoMenstrual,
    int? regularidadeMenstruacao,
    String? quaoIrregular,
    bool? dimenorreia,
    String? usoAbsorvente,
    bool? usaMedicamento,
    String? qualMedicamento,
    String? observacoesSaudeSexualEReprodutivaMeninas,
    bool? vidaSexualAtiva,
    bool? usaMetodoContraceptivo,
    String? qualMetodoContraceptivo,
    bool? jaFezPreventivo,
    DateTime? quandoFezPreventivo,
    bool? seMasturba,
    String? frequenciaMasturbacao,
    int? estagioTurnerMeninosGenitalia,
    int? estagioTurnerMeninosPelosPubianos,
    bool? semenarca,
    DateTime? quandoSemenarca,
  }) {
    return Consulta(
      idade: idade ?? this.idade,
      cuidadorPrincipal: cuidadorPrincipal ?? this.cuidadorPrincipal,
      queixaPrincipal: queixaPrincipal ?? this.queixaPrincipal,
      descricao: descricao ?? this.descricao,
      observacoesPaciente: observacoesPaciente ?? this.observacoesPaciente,
      refeicoesComTecnologia: refeicoesComTecnologia ?? this.refeicoesComTecnologia,
      refeicoesDuranteODia: refeicoesDuranteODia ?? this.refeicoesDuranteODia,
      consumiuFeijao: consumiuFeijao ?? this.consumiuFeijao,
      consumiuFrutas: consumiuFrutas ?? this.consumiuFrutas,
      consumiuVerdurasLegumes: consumiuVerdurasLegumes ?? this.consumiuVerdurasLegumes,
      consumiuEmbutidos: consumiuEmbutidos ?? this.consumiuEmbutidos,
      consumiuBebidasAdocicadas: consumiuBebidasAdocicadas ?? this.consumiuBebidasAdocicadas,
      consumiuMacarraoInstantaneoSalgado: consumiuMacarraoInstantaneoSalgado ?? this.consumiuMacarraoInstantaneoSalgado,
      consumiuBiscoitoRecheado: consumiuBiscoitoRecheado ?? this.consumiuBiscoitoRecheado,
      ingestaoHidrica: ingestaoHidrica ?? this.ingestaoHidrica,
      suplementacao: suplementacao ?? this.suplementacao,
      diurese: diurese ?? this.diurese,
      evacuacoes: evacuacoes ?? this.evacuacoes,
      itensHigiene: itensHigiene ?? this.itensHigiene,
      higieneCorporal: higieneCorporal ?? this.higieneCorporal,
      sono: sono ?? this.sono,
      comprimento: comprimento ?? this.comprimento,
      peso: peso ?? this.peso,
      comprimentoPorIdade: comprimentoPorIdade ?? this.comprimentoPorIdade,
      imcPorIdade: imcPorIdade ?? this.imcPorIdade,
      frequenciaCardiaca: frequenciaCardiaca ?? this.frequenciaCardiaca,
      saturacao: saturacao ?? this.saturacao,
      auscultaCardiaca: auscultaCardiaca ?? this.auscultaCardiaca,
      auscultaPulmonar: auscultaPulmonar ?? this.auscultaPulmonar,
      pressaoArterial: pressaoArterial ?? this.pressaoArterial,
      temperatura: temperatura ?? this.temperatura,
      otoscopia: otoscopia ?? this.otoscopia,
      orofaringe: orofaringe ?? this.orofaringe,
      avaliacaoMuscoesqueletica: avaliacaoMuscoesqueletica ?? this.avaliacaoMuscoesqueletica,
      avaliacaoPele: avaliacaoPele ?? this.avaliacaoPele,
      marcosPresentes: marcosPresentes ?? this.marcosPresentes,
      marcosAusentes: marcosAusentes ?? this.marcosAusentes,
      observacoesDesenvolvimento: observacoesDesenvolvimento ?? this.observacoesDesenvolvimento,
      comoSeSenteHoje: comoSeSenteHoje ?? this.comoSeSenteHoje,
      observacoesPsicoemocionais: observacoesPsicoemocionais ?? this.observacoesPsicoemocionais,
      analiseGeral: analiseGeral ?? this.analiseGeral,
      avaliacoes: avaliacoes ?? this.avaliacoes,
      intervencoes: intervencoes ?? this.intervencoes,
      frequenciaRespiratoria: frequenciaRespiratoria ?? this.frequenciaRespiratoria,
      bregmatica: bregmatica ?? this.bregmatica,
      bregmaticaCalcificada: bregmaticaCalcificada ?? this.bregmaticaCalcificada,
      lambdoide: lambdoide ?? this.lambdoide,
      lambdoideCalcificada: lambdoideCalcificada ?? this.lambdoideCalcificada,
      avaliacaoLinguagem: avaliacaoLinguagem ?? this.avaliacaoLinguagem,
      reflexoBusca: reflexoBusca ?? this.reflexoBusca,
      reflexoSuccao: reflexoSuccao ?? this.reflexoSuccao,
      reflexoPreensaoPalmar: reflexoPreensaoPalmar ?? this.reflexoPreensaoPalmar,
      reflexoPreensaoPlantar: reflexoPreensaoPlantar ?? this.reflexoPreensaoPlantar,
      reflexoBabinski: reflexoBabinski ?? this.reflexoBabinski,
      reflexoTonicoCervical: reflexoTonicoCervical ?? this.reflexoTonicoCervical,
      reflexoMoro: reflexoMoro ?? this.reflexoMoro,
      reflexoMarcha: reflexoMarcha ?? this.reflexoMarcha,
      reflexoPiscarOptico: reflexoPiscarOptico ?? this.reflexoPiscarOptico,
      reflexoBuscaESuccao: reflexoBuscaESuccao ?? this.reflexoBuscaESuccao,
      movimentosSimetricosFaciais: movimentosSimetricosFaciais ?? this.movimentosSimetricosFaciais,
      reflexoPiscarAcustico: reflexoPiscarAcustico ?? this.reflexoPiscarAcustico,
      reflexoVomito: reflexoVomito ?? this.reflexoVomito,
      aperteNariz: aperteNariz ?? this.aperteNariz,
      atividadesLazer: atividadesLazer ?? this.atividadesLazer,
      identidadeGenero: identidadeGenero ?? this.identidadeGenero,
      sexualidade: sexualidade ?? this.sexualidade,
      estagioTurnerMeninasMamas: estagioTurnerMeninasMamas ?? this.estagioTurnerMeninasMamas,
      estagioTurnerMeninasPelosPubianos: estagioTurnerMeninasPelosPubianos ?? this.estagioTurnerMeninasPelosPubianos,
      dataUltimaMenstruacao: dataUltimaMenstruacao ?? this.dataUltimaMenstruacao,
      fluxoMenstrual: fluxoMenstrual ?? this.fluxoMenstrual,
      regularidadeMenstruacao: regularidadeMenstruacao ?? this.regularidadeMenstruacao,
      quaoIrregular: quaoIrregular ?? this.quaoIrregular,
      dimenorreia: dimenorreia ?? this.dimenorreia,
      usoAbsorvente: usoAbsorvente ?? this.usoAbsorvente,
      usaMedicamento: usaMedicamento ?? this.usaMedicamento,
      qualMedicamento: qualMedicamento ?? this.qualMedicamento,
      observacoesSaudeSexualEReprodutivaMeninas: observacoesSaudeSexualEReprodutivaMeninas ?? this.observacoesSaudeSexualEReprodutivaMeninas,
      vidaSexualAtiva: vidaSexualAtiva ?? this.vidaSexualAtiva,
      usaMetodoContraceptivo: usaMetodoContraceptivo ?? this.usaMetodoContraceptivo,
      qualMetodoContraceptivo: qualMetodoContraceptivo ?? this.qualMetodoContraceptivo,
      jaFezPreventivo: jaFezPreventivo ?? this.jaFezPreventivo,
      quandoFezPreventivo: quandoFezPreventivo ?? this.quandoFezPreventivo,
      seMasturba: seMasturba ?? this.seMasturba,
      frequenciaMasturbacao: frequenciaMasturbacao ?? this.frequenciaMasturbacao,
      estagioTurnerMeninosGenitalia: estagioTurnerMeninosGenitalia ?? this.estagioTurnerMeninosGenitalia,
      estagioTurnerMeninosPelosPubianos: estagioTurnerMeninosPelosPubianos ?? this.estagioTurnerMeninosPelosPubianos,
      semenarca: semenarca ?? this.semenarca,
      quandoSemenarca: quandoSemenarca ?? this.quandoSemenarca,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idade': idade.millisecondsSinceEpoch,
      'cuidadorPrincipal': cuidadorPrincipal,
      'queixaPrincipal': queixaPrincipal,
      'descricao': descricao,
      'observacoesPaciente': observacoesPaciente,
      'refeicoesComTecnologia': refeicoesComTecnologia,
      'refeicoesDuranteODia': refeicoesDuranteODia,
      'consumiuFeijao': consumiuFeijao,
      'consumiuFrutas': consumiuFrutas,
      'consumiuVerdurasLegumes': consumiuVerdurasLegumes,
      'consumiuEmbutidos': consumiuEmbutidos,
      'consumiuBebidasAdocicadas': consumiuBebidasAdocicadas,
      'consumiuMacarraoInstantaneoSalgado': consumiuMacarraoInstantaneoSalgado,
      'consumiuBiscoitoRecheado': consumiuBiscoitoRecheado,
      'ingestaoHidrica': ingestaoHidrica,
      'suplementacao': suplementacao,
      'diurese': diurese,
      'evacuacoes': evacuacoes,
      'itensHigiene': itensHigiene,
      'higieneCorporal': higieneCorporal,
      'sono': sono,
      'comprimento': comprimento,
      'peso': peso,
      'comprimentoPorIdade': comprimentoPorIdade,
      'imcPorIdade': imcPorIdade,
      'frequenciaCardiaca': frequenciaCardiaca,
      'saturacao': saturacao,
      'auscultaCardiaca': auscultaCardiaca,
      'auscultaPulmonar': auscultaPulmonar,
      'pressaoArterial': pressaoArterial,
      'temperatura': temperatura,
      'otoscopia': otoscopia,
      'orofaringe': orofaringe,
      'avaliacaoMuscoesqueletica': avaliacaoMuscoesqueletica,
      'avaliacaoPele': avaliacaoPele,
      'marcosPresentes': marcosPresentes,
      'marcosAusentes': marcosAusentes,
      'observacoesDesenvolvimento': observacoesDesenvolvimento,
      'comoSeSenteHoje': comoSeSenteHoje,
      'observacoesPsicoemocionais': observacoesPsicoemocionais,
      'analiseGeral': analiseGeral,
      'avaliacoes': avaliacoes,
      'intervencoes': intervencoes,
      'frequenciaRespiratoria': frequenciaRespiratoria,
      'bregmatica': bregmatica,
      'bregmaticaCalcificada': bregmaticaCalcificada,
      'lambdoide': lambdoide,
      'lambdoideCalcificada': lambdoideCalcificada,
      'avaliacaoLinguagem': avaliacaoLinguagem,
      'reflexoBusca': reflexoBusca,
      'reflexoSuccao': reflexoSuccao,
      'reflexoPreensaoPalmar': reflexoPreensaoPalmar,
      'reflexoPreensaoPlantar': reflexoPreensaoPlantar,
      'reflexoBabinski': reflexoBabinski,
      'reflexoTonicoCervical': reflexoTonicoCervical,
      'reflexoMoro': reflexoMoro,
      'reflexoMarcha': reflexoMarcha,
      'reflexoPiscarOptico': reflexoPiscarOptico,
      'reflexoBuscaESuccao': reflexoBuscaESuccao,
      'movimentosSimetricosFaciais': movimentosSimetricosFaciais,
      'reflexoPiscarAcustico': reflexoPiscarAcustico,
      'reflexoVomito': reflexoVomito,
      'aperteNariz': aperteNariz,
      'atividadesLazer': atividadesLazer,
      'identidadeGenero': identidadeGenero,
      'sexualidade': sexualidade,
      'estagioTurnerMeninasMamas': estagioTurnerMeninasMamas,
      'estagioTurnerMeninasPelosPubianos': estagioTurnerMeninasPelosPubianos,
      'dataUltimaMenstruacao': dataUltimaMenstruacao?.millisecondsSinceEpoch,
      'fluxoMenstrual': fluxoMenstrual,
      'regularidadeMenstruacao': regularidadeMenstruacao,
      'quaoIrregular': quaoIrregular,
      'dimenorreia': dimenorreia,
      'usoAbsorvente': usoAbsorvente,
      'usaMedicamento': usaMedicamento,
      'qualMedicamento': qualMedicamento,
      'observacoesSaudeSexualEReprodutivaMeninas': observacoesSaudeSexualEReprodutivaMeninas,
      'vidaSexualAtiva': vidaSexualAtiva,
      'usaMetodoContraceptivo': usaMetodoContraceptivo,
      'qualMetodoContraceptivo': qualMetodoContraceptivo,
      'jaFezPreventivo': jaFezPreventivo,
      'quandoFezPreventivo': quandoFezPreventivo?.millisecondsSinceEpoch,
      'seMasturba': seMasturba,
      'frequenciaMasturbacao': frequenciaMasturbacao,
      'estagioTurnerMeninosGenitalia': estagioTurnerMeninosGenitalia,
      'estagioTurnerMeninosPelosPubianos': estagioTurnerMeninosPelosPubianos,
      'semenarca': semenarca,
      'quandoSemenarca': quandoSemenarca?.millisecondsSinceEpoch,
    };
  }

  factory Consulta.fromMap(Map<String, dynamic> map) {
    return Consulta(
      idade: DateTime.fromMillisecondsSinceEpoch(map['idade'] as int),
      cuidadorPrincipal: map['cuidadorPrincipal'] as String,
      queixaPrincipal: map['queixaPrincipal'] as String,
      descricao: map['descricao'] as String,
      observacoesPaciente: map['observacoesPaciente'] != null ? map['observacoesPaciente'] as String : null,
      refeicoesComTecnologia: map['refeicoesComTecnologia'] as int,
      refeicoesDuranteODia: map['refeicoesDuranteODia'] as String,
      consumiuFeijao: map['consumiuFeijao'] as int,
      consumiuFrutas: map['consumiuFrutas'] as int,
      consumiuVerdurasLegumes: map['consumiuVerdurasLegumes'] as int,
      consumiuEmbutidos: map['consumiuEmbutidos'] as int,
      consumiuBebidasAdocicadas: map['consumiuBebidasAdocicadas'] as int,
      consumiuMacarraoInstantaneoSalgado: map['consumiuMacarraoInstantaneoSalgado'] as int,
      consumiuBiscoitoRecheado: map['consumiuBiscoitoRecheado'] as int,
      ingestaoHidrica: map['ingestaoHidrica'] as String,
      suplementacao: map['suplementacao'] as String,
      diurese: map['diurese'] as String,
      evacuacoes: map['evacuacoes'] as String,
      itensHigiene: map['itensHigiene'] as String,
      higieneCorporal: map['higieneCorporal'] as String,
      sono: map['sono'] as String,
      comprimento: map['comprimento'] as int,
      peso: map['peso'] as double,
      comprimentoPorIdade: map['comprimentoPorIdade'] as int,
      imcPorIdade: map['imcPorIdade'] as int,
      frequenciaCardiaca: map['frequenciaCardiaca'] as String,
      saturacao: map['saturacao'] as String,
      auscultaCardiaca: map['auscultaCardiaca'] as String,
      auscultaPulmonar: map['auscultaPulmonar'] as String,
      pressaoArterial: map['pressaoArterial'] as String,
      temperatura: map['temperatura'] as double,
      otoscopia: map['otoscopia'] as String,
      orofaringe: map['orofaringe'] as String,
      avaliacaoMuscoesqueletica: map['avaliacaoMuscoesqueletica'] as String,
      avaliacaoPele: map['avaliacaoPele'] as String,
      marcosPresentes: map['marcosPresentes'] as String,
      marcosAusentes: map['marcosAusentes'] as String,
      observacoesDesenvolvimento: map['observacoesDesenvolvimento'] != null ? map['observacoesDesenvolvimento'] as String : null,
      comoSeSenteHoje: map['comoSeSenteHoje'] as String,
      observacoesPsicoemocionais: map['observacoesPsicoemocionais'] != null ? map['observacoesPsicoemocionais'] as String : null,
      analiseGeral: map['analiseGeral'] as String,
      avaliacoes: map['avaliacoes'] as String,
      intervencoes: map['intervencoes'] as String,
      frequenciaRespiratoria: map['frequenciaRespiratoria'] != null ? map['frequenciaRespiratoria'] as String : null,
      bregmatica: map['bregmatica'] != null ? map['bregmatica'] as int : null,
      bregmaticaCalcificada: map['bregmaticaCalcificada'] != null ? map['bregmaticaCalcificada'] as bool : null,
      lambdoide: map['lambdoide'] != null ? map['lambdoide'] as int : null,
      lambdoideCalcificada: map['lambdoideCalcificada'] != null ? map['lambdoideCalcificada'] as bool : null,
      avaliacaoLinguagem: map['avaliacaoLinguagem'] != null ? map['avaliacaoLinguagem'] as String : null,
      reflexoBusca: map['reflexoBusca'] != null ? map['reflexoBusca'] as int : null,
      reflexoSuccao: map['reflexoSuccao'] != null ? map['reflexoSuccao'] as int : null,
      reflexoPreensaoPalmar: map['reflexoPreensaoPalmar'] != null ? map['reflexoPreensaoPalmar'] as int : null,
      reflexoPreensaoPlantar: map['reflexoPreensaoPlantar'] != null ? map['reflexoPreensaoPlantar'] as int : null,
      reflexoBabinski: map['reflexoBabinski'] != null ? map['reflexoBabinski'] as int : null,
      reflexoTonicoCervical: map['reflexoTonicoCervical'] != null ? map['reflexoTonicoCervical'] as int : null,
      reflexoMoro: map['reflexoMoro'] != null ? map['reflexoMoro'] as int : null,
      reflexoMarcha: map['reflexoMarcha'] != null ? map['reflexoMarcha'] as int : null,
      reflexoPiscarOptico: map['reflexoPiscarOptico'] != null ? map['reflexoPiscarOptico'] as int : null,
      reflexoBuscaESuccao: map['reflexoBuscaESuccao'] != null ? map['reflexoBuscaESuccao'] as int : null,
      movimentosSimetricosFaciais: map['movimentosSimetricosFaciais'] != null ? map['movimentosSimetricosFaciais'] as int : null,
      reflexoPiscarAcustico: map['reflexoPiscarAcustico'] != null ? map['reflexoPiscarAcustico'] as int : null,
      reflexoVomito: map['reflexoVomito'] != null ? map['reflexoVomito'] as int : null,
      aperteNariz: map['aperteNariz'] != null ? map['aperteNariz'] as int : null,
      atividadesLazer: map['atividadesLazer'] != null ? map['atividadesLazer'] as String : null,
      identidadeGenero: map['identidadeGenero'] != null ? map['identidadeGenero'] as int : null,
      sexualidade: map['sexualidade'] != null ? map['sexualidade'] as int : null,
      estagioTurnerMeninasMamas: map['estagioTurnerMeninasMamas'] != null ? map['estagioTurnerMeninasMamas'] as int : null,
      estagioTurnerMeninasPelosPubianos: map['estagioTurnerMeninasPelosPubianos'] != null ? map['estagioTurnerMeninasPelosPubianos'] as int : null,
      dataUltimaMenstruacao: map['dataUltimaMenstruacao'] != null ? DateTime.fromMillisecondsSinceEpoch(map['dataUltimaMenstruacao'] as int) : null,
      fluxoMenstrual: map['fluxoMenstrual'] != null ? map['fluxoMenstrual'] as int : null,
      regularidadeMenstruacao: map['regularidadeMenstruacao'] != null ? map['regularidadeMenstruacao'] as int : null,
      quaoIrregular: map['quaoIrregular'] != null ? map['quaoIrregular'] as String : null,
      dimenorreia: map['dimenorreia'] != null ? map['dimenorreia'] as bool : null,
      usoAbsorvente: map['usoAbsorvente'] != null ? map['usoAbsorvente'] as String : null,
      usaMedicamento: map['usaMedicamento'] != null ? map['usaMedicamento'] as bool : null,
      qualMedicamento: map['qualMedicamento'] != null ? map['qualMedicamento'] as String : null,
      observacoesSaudeSexualEReprodutivaMeninas: map['observacoesSaudeSexualEReprodutivaMeninas'] != null ? map['observacoesSaudeSexualEReprodutivaMeninas'] as String : null,
      vidaSexualAtiva: map['vidaSexualAtiva'] != null ? map['vidaSexualAtiva'] as bool : null,
      usaMetodoContraceptivo: map['usaMetodoContraceptivo'] != null ? map['usaMetodoContraceptivo'] as bool : null,
      qualMetodoContraceptivo: map['qualMetodoContraceptivo'] != null ? map['qualMetodoContraceptivo'] as String : null,
      jaFezPreventivo: map['jaFezPreventivo'] != null ? map['jaFezPreventivo'] as bool : null,
      quandoFezPreventivo: map['quandoFezPreventivo'] != null ? DateTime.fromMillisecondsSinceEpoch(map['quandoFezPreventivo'] as int) : null,
      seMasturba: map['seMasturba'] != null ? map['seMasturba'] as bool : null,
      frequenciaMasturbacao: map['frequenciaMasturbacao'] != null ? map['frequenciaMasturbacao'] as String : null,
      estagioTurnerMeninosGenitalia: map['estagioTurnerMeninosGenitalia'] != null ? map['estagioTurnerMeninosGenitalia'] as int : null,
      estagioTurnerMeninosPelosPubianos: map['estagioTurnerMeninosPelosPubianos'] != null ? map['estagioTurnerMeninosPelosPubianos'] as int : null,
      semenarca: map['semenarca'] != null ? map['semenarca'] as bool : null,
      quandoSemenarca: map['quandoSemenarca'] != null ? DateTime.fromMillisecondsSinceEpoch(map['quandoSemenarca'] as int) : null,
    );
  }
}

class ConsultaCadastro {
  String? id;
  String casaDeApoioId;
  String? pacienteNome;
  String pacienteId;
  DateTime dataHorario;
  String estado;
  Consulta? dadosConsulta;
  ConsultaCadastro({
    this.id,
    required this.casaDeApoioId,
    this.pacienteNome,
    required this.pacienteId,
    required this.dataHorario,
    required this.estado,
    this.dadosConsulta,
  });

  ConsultaCadastro copyWith({
    String? id,
    String? casaDeApoioId,
    String? pacienteNome,
    String? pacienteId,
    DateTime? dataHorario,
    String? estado,
    Consulta? dadosConsulta,
  }) {
    return ConsultaCadastro(
      id: id ?? this.id,
      casaDeApoioId: casaDeApoioId ?? this.casaDeApoioId,
      pacienteNome: pacienteNome ?? this.pacienteNome,
      pacienteId: pacienteId ?? this.pacienteId,
      dataHorario: dataHorario ?? this.dataHorario,
      estado: estado ?? this.estado,
      dadosConsulta: dadosConsulta ?? this.dadosConsulta,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'casaDeApoioId': casaDeApoioId,
      'pacienteId': pacienteId,
      'pacienteNome': pacienteNome,
      'dataHorario': dataHorario,
      'estado': estado,
      'dadosConsulta': dadosConsulta?.toMap(),
    };
  }

  factory ConsultaCadastro.fromMap(Map<String, dynamic> map) {
    return ConsultaCadastro(
      id: map['id'] != null ? map['id'] as String : null,
      casaDeApoioId: map['casaDeApoioId'] as String,
      pacienteNome: map['pacienteNome'] != null ? map['pacienteNome'] as String : null,
      pacienteId: map['pacienteId'] as String,
      dataHorario: (map['dataHorario'] as Timestamp).toDate(),
      estado: map['estado'] as String,
      dadosConsulta: map['dadosConsulta'] != null ? Consulta.fromMap(map['dadosConsulta'] as Map<String,dynamic>) : null,
    );
  }

  @override
  bool operator ==(covariant ConsultaCadastro other) {
    if (identical(this, other)) return true;
  
    return other.id == id ;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      casaDeApoioId.hashCode ^
      pacienteNome.hashCode ^
      pacienteId.hashCode ^
      dataHorario.hashCode ^
      estado.hashCode;
  }
}