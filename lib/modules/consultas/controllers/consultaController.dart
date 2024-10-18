import 'dart:async';

import 'package:acolherconsultas/modules/consultas/models/consulta.dart';
import 'package:acolherconsultas/modules/pacientes/models/paciente.dart';
import 'package:acolherconsultas/shared/databases/repositories/consultaRepository.dart';
import 'package:flutter/foundation.dart';

// A classe ConsultaController é a classe que controla os consultas.
class ConsultaController extends ChangeNotifier {
  // Repositório de consultas, com métodos de CRUD.
  final _repository = ConsultaRepository();

  // Lista de consultas.
  final List<ConsultaCadastro> _consultas = [];
  List<ConsultaCadastro> get consultas => _consultas;

  final _consultasStreamController = StreamController<List<ConsultaCadastro>>.broadcast();

  // Stream getter para mandar a consulta stream
  Stream<List<ConsultaCadastro>> get streamConsultas => _consultasStreamController.stream;

  void _updateConsultas(List<ConsultaCadastro> consultas) {
    _consultas.clear();
    _consultas.addAll(consultas);
    _consultasStreamController.add(_consultas);
    notifyListeners();
  }

  // Método que busca a lista de consultas e notifica os 'ouvintes'.
  Future<void> getConsultas() async {
    // Limpa a lista de consultas.
    _consultas.clear();

    // Busca a lista de consultas no repositório de consultas e adiciona na lista de consultas do provedor.
    for(var consulta in await _repository.selecionarTodos()){
      ConsultaCadastro c = ConsultaCadastro.fromMap(consulta);
      _consultas.add(c);
    }

    notifyListeners();
  }

  // Busca consulta a partir do id da mesma
  Future<ConsultaCadastro> getConsulta(String consultaId) async {
    // Busca a lista de consultas no repositório de consultas e adiciona na lista de consultas do provedor.
    var consulta = await _repository.buscarConsulta(consultaId);
    if (consulta!=null) {
      return ConsultaCadastro.fromMap(consulta);
    }
    else {
      throw Exception("Consulta não existe");
    }
  }

  // Método que remove uma consulta a partir do seu id
  Future<void> remover(String consultaId) async {
    await _repository.remover(consultaId);
      notifyListeners();
  }

  // Método que verifica se o horário da consulta ja esta ocupado.
  Future<bool> horarioOcupado(String casaApoioId, DateTime dataHorario) async {
    return await _repository.horarioOcupado(casaApoioId,dataHorario) != null;
  }

  // Método que reagenda uma consulta, removendo a anterior e criando uma nova
  Future<String> reagendar(DateTime dataHorario, ConsultaCadastro consulta) async {
    try {
      if(consulta.id==null) {
        throw Exception("Id da consulta não está presente");
      }
      else if(await horarioOcupado(consulta.casaDeApoioId, dataHorario)) {
        throw Exception("Horário já está ocupado");
      }
      consulta.dataHorario=DateTime(dataHorario.year,dataHorario.month,dataHorario.day,dataHorario.hour);
      consulta.estado="agendada";

      await _repository.atualizar(consulta, consulta.id!);
      notifyListeners();
      return "ConsultaCadastro alterada com sucesso";
    } on Exception catch (e) {
      return "Erro ao cadastrar: $e";
    } 
  }

  // Método que cria uma nova consulta e notifica os 'ouvintes'.
  Future<String> cadastrarConsulta(Paciente paciente,DateTime dataHorario) async {
    try {
      if(paciente.id==null) {
        throw Exception("Id do paciente não está presente");
      }
      else if(await horarioOcupado(paciente.casaDeApoioId, dataHorario)) {
        throw Exception("Horário já está ocupado");
      }
      ConsultaCadastro novaConsulta = ConsultaCadastro(casaDeApoioId: paciente.casaDeApoioId, pacienteId: paciente.id!, dataHorario: dataHorario, estado: "agendada");

      String id = await _repository.criar(novaConsulta);
      novaConsulta.id = id;

      _consultas.add(novaConsulta);
      notifyListeners();
      return "ConsultaCadastro cadastrada com sucesso";
    } on Exception catch (e) {
      return "Erro ao cadastrar: $e";
    }
  }
 
