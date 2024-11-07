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
        ? " "
        : observacoesPaciente.text.trim(),
    refeicoesComTecnologia: refeicoesComTecnologia.text.trim(),
    refeicoesDuranteODia: refeicoesDuranteODia.text.trim(),
    consumiuFeijao: consumiuFeijao.text.trim(),
    consumiuFrutas: consumiuFrutas.text.trim(),
    consumiuVerdurasLegumes: consumiuVerdurasLegumes.text.trim(),
    consumiuEmbutidos: consumiuEmbutidos.text.trim(),
    consumiuBebidasAdocicadas: consumiuBebidasAdocicadas.text.trim(),
    consumiuMacarraoInstantaneoSalgado: consumiuMacarraoInstantaneoSalgado.text.trim(),
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
    frequenciaRespiratoria: frequenciaRespiratoria.text.isEmpty ? " " : frequenciaRespiratoria.text,
    bregmatica: int.tryParse(bregmatica.text) ?? 0,
    bregmaticaCalcificada: bregmaticaCalcificada.text.toLowerCase() == 'true',
    lambdoide: int.tryParse(lambdoide.text) ?? 0,
    lambdoideCalcificada: lambdoideCalcificada.text.toLowerCase() == 'true',
    avaliacaoLinguagem: avaliacaoLinguagem.text.isEmpty ? " " : avaliacaoLinguagem.text,
    reflexoBusca: reflexoBusca.text.isEmpty ? " ": reflexoBusca.text,
    reflexoSuccao: reflexoSuccao.text.isEmpty ? " ":reflexoSuccao.text,
    reflexoPreensaoPalmar: reflexoPreensaoPalmar.text.isEmpty ? " ":reflexoPreensaoPalmar.text,
    reflexoPreensaoPlantar: reflexoPreensaoPlantar.text.isEmpty ? " ": reflexoPreensaoPlantar.text,
    reflexoBabinski: reflexoBabinski.text.isEmpty ? " ":reflexoBabinski.text,
    reflexoTonicoCervical: reflexoTonicoCervical.text.isEmpty ? " ": reflexoTonicoCervical.text,
    reflexoMoro: reflexoMoro.text.isEmpty ? " ": reflexoMoro.text,
    reflexoMarcha: reflexoMarcha.text.isEmpty ? " ": reflexoMarcha.text,
    reflexoPiscarOptico: reflexoPiscarOptico.text.isEmpty ? " ": reflexoPiscarOptico.text,
    reflexoBuscaESuccao: reflexoBuscaESuccao.text.isEmpty ? " ": reflexoBuscaESuccao.text,
    movimentosSimetricosFaciais: movimentosSimetricosFaciais.text.isEmpty ? " ": movimentosSimetricosFaciais.text,
    reflexoPiscarAcustico: reflexoPiscarAcustico.text.isEmpty ? " ": reflexoPiscarAcustico.text,
    reflexoVomito: reflexoVomito.text.isEmpty ? " ": reflexoVomito.text,
    aperteNariz: aperteNariz.text.isEmpty ? " ":aperteNariz.text,

    // Campos somente adolescentes
    atividadesLazer: atividadesLazer.text.isEmpty ? " " : atividadesLazer.text,
    identidadeGenero: identidadeGenero.text.isEmpty ? " " : identidadeGenero.text.trim(),
    sexualidade: sexualidade.text.isEmpty ? " " : sexualidade.text.trim(),
    estagioTurnerMeninasMamas: estagioTurnerMeninasMamas.text.isEmpty ? " " : estagioTurnerMeninasMamas.text.trim(),
    estagioTurnerMeninasPelosPubianos: estagioTurnerMeninasPelosPubianos.text.isEmpty ? " " : estagioTurnerMeninasPelosPubianos.text.trim(),
    dataUltimaMenstruacao: dataUltimaMenstruacao.text.trim().isEmpty
        ? DateTime(1900, 1, 1)
        : DateFormat('dd/MM/yyyy').parse(dataUltimaMenstruacao.text),
    fluxoMenstrual: fluxoMenstrual.text.isEmpty ? " " : fluxoMenstrual.text.trim(),
    regularidadeMenstruacao: regularidadeMenstruacao.text.isEmpty ? " " : regularidadeMenstruacao.text.trim(),
    quaoIrregular: quaoIrregular.text.isEmpty ? " " : quaoIrregular.text,
    dimenorreia: dimenorreia.text.isEmpty ? " " : dimenorreia.text,
    usoAbsorvente: usoAbsorvente.text.trim(),
    usaMedicamento: usaMedicamento.text.isEmpty ? " " : usaMedicamento.text,
    qualMedicamento: qualMedicamento.text.isEmpty ? " " : qualMedicamento.text,
    observacoesSaudeSexualEReprodutivaMeninas:
        observacoesSaudeSexualEReprodutivaMeninas.text.isEmpty ? " " : observacoesSaudeSexualEReprodutivaMeninas.text,
    vidaSexualAtiva: vidaSexualAtiva.text.isEmpty ? " " : vidaSexualAtiva.text,
    usaMetodoContraceptivo: usaMetodoContraceptivo.text.isEmpty ? " " : usaMetodoContraceptivo.text,
    qualMetodoContraceptivo: qualMetodoContraceptivo.text.isEmpty ? " " : qualMetodoContraceptivo.text,
    jaFezPreventivo: jaFezPreventivo.text.isEmpty ? " " : jaFezPreventivo.text,
    quandoFezPreventivo: quandoFezPreventivo.text.trim().isEmpty
        ? DateTime(1900, 1, 1)
        : DateFormat('dd/MM/yyyy').parse(quandoFezPreventivo.text),
    seMasturba: seMasturba.text.isEmpty ? " " : seMasturba.text,
    frequenciaMasturbacao: frequenciaMasturbacao.text.isEmpty ? " " : frequenciaMasturbacao.text,
    estagioTurnerMeninosGenitalia: estagioTurnerMeninosGenitalia.text.isEmpty ? " " : estagioTurnerMeninosGenitalia.text.trim(),
    estagioTurnerMeninosPelosPubianos: estagioTurnerMeninosPelosPubianos.text.isEmpty ? " " : estagioTurnerMeninosPelosPubianos.text.trim(),
    semenarca: semenarca.text.isEmpty ? " " : semenarca.text,
    quandoSemenarca: quandoSemenarca.text.trim().isEmpty
        ? DateTime(1900, 1, 1)
        : DateFormat('dd/MM/yyyy').parse(quandoSemenarca.text),
    analiseGeralCasa: analiseGeralCasa.text.isEmpty ? " " : analiseGeralCasa.text,
    exameFisicoCasa: exameFisicoCasa.text.isEmpty ? " " : exameFisicoCasa.text,
    avaliacoesCasa: avaliacoesCasa.text.isEmpty ? " " : avaliacoesCasa.text,
    oriParaCuidador: oriParaCuidador.text.isEmpty ? " " : oriParaCuidador.text,
    oriParaPaciente: oriParaPaciente.text.isEmpty ? " " : oriParaPaciente.text,
    oriParaCoordenacao: oriParaCoordenacao.text.isEmpty ? " " : oriParaCoordenacao.text,
  );
  return consulta;
}

}
