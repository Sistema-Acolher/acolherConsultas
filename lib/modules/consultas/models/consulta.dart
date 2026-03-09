import 'package:cloud_firestore/cloud_firestore.dart';

class Consulta {
  // Dados comuns entre crianças e adolescentes
  String cuidadorPrincipal;
  String queixaPrincipal;
  String descricao;
  String? observacoesPaciente;
  String refeicoesComTecnologia;
  String refeicoesDuranteODia;
  String consumiuFeijao;
  String consumiuFrutas;
  String consumiuVerdurasLegumes;
  String consumiuEmbutidos;
  String consumiuBebidasAdocicadas;
  String consumiuMacarraoInstantaneoSalgado;
  String consumiuBiscoitoRecheado;
  String ingestaoHidrica;
  String suplementacao;
  String diurese;
  String evacuacoes;
  String itensHigiene;
  String higieneCorporal;
  String higieneBucal;
  String sono;
  int comprimento;
  double peso;
  String comprimentoPorIdade;
  String imcPorIdade;
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
  String? fontanelas;
  String? cotoUmbilical;
  String? genitalia;
  String? frequenciaRespiratoria;
  int? bregmatica;
  bool? bregmaticaCalcificada;
  int? lambdoide;
  bool? lambdoideCalcificada;
  String? avaliacaoLinguagem;
  String? reflexoBusca;
  String? reflexoSuccao;
  String? reflexoPreensaoPalmar;
  String? reflexoPreensaoPlantar;
  String? reflexoBabinski;
  String? reflexoTonicoCervical;
  String? reflexoMoro;
  String? reflexoMarcha;
  String? reflexoPiscarOptico;
  String? reflexoBuscaESuccao;
  String? movimentosSimetricosFaciais;
  String? reflexoPiscarAcustico;
  String? reflexoVomito;
  String? aperteNariz;

  // Dados somente adolescentes
  String? atividadesLazer;
  String? identidadeGenero;
  String? sexualidade;
  String? estagioTurnerMeninasMamas;
  String? estagioTurnerMeninasPelosPubianos;
  DateTime? dataUltimaMenstruacao;
  String? fluxoMenstrual;
  String? regularidadeMenstruacao;
  String? quaoIrregular;
  String? dimenorreia;
  String? usoAbsorvente;
  String? usaMedicamento;
  String? qualMedicamento;
  String? observacoesSaudeSexualEReprodutivaMeninas;
  String? vidaSexualAtiva;
  String? usaMetodoContraceptivo;
  String? qualMetodoContraceptivo;
  String? jaFezPreventivo;
  DateTime? quandoFezPreventivo;
  String? seMasturba;
  String? frequenciaMasturbacao;
  String? estagioTurnerMeninosGenitalia;
  String? estagioTurnerMeninosPelosPubianos;
  String? semenarca;
  DateTime? quandoSemenarca;

  //para a casa
  String? analiseGeralCasa;
  String? exameFisicoCasa;
  String? avaliacoesCasa;
  String? oriParaCuidador;
  String? oriParaPaciente;
  String? oriParaCoordenacao;

  Consulta({
    // Dados somente crianças
    // Dados somente adolescentes
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
    required this.higieneBucal,
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
    this.fontanelas,
    this.cotoUmbilical,
    this.genitalia,
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
    this.analiseGeralCasa,
    this.exameFisicoCasa,
    this.avaliacoesCasa,
    this.oriParaCuidador,
    this.oriParaPaciente,
    this.oriParaCoordenacao
  });