  Future<String> cadastrarConsultaCrianca(
    String consultaId,
    String nome,
    DateTime idade,
    DateTime dataConsulta,
    String cuidadorPrincipal,
    String queixaPrincipal,
    String descricao,
    int refeicoesComTecnologia,
    String refeicoesDuranteODia,
    int consumiuFeijao,
    int consumiuFrutas,
    int consumiuVerdurasLegumes,
    int consumiuEmbutidos,
    int consumiuBebidasAdocicadas,
    int consumiuMacarraoInstantaneoSalgado,
    int consumiuBiscoitoRecheado,
    String ingestaoHidrica,
    String suplementacao,
    String diurese,
    String evacuacoes,
    String itensHigiene,
    String higieneCorporal,
    String sono,
    int comprimento,
    double peso,
    int comprimentoPorIdade,
    int imcPorIdade,
    String fc,
    String saturacao,
    String auscultaCardiaca,
    String auscultaPulmonar,
    String pa,
    double temperatura,
    String otoscopia,
    String orofaringe,
    String avaliacaoMuscoesqueletica,
    String avaliacaoPele,
    String marcosPresentes,
    String marcosAusentes,
    String comoSeSenteHoje,
    String analiseGeral,
    String avaliacoes,
    String intervencoes,

    // Dados específicos de crianças
    String? fr,
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
  ) async {
    try {
      var consulta = await getConsulta(consultaId);

      // Criar nova consulta com dados de criança
      consulta.dadosConsulta = Consulta(
        idade: idade,
        dataConsulta: dataConsulta,
        cuidadorPrincipal: cuidadorPrincipal,
        queixaPrincipal: queixaPrincipal,
        descricao: descricao,
        refeicoesComTecnologia: refeicoesComTecnologia,
        refeicoesDuranteODia: refeicoesDuranteODia,
        consumiuFeijao: consumiuFeijao,
        consumiuFrutas: consumiuFrutas,
        consumiuVerdurasLegumes: consumiuVerdurasLegumes,
        consumiuEmbutidos: consumiuEmbutidos,
        consumiuBebidasAdocicadas: consumiuBebidasAdocicadas,
        consumiuMacarraoInstantaneoSalgado: consumiuMacarraoInstantaneoSalgado,
        consumiuBiscoitoRecheado: consumiuBiscoitoRecheado,
        ingestaoHidrica: ingestaoHidrica,
        suplementacao: suplementacao,
        diurese: diurese,
        evacuacoes: evacuacoes,
        itensHigiene: itensHigiene,
        higieneCorporal: higieneCorporal,
        sono: sono,
        comprimento: comprimento,
        peso: peso,
        comprimentoPorIdade: comprimentoPorIdade,
        imcPorIdade: imcPorIdade,
        fc: fc,
        saturacao: saturacao,
        auscultaCardiaca: auscultaCardiaca,
        auscultaPulmonar: auscultaPulmonar,
        pa: pa,
        temperatura: temperatura,
        otoscopia: otoscopia,
        orofaringe: orofaringe,
        avaliacaoMuscoesqueletica: avaliacaoMuscoesqueletica,
        avaliacaoPele: avaliacaoPele,
        marcosPresentes: marcosPresentes,
        marcosAusentes: marcosAusentes,
        comoSeSenteHoje: comoSeSenteHoje,
        analiseGeral: analiseGeral,
        avaliacoes: avaliacoes,
        intervencoes: intervencoes,

        // Dados de crianças
        fr: fr,
        bregmatica: bregmatica,
        bregmaticaCalcificada: bregmaticaCalcificada,
        lambdoide: lambdoide,
        lambdoideCalcificada: lambdoideCalcificada,
        avaliacaoLinguagem: avaliacaoLinguagem,
        reflexoBusca: reflexoBusca,
        reflexoSuccao: reflexoSuccao,
        reflexoPreensaoPalmar: reflexoPreensaoPalmar,
        reflexoPreensaoPlantar: reflexoPreensaoPlantar,
        reflexoBabinski: reflexoBabinski,
        reflexoTonicoCervical: reflexoTonicoCervical,
        reflexoMoro: reflexoMoro,
        reflexoMarcha: reflexoMarcha,
        reflexoPiscarOptico: reflexoPiscarOptico,
        reflexoBuscaESuccao: reflexoBuscaESuccao,
        movimentosSimetricosFaciais: movimentosSimetricosFaciais,
        reflexoPiscarAcustico: reflexoPiscarAcustico,
        reflexoVomito: reflexoVomito,
        aperteNariz: aperteNariz,
      );

      await _repository.atualizar(consulta,consultaId);
      return "Consulta realizada com sucesso";
    } on Exception catch (e) {
      return "Erro ao cadastrar: $e";
    }
  }

