import 'dart:async';

import 'package:acolherconsultas/modules/consultas/models/consulta.dart';
import 'package:acolherconsultas/modules/pacientes/models/paciente.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

// A classe ConsultaController é a classe que controla os consultas.
class ConsultaController extends ChangeNotifier {
  // Instância do Firestore, que é a classe responsável por realizar a comunicação com o banco de dados Firebase Firestore.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // CRUD -----------------------------------
  Future<String> criarConsulta(ConsultaCadastro consulta) async {
    DocumentReference<Map<String, dynamic>> consultaAdicionada = await _firestore.collection("consultas").add(consulta.toMap());

    return consultaAdicionada.id;
  }

  Future<List<Map<String, dynamic>>> selecionarTodosConsulta() async {
    QuerySnapshot querySnapshot = await _firestore.collection("consultas").get();
    List<Map<String, dynamic>> consultas = [];

    for (var element in querySnapshot.docs) {
      var consulta = element.data() as Map<String, dynamic>;
      consulta["id"] = element.id;
      consultas.add(consulta);
    }

    return consultas;
  }
  
  Future<void> atualizarConsulta(ConsultaCadastro consulta,String consultaId) async {
    await _firestore.collection("consultas").doc(consultaId).update(consulta.toMap());
  }

  Future<void> remover(String consultaId) async {
    await _firestore.collection("consultas").doc(consultaId).delete();
  }

  // Funções extras do banco -----------------------------------
  // Busca uma stream de listas de consulta, esse método substitui getConsultas e atualizarConsultas
  // Ele busca a lista como primeiro evento do aplicativo, e ao atualizar, automaticamente atualiza o app 
  Stream<List<ConsultaCadastro>> get consultasStream {
    return _firestore.collection('consultas').snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          var temp = doc.data();
          temp.addAll({'id':doc.id});
          return ConsultaCadastro.fromMap(temp);
        }).toList();
      },
    );
  }

  // Busca uma consulta a partir do Id da mesma
  Future<Map<String, dynamic>?> buscarConsulta(String consultaId) async {
    DocumentSnapshot docsSnapshot = await _firestore.collection("consultas").doc(consultaId).get();

    if(!docsSnapshot.exists){
      return null;
    }
    
    return docsSnapshot.data() as Map<String, dynamic>;
  }

  // Vê se um horário naquela casa de apoio está ocupado, retorna null ou o horário
  Future<Map<String, dynamic>?> horarioOcupado(String casaApoioId, DateTime dataHorario) async {
    QuerySnapshot querySnapshot = await _firestore.collection("consultas")
      .where("casaDeApoioId", isEqualTo: casaApoioId)
      .where("dataHorario", isGreaterThanOrEqualTo: dataHorario)
      .where("dataHorario", isLessThan: DateTime(dataHorario.year,dataHorario.month,dataHorario.day,dataHorario.hour+1))
      .get();

    if(querySnapshot.docs.isEmpty){
      return null;
    }
    
    return querySnapshot.docs.first.data() as Map<String, dynamic>;
  }

  // Funções da controller -----------------------------------

  // Busca consulta a partir do id da mesma
  Future<ConsultaCadastro> getConsulta(String consultaId) async {
    var consulta = await buscarConsulta(consultaId);
    if (consulta!=null) {
      return ConsultaCadastro.fromMap(consulta);
    }
    else {
      throw Exception("Consulta não existe");
    }
  }

  Future<String> reagendar(DateTime dataHorario, ConsultaCadastro consulta) async {
    try {
      if(consulta.id==null) {
        throw Exception("Id da consulta não está presente");
      }
      else if(await horarioOcupado(consulta.casaDeApoioId, dataHorario) != null) {
        throw Exception("Horário já está ocupado");
      }
      consulta.dataHorario=DateTime(dataHorario.year,dataHorario.month,dataHorario.day,dataHorario.hour);
      consulta.estado="agendada";

      await atualizarConsulta(consulta, consulta.id!);
      return "ConsultaCadastro alterada com sucesso";
    } on Exception catch (e) {
      return "Erro ao cadastrar: $e";
    } 
  }

  Future<String> cadastrarConsulta(Paciente paciente,DateTime dataHorario) async {
    try {
      if(paciente.id==null) {
        throw Exception("Id do paciente não está presente");
      }
      else if(await horarioOcupado(paciente.casaDeApoioId, dataHorario) != null) {
        throw Exception("Horário já está ocupado");
      }
      ConsultaCadastro novaConsulta = ConsultaCadastro(casaDeApoioId: paciente.casaDeApoioId, pacienteId: paciente.id!, dataHorario: dataHorario, estado: "agendada");

      await criarConsulta(novaConsulta);
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

      await atualizarConsulta(consulta,consultaId);
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
      
      await atualizarConsulta(consulta,consultaId);
      return "Consulta realizada com sucesso";
    } on Exception catch (e) {
      return "Erro ao cadastrar: $e";
    }
  }
}