  Consulta copyWith({
    DateTime? dataConsulta,
    String? cuidadorPrincipal,
    String? queixaPrincipal,
    String? descricao,
    String? observacoesPaciente,
    String? refeicoesComTecnologia,
    String? refeicoesDuranteODia,
    String? consumiuFeijao,
    String? consumiuFrutas,
    String? consumiuVerdurasLegumes,
    String? consumiuEmbutidos,
    String? consumiuBebidasAdocicadas,
    String? consumiuMacarraoInstantaneoSalgado,
    String? consumiuBiscoitoRecheado,
    String? ingestaoHidrica,
    String? suplementacao,
    String? diurese,
    String? evacuacoes,
    String? itensHigiene,
    String? higieneCorporal,
    String? higieneBucal,
    String? sono,
    int? comprimento,
    double? peso,
    String? comprimentoPorIdade,
    String? imcPorIdade,
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
    String? fontanelas,
    String? cotoUmbilical,
    String? genitalia,
    String? frequenciaRespiratoria,
    int? bregmatica,
    bool? bregmaticaCalcificada,
    int? lambdoide,
    bool? lambdoideCalcificada,
    String? avaliacaoLinguagem,
    String? reflexoBusca,
    String? reflexoSuccao,
    String? reflexoPreensaoPalmar,
    String? reflexoPreensaoPlantar,
    String? reflexoBabinski,
    String? reflexoTonicoCervical,
    String? reflexoMoro,
    String? reflexoMarcha,
    String? reflexoPiscarOptico,
    String? reflexoBuscaESuccao,
    String? movimentosSimetricosFaciais,
    String? reflexoPiscarAcustico,
    String? reflexoVomito,
    String? aperteNariz,
    String? atividadesLazer,
    String? identidadeGenero,
    String? sexualidade,
    String? estagioTurnerMeninasMamas,
    String? estagioTurnerMeninasPelosPubianos,
    DateTime? dataUltimaMenstruacao,
    String? fluxoMenstrual,
    String? regularidadeMenstruacao,
    String? quaoIrregular,
    String? dimenorreia,
    String? usoAbsorvente,
    String? usaMedicamento,
    String? qualMedicamento,
    String? observacoesSaudeSexualEReprodutivaMeninas,
    String? vidaSexualAtiva,
    String? usaMetodoContraceptivo,
    String? qualMetodoContraceptivo,
    String? jaFezPreventivo,
    DateTime? quandoFezPreventivo,
    String? seMasturba,
    String? frequenciaMasturbacao,
    String? estagioTurnerMeninosGenitalia,
    String? estagioTurnerMeninosPelosPubianos,
    String? semenarca,
    DateTime? quandoSemenarca,
    String? analiseGeralCasa,
    String? exameFisicoCasa,
    String? avaliacoesCasa,
    String? oriParaCuidador,
    String? oriParaPaciente,
    String? oriParaCoordenacao
  }) {
    return Consulta(
      cuidadorPrincipal: cuidadorPrincipal ?? this.cuidadorPrincipal,
      queixaPrincipal: queixaPrincipal ?? this.queixaPrincipal,
      descricao: descricao ?? this.descricao,
      observacoesPaciente: observacoesPaciente ?? this.observacoesPaciente,
      refeicoesComTecnologia:
          refeicoesComTecnologia ?? this.refeicoesComTecnologia,
      refeicoesDuranteODia: refeicoesDuranteODia ?? this.refeicoesDuranteODia,
      consumiuFeijao: consumiuFeijao ?? this.consumiuFeijao,
      consumiuFrutas: consumiuFrutas ?? this.consumiuFrutas,
      consumiuVerdurasLegumes:
          consumiuVerdurasLegumes ?? this.consumiuVerdurasLegumes,
      consumiuEmbutidos: consumiuEmbutidos ?? this.consumiuEmbutidos,
      consumiuBebidasAdocicadas:
          consumiuBebidasAdocicadas ?? this.consumiuBebidasAdocicadas,
      consumiuMacarraoInstantaneoSalgado: consumiuMacarraoInstantaneoSalgado ??
          this.consumiuMacarraoInstantaneoSalgado,
      consumiuBiscoitoRecheado:
          consumiuBiscoitoRecheado ?? this.consumiuBiscoitoRecheado,
      ingestaoHidrica: ingestaoHidrica ?? this.ingestaoHidrica,
      suplementacao: suplementacao ?? this.suplementacao,
      diurese: diurese ?? this.diurese,
      evacuacoes: evacuacoes ?? this.evacuacoes,
      itensHigiene: itensHigiene ?? this.itensHigiene,
      higieneCorporal: higieneCorporal ?? this.higieneCorporal,
      higieneBucal: higieneBucal ?? this.higieneBucal,
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
      avaliacaoMuscoesqueletica:
          avaliacaoMuscoesqueletica ?? this.avaliacaoMuscoesqueletica,
      avaliacaoPele: avaliacaoPele ?? this.avaliacaoPele,
      marcosPresentes: marcosPresentes ?? this.marcosPresentes,
      marcosAusentes: marcosAusentes ?? this.marcosAusentes,
      observacoesDesenvolvimento:
          observacoesDesenvolvimento ?? this.observacoesDesenvolvimento,
      comoSeSenteHoje: comoSeSenteHoje ?? this.comoSeSenteHoje,
      observacoesPsicoemocionais:
          observacoesPsicoemocionais ?? this.observacoesPsicoemocionais,
      analiseGeral: analiseGeral ?? this.analiseGeral,
      avaliacoes: avaliacoes ?? this.avaliacoes,
      intervencoes: intervencoes ?? this.intervencoes,
      fontanelas: fontanelas ?? this.fontanelas,
      cotoUmbilical: cotoUmbilical ?? this.cotoUmbilical,
      genitalia: genitalia ?? this.genitalia,
      frequenciaRespiratoria:
          frequenciaRespiratoria ?? this.frequenciaRespiratoria,
      bregmatica: bregmatica ?? this.bregmatica,
      bregmaticaCalcificada:
          bregmaticaCalcificada ?? this.bregmaticaCalcificada,
      lambdoide: lambdoide ?? this.lambdoide,
      lambdoideCalcificada: lambdoideCalcificada ?? this.lambdoideCalcificada,
      avaliacaoLinguagem: avaliacaoLinguagem ?? this.avaliacaoLinguagem,
      reflexoBusca: reflexoBusca ?? this.reflexoBusca,
      reflexoSuccao: reflexoSuccao ?? this.reflexoSuccao,
      reflexoPreensaoPalmar:
          reflexoPreensaoPalmar ?? this.reflexoPreensaoPalmar,
      reflexoPreensaoPlantar:
          reflexoPreensaoPlantar ?? this.reflexoPreensaoPlantar,
      reflexoBabinski: reflexoBabinski ?? this.reflexoBabinski,
      reflexoTonicoCervical:
          reflexoTonicoCervical ?? this.reflexoTonicoCervical,
      reflexoMoro: reflexoMoro ?? this.reflexoMoro,
      reflexoMarcha: reflexoMarcha ?? this.reflexoMarcha,
      reflexoPiscarOptico: reflexoPiscarOptico ?? this.reflexoPiscarOptico,
      reflexoBuscaESuccao: reflexoBuscaESuccao ?? this.reflexoBuscaESuccao,
      movimentosSimetricosFaciais:
          movimentosSimetricosFaciais ?? this.movimentosSimetricosFaciais,
      reflexoPiscarAcustico:
          reflexoPiscarAcustico ?? this.reflexoPiscarAcustico,
      reflexoVomito: reflexoVomito ?? this.reflexoVomito,
      aperteNariz: aperteNariz ?? this.aperteNariz,
      atividadesLazer: atividadesLazer ?? this.atividadesLazer,
      identidadeGenero: identidadeGenero ?? this.identidadeGenero,
      sexualidade: sexualidade ?? this.sexualidade,
      estagioTurnerMeninasMamas:
          estagioTurnerMeninasMamas ?? this.estagioTurnerMeninasMamas,
      estagioTurnerMeninasPelosPubianos: estagioTurnerMeninasPelosPubianos ??
          this.estagioTurnerMeninasPelosPubianos,
      dataUltimaMenstruacao:
          dataUltimaMenstruacao ?? this.dataUltimaMenstruacao,
      fluxoMenstrual: fluxoMenstrual ?? this.fluxoMenstrual,
      regularidadeMenstruacao:
          regularidadeMenstruacao ?? this.regularidadeMenstruacao,
      quaoIrregular: quaoIrregular ?? this.quaoIrregular,
      dimenorreia: dimenorreia ?? this.dimenorreia,
      usoAbsorvente: usoAbsorvente ?? this.usoAbsorvente,
      usaMedicamento: usaMedicamento ?? this.usaMedicamento,
      qualMedicamento: qualMedicamento ?? this.qualMedicamento,
      observacoesSaudeSexualEReprodutivaMeninas:
          observacoesSaudeSexualEReprodutivaMeninas ??
              this.observacoesSaudeSexualEReprodutivaMeninas,
      vidaSexualAtiva: vidaSexualAtiva ?? this.vidaSexualAtiva,
      usaMetodoContraceptivo:
          usaMetodoContraceptivo ?? this.usaMetodoContraceptivo,
      qualMetodoContraceptivo:
          qualMetodoContraceptivo ?? this.qualMetodoContraceptivo,
      jaFezPreventivo: jaFezPreventivo ?? this.jaFezPreventivo,
      quandoFezPreventivo: quandoFezPreventivo ?? this.quandoFezPreventivo,
      seMasturba: seMasturba ?? this.seMasturba,
      frequenciaMasturbacao:
          frequenciaMasturbacao ?? this.frequenciaMasturbacao,
      estagioTurnerMeninosGenitalia:
          estagioTurnerMeninosGenitalia ?? this.estagioTurnerMeninosGenitalia,
      estagioTurnerMeninosPelosPubianos: estagioTurnerMeninosPelosPubianos ??
          this.estagioTurnerMeninosPelosPubianos,
      semenarca: semenarca ?? this.semenarca,
      quandoSemenarca: quandoSemenarca ?? this.quandoSemenarca,
      analiseGeralCasa: analiseGeralCasa ?? this.analiseGeralCasa,
      exameFisicoCasa: exameFisicoCasa ?? this.exameFisicoCasa,
      avaliacoesCasa: avaliacoesCasa ?? this.avaliacoesCasa,
      oriParaCuidador: oriParaCuidador ?? this.oriParaCuidador,
      oriParaPaciente: oriParaPaciente ?? this.oriParaPaciente,
      oriParaCoordenacao: oriParaCoordenacao ?? this.oriParaCoordenacao
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      //'idade': idade,
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
      'higieneBucal': higieneBucal,
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
      'fontanelas': fontanelas,
      'cotoUmbilical': cotoUmbilical,
      'genitalia': genitalia,
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
      'dataUltimaMenstruacao': dataUltimaMenstruacao != null
          ? Timestamp.fromDate(dataUltimaMenstruacao!)
          : null,
      'fluxoMenstrual': fluxoMenstrual,
      'regularidadeMenstruacao': regularidadeMenstruacao,
      'quaoIrregular': quaoIrregular,
      'dimenorreia': dimenorreia,
      'usoAbsorvente': usoAbsorvente,
      'usaMedicamento': usaMedicamento,
      'qualMedicamento': qualMedicamento,
      'observacoesSaudeSexualEReprodutivaMeninas':
          observacoesSaudeSexualEReprodutivaMeninas,
      'vidaSexualAtiva': vidaSexualAtiva,
      'usaMetodoContraceptivo': usaMetodoContraceptivo,
      'qualMetodoContraceptivo': qualMetodoContraceptivo,
      'jaFezPreventivo': jaFezPreventivo,
      'quandoFezPreventivo': quandoFezPreventivo != null ? Timestamp.fromDate(quandoFezPreventivo!) : null,
      'seMasturba': seMasturba,
      'frequenciaMasturbacao': frequenciaMasturbacao,
      'estagioTurnerMeninosGenitalia': estagioTurnerMeninosGenitalia,
      'estagioTurnerMeninosPelosPubianos': estagioTurnerMeninosPelosPubianos,
      'semenarca': semenarca,
      'quandoSemenarca':
          quandoSemenarca != null ? Timestamp.fromDate(quandoSemenarca!) : null,
      'analiseGeralCasa': analiseGeralCasa,
      'exameFisicoCasa': exameFisicoCasa ,
      'avaliacoesCasa': avaliacoesCasa,
      'oriParaCuidador': oriParaCuidador,
      'oriParaPaciente': oriParaPaciente, 
      'oriParaCoordenacao': oriParaCoordenacao
    };
  }

