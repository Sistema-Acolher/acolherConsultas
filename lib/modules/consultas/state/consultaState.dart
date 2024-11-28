import 'package:acolherconsultas/modules/consultas/models/consulta.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConsultaState extends ChangeNotifier {
  // Campos comuns entre crianças e adolescentes.
  final idade = TextEditingController();
  final cuidadorPrincipal = TextEditingController();
  final queixaPrincipal = TextEditingController();
  final descricao = TextEditingController();
  final observacoesPaciente = TextEditingController();
  final refeicoesComTecnologia = TextEditingController();
  final refeicoesDuranteODia = TextEditingController();
  final consumiuFeijao = TextEditingController();
  final consumiuFrutas = TextEditingController();
  final consumiuVerdurasLegumes = TextEditingController();
  final consumiuEmbutidos = TextEditingController();
  final consumiuBebidasAdocicadas = TextEditingController();
  final consumiuMacarraoInstantaneoSalgado = TextEditingController();
  final consumiuBiscoitoRecheado = TextEditingController();
  final ingestaoHidrica = TextEditingController();
  final suplementacao = TextEditingController();
  final diurese = TextEditingController();
  final evacuacoes = TextEditingController();
  final itensHigiene = TextEditingController();
  final higieneCorporal = TextEditingController();
  final higieneBucal = TextEditingController();
  final sono = TextEditingController();
  final comprimento = TextEditingController();
  final peso = TextEditingController();
  final comprimentoPorIdade = TextEditingController();
  final imcPorIdade = TextEditingController();
  final frequenciaCardiaca = TextEditingController();
  final saturacao = TextEditingController();
  final auscultaCardiaca = TextEditingController();
  final auscultaPulmonar = TextEditingController();
  final pressaoArterial = TextEditingController();
  final temperatura = TextEditingController();
  final otoscopia = TextEditingController();
  final orofaringe = TextEditingController();
  final avaliacaoMuscoesqueletica = TextEditingController();
  final avaliacaoPele = TextEditingController();
  final marcosPresentes = TextEditingController();
  final marcosAusentes = TextEditingController();
  final observacoesDesenvolvimento = TextEditingController();
  final comoSeSenteHoje = TextEditingController();
  final observacoesPsicoemocionais = TextEditingController();
  final analiseGeral = TextEditingController();
  final avaliacoes = TextEditingController();
  final intervencoes = TextEditingController();

  // Campos somente para crianças.
  final fontanelas = TextEditingController();
  final cotoUmbilical = TextEditingController();
  final genitalia = TextEditingController();
  final frequenciaRespiratoria = TextEditingController();
  final bregmatica = TextEditingController();
  ValueNotifier<bool> bregmaticaCalcificada = ValueNotifier<bool>(false);
  final lambdoide = TextEditingController();
  ValueNotifier<bool> lambdoideCalcificada = ValueNotifier<bool>(false);
  final avaliacaoLinguagem = TextEditingController();
  final reflexoBusca = TextEditingController();
  final reflexoSuccao = TextEditingController();
  final reflexoPreensaoPalmar = TextEditingController();
  final reflexoPreensaoPlantar = TextEditingController();
  final reflexoBabinski = TextEditingController();
  final reflexoTonicoCervical = TextEditingController();
  final reflexoMoro = TextEditingController();
  final reflexoMarcha = TextEditingController();
  final reflexoPiscarOptico = TextEditingController();
  final reflexoBuscaESuccao = TextEditingController();
  final movimentosSimetricosFaciais = TextEditingController();
  final reflexoPiscarAcustico = TextEditingController();
  final reflexoVomito = TextEditingController();
  final aperteNariz = TextEditingController();

  // Campos somente para adolescentes.
  final atividadesLazer = TextEditingController();
  final identidadeGenero = TextEditingController();
  final sexualidade = TextEditingController();
  final estagioTurnerMeninasMamas = TextEditingController();
  final estagioTurnerMeninasPelosPubianos = TextEditingController();
  final dataUltimaMenstruacao = TextEditingController();
  final fluxoMenstrual = TextEditingController();
  final regularidadeMenstruacao = TextEditingController();
  final quaoIrregular = TextEditingController();
  final dimenorreia = TextEditingController();
  final usoAbsorvente = TextEditingController();
  final usaMedicamento = TextEditingController();
  final qualMedicamento = TextEditingController();
  final observacoesSaudeSexualEReprodutivaMeninas = TextEditingController();
  final vidaSexualAtiva = TextEditingController();
  final usaMetodoContraceptivo = TextEditingController();
  final qualMetodoContraceptivo = TextEditingController();
  final jaFezPreventivo = TextEditingController();
  final quandoFezPreventivo = TextEditingController();
  final seMasturba = TextEditingController();
  final frequenciaMasturbacao = TextEditingController();
  final estagioTurnerMeninosGenitalia = TextEditingController();
  final estagioTurnerMeninosPelosPubianos = TextEditingController();
  final semenarca = TextEditingController();
  final quandoSemenarca = TextEditingController();

  // Casa
  final analiseGeralCasa = TextEditingController();
  final exameFisicoCasa = TextEditingController();
  final avaliacoesCasa = TextEditingController();
  final oriParaCuidador = TextEditingController();
  final oriParaPaciente = TextEditingController();
  final oriParaCoordenacao = TextEditingController();

  // Notifiers
  ValueNotifier<bool> notifierRefeicoesComTecnologia =
      ValueNotifier<bool>(false);
  ValueNotifier<bool> notifierConsumiuFeijao = ValueNotifier<bool>(false);
  ValueNotifier<bool> notifierConsumiuFrutas = ValueNotifier<bool>(false);
  ValueNotifier<bool> notifierConsumiuVerdurasLegumes =
      ValueNotifier<bool>(false);
  ValueNotifier<bool> notifierConsumiuEmbutidos = ValueNotifier<bool>(false);
  ValueNotifier<bool> notifierConsumiuBebidasAdocicadas =
      ValueNotifier<bool>(false);
  ValueNotifier<bool> notifierConsumiuMacarraoInstantaneoSalgado =
      ValueNotifier<bool>(false);
  ValueNotifier<bool> notifierConsumiuBiscoitoRecheado =
      ValueNotifier<bool>(false);
  ValueNotifier<bool> notifierComprimentoPorIdade = ValueNotifier<bool>(false);
  ValueNotifier<bool> notifierIMCPorIdade = ValueNotifier<bool>(false);
  ValueNotifier<bool> notifierReflexoBusca = ValueNotifier<bool>(false);
  ValueNotifier<bool> notifierReflexoSuccao = ValueNotifier<bool>(false);
  ValueNotifier<bool> notifierReflexoPreensaoPalmar =
      ValueNotifier<bool>(false);
  ValueNotifier<bool> notifierReflexoPreensaoPlantar =
      ValueNotifier<bool>(false);
  ValueNotifier<bool> notifierReflexoBabinski = ValueNotifier<bool>(false);
  ValueNotifier<bool> notifierReflexoTonicoCervical =
      ValueNotifier<bool>(false);
  ValueNotifier<bool> notifierReflexoMoro = ValueNotifier<bool>(false);
  ValueNotifier<bool> notifierReflexoMarcha = ValueNotifier<bool>(false);
  ValueNotifier<bool> notifierReflexoPiscarOptico = ValueNotifier<bool>(false);
  ValueNotifier<bool> notifierReflexoBuscaESuccao = ValueNotifier<bool>(false);
  ValueNotifier<bool> notifierMovimentosSimetricosFaciais =
      ValueNotifier<bool>(false);
  ValueNotifier<bool> notifierReflexoPiscarAcustico =
      ValueNotifier<bool>(false);
  ValueNotifier<bool> notifierReflexoVomito = ValueNotifier<bool>(false);
  ValueNotifier<bool> notifierAperteNariz = ValueNotifier<bool>(false);
  ValueNotifier<bool> notifierIdentidadeGenero = ValueNotifier<bool>(false);
  ValueNotifier<bool> notifierSexo = ValueNotifier<bool>(false);
  ValueNotifier<bool> notifierVidaSexualAtiva = ValueNotifier<bool>(false);
  ValueNotifier<bool> notifierMetodoContraceptivo = ValueNotifier<bool>(false);
  ValueNotifier<bool> notifierSeMasturba = ValueNotifier<bool>(false);
  ValueNotifier<bool> notifierSemenarca = ValueNotifier<bool>(false);
  ValueNotifier<bool> notifierFluxoMenstrual = ValueNotifier<bool>(false);
  ValueNotifier<bool> notifierRegularidadeMenstrual =
      ValueNotifier<bool>(false);
  ValueNotifier<bool> notifierDismenorreia = ValueNotifier<bool>(false);
  ValueNotifier<bool> notifierUsaMedicamento = ValueNotifier<bool>(false);
  ValueNotifier<bool> notifierJaFezPreventivo = ValueNotifier<bool>(false);
  ValueNotifier<bool> notifierGenitalia = ValueNotifier<bool>(false);
  ValueNotifier<bool> notifierMamas = ValueNotifier<bool>(false);
  ValueNotifier<bool> notifierPelosPubianos = ValueNotifier<bool>(false);

  // Método que retorna um objeto Consulta com os dados preenchidos nos campos.
  Consulta cadastro() {
    Consulta consulta = Consulta(
      cuidadorPrincipal: cuidadorPrincipal.text.trim(),
      queixaPrincipal: queixaPrincipal.text.trim(),
      descricao: descricao.text.trim(),
      observacoesPaciente: observacoesPaciente.text.trim().isEmpty
          ? " "
          : observacoesPaciente.text.trim(),
      refeicoesComTecnologia: refeicoesComTecnologia.text.trim(),
      refeicoesDuranteODia: refeicoesDuranteODia.text.trim(),
      consumiuFeijao: consumiuFeijao.text.trim(),
      consumiuFrutas: consumiuFrutas.text.trim(),
      consumiuVerdurasLegumes: consumiuVerdurasLegumes.text.trim(),
      consumiuEmbutidos: consumiuEmbutidos.text.trim(),
      consumiuBebidasAdocicadas: consumiuBebidasAdocicadas.text.trim(),
      consumiuMacarraoInstantaneoSalgado:
          consumiuMacarraoInstantaneoSalgado.text.trim(),
      consumiuBiscoitoRecheado: consumiuBiscoitoRecheado.text.trim(),
      ingestaoHidrica: ingestaoHidrica.text.trim(),
      suplementacao: suplementacao.text.trim(),
      diurese: diurese.text.trim(),
      evacuacoes: evacuacoes.text.trim(),
      itensHigiene: itensHigiene.text.trim(),
      higieneCorporal: higieneCorporal.text.trim(),
      higieneBucal: higieneBucal.text.trim(),
      sono: sono.text.trim(),
      comprimento: int.tryParse(comprimento.text) ?? 0,
      peso: double.tryParse(peso.text) ?? 0.0,
      comprimentoPorIdade: comprimentoPorIdade.text.trim(),
      imcPorIdade: imcPorIdade.text.trim(),
      frequenciaCardiaca: frequenciaCardiaca.text.trim(),
      saturacao: saturacao.text.trim(),
      auscultaCardiaca: auscultaCardiaca.text.trim(),
      auscultaPulmonar: auscultaPulmonar.text.trim(),
      pressaoArterial: pressaoArterial.text.trim(),
      temperatura: double.tryParse(temperatura.text) ?? 0.0,
      otoscopia: otoscopia.text.trim(),
      orofaringe: orofaringe.text.trim(),
      avaliacaoMuscoesqueletica: avaliacaoMuscoesqueletica.text.trim(),
      avaliacaoPele: avaliacaoPele.text.trim(),
      marcosPresentes: marcosPresentes.text.trim(),
      marcosAusentes: marcosAusentes.text.trim(),
      observacoesDesenvolvimento: observacoesDesenvolvimento.text.trim(),
      comoSeSenteHoje: comoSeSenteHoje.text.trim(),
      observacoesPsicoemocionais: observacoesPsicoemocionais.text.trim(),
      analiseGeral: analiseGeral.text.trim(),
      avaliacoes: avaliacoes.text.trim(),
      intervencoes: intervencoes.text.trim(),

      // Campos somente crianças
      fontanelas: fontanelas.text.isEmpty ? " " : fontanelas.text,
      cotoUmbilical: cotoUmbilical.text.isEmpty ? " " : cotoUmbilical.text,
      genitalia: genitalia.text.isEmpty ? " " : genitalia.text,
      frequenciaRespiratoria: frequenciaRespiratoria.text.isEmpty
          ? " "
          : frequenciaRespiratoria.text,
      bregmatica: int.tryParse(bregmatica.text) ?? 0,
      bregmaticaCalcificada: bregmaticaCalcificada.value,
      lambdoide: int.tryParse(lambdoide.text) ?? 0,
      lambdoideCalcificada: lambdoideCalcificada.value,
      avaliacaoLinguagem:
          avaliacaoLinguagem.text.isEmpty ? " " : avaliacaoLinguagem.text,
      reflexoBusca: reflexoBusca.text.isEmpty ? " " : reflexoBusca.text,
      reflexoSuccao: reflexoSuccao.text.isEmpty ? " " : reflexoSuccao.text,
      reflexoPreensaoPalmar:
          reflexoPreensaoPalmar.text.isEmpty ? " " : reflexoPreensaoPalmar.text,
      reflexoPreensaoPlantar: reflexoPreensaoPlantar.text.isEmpty
          ? " "
          : reflexoPreensaoPlantar.text,
      reflexoBabinski:
          reflexoBabinski.text.isEmpty ? " " : reflexoBabinski.text,
      reflexoTonicoCervical:
          reflexoTonicoCervical.text.isEmpty ? " " : reflexoTonicoCervical.text,
      reflexoMoro: reflexoMoro.text.isEmpty ? " " : reflexoMoro.text,
      reflexoMarcha: reflexoMarcha.text.isEmpty ? " " : reflexoMarcha.text,
      reflexoPiscarOptico:
          reflexoPiscarOptico.text.isEmpty ? " " : reflexoPiscarOptico.text,
      reflexoBuscaESuccao:
          reflexoBuscaESuccao.text.isEmpty ? " " : reflexoBuscaESuccao.text,
      movimentosSimetricosFaciais: movimentosSimetricosFaciais.text.isEmpty
          ? " "
          : movimentosSimetricosFaciais.text,
      reflexoPiscarAcustico:
          reflexoPiscarAcustico.text.isEmpty ? " " : reflexoPiscarAcustico.text,
      reflexoVomito: reflexoVomito.text.isEmpty ? " " : reflexoVomito.text,
      aperteNariz: aperteNariz.text.isEmpty ? " " : aperteNariz.text,

      // Campos somente adolescentes
      atividadesLazer:
          atividadesLazer.text.isEmpty ? " " : atividadesLazer.text,
      identidadeGenero:
          identidadeGenero.text.isEmpty ? " " : identidadeGenero.text.trim(),
      sexualidade: sexualidade.text.isEmpty ? " " : sexualidade.text.trim(),
      estagioTurnerMeninasMamas: estagioTurnerMeninasMamas.text.isEmpty
          ? " "
          : estagioTurnerMeninasMamas.text.trim(),
      estagioTurnerMeninasPelosPubianos:
          estagioTurnerMeninasPelosPubianos.text.isEmpty
              ? " "
              : estagioTurnerMeninasPelosPubianos.text.trim(),
      dataUltimaMenstruacao: dataUltimaMenstruacao.text.trim().isEmpty
          ? DateTime(1900, 1, 1)
          : DateFormat('dd/MM/yyyy').parse(dataUltimaMenstruacao.text),
      fluxoMenstrual:
          fluxoMenstrual.text.isEmpty ? " " : fluxoMenstrual.text.trim(),
      regularidadeMenstruacao: regularidadeMenstruacao.text.isEmpty
          ? " "
          : regularidadeMenstruacao.text.trim(),
      quaoIrregular: quaoIrregular.text.isEmpty ? " " : quaoIrregular.text,
      dimenorreia: dimenorreia.text.isEmpty ? " " : dimenorreia.text,
      usoAbsorvente: usoAbsorvente.text.trim(),
      usaMedicamento: usaMedicamento.text.isEmpty ? " " : usaMedicamento.text,
      qualMedicamento:
          qualMedicamento.text.isEmpty ? " " : qualMedicamento.text,
      observacoesSaudeSexualEReprodutivaMeninas:
          observacoesSaudeSexualEReprodutivaMeninas.text.isEmpty
              ? " "
              : observacoesSaudeSexualEReprodutivaMeninas.text,
      vidaSexualAtiva:
          vidaSexualAtiva.text.isEmpty ? " " : vidaSexualAtiva.text,
      usaMetodoContraceptivo: usaMetodoContraceptivo.text.isEmpty
          ? " "
          : usaMetodoContraceptivo.text,
      qualMetodoContraceptivo: qualMetodoContraceptivo.text.isEmpty
          ? " "
          : qualMetodoContraceptivo.text,
      jaFezPreventivo:
          jaFezPreventivo.text.isEmpty ? " " : jaFezPreventivo.text,
      quandoFezPreventivo: quandoFezPreventivo.text.trim().isEmpty
          ? DateTime(1900, 1, 1)
          : DateFormat('dd/MM/yyyy').parse(quandoFezPreventivo.text),
      seMasturba: seMasturba.text.isEmpty ? " " : seMasturba.text,
      frequenciaMasturbacao:
          frequenciaMasturbacao.text.isEmpty ? " " : frequenciaMasturbacao.text,
      estagioTurnerMeninosGenitalia: estagioTurnerMeninosGenitalia.text.isEmpty
          ? " "
          : estagioTurnerMeninosGenitalia.text.trim(),
      estagioTurnerMeninosPelosPubianos:
          estagioTurnerMeninosPelosPubianos.text.isEmpty
              ? " "
              : estagioTurnerMeninosPelosPubianos.text.trim(),
      semenarca: semenarca.text.isEmpty ? " " : semenarca.text,
      quandoSemenarca: quandoSemenarca.text.trim().isEmpty
          ? DateTime(1900, 1, 1)
          : DateFormat('dd/MM/yyyy').parse(quandoSemenarca.text),
      analiseGeralCasa:
          analiseGeralCasa.text.isEmpty ? " " : analiseGeralCasa.text,
      exameFisicoCasa:
          exameFisicoCasa.text.isEmpty ? " " : exameFisicoCasa.text,
      avaliacoesCasa: avaliacoesCasa.text.isEmpty ? " " : avaliacoesCasa.text,
      oriParaCuidador:
          oriParaCuidador.text.isEmpty ? " " : oriParaCuidador.text,
      oriParaPaciente:
          oriParaPaciente.text.isEmpty ? " " : oriParaPaciente.text,
      oriParaCoordenacao:
          oriParaCoordenacao.text.isEmpty ? " " : oriParaCoordenacao.text,
    );
    return consulta;
  }

  ConsultaState();

  ConsultaState.fromConsulta(Consulta consulta) {
    cuidadorPrincipal.value =
        TextEditingValue(text: consulta.cuidadorPrincipal);
    queixaPrincipal.value = TextEditingValue(text: consulta.queixaPrincipal);
    descricao.value = TextEditingValue(text: consulta.descricao);
    observacoesPaciente.value =
        TextEditingValue(text: consulta.observacoesPaciente ?? '');
    refeicoesComTecnologia.value =
        TextEditingValue(text: consulta.refeicoesComTecnologia);
    refeicoesDuranteODia.value =
        TextEditingValue(text: consulta.refeicoesDuranteODia);
    consumiuFeijao.value = TextEditingValue(text: consulta.consumiuFeijao);
    consumiuFrutas.value = TextEditingValue(text: consulta.consumiuFrutas);
    consumiuVerdurasLegumes.value =
        TextEditingValue(text: consulta.consumiuVerdurasLegumes);
    consumiuEmbutidos.value =
        TextEditingValue(text: consulta.consumiuEmbutidos);
    consumiuBebidasAdocicadas.value =
        TextEditingValue(text: consulta.consumiuBebidasAdocicadas);
    consumiuMacarraoInstantaneoSalgado.value =
        TextEditingValue(text: consulta.consumiuMacarraoInstantaneoSalgado);
    consumiuBiscoitoRecheado.value =
        TextEditingValue(text: consulta.consumiuBiscoitoRecheado);
    ingestaoHidrica.value = TextEditingValue(text: consulta.ingestaoHidrica);
    suplementacao.value = TextEditingValue(text: consulta.suplementacao);
    diurese.value = TextEditingValue(text: consulta.diurese);
    evacuacoes.value = TextEditingValue(text: consulta.evacuacoes);
    itensHigiene.value = TextEditingValue(text: consulta.itensHigiene);
    higieneCorporal.value = TextEditingValue(text: consulta.higieneCorporal);
    higieneBucal.value = TextEditingValue(text: consulta.higieneBucal);
    sono.value = TextEditingValue(text: consulta.sono);
    comprimento.value = TextEditingValue(text: consulta.comprimento.toString());
    peso.value = TextEditingValue(text: consulta.peso.toString());
    comprimentoPorIdade.value =
        TextEditingValue(text: consulta.comprimentoPorIdade);
    imcPorIdade.value = TextEditingValue(text: consulta.imcPorIdade);
    frequenciaCardiaca.value =
        TextEditingValue(text: consulta.frequenciaCardiaca);
    saturacao.value = TextEditingValue(text: consulta.saturacao);
    auscultaCardiaca.value = TextEditingValue(text: consulta.auscultaCardiaca);
    auscultaPulmonar.value = TextEditingValue(text: consulta.auscultaPulmonar);
    pressaoArterial.value = TextEditingValue(text: consulta.pressaoArterial);
    temperatura.value = TextEditingValue(text: consulta.temperatura.toString());
    otoscopia.value = TextEditingValue(text: consulta.otoscopia);
    orofaringe.value = TextEditingValue(text: consulta.orofaringe);
    avaliacaoMuscoesqueletica.value =
        TextEditingValue(text: consulta.avaliacaoMuscoesqueletica);
    avaliacaoPele.value = TextEditingValue(text: consulta.avaliacaoPele);
    marcosPresentes.value = TextEditingValue(text: consulta.marcosPresentes);
    marcosAusentes.value = TextEditingValue(text: consulta.marcosAusentes);
    observacoesDesenvolvimento.value =
        TextEditingValue(text: consulta.observacoesDesenvolvimento ?? '');
    comoSeSenteHoje.value = TextEditingValue(text: consulta.comoSeSenteHoje);
    observacoesPsicoemocionais.value =
        TextEditingValue(text: consulta.observacoesPsicoemocionais ?? '');
    analiseGeral.value = TextEditingValue(text: consulta.analiseGeral);
    avaliacoes.value = TextEditingValue(text: consulta.avaliacoes);
    intervencoes.value = TextEditingValue(text: consulta.intervencoes);

    // Campos somente crianças
    fontanelas.value = TextEditingValue(text: consulta.fontanelas ?? '');
    cotoUmbilical.value = TextEditingValue(text: consulta.cotoUmbilical ?? '');
    genitalia.value = TextEditingValue(text: consulta.genitalia ?? '');
    frequenciaRespiratoria.value =
        TextEditingValue(text: consulta.frequenciaRespiratoria ?? '');
    bregmatica.value =
        TextEditingValue(text: consulta.bregmatica?.toString() ?? '');
    bregmaticaCalcificada.value = consulta.bregmaticaCalcificada ?? false;
    lambdoide.value =
        TextEditingValue(text: consulta.lambdoide?.toString() ?? '');
    lambdoideCalcificada.value = consulta.lambdoideCalcificada ?? false;
    avaliacaoLinguagem.value =
        TextEditingValue(text: consulta.avaliacaoLinguagem ?? '');
    reflexoBusca.value = TextEditingValue(text: consulta.reflexoBusca ?? '');
    reflexoSuccao.value = TextEditingValue(text: consulta.reflexoSuccao ?? '');
    reflexoPreensaoPalmar.value =
        TextEditingValue(text: consulta.reflexoPreensaoPalmar ?? '');
    reflexoPreensaoPlantar.value =
        TextEditingValue(text: consulta.reflexoPreensaoPlantar ?? '');
    reflexoBabinski.value =
        TextEditingValue(text: consulta.reflexoBabinski ?? '');
    reflexoTonicoCervical.value =
        TextEditingValue(text: consulta.reflexoTonicoCervical ?? '');
    reflexoMoro.value = TextEditingValue(text: consulta.reflexoMoro ?? '');
    reflexoMarcha.value = TextEditingValue(text: consulta.reflexoMarcha ?? '');
    reflexoPiscarOptico.value =
        TextEditingValue(text: consulta.reflexoPiscarOptico ?? '');
    reflexoBuscaESuccao.value =
        TextEditingValue(text: consulta.reflexoBuscaESuccao ?? '');
    movimentosSimetricosFaciais.value =
        TextEditingValue(text: consulta.movimentosSimetricosFaciais ?? '');
    reflexoPiscarAcustico.value =
        TextEditingValue(text: consulta.reflexoPiscarAcustico ?? '');
    reflexoVomito.value = TextEditingValue(text: consulta.reflexoVomito ?? '');
    aperteNariz.value = TextEditingValue(text: consulta.aperteNariz ?? '');

    // Campos somente adolescentes
    atividadesLazer.value =
        TextEditingValue(text: consulta.atividadesLazer ?? '');
    identidadeGenero.value =
        TextEditingValue(text: consulta.identidadeGenero ?? '');
    sexualidade.value = TextEditingValue(text: consulta.sexualidade ?? '');
    estagioTurnerMeninasMamas.value =
        TextEditingValue(text: consulta.estagioTurnerMeninasMamas ?? '');
    estagioTurnerMeninasPelosPubianos.value = TextEditingValue(
        text: consulta.estagioTurnerMeninasPelosPubianos ?? '');
    dataUltimaMenstruacao.value = TextEditingValue(
        text: consulta.dataUltimaMenstruacao != null
            ? DateFormat('dd/MM/yyyy').format(consulta.dataUltimaMenstruacao!)
            : '');
    fluxoMenstrual.value =
        TextEditingValue(text: consulta.fluxoMenstrual ?? '');
    regularidadeMenstruacao.value =
        TextEditingValue(text: consulta.regularidadeMenstruacao ?? '');
    quaoIrregular.value = TextEditingValue(text: consulta.quaoIrregular ?? '');
    dimenorreia.value = TextEditingValue(text: consulta.dimenorreia ?? '');
    usoAbsorvente.value = TextEditingValue(text: consulta.usoAbsorvente ?? '');
    usaMedicamento.value =
        TextEditingValue(text: consulta.usaMedicamento ?? '');
    qualMedicamento.value =
        TextEditingValue(text: consulta.qualMedicamento ?? '');
    observacoesSaudeSexualEReprodutivaMeninas.value = TextEditingValue(
        text: consulta.observacoesSaudeSexualEReprodutivaMeninas ?? '');
    vidaSexualAtiva.value =
        TextEditingValue(text: consulta.vidaSexualAtiva ?? '');
    usaMetodoContraceptivo.value =
        TextEditingValue(text: consulta.usaMetodoContraceptivo ?? '');
    qualMetodoContraceptivo.value =
        TextEditingValue(text: consulta.qualMetodoContraceptivo ?? '');
    jaFezPreventivo.value =
        TextEditingValue(text: consulta.jaFezPreventivo ?? '');
    quandoFezPreventivo.value = TextEditingValue(
        text: consulta.quandoFezPreventivo != null
            ? DateFormat('dd/MM/yyyy').format(consulta.quandoFezPreventivo!)
            : '');
    seMasturba.value = TextEditingValue(text: consulta.seMasturba ?? '');
    frequenciaMasturbacao.value =
        TextEditingValue(text: consulta.frequenciaMasturbacao ?? '');
    estagioTurnerMeninosGenitalia.value =
        TextEditingValue(text: consulta.estagioTurnerMeninosGenitalia ?? '');
    estagioTurnerMeninosPelosPubianos.value = TextEditingValue(
        text: consulta.estagioTurnerMeninosPelosPubianos ?? '');
    semenarca.value = TextEditingValue(text: consulta.semenarca ?? '');
    quandoSemenarca.value = TextEditingValue(
        text: consulta.quandoSemenarca != null
            ? DateFormat('dd/MM/yyyy').format(consulta.quandoSemenarca!)
            : '');
    analiseGeralCasa.value =
        TextEditingValue(text: consulta.analiseGeralCasa ?? '');
    exameFisicoCasa.value =
        TextEditingValue(text: consulta.exameFisicoCasa ?? '');
    avaliacoesCasa.value =
        TextEditingValue(text: consulta.avaliacoesCasa ?? '');
    oriParaCuidador.value =
        TextEditingValue(text: consulta.oriParaCuidador ?? '');
    oriParaPaciente.value =
        TextEditingValue(text: consulta.oriParaPaciente ?? '');
    oriParaCoordenacao.value =
        TextEditingValue(text: consulta.oriParaCoordenacao ?? '');
  }
}