  Future<String> cadastrarConsultaAdolescente(
    String consultaId,
    String estado,
    DateTime dataHorario,
    String nome,
    DateTime idade,
    DateTime dataConsulta,
    String cuidadorPrincipal,
    String queixaPrincipal,
    String descricao,
    int refeicoesComTecnologia,
    String refeicoesDuranteODia,
    int consumiuFeijao,
    int consumiuFrutas,
    int consumiuVerdurasLegumes,
    int consumiuEmbutidos,
    int consumiuBebidasAdocicadas,
    int consumiuMacarraoInstantaneoSalgado,
    int consumiuBiscoitoRecheado,
    String ingestaoHidrica,
    String suplementacao,
    String diurese,
    String evacuacoes,
    String itensHigiene,
    String higieneCorporal,
    String sono,
    int comprimento,
    double peso,
    int comprimentoPorIdade,
    int imcPorIdade,
    String fc,
    String saturacao,
    String auscultaCardiaca,
    String auscultaPulmonar,
    String pa,
    double temperatura,
    String otoscopia,
    String orofaringe,
    String avaliacaoMuscoesqueletica,
    String avaliacaoPele,
    String marcosPresentes,
    String marcosAusentes,
    String comoSeSenteHoje,
    String analiseGeral,
    String avaliacoes,
    String intervencoes,

    // Dados específicos de adolescentes
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
  ) async {
    try { 
      var consulta = await getConsulta(consultaId);

      // Criar nova consulta com dados de criança
      consulta.dadosConsulta = Consulta(
        idade: idade,
        dataConsulta: dataConsulta,
        cuidadorPrincipal: cuidadorPrincipal,
        queixaPrincipal: queixaPrincipal,
        descricao: descricao,
        refeicoesComTecnologia: refeicoesComTecnologia,
        refeicoesDuranteODia: refeicoesDuranteODia,
        consumiuFeijao: consumiuFeijao,
        consumiuFrutas: consumiuFrutas,
        consumiuVerdurasLegumes: consumiuVerdurasLegumes,
        consumiuEmbutidos: consumiuEmbutidos,
        consumiuBebidasAdocicadas: consumiuBebidasAdocicadas,
        consumiuMacarraoInstantaneoSalgado: consumiuMacarraoInstantaneoSalgado,
        consumiuBiscoitoRecheado: consumiuBiscoitoRecheado,
        ingestaoHidrica: ingestaoHidrica,
        suplementacao: suplementacao,
        diurese: diurese,
        evacuacoes: evacuacoes,
        itensHigiene: itensHigiene,
        higieneCorporal: higieneCorporal,
        sono: sono,
        comprimento: comprimento,
        peso: peso,
        comprimentoPorIdade: comprimentoPorIdade,
        imcPorIdade: imcPorIdade,
        fc: fc,
        saturacao: saturacao,
        auscultaCardiaca: auscultaCardiaca,
        auscultaPulmonar: auscultaPulmonar,
        pa: pa,
        temperatura: temperatura,
        otoscopia: otoscopia,
        orofaringe: orofaringe,
        avaliacaoMuscoesqueletica: avaliacaoMuscoesqueletica,
        avaliacaoPele: avaliacaoPele,
        marcosPresentes: marcosPresentes,
        marcosAusentes: marcosAusentes,
        comoSeSenteHoje: comoSeSenteHoje,
        analiseGeral: analiseGeral,
        avaliacoes: avaliacoes,
        intervencoes: intervencoes,

        // Dados de adolescentes
        atividadesLazer: atividadesLazer,
        identidadeGenero: identidadeGenero,
        sexualidade: sexualidade,
        estagioTurnerMeninasMamas: estagioTurnerMeninasMamas,
        estagioTurnerMeninasPelosPubianos: estagioTurnerMeninasPelosPubianos,
        dataUltimaMenstruacao: dataUltimaMenstruacao,
        fluxoMenstrual: fluxoMenstrual,
        regularidadeMenstruacao: regularidadeMenstruacao,
        quaoIrregular: quaoIrregular,
        dimenorreia: dimenorreia,
        usoAbsorvente: usoAbsorvente,
        usaMedicamento: usaMedicamento,
        qualMedicamento: qualMedicamento,
        observacoesSaudeSexualEReprodutivaMeninas: observacoesSaudeSexualEReprodutivaMeninas,
        vidaSexualAtiva: vidaSexualAtiva,
        usaMetodoContraceptivo: usaMetodoContraceptivo,
        qualMetodoContraceptivo: qualMetodoContraceptivo,
        jaFezPreventivo: jaFezPreventivo,
        quandoFezPreventivo: quandoFezPreventivo,
        seMasturba: seMasturba,
        frequenciaMasturbacao: frequenciaMasturbacao,
        estagioTurnerMeninosGenitalia: estagioTurnerMeninosGenitalia,
        estagioTurnerMeninosPelosPubianos: estagioTurnerMeninosPelosPubianos,
        semenarca: semenarca,
        quandoSemenarca: quandoSemenarca,
      );
      
      await _repository.atualizar(consulta,consultaId);
      return "Consulta realizada com sucesso";
    } on Exception catch (e) {
      return "Erro ao cadastrar: $e";
    }
  }
}