  factory Consulta.fromMap(Map<String, dynamic> map) {
    return Consulta(
      cuidadorPrincipal: map['cuidadorPrincipal']?.toString() ?? "",
      queixaPrincipal: map['queixaPrincipal']?.toString() ?? "",
      descricao: map['descricao']?.toString() ?? "",
      observacoesPaciente: map['observacoesPaciente']?.toString(),
      refeicoesComTecnologia: map['refeicoesComTecnologia']?.toString() ?? "",
      refeicoesDuranteODia: map['refeicoesDuranteODia']?.toString() ?? "",
      consumiuFeijao: map['consumiuFeijao']?.toString() ?? "",
      consumiuFrutas: map['consumiuFrutas']?.toString() ?? "",
      consumiuVerdurasLegumes: map['consumiuVerdurasLegumes']?.toString() ?? "",
      consumiuEmbutidos: map['consumiuEmbutidos']?.toString() ?? "",
      consumiuBebidasAdocicadas: map['consumiuBebidasAdocicadas']?.toString() ?? "",
      consumiuMacarraoInstantaneoSalgado: map['consumiuMacarraoInstantaneoSalgado']?.toString() ?? "",
      consumiuBiscoitoRecheado: map['consumiuBiscoitoRecheado']?.toString() ?? "",
      ingestaoHidrica: map['ingestaoHidrica']?.toString() ?? "",
      suplementacao: map['suplementacao']?.toString() ?? "",
      diurese: map['diurese']?.toString() ?? "",
      evacuacoes: map['evacuacoes']?.toString() ?? "",
      itensHigiene: map['itensHigiene']?.toString() ?? "",
      higieneCorporal: map['higieneCorporal']?.toString() ?? "",
      higieneBucal: map['higieneBucal']?.toString() ?? "",
      sono: map['sono']?.toString() ?? "",
      
      // Correção Vital: Lida com ints e doubles de forma segura
      comprimento: (map['comprimento'] as num?)?.toInt() ?? 0,
      peso: (map['peso'] as num?)?.toDouble() ?? 0.0,
      
      comprimentoPorIdade: map['comprimentoPorIdade']?.toString() ?? "",
      imcPorIdade: map['imcPorIdade']?.toString() ?? "",
      frequenciaCardiaca: map['frequenciaCardiaca']?.toString() ?? "",
      saturacao: map['saturacao']?.toString() ?? "",
      auscultaCardiaca: map['auscultaCardiaca']?.toString() ?? "",
      auscultaPulmonar: map['auscultaPulmonar']?.toString() ?? "",
      pressaoArterial: map['pressaoArterial']?.toString() ?? "",
      
      // Correção Vital: Lida com ints e doubles de forma segura
      temperatura: (map['temperatura'] as num?)?.toDouble() ?? 0.0,
      
      otoscopia: map['otoscopia']?.toString() ?? "",
      orofaringe: map['orofaringe']?.toString() ?? "",
      avaliacaoMuscoesqueletica: map['avaliacaoMuscoesqueletica']?.toString() ?? "",
      avaliacaoPele: map['avaliacaoPele']?.toString() ?? "",
      marcosPresentes: map['marcosPresentes']?.toString() ?? "",
      marcosAusentes: map['marcosAusentes']?.toString() ?? "",
      observacoesDesenvolvimento: map['observacoesDesenvolvimento']?.toString(),
      comoSeSenteHoje: map['comoSeSenteHoje']?.toString() ?? "",
      observacoesPsicoemocionais: map['observacoesPsicoemocionais']?.toString(),
      analiseGeral: map['analiseGeral']?.toString() ?? "",
      avaliacoes: map['avaliacoes']?.toString() ?? "",
      intervencoes: map['intervencoes']?.toString() ?? "",

      // Dados somente crianças
      fontanelas: map['fontanelas']?.toString(),
      cotoUmbilical: map['cotoUmbilical']?.toString(),
      genitalia: map['genitalia']?.toString(),
      frequenciaRespiratoria: map['frequenciaRespiratoria']?.toString(),
      bregmatica: (map['bregmatica'] as num?)?.toInt(),
      bregmaticaCalcificada: map['bregmaticaCalcificada'] as bool?,
      lambdoide: (map['lambdoide'] as num?)?.toInt(),
      lambdoideCalcificada: map['lambdoideCalcificada'] as bool?,
      avaliacaoLinguagem: map['avaliacaoLinguagem']?.toString(),
      reflexoBusca: map['reflexoBusca']?.toString(),
      reflexoSuccao: map['reflexoSuccao']?.toString(),
      reflexoPreensaoPalmar: map['reflexoPreensaoPalmar']?.toString(),
      reflexoPreensaoPlantar: map['reflexoPreensaoPlantar']?.toString(),
      reflexoBabinski: map['reflexoBabinski']?.toString(),
      reflexoTonicoCervical: map['reflexoTonicoCervical']?.toString(),
      reflexoMoro: map['reflexoMoro']?.toString(),
      reflexoMarcha: map['reflexoMarcha']?.toString(),
      reflexoPiscarOptico: map['reflexoPiscarOptico']?.toString(),
      reflexoBuscaESuccao: map['reflexoBuscaESuccao']?.toString(),
      movimentosSimetricosFaciais: map['movimentosSimetricosFaciais']?.toString(),
      reflexoPiscarAcustico: map['reflexoPiscarAcustico']?.toString(),
      reflexoVomito: map['reflexoVomito']?.toString(),
      aperteNariz: map['aperteNariz']?.toString(),

      // Dados somente adolescentes
      atividadesLazer: map['atividadesLazer']?.toString(),
      identidadeGenero: map['identidadeGenero']?.toString(),
      sexualidade: map['sexualidade']?.toString(),
      estagioTurnerMeninasMamas: map['estagioTurnerMeninasMamas']?.toString(),
      estagioTurnerMeninasPelosPubianos: map['estagioTurnerMeninasPelosPubianos']?.toString(),
      dataUltimaMenstruacao: map['dataUltimaMenstruacao'] != null
          ? (map['dataUltimaMenstruacao'] as Timestamp).toDate()
          : null,
      fluxoMenstrual: map['fluxoMenstrual']?.toString(),
      regularidadeMenstruacao: map['regularidadeMenstruacao']?.toString(),
      quaoIrregular: map['quaoIrregular']?.toString(),
      dimenorreia: map['dimenorreia']?.toString(),
      usoAbsorvente: map['usoAbsorvente']?.toString(),
      usaMedicamento: map['usaMedicamento']?.toString(),
      qualMedicamento: map['qualMedicamento']?.toString(),
      observacoesSaudeSexualEReprodutivaMeninas: map['observacoesSaudeSexualEReprodutivaMeninas']?.toString(),
      vidaSexualAtiva: map['vidaSexualAtiva']?.toString(),
      usaMetodoContraceptivo: map['usaMetodoContraceptivo']?.toString(),
      qualMetodoContraceptivo: map['qualMetodoContraceptivo']?.toString(),
      jaFezPreventivo: map['jaFezPreventivo']?.toString(),
      quandoFezPreventivo: map['quandoFezPreventivo'] != null
          ? (map['quandoFezPreventivo'] as Timestamp).toDate()
          : null,
      seMasturba: map['seMasturba']?.toString(),
      frequenciaMasturbacao: map['frequenciaMasturbacao']?.toString(),
      estagioTurnerMeninosGenitalia: map['estagioTurnerMeninosGenitalia']?.toString(),
      estagioTurnerMeninosPelosPubianos: map['estagioTurnerMeninosPelosPubianos']?.toString(),
      semenarca: map['semenarca']?.toString(),
      quandoSemenarca: map['quandoSemenarca'] != null
          ? (map['quandoSemenarca'] as Timestamp).toDate()
          : null,

      analiseGeralCasa: map['analiseGeralCasa']?.toString(),
      exameFisicoCasa: map['exameFisicoCasa']?.toString(),
      avaliacoesCasa: map['avaliacoesCasa']?.toString(),
      oriParaCuidador: map['oriParaCuidador']?.toString(),
      oriParaPaciente: map['oriParaPaciente']?.toString(),
      oriParaCoordenacao: map['oriParaCoordenacao']?.toString() ?? map['oriParaCooerdanacao']?.toString()
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
      casaDeApoioId: map['casaDeApoioId'] as String? ?? "",
      pacienteNome: map['pacienteNome'] as String?,
      pacienteId: map['pacienteId'] as String? ?? "",
      dataHorario: map['dataHorario'] != null ? (map['dataHorario'] as Timestamp).toDate() : DateTime.now(),
      estado: map['estado'] as String? ?? "agendada",
      dadosConsulta: map['dadosConsulta'] != null
          ? Consulta.fromMap(map['dadosConsulta'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  bool operator ==(covariant ConsultaCadastro other) {
    if (identical(this, other)) return true;

    return other.id == id;
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
