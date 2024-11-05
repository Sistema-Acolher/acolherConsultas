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
  final bregmaticaCalcificada = TextEditingController();
  final lambdoide = TextEditingController();
  final lambdoideCalcificada = TextEditingController();
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
  //casa
  final analiseGeralCasa = TextEditingController();
  final exameFisicoCasa= TextEditingController();
  final avaliacoesCasa= TextEditingController();
  final oriParaCuidador= TextEditingController();
  final oriParaPaciente= TextEditingController();
  final oriParaCoordenacao= TextEditingController();
  // Método que retorna um objeto Consulta com os dados preenchidos nos campos.
  Consulta cadastro() {
    Consulta consulta = Consulta(
      cuidadorPrincipal: cuidadorPrincipal.text.trim(),
      queixaPrincipal: queixaPrincipal.text.trim(),
      descricao: descricao.text.trim(),
      observacoesPaciente: observacoesPaciente.text.trim().isEmpty
          ? null
          : observacoesPaciente.text.trim(),
      refeicoesComTecnologia: int.tryParse(refeicoesComTecnologia.text) ?? 0,
      refeicoesDuranteODia: refeicoesDuranteODia.text.trim(),
      consumiuFeijao: int.tryParse(consumiuFeijao.text) ?? 0,
      consumiuFrutas: int.tryParse(consumiuFrutas.text) ?? 0,
      consumiuVerdurasLegumes: int.tryParse(consumiuVerdurasLegumes.text) ?? 0,
      consumiuEmbutidos: int.tryParse(consumiuEmbutidos.text) ?? 0,
      consumiuBebidasAdocicadas:
          int.tryParse(consumiuBebidasAdocicadas.text) ?? 0,
      consumiuMacarraoInstantaneoSalgado:
          int.tryParse(consumiuMacarraoInstantaneoSalgado.text) ?? 0,
      consumiuBiscoitoRecheado:
          int.tryParse(consumiuBiscoitoRecheado.text) ?? 0,
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
      comprimentoPorIdade: int.tryParse(comprimentoPorIdade.text) ?? 0,
      imcPorIdade: int.tryParse(imcPorIdade.text) ?? 0,
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
      fontanelas: fontanelas.text.isEmpty ? null: fontanelas.text,
      cotoUmbilical: cotoUmbilical.text.isEmpty ? null: cotoUmbilical.text,
      genitalia: genitalia.text.isEmpty ? null: genitalia.text,
      frequenciaRespiratoria: frequenciaRespiratoria.text.isEmpty ? null : frequenciaRespiratoria.text,
      bregmatica: int.tryParse(bregmatica.text),
      bregmaticaCalcificada: bregmaticaCalcificada.text.toLowerCase() == 'true',
      lambdoide: int.tryParse(lambdoide.text),
      lambdoideCalcificada: lambdoideCalcificada.text.toLowerCase() == 'true',
      avaliacaoLinguagem:
          avaliacaoLinguagem.text.isEmpty ? null : avaliacaoLinguagem.text,
      reflexoBusca: int.tryParse(reflexoBusca.text),
      reflexoSuccao: int.tryParse(reflexoSuccao.text),
      reflexoPreensaoPalmar: int.tryParse(reflexoPreensaoPalmar.text),
      reflexoPreensaoPlantar: int.tryParse(reflexoPreensaoPlantar.text),
      reflexoBabinski: int.tryParse(reflexoBabinski.text),
      reflexoTonicoCervical: int.tryParse(reflexoTonicoCervical.text),
      reflexoMoro: int.tryParse(reflexoMoro.text),
      reflexoMarcha: int.tryParse(reflexoMarcha.text),
      reflexoPiscarOptico: int.tryParse(reflexoPiscarOptico.text),
      reflexoBuscaESuccao: int.tryParse(reflexoBuscaESuccao.text),
      movimentosSimetricosFaciais:
          int.tryParse(movimentosSimetricosFaciais.text),
      reflexoPiscarAcustico: int.tryParse(reflexoPiscarAcustico.text),
      reflexoVomito: int.tryParse(reflexoVomito.text),
      aperteNariz: int.tryParse(aperteNariz.text),

      // Campos somente adolescentes
      atividadesLazer:
          atividadesLazer.text.isEmpty ? null : atividadesLazer.text,
      identidadeGenero: int.tryParse(identidadeGenero.text),
      sexualidade: int.tryParse(sexualidade.text),
      estagioTurnerMeninasMamas: int.tryParse(estagioTurnerMeninasMamas.text),
      estagioTurnerMeninasPelosPubianos:
          int.tryParse(estagioTurnerMeninasPelosPubianos.text),
      dataUltimaMenstruacao: dataUltimaMenstruacao.text.trim().isEmpty
          ? null
          : DateFormat('dd/MM/yyyy').parse(dataUltimaMenstruacao.text),
      fluxoMenstrual: int.tryParse(fluxoMenstrual.text),
      regularidadeMenstruacao: int.tryParse(regularidadeMenstruacao.text),
      quaoIrregular: quaoIrregular.text.isEmpty ? null : quaoIrregular.text,
      dimenorreia: dimenorreia.text.toLowerCase() == 'true',
      usoAbsorvente: usoAbsorvente.text.trim(),
      usaMedicamento: usaMedicamento.text.toLowerCase() == 'true',
      qualMedicamento:
          qualMedicamento.text.isEmpty ? null : qualMedicamento.text,
      observacoesSaudeSexualEReprodutivaMeninas:
          observacoesSaudeSexualEReprodutivaMeninas.text.isEmpty
              ? null
              : observacoesSaudeSexualEReprodutivaMeninas.text,
      vidaSexualAtiva: vidaSexualAtiva.text.toLowerCase() == 'true',
      usaMetodoContraceptivo:
          usaMetodoContraceptivo.text.toLowerCase() == 'true',
      qualMetodoContraceptivo: qualMetodoContraceptivo.text.isEmpty
          ? null
          : qualMetodoContraceptivo.text,
      jaFezPreventivo: jaFezPreventivo.text.toLowerCase() == 'true',
      quandoFezPreventivo: quandoFezPreventivo.text.trim().isEmpty
          ? null
          : DateFormat('dd/MM/yyyy').parse(quandoFezPreventivo.text),
      seMasturba: seMasturba.text.toLowerCase() == 'true',
      frequenciaMasturbacao: frequenciaMasturbacao.text.isEmpty
          ? null
          : frequenciaMasturbacao.text,
      estagioTurnerMeninosGenitalia:
          int.tryParse(estagioTurnerMeninosGenitalia.text),
      estagioTurnerMeninosPelosPubianos:
          int.tryParse(estagioTurnerMeninosPelosPubianos.text),
      semenarca: semenarca.text.toLowerCase() == 'true',
      quandoSemenarca: quandoSemenarca.text.trim().isEmpty
          ? null
          : DateFormat('dd/MM/yyyy').parse(quandoSemenarca.text),
      analiseGeralCasa: analiseGeralCasa.text.isEmpty? null : analiseGeralCasa.text,
      exameFisicoCasa: exameFisicoCasa.text.isEmpty? null: exameFisicoCasa.text,
      avaliacoesCasa: avaliacoesCasa.text.isEmpty? null: avaliacoesCasa.text,
      oriParaCuidador: oriParaCuidador.text.isEmpty? null: oriParaCuidador.text,
      oriParaPaciente: oriParaPaciente.text.isEmpty? null: oriParaPaciente.text,
      oriParaCoordenacao: oriParaCoordenacao.text.isEmpty? null: oriParaCoordenacao.text
    );

    return consulta;
  }
}
