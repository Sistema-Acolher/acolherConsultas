import 'package:acolherconsultas/modules/casasDeApoio/models/casaDeApoio.dart';
import 'package:acolherconsultas/modules/consultas/models/consulta.dart';
import 'package:acolherconsultas/modules/consultas/controllers/consultaController.dart';
import 'package:acolherconsultas/modules/consultas/state/consultaState.dart';
import 'package:acolherconsultas/modules/pacientes/controllers/pacienteController.dart';
import 'package:acolherconsultas/modules/pacientes/models/paciente.dart';
import 'package:acolherconsultas/modules/sistema/views/loadingLogo.dart';
import 'package:acolherconsultas/shared/components/bars/pacienteAppbar.dart';
import 'package:acolherconsultas/shared/components/bars/pageAppBar.dart';
import 'package:acolherconsultas/shared/components/buttons/bigRoundButton.dart';
import 'package:acolherconsultas/shared/components/inputs/inputRadioButtonsConsulta.dart';
import 'package:acolherconsultas/shared/components/inputs/inputTexto.dart';
import 'package:acolherconsultas/shared/components/list/listaHorarios.dart';
import 'package:acolherconsultas/shared/components/inputs/inputCaixaDeTexto.dart';
import 'package:flutter/material.dart';
import 'package:mask/mask/mask.dart';
import 'package:provider/provider.dart';

class ConsultarScreen extends StatefulWidget {
  const ConsultarScreen({super.key, this.dadosConsulta});

  final ConsultaCadastro? dadosConsulta;

  @override
  State<ConsultarScreen> createState() => _ConsultarScreenState();
}

class _ConsultarScreenState extends State<ConsultarScreen> {
  final _formKey = GlobalKey<FormState>();
  final ConsultaState _consultaState = ConsultaState();
  ValueNotifier<bool> refeicoesComTecnologiaNotifier =
      ValueNotifier<bool>(false);
  ValueNotifier<bool> consumiuFeijaoNotifier = ValueNotifier<bool>(false);
  ValueNotifier<bool> consumiuFrutasNotifier = ValueNotifier<bool>(false);
  ValueNotifier<bool> consumiuVerdurasLegumesNotifier =
      ValueNotifier<bool>(false);
  ValueNotifier<bool> consumiuEmbutidosNotifier = ValueNotifier<bool>(false);
  ValueNotifier<bool> consumiuBebidasAdocicadasNotifier =
      ValueNotifier<bool>(false);
  ValueNotifier<bool> consumiuMacarraoInstantaneoSalgadoNotifier =
      ValueNotifier<bool>(false);
  ValueNotifier<bool> consumiuBiscoitoRecheadoNotifier =
      ValueNotifier<bool>(false);
  ValueNotifier<bool> radiobuttonNotifierEstatura = ValueNotifier<bool>(false);
  ValueNotifier<bool> radiobuttonNotifierIMC = ValueNotifier<bool>(false);
  ValueNotifier<bool> reflexoBuscaNotifier = ValueNotifier<bool>(false);
  ValueNotifier<bool> reflexoSuccaoNotifier = ValueNotifier<bool>(false);
  ValueNotifier<bool> reflexoPreensaoPalmarNotifier =
      ValueNotifier<bool>(false);
  ValueNotifier<bool> reflexoPreensaoPlantarNotifier =
      ValueNotifier<bool>(false);
  ValueNotifier<bool> reflexoBabinskiNotifier = ValueNotifier<bool>(false);
  ValueNotifier<bool> reflexoTonicoCervicalNotifier =
      ValueNotifier<bool>(false);
  ValueNotifier<bool> reflexoMoroNotifier = ValueNotifier<bool>(false);
  ValueNotifier<bool> reflexoMarchaNotifier = ValueNotifier<bool>(false);
  ValueNotifier<bool> reflexoPiscarOpticoNotifier = ValueNotifier<bool>(false);
  ValueNotifier<bool> radiobuttonPiscarOpticoNotifier =
      ValueNotifier<bool>(false);
  ValueNotifier<bool> radiobuttonBuscaESuccaoNotifier =
      ValueNotifier<bool>(false);
  ValueNotifier<bool> movimentosSimetricosFaciaisNotifier =
      ValueNotifier<bool>(false);
  ValueNotifier<bool> radiobuttonPiscarAcusticoNotifier =
      ValueNotifier<bool>(false);
  ValueNotifier<bool> radiobuttonVomitoNotifier = ValueNotifier<bool>(false);
  ValueNotifier<bool> aperteNarizNotifier = ValueNotifier<bool>(false);
  ValueNotifier<bool> radiobuttonNotifierG = ValueNotifier<bool>(false);
  ValueNotifier<bool> radiobuttonNotifierS = ValueNotifier<bool>(false);
  ValueNotifier<bool> vidaSexualAtivaNotifier = ValueNotifier<bool>(false);
  ValueNotifier<bool> usaMetodoContraceptivoNotifier =
      ValueNotifier<bool>(false);
  ValueNotifier<bool> seMasturbaNotifier = ValueNotifier<bool>(false);
  ValueNotifier<bool> semenarcaNotifier = ValueNotifier<bool>(false);
  ValueNotifier<bool> fluxoMenstrualNotifier = ValueNotifier<bool>(false);
  ValueNotifier<bool> regularidadeMenstrualNotifier =
      ValueNotifier<bool>(false);
  ValueNotifier<bool> dismenorreiaNotifier = ValueNotifier<bool>(false);
  ValueNotifier<bool> usaMedicamentoNotifier = ValueNotifier<bool>(false);
  ValueNotifier<bool> vidaSexualAtivaNotifierW = ValueNotifier<bool>(false);
  ValueNotifier<bool> usaMetodoContraceptivoNotifierW =
      ValueNotifier<bool>(false);
  ValueNotifier<bool> jaFezPreventivoNotifier = ValueNotifier<bool>(false);
  ValueNotifier<bool> seMasturbaNotifierW = ValueNotifier<bool>(false);
  ValueNotifier<bool> genitalia = ValueNotifier<bool>(false);
  ValueNotifier<bool> mamas = ValueNotifier<bool>(false);
  ValueNotifier<bool> pelosPubianos = ValueNotifier<bool>(false);

  ConsultaCadastro? consultaSelecionado;
  late List<ConsultaCadastro> consultasDia;

  @override
  void initState() {
    super.initState();
  }

  void loadConsultas() {
    consultasDia = Provider.of<List<ConsultaCadastro>>(context)
        .where((element) =>
            element.dataHorario.day == DateTime.now().day &&
            element.casaDeApoioId == Provider.of<CasaDeApoio>(context).id)
        .toList();
  }

  /*Future<void> _enviarConsulta() async {
    var consulta = (widget.dadosConsulta??consultaSelecionado);
    if((_formKey.currentState?.validate()??false) && consulta!=null) {
      await ConsultaController().realizarConsulta(consulta.id!, _consultaState.cadastro()).then((value) => {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(value)),
        )
      });
    }
  }*/

  Future<void> _enviarConsulta() async {
    var consulta = widget.dadosConsulta ?? consultaSelecionado;

    // Verifique se consulta é nula
    if (consulta == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nenhuma consulta selecionada")),
      );
      return;
    }

    // Verifique se os campos obrigatórios estão preenchidos
    if (_formKey.currentState?.validate() == false) {
      return; // Não envie a consulta se a validação falhar
    }

    // Continue com o envio da consulta
    await ConsultaController()
        .realizarConsulta(consulta.id!, _consultaState.cadastro())
        .then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(value)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    loadConsultas();
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: widget.dadosConsulta != null
              ? PacienteAppbar(
                  paciente: Provider.of<List<CadastroPaciente>>(context)
                      .where((paciente) =>
                          paciente.paciente.id ==
                          widget.dadosConsulta?.pacienteId)
                      .firstOrNull
                      ?.paciente)
              : consultaSelecionado != null
                  ? PageAppBar(
                      leading: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          ),
                          onPressed: () => setState(() {
                                consultaSelecionado = null;
                              })),
                      titulo: consultaSelecionado?.pacienteNome ?? "",
                      casaDeApoioSelecionada: Provider.of<CasaDeApoio>(context))
                  : PageAppBar(
                      titulo: "Consultar",
                      casaDeApoioSelecionada:
                          Provider.of<CasaDeApoio>(context)),
        ),
        floatingActionButtonLocation:
            widget.dadosConsulta != null || consultaSelecionado != null
                ? FloatingActionButtonLocation.endFloat
                : null,
        floatingActionButton:
            widget.dadosConsulta != null || consultaSelecionado != null
                ? BigRoundButton(
                    text: "Enviar Consulta",
                    icon: Icons.send,
                    onPressed:
                        _enviarConsulta, // Chama a função para enviar a consulta
                  )
                : null,
        body: widget.dadosConsulta != null || consultaSelecionado != null
            ? Center(
                child: Form(
                  key: _formKey,
                  child: Builder(
                    builder: (context) {
                      ConsultaCadastro consulta =
                          (widget.dadosConsulta ?? consultaSelecionado)!;
                      Paciente? paciente =
                          Provider.of<List<CadastroPaciente>>(context)
                              .where((paciente) =>
                                  paciente.paciente.id == consulta.pacienteId)
                              .firstOrNull
                              ?.paciente;
                      if (paciente != null) {
                        String? idadeS = PacientesController.calcularIdade(
                            paciente.dataNasc);
                        final match = RegExp(r'^(\d+)a').firstMatch(idadeS);
                        int idade =
                            match != null ? int.parse(match.group(1)!) : 0;
                        String? sexo = paciente.sexo;

                        List<String> pageTitles = [];
                        List<Widget> pageWidgets = [];
                        if (idade > 12 && sexo == 'Feminino') {
                          pageTitles = [
                            "Informações Básicas",
                            "Consumo Alimentar",
                            "Eliminações",
                            "Higiene",
                            "Sono",
                            "Exame Físico",
                            "Identidade de Genêro",
                            "Estágio de Turner",
                            "Saúde Sexual Reprodutiva",
                            "Avaliação Psicoemocional",
                            "Conclusões",
                            "Casa de Apoio"
                          ];
                          pageWidgets = [
                            InformacoesBasicas(state: _consultaState),
                            MarcosDeConsumoAlimentar(
                                state: _consultaState,
                                refeicoesComTecnologiaNotifier:
                                    refeicoesComTecnologiaNotifier,
                                consumiuFeijaoNotifier: consumiuFeijaoNotifier,
                                consumiuFrutasNotifier: consumiuFrutasNotifier,
                                consumiuVerdurasLegumesNotifier:
                                    consumiuVerdurasLegumesNotifier,
                                consumiuEmbutidosNotifier:
                                    consumiuEmbutidosNotifier,
                                consumiuBebidasAdocicadasNotifier:
                                    consumiuBebidasAdocicadasNotifier,
                                consumiuMacarraoInstantaneoSalgadoNotifier:
                                    consumiuMacarraoInstantaneoSalgadoNotifier,
                                consumiuBiscoitoRecheadoNotifier:
                                    consumiuBiscoitoRecheadoNotifier),
                            Eliminacoes(state: _consultaState),
                            Higiente(state: _consultaState),
                            Sono(state: _consultaState),
                            ExameFisico(
                                state: _consultaState,
                                radiobuttonNotifierEstatura:
                                    radiobuttonNotifierEstatura,
                                radiobuttonNotifierIMC: radiobuttonNotifierIMC),
                            IdentidadeGenero(
                                state: _consultaState,
                                radiobuttonNotifierG: radiobuttonNotifierG,
                                radiobuttonNotifierS: radiobuttonNotifierS),
                            EstagioDeTurnerMeninas(state: _consultaState,mamas: mamas,pelosPubianos: pelosPubianos),
                            SaudeSexualReprodutivaMeninas(
                              state: _consultaState,
                              fluxoMenstrualNotifier: fluxoMenstrualNotifier,
                              regularidadeMenstrualNotifier:
                                  regularidadeMenstrualNotifier,
                              dismenorreiaNotifier: dismenorreiaNotifier,
                              usaMedicamentoNotifier: usaMedicamentoNotifier,
                              vidaSexualAtivaNotifierW:
                                  vidaSexualAtivaNotifierW,
                              usaMetodoContraceptivoNotifierW:
                                  usaMetodoContraceptivoNotifierW,
                              jaFezPreventivoNotifier: jaFezPreventivoNotifier,
                              seMasturbaNotifierW: seMasturbaNotifierW,
                            ),
                            AvaliacaoPsicoemocional(state: _consultaState),
                            ObservacoesFinais(state: _consultaState),
                            ParaCasa(state: _consultaState),
                          ];
                        } else if (idade > 12 && sexo == 'Masculino') {
                          pageTitles = [
                            "Informações Básicas",
                            "Consumo Alimentar",
                            "Eliminações",
                            "Higiene",
                            "Sono",
                            "Exame Físico",
                            "Identidade de Genêro",
                            "Estágio de Turner",
                            "Saúde Sexual Reprodutiva",
                            "Avaliação Psicoemocional",
                            "Conclusões",
                            "Casa de Apoio"
                          ];
                          pageWidgets = [
                            InformacoesBasicas(state: _consultaState),
                            MarcosDeConsumoAlimentar(
                                state: _consultaState,
                                refeicoesComTecnologiaNotifier:
                                    refeicoesComTecnologiaNotifier,
                                consumiuFeijaoNotifier: consumiuFeijaoNotifier,
                                consumiuFrutasNotifier: consumiuFrutasNotifier,
                                consumiuVerdurasLegumesNotifier:
                                    consumiuVerdurasLegumesNotifier,
                                consumiuEmbutidosNotifier:
                                    consumiuEmbutidosNotifier,
                                consumiuBebidasAdocicadasNotifier:
                                    consumiuBebidasAdocicadasNotifier,
                                consumiuMacarraoInstantaneoSalgadoNotifier:
                                    consumiuMacarraoInstantaneoSalgadoNotifier,
                                consumiuBiscoitoRecheadoNotifier:
                                    consumiuBiscoitoRecheadoNotifier),
                            Eliminacoes(state: _consultaState),
                            Higiente(state: _consultaState),
                            Sono(state: _consultaState),
                            ExameFisico(
                                state: _consultaState,
                                radiobuttonNotifierEstatura:
                                    radiobuttonNotifierEstatura,
                                radiobuttonNotifierIMC: radiobuttonNotifierIMC),
                            IdentidadeGenero(
                                state: _consultaState,
                                radiobuttonNotifierG: radiobuttonNotifierG,
                                radiobuttonNotifierS: radiobuttonNotifierS),
                            EstagioDeTurnerMeninos(state: _consultaState,genitalia: genitalia,),
                            SaudeSexualReprodutivaMeninos(
                              state: _consultaState,
                              vidaSexualAtivaNotifier: vidaSexualAtivaNotifier,
                              usaMetodoContraceptivoNotifier:
                                  usaMetodoContraceptivoNotifier,
                              seMasturbaNotifier: seMasturbaNotifier,
                              semenarcaNotifier: semenarcaNotifier,
                            ),
                            AvaliacaoPsicoemocional(state: _consultaState),
                            ObservacoesFinais(state: _consultaState),
                            ParaCasa(state: _consultaState)
                          ];
                        } else {
                          pageTitles = [
                            "Informações Básicas",
                            "Consumo Alimentar",
                            "Eliminações",
                            "Higiene",
                            "Sono",
                            "Exame Físico",
                            "Avaliação Reflexos",
                            "Avaliação Nervos",
                            "Avaliação Psicoemocional",
                            "Conclusões",
                            "Casa de Apoio"
                          ];
                          pageWidgets = [
                            InformacoesBasicas(state: _consultaState),
                            MarcosDeConsumoAlimentar(
                                state: _consultaState,
                                refeicoesComTecnologiaNotifier:
                                    refeicoesComTecnologiaNotifier,
                                consumiuFeijaoNotifier: consumiuFeijaoNotifier,
                                consumiuFrutasNotifier: consumiuFrutasNotifier,
                                consumiuVerdurasLegumesNotifier:
                                    consumiuVerdurasLegumesNotifier,
                                consumiuEmbutidosNotifier:
                                    consumiuEmbutidosNotifier,
                                consumiuBebidasAdocicadasNotifier:
                                    consumiuBebidasAdocicadasNotifier,
                                consumiuMacarraoInstantaneoSalgadoNotifier:
                                    consumiuMacarraoInstantaneoSalgadoNotifier,
                                consumiuBiscoitoRecheadoNotifier:
                                    consumiuBiscoitoRecheadoNotifier),
                            Eliminacoes(state: _consultaState),
                            Higiente(state: _consultaState),
                            Sono(state: _consultaState),
                            ExameFisicoCrianca(
                                state: _consultaState,
                                radiobuttonNotifierEstatura:
                                    radiobuttonNotifierEstatura,
                                radiobuttonNotifierIMC: radiobuttonNotifierIMC),
                            AvaliacaoReflexos(
                              state: _consultaState,
                              reflexoBuscaNotifier: reflexoBuscaNotifier,
                              reflexoSuccaoNotifier: reflexoSuccaoNotifier,
                              reflexoPreensaoPalmarNotifier:
                                  reflexoPreensaoPalmarNotifier,
                              reflexoPreensaoPlantarNotifier:
                                  reflexoPreensaoPlantarNotifier,
                              reflexoBabinskiNotifier: reflexoBabinskiNotifier,
                              reflexoTonicoCervicalNotifier:
                                  reflexoTonicoCervicalNotifier,
                              reflexoMoroNotifier: reflexoMoroNotifier,
                              reflexoMarchaNotifier: reflexoMarchaNotifier,
                              reflexoPiscarOpticoNotifier:
                                  reflexoPiscarOpticoNotifier,
                            ),
                            AvaliacaoNervos(
                              state: _consultaState,
                              reflexoPiscarOpticoNotifier:
                                  radiobuttonPiscarOpticoNotifier,
                              reflexoBuscaESuccaoNotifier:
                                  radiobuttonBuscaESuccaoNotifier,
                              movimentosSimetricosFaciaisNotifier:
                                  movimentosSimetricosFaciaisNotifier,
                              reflexoPiscarAcusticoNotifier:
                                  radiobuttonPiscarAcusticoNotifier,
                              reflexoVomitoNotifier: radiobuttonVomitoNotifier,
                              aperteNarizNotifier: aperteNarizNotifier,
                            ),
                            AvaliacaoPsicoemocional(state: _consultaState),
                            ObservacoesFinais(state: _consultaState),
                            ParaCasa(state: _consultaState)
                          ];
                        }
                        return ExibirConsulta(
                          pageTitles: pageTitles,
                          pageWidgets: pageWidgets,
                        );
                      } else {
                        return const LoadingLogo();
                      }
                    },
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(bottom: 60, left: 30, right: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Selecione uma consulta:",
                      style: TextStyle(
                          fontSize: 20,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold),
                    ),
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 20),
                        decoration: BoxDecoration(
                            color: Colors.amber[100],
                            borderRadius: BorderRadius.circular(15)),
                        child: ListaHorario(
                          consultasDoDia: consultasDia,
                          onSelect: (p) => setState(() {
                            if(p.estado!="concluida") {
                              consultaSelecionado = p;
                            }
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ));
  }
}

class AvaliacaoPsicoemocional extends StatelessWidget {
  final ConsultaState state;
  const AvaliacaoPsicoemocional({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 100.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputCaixaDeTexto(
            label: "Como está se sentindo hoje? Por que?",
            controller: state.comoSeSenteHoje,
            isCadastro: true,
          ),
          const SizedBox(height: 10.0),
          InputCaixaDeTexto(
            label: "Observações psicoemocionais",
            controller: state.observacoesPsicoemocionais,
            isCadastro: true,
          ),
        ],
      ),
    );
  }
}

class ObservacoesFinais extends StatelessWidget {
  final ConsultaState state;
  const ObservacoesFinais({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 100.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
              label: "Marcos presentes:",
              controller: state.marcosPresentes,
              emptyMessage: "Informe os marcos presentes",
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
              label: "Marcos ausentes:",
              controller: state.marcosAusentes,
              emptyMessage: "Informe os marcos ausentes",
            ),
          ),
          InputCaixaDeTexto(
            label: "Observações do desenvolvimento",
            controller: state.observacoesDesenvolvimento,
            isCadastro: true,
          ),
          const SizedBox(height: 10.0),
          InputCaixaDeTexto(
            label: "Análise geral",
            controller: state.analiseGeral,
            isCadastro: true,
          ),
          const SizedBox(height: 10.0),
          InputCaixaDeTexto(
            label: "Avaliações",
            controller: state.avaliacoes,
            isCadastro: true,
          ),
          const SizedBox(height: 10.0),
          InputCaixaDeTexto(
            label: "Intervenções",
            controller: state.intervencoes,
            isCadastro: true,
          ),
        ],
      ),
    );
  }
}

class InformacoesBasicas extends StatelessWidget {
  final ConsultaState state;
  const InformacoesBasicas({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 100.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
              label: "Cuidador Principal",
              controller: state.cuidadorPrincipal,
              emptyMessage: "Informe o cuidador princial",
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
              label: "Queixa Principal",
              controller: state.queixaPrincipal,
              emptyMessage: "Informe a queixa principal",
            ),
          ),
          InputCaixaDeTexto(
            label: "Descrição",
            controller: state.descricao,
            isCadastro: true,
          ),
          const SizedBox(height: 10.0),
          InputCaixaDeTexto(
            label: "Observações",
            controller: state.observacoesPaciente,
            isCadastro: true,
          ),
        ],
      ),
    );
  }
}

class MarcosDeConsumoAlimentar extends StatelessWidget {
  final ConsultaState state;

  // Notifiers específicos para cada RadioButton
  final ValueNotifier<bool> refeicoesComTecnologiaNotifier;
  final ValueNotifier<bool> consumiuFeijaoNotifier;
  final ValueNotifier<bool> consumiuFrutasNotifier;
  final ValueNotifier<bool> consumiuVerdurasLegumesNotifier;
  final ValueNotifier<bool> consumiuEmbutidosNotifier;
  final ValueNotifier<bool> consumiuBebidasAdocicadasNotifier;
  final ValueNotifier<bool> consumiuMacarraoInstantaneoSalgadoNotifier;
  final ValueNotifier<bool> consumiuBiscoitoRecheadoNotifier;

  const MarcosDeConsumoAlimentar({
    super.key,
    required this.state,
    required this.refeicoesComTecnologiaNotifier,
    required this.consumiuFeijaoNotifier,
    required this.consumiuFrutasNotifier,
    required this.consumiuVerdurasLegumesNotifier,
    required this.consumiuEmbutidosNotifier,
    required this.consumiuBebidasAdocicadasNotifier,
    required this.consumiuMacarraoInstantaneoSalgadoNotifier,
    required this.consumiuBiscoitoRecheadoNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 100.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputRadioButtonsConsulta(
            options: const ["Sim ", "Não", "Não sabe"],
            label:
                "Você tem costume de realizar as refeições assistindo à TV, mexendo no computador e/ou celular?",
            controller: state.refeicoesComTecnologia,
            isChecked: refeicoesComTecnologiaNotifier,
          ),
          RefeicoesCheckbox(
            refeicoesController: state.refeicoesDuranteODia,
          ),
          const Text("Ontem você consumiu?"),
          InputRadioButtonsConsulta(
            options: const ["Sim", "Não", "Não sabe"],
            label: "Feijão",
            controller: state.consumiuFeijao,
            isChecked: consumiuFeijaoNotifier,
          ),
          InputRadioButtonsConsulta(
            options: const ["Sim", "Não", "Não sabe"],
            label: "Frutas frescas (não considerar suco de frutas)",
            controller: state.consumiuFrutas,
            isChecked: consumiuFrutasNotifier,
          ),
          InputRadioButtonsConsulta(
            options: const ["Sim", "Não", "Não sabe"],
            label:
                "Verduras e/ou legumes (não considerar batata, mandioca, aipim, macaxeira, cará e inhame)",
            controller: state.consumiuVerdurasLegumes,
            isChecked: consumiuVerdurasLegumesNotifier,
          ),
          InputRadioButtonsConsulta(
            options: const ["Sim", "Não", "Não sabe"],
            label:
                "Hambúrguer e/ou embutidos (presunto, mortadela, salame, linguiça, salsicha)",
            controller: state.consumiuEmbutidos,
            isChecked: consumiuEmbutidosNotifier,
          ),
          InputRadioButtonsConsulta(
            options: const ["Sim", "Não", "Não sabe"],
            label:
                "Bebidas adoçadas (refrigerante, suco de caixinha, suco em pó, água de coco de caixinha, xaropes de guaraná/groselha, suco de fruta com adição de açúcar)",
            controller: state.consumiuBebidasAdocicadas,
            isChecked: consumiuBebidasAdocicadasNotifier,
          ),
          InputRadioButtonsConsulta(
            options: const ["Sim", "Não", "Não sabe"],
            label:
                "Macarrão instantâneo, salgadinhos de pacote ou biscoitos salgados",
            controller: state.consumiuMacarraoInstantaneoSalgado,
            isChecked: consumiuMacarraoInstantaneoSalgadoNotifier,
          ),
          InputRadioButtonsConsulta(
            options: const ["Sim", "Não", "Não sabe"],
            label:
                "Biscoito recheado, doces ou guloseimas (balas, pirulitos, chiclete, caramelo, gelatina)",
            controller: state.consumiuBiscoitoRecheado,
            isChecked: consumiuBiscoitoRecheadoNotifier,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
              label: "Ingesta Hídrica (quantidade)",
              controller: state.ingestaoHidrica,
              emptyMessage: "Informe a ingestão hídrica",
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
              label: "Suplementação de Ferro e/ou vitaminas",
              controller: state.suplementacao,
              emptyMessage: "Informe a suplementação",
            ),
          ),
        ],
      ),
    );
  }
}

class Eliminacoes extends StatelessWidget {
  final ConsultaState state;
  const Eliminacoes({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 100.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'src/images/Diurese.jpg',
            height: 300, // Ajuste o tamanho conforme necessário
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
                label: "Diurese: coloração, odor/dor, frequência",
                controller: state.diurese,
                emptyMessage: "Informe a diurese"),
          ),
          Image.asset(
            'src/images/Evacuação.jpg',
            height: 300, // Ajuste o tamanho conforme necessário
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
                label: "Evacuações: aspecto, coloração, dor, frequência",
                controller: state.evacuacoes,
                emptyMessage: "Informe a evacuação"),
          ),
        ],
      ),
    );
  }
}

class Higiente extends StatelessWidget {
  final ConsultaState state;

  const Higiente({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 100.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
                label: "Itens utilizados para higiene ( banho e escovação)",
                controller: state.itensHigiene,
                emptyMessage: "Informe os itens de higiene"),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
                label: "Higiene corporal  (sequência, frequência)",
                controller: state.higieneCorporal,
                emptyMessage: "Informe a higiene corporal"),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
                label:
                    "Higiene Bucal (verificar presença de cáries, frequência escovação, uso correto do fio dental)",
                controller: state.higieneBucal,
                emptyMessage: "Informe a higiene bucal"),
          ),
        ],
      ),
    );
  }
}

class Sono extends StatelessWidget {
  final ConsultaState state;
  const Sono({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 100.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputCaixaDeTexto(
            label:
                "Precisa de ajuda para dormir?,  compartilha quarto para dormir? Qual sua relação com quem compartilha o quarto?",
            controller: state.sono,
            isCadastro: true,
          )
        ],
      ),
    );
  }
}

class ExameFisico extends StatelessWidget {
  final ConsultaState state;
  final ValueNotifier<bool> radiobuttonNotifierEstatura;
  final ValueNotifier<bool> radiobuttonNotifierIMC;

  const ExameFisico({
    super.key,
    required this.state,
    required this.radiobuttonNotifierEstatura,
    required this.radiobuttonNotifierIMC,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 100.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: InputTextoAcolher(
                      label: "Comprimento",
                      placeHolder: "cm",
                      controller: state.comprimento,
                      emptyMessage: "Informe o comprimento"),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: InputTextoAcolher(
                      label: "Peso",
                      placeHolder: "kg",
                      controller: state.peso,
                      emptyMessage: "Informe o peso"),
                ),
              ],
            ),
          ),
          //EstaturaForm(),
          InputRadioButtonsConsulta(
              options: const ["Adequado", "Baixa estatura pra idade"],
              label: "Estatura X Idade",
              controller: state.comprimentoPorIdade,
              isChecked: radiobuttonNotifierEstatura),
          InputRadioButtonsConsulta(
              options: const [
                "Obsidade",
                "Sobrepeso",
                "Eutrofia",
                "Magreza",
                "Magreza Acentuada"
              ],
              label: "IMC X Idade",
              controller: state.imcPorIdade,
              isChecked: radiobuttonNotifierIMC),
          const SizedBox(height: 20), // Espaço entre os grupos
          //ImcForm(),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
                label: "FC:",
                controller: state.frequenciaCardiaca,
                emptyMessage: "Informe a FC"),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
                label: "Saturação:",
                controller: state.saturacao,
                emptyMessage: "Informe a saturação"),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
                label: "Ausculta Cardíaca:",
                controller: state.auscultaCardiaca,
                emptyMessage: "Informe a ausculta cardíaca"),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
                label: "Ausculta Pulmonar:",
                controller: state.auscultaPulmonar,
                emptyMessage: "Informe a ausculta pulmonar"),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
                label: "PA:",
                controller: state.pressaoArterial,
                emptyMessage: "Informe a PA"),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
                label: "Temperatura:",
                controller: state.temperatura,
                emptyMessage: "Informe a temperatura"),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
                label: "Otoscopia:",
                controller: state.otoscopia,
                emptyMessage: "Informe a otoscopia"),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
                label: "Orofaringe:",
                controller: state.orofaringe,
                emptyMessage: "Informe a orofaringe"),
          ),
          InputCaixaDeTexto(
            label:
                "Avaliação Musculoesquelético (Postura, Desalinhamentos, Condição muscular, Tipo de andado)",
            controller: state.avaliacaoMuscoesqueletica,
            isCadastro: true,
          ),
          const SizedBox(height: 10.0),
          InputCaixaDeTexto(
            label:
                "Avaliação da Pele (eritemas, palidez, manchas, alterações hormonais, umidade, turgor)",
            controller: state.avaliacaoPele,
            isCadastro: true,
          ),
        ],
      ),
    );
  }
}

class ExameFisicoCrianca extends StatelessWidget {
  final ConsultaState state;
  final ValueNotifier<bool> radiobuttonNotifierEstatura;
  final ValueNotifier<bool> radiobuttonNotifierIMC;

  const ExameFisicoCrianca({
    super.key,
    required this.state,
    required this.radiobuttonNotifierEstatura,
    required this.radiobuttonNotifierIMC,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 100.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: InputTextoAcolher(
                      label: "Comprimento",
                      placeHolder: "cm",
                      controller: state.comprimento,
                      emptyMessage: "Informe o comprimento"),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: InputTextoAcolher(
                      label: "Peso",
                      placeHolder: "kg",
                      controller: state.peso,
                      emptyMessage: "Informe o peso"),
                ),
              ],
            ),
          ),
          //EstaturaForm(),
          InputRadioButtonsConsulta(
              options: const ["Adequado", "Baixa estatura pra idade"],
              label: "Estatura X Idade",
              controller: state.comprimentoPorIdade,
              isChecked: radiobuttonNotifierEstatura),
          InputRadioButtonsConsulta(
              options: const [
                "Obsidade",
                "Sobrepeso",
                "Eutrofia",
                "Magreza",
                "Magreza Acentuada"
              ],
              label: "IMC X Idade",
              controller: state.imcPorIdade,
              isChecked: radiobuttonNotifierIMC),
          const SizedBox(height: 20), // Espaço entre os grupos
          //ImcForm(),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
                label: "FC:",
                controller: state.frequenciaCardiaca,
                emptyMessage: "Informe a FC"),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
                label: "Saturação:",
                controller: state.saturacao,
                emptyMessage: "Informe a saturação"),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
                label: "Ausculta Cardíaca:",
                controller: state.auscultaCardiaca,
                emptyMessage: "Informe a ausculta cardíaca"),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
                label: "Ausculta Pulmonar:",
                controller: state.auscultaPulmonar,
                emptyMessage: "Informe a ausculta pulmonar"),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
                label: "PA:",
                controller: state.pressaoArterial,
                emptyMessage: "Informe a PA"),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
                label: "Temperatura:",
                controller: state.temperatura,
                emptyMessage: "Informe a temperatura"),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
                label: "Otoscopia:",
                controller: state.otoscopia,
                emptyMessage: "Informe a otoscopia"),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
                label: "Orofaringe:",
                controller: state.orofaringe,
                emptyMessage: "Informe a orofaringe"),
          ),
          InputCaixaDeTexto(
            label:
                "Avaliação Musculoesquelético (Postura, Desalinhamentos, Condição muscular, Tipo de andado)",
            controller: state.avaliacaoMuscoesqueletica,
            isCadastro: true,
          ),
          const SizedBox(height: 10.0),
          InputCaixaDeTexto(
            label:
                "Avaliação da Pele (eritemas, palidez, manchas, alterações hormonais, umidade, turgor)",
            controller: state.avaliacaoPele,
            isCadastro: true,
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
                label: "Fontanelas:",
                controller: state.fontanelas,
                validation: (value) => Mask.validations
                    .generic(value, error: " ", min: 0)),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
              label: "Coto umbilical:",
              controller: state.cotoUmbilical,
              validation: (value) => Mask.validations
                  .generic(value, error: " ", min: 0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
                label: "Genitalia:",
                controller: state.genitalia,
                emptyMessage: "Informe a genitalia"),
          ),
          /*Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: InputTextoAcolher(
                        label: "Bregmatica:",
                        controller: state.bregmatica),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: InputTextoAcolher(
                        label: "Lamboide:",
                        controller: state.lambdoide),
                  ),*/
          InputCaixaBregmatica(
            label: "Bregmática:",
            controller: state.bregmatica,
            isCadastro: true,
            optionalController:
                state.bregmaticaCalcificada, // Passando o optionalController
          ),
          InputCaixaLambdoide(
            label: "Lambdoide:",
            controller: state.lambdoide,
            isCadastro: true,
            optionalController:
                state.lambdoideCalcificada, // Passando o optionalController
          ),
        ],
      ),
    );
  }
}

class AvaliacaoReflexos extends StatelessWidget {
  final ConsultaState state;

  // Notifiers específicos para cada RadioButton
  final ValueNotifier<bool> reflexoBuscaNotifier;
  final ValueNotifier<bool> reflexoSuccaoNotifier;
  final ValueNotifier<bool> reflexoPreensaoPalmarNotifier;
  final ValueNotifier<bool> reflexoPreensaoPlantarNotifier;
  final ValueNotifier<bool> reflexoBabinskiNotifier;
  final ValueNotifier<bool> reflexoTonicoCervicalNotifier;
  final ValueNotifier<bool> reflexoMoroNotifier;
  final ValueNotifier<bool> reflexoMarchaNotifier;
  final ValueNotifier<bool> reflexoPiscarOpticoNotifier;

  const AvaliacaoReflexos({
    super.key,
    required this.state,
    required this.reflexoBuscaNotifier,
    required this.reflexoSuccaoNotifier,
    required this.reflexoPreensaoPalmarNotifier,
    required this.reflexoPreensaoPlantarNotifier,
    required this.reflexoBabinskiNotifier,
    required this.reflexoTonicoCervicalNotifier,
    required this.reflexoMoroNotifier,
    required this.reflexoMarchaNotifier,
    required this.reflexoPiscarOpticoNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 100.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputRadioButtonsConsulta(
            options: const ["P", "A", "N/V"],
            label: "Reflexo de busca (do nascimento aos 3-4 meses)",
            controller: state.reflexoBusca,
            isChecked: reflexoBuscaNotifier,
          ),
          InputRadioButtonsConsulta(
            options: const ["P", "A", "N/V"],
            label: "Reflexo de sucção (do nascimento aos 10-12 meses)",
            controller: state.reflexoSuccao,
            isChecked: reflexoSuccaoNotifier,
          ),
          InputRadioButtonsConsulta(
            options: const ["P", "A", "N/V"],
            label: "Reflexo de preensão palmar (do nascimento aos 3-4 meses)",
            controller: state.reflexoPreensaoPalmar,
            isChecked: reflexoPreensaoPalmarNotifier,
          ),
          InputRadioButtonsConsulta(
            options: const ["P", "A", "N/V"],
            label: "Reflexo de preensão plantar (do nascimento aos 8-10 meses)",
            controller: state.reflexoPreensaoPlantar,
            isChecked: reflexoPreensaoPlantarNotifier,
          ),
          InputRadioButtonsConsulta(
            options: const ["P", "A", "N/V"],
            label: "Reflexo de babinski (do nascimento aos 24 meses)",
            controller: state.reflexoBabinski,
            isChecked: reflexoBabinskiNotifier,
          ),
          InputRadioButtonsConsulta(
            options: const ["P", "A", "N/V"],
            label: "Reflexo de tônico-cervical (dos 2-3 meses aos 4-6 meses)",
            controller: state.reflexoTonicoCervical,
            isChecked: reflexoTonicoCervicalNotifier,
          ),
          InputRadioButtonsConsulta(
            options: const ["P", "A", "N/V"],
            label: "Reflexo de Moro (do nascimento aos 4-6 meses)",
            controller: state.reflexoMoro,
            isChecked: reflexoMoroNotifier,
          ),
          InputRadioButtonsConsulta(
            options: const ["P", "A", "N/V"],
            label: "Reflexo de Marcha (até o andar voluntário)",
            controller: state.reflexoMarcha,
            isChecked: reflexoMarchaNotifier,
          ),
          InputRadioButtonsConsulta(
            options: const ["P", "A", "N/V"],
            label: "Reflexo do piscar óptico",
            controller: state.reflexoPiscarOptico,
            isChecked: reflexoPiscarOpticoNotifier,
          ),
        ],
      ),
    );
  }
}

class AvaliacaoNervos extends StatelessWidget {
  final ConsultaState state;

  // Notifiers específicos para cada RadioButton
  final ValueNotifier<bool> reflexoPiscarOpticoNotifier;
  final ValueNotifier<bool> reflexoBuscaESuccaoNotifier;
  final ValueNotifier<bool> movimentosSimetricosFaciaisNotifier;
  final ValueNotifier<bool> reflexoPiscarAcusticoNotifier;
  final ValueNotifier<bool> reflexoVomitoNotifier;
  final ValueNotifier<bool> aperteNarizNotifier;

  const AvaliacaoNervos({
    super.key,
    required this.state,
    required this.reflexoPiscarOpticoNotifier,
    required this.reflexoBuscaESuccaoNotifier,
    required this.movimentosSimetricosFaciaisNotifier,
    required this.reflexoPiscarAcusticoNotifier,
    required this.reflexoVomitoNotifier,
    required this.aperteNarizNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 100.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputRadioButtonsConsulta(
            options: const ["P", "A", "N/V"],
            label: "Reflexo do piscar óptico",
            controller: state.reflexoPiscarOptico,
            isChecked: reflexoPiscarOpticoNotifier,
          ),
          InputRadioButtonsConsulta(
            options: const ["P", "A", "N/V"],
            label: "Reflexo de busca e sucção",
            controller: state.reflexoBuscaESuccao,
            isChecked: reflexoBuscaESuccaoNotifier,
          ),
          InputRadioButtonsConsulta(
            options: const ["P", "A", "N/V"],
            label: "Movimentos Simétricos Faciais",
            controller: state.movimentosSimetricosFaciais,
            isChecked: movimentosSimetricosFaciaisNotifier,
          ),
          InputRadioButtonsConsulta(
            options: const ["P", "A", "N/V"],
            label: "Reflexo piscar acústico",
            controller: state.reflexoPiscarAcustico,
            isChecked: reflexoPiscarAcusticoNotifier,
          ),
          InputRadioButtonsConsulta(
            options: const ["P", "A", "N/V"],
            label: "Reflexo de vômito",
            controller: state.reflexoVomito,
            isChecked: reflexoVomitoNotifier,
          ),
          InputRadioButtonsConsulta(
            options: const ["P", "A", "N/V"],
            label:
                "Aperte o nariz, a boca abre-se e a língua eleva-se na linha média",
            controller: state.aperteNariz,
            isChecked: aperteNarizNotifier,
          ),
        ],
      ),
    );
  }
}

class IdentidadeGenero extends StatelessWidget {
  final ConsultaState state;
  final ValueNotifier<bool> radiobuttonNotifierG;
  final ValueNotifier<bool> radiobuttonNotifierS;

  const IdentidadeGenero({
    super.key,
    required this.state,
    required this.radiobuttonNotifierG,
    required this.radiobuttonNotifierS,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 100.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputRadioButtonsConsulta(
              options: const [
                "Transgênero",
                "Cisgênero",
                "Agênero",
                "Bigênero"
              ],
              label: "Identidade de gênero",
              controller: state.identidadeGenero,
              isChecked: radiobuttonNotifierG),
          InputRadioButtonsConsulta(
              options: const ["Heterossexual", "Homossexual", "Bissexual"],
              label: "Sexualidade",
              controller: state.sexualidade,
              isChecked: radiobuttonNotifierS),
        ],
      ),
    );
  }
}

class EstagioDeTurnerMeninas extends StatelessWidget {
  final ConsultaState state;
  final ValueNotifier<bool> pelosPubianos;
  final ValueNotifier<bool> mamas;
  const EstagioDeTurnerMeninas(
      {super.key,
      required this.state,
      required this.mamas,
      required this.pelosPubianos});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 100.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'src/images/EstagioTurnerMeninasSuperior.jpg',
            height: 500, // Ajuste o tamanho conforme necessário
          ),
          InputRadioButtonsConsulta(
            options: const ["M1", "M2", "M3", "M4", "M5"],
            label: "ESTÁGIOS DE TURNER MAMAS",
            controller: state.estagioTurnerMeninasMamas,
            isChecked: mamas,
          ),
          const SizedBox(height: 10.0),
          Image.asset(
            'src/images/EstagioTurnerMeninasInferior.jpg',
            height: 500, // Ajuste o tamanho conforme necessário
          ),
          InputRadioButtonsConsulta(
            options: const ["P1", "P2", "P3", "P4", "P5"],
            label: "ESTÁGIOS DE TURNER PELOS PUBIANOS",
            controller: state.estagioTurnerMeninasPelosPubianos,
            isChecked: pelosPubianos,
          ),
        ],
      ),
    );
  }
}

class SaudeSexualReprodutivaMeninas extends StatelessWidget {
  final ConsultaState state;

  // Notifiers específicos para cada RadioButton
  final ValueNotifier<bool> fluxoMenstrualNotifier;
  final ValueNotifier<bool> regularidadeMenstrualNotifier;
  final ValueNotifier<bool> dismenorreiaNotifier;
  final ValueNotifier<bool> usaMedicamentoNotifier;
  final ValueNotifier<bool> vidaSexualAtivaNotifierW;
  final ValueNotifier<bool> usaMetodoContraceptivoNotifierW;
  final ValueNotifier<bool> jaFezPreventivoNotifier;
  final ValueNotifier<bool> seMasturbaNotifierW;

  final _controllerRadio = TextEditingController();

  SaudeSexualReprodutivaMeninas({
    super.key,
    required this.state,
    required this.fluxoMenstrualNotifier,
    required this.regularidadeMenstrualNotifier,
    required this.dismenorreiaNotifier,
    required this.usaMedicamentoNotifier,
    required this.vidaSexualAtivaNotifierW,
    required this.usaMetodoContraceptivoNotifierW,
    required this.jaFezPreventivoNotifier,
    required this.seMasturbaNotifierW,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 100.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputTextoAcolher(
            label: "Data da ultima menstruação",
            placeHolder: "    /    /",
            controller: state.dataUltimaMenstruacao,
            keyboardType: TextInputType.datetime,
            icone: Icons.date_range_outlined,
            readOnly: true,
          ),
          InputRadioButtonsConsulta(
            options: const ["Leve", "Moderado", "Intenso"],
            label: "Fluxo menstrual",
            controller: state.fluxoMenstrual,
            isChecked: fluxoMenstrualNotifier,
          ),
          InputRadioButtonsConsulta(
            options: const ["Regular", "Irregular"],
            label: "Regularidade",
            controller: state.regularidadeMenstruacao,
            isChecked: regularidadeMenstrualNotifier,
          ),
          InputRadioButtonsConsulta(
            options: const ["Presente", "Ausente"],
            label: "Dismenorréia",
            controller: state.dimenorreia,
            isChecked: dismenorreiaNotifier,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
              label: "Uso de absorvente (trocas/higienização):",
              controller: state.usoAbsorvente,
              validation: (value) => Mask.validations
                  .generic(value, error: "", min: 0),
            ),
          ),
          InputRadioButtonsConsulta(
            options: const ["Sim", "Não"],
            label: "Usa medicamento",
            controller: _controllerRadio,
            secondController: state.usaMedicamento,
            thirdController: state.qualMedicamento,
            isChecked: usaMedicamentoNotifier,
          ),
          InputRadioButtonsConsulta(
            options: const ["Sim ", "Não"],
            label: "Tem vida sexual ativa",
            controller: state.vidaSexualAtiva,
            isChecked: vidaSexualAtivaNotifierW,
          ),
          InputRadioButtonsConsulta(
            options: const ["Sim", "Não"],
            label: "Usa algum método contraceptivo",
            controller: _controllerRadio,
            secondController: state.usaMetodoContraceptivo,
            thirdController: state.qualMetodoContraceptivo,
            isChecked: usaMetodoContraceptivoNotifierW,
          ),
          InputRadioButtonsConsulta(
            options: const ["Sim", "Não"],
            label: "Já fez preventivo",
            controller: _controllerRadio,
            secondController: state.jaFezPreventivo,
            thirdController: state.quandoFezPreventivo,
            isChecked: jaFezPreventivoNotifier,
          ),
          InputRadioButtonsConsulta(
            options: const ["Sim", "Não"],
            label: "Você se masturba",
            controller: _controllerRadio,
            secondController: state.seMasturba,
            thirdController: state.frequenciaMasturbacao,
            isChecked: seMasturbaNotifierW,
          ),
          InputCaixaDeTexto(
            label: "Observações",
            controller: state.observacoesSaudeSexualEReprodutivaMeninas,
            isCadastro: true,
          ),
        ],
      ),
    );
  }
}

class EstagioDeTurnerMeninos extends StatelessWidget {
  final ConsultaState state;
  final ValueNotifier<bool> genitalia;

  const EstagioDeTurnerMeninos(
      {super.key, required this.state, required this.genitalia});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 100.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'src/images/EstagioTurnerMeninos.jpg',
            height: 150, // Ajuste o tamanho conforme necessário
          ),
          InputRadioButtonsConsulta(
            options: const ["G1", "G2", "G3", "G4", "G5"],
            label: "ESTÁGIOS DE TURNER GENITALIA",
            controller: state.estagioTurnerMeninosGenitalia,
            isChecked: genitalia,
          ),
          const SizedBox(height: 10.0),
          InputCaixaDeTexto(
            label: "ESTÁGIOS DE TURNER PELOS PUBIANOS",
            controller: state.estagioTurnerMeninosPelosPubianos,
            isCadastro: true,
          ),
        ],
      ),
    );
  }
}

class SaudeSexualReprodutivaMeninos extends StatelessWidget {
  final ConsultaState state;

  // Notifiers específicos para cada RadioButton
  final ValueNotifier<bool> vidaSexualAtivaNotifier;
  final ValueNotifier<bool> usaMetodoContraceptivoNotifier;
  final ValueNotifier<bool> seMasturbaNotifier;
  final ValueNotifier<bool> semenarcaNotifier;

  final _controllerRadio = TextEditingController();

  SaudeSexualReprodutivaMeninos({
    super.key,
    required this.state,
    required this.vidaSexualAtivaNotifier,
    required this.usaMetodoContraceptivoNotifier,
    required this.seMasturbaNotifier,
    required this.semenarcaNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 100.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputRadioButtonsConsulta(
            options: const ["Sim ", "Não"],
            label: "Tem vida sexual ativa",
            controller: state.vidaSexualAtiva,
            isChecked: vidaSexualAtivaNotifier,
          ),
          InputRadioButtonsConsulta(
            options: const ["Sim", "Não"],
            label: "Usa algum método contraceptivo",
            controller: _controllerRadio,
            secondController: state.usaMetodoContraceptivo,
            thirdController: state.qualMetodoContraceptivo,
            isChecked: usaMetodoContraceptivoNotifier,
          ),
          InputRadioButtonsConsulta(
            options: const ["Sim", "Não"],
            label: "Você se masturba",
            controller: _controllerRadio,
            secondController: state.seMasturba,
            thirdController: state.frequenciaMasturbacao,
            isChecked: seMasturbaNotifier,
          ),
          InputCaixaDeTexto(
            label: "Observações",
            controller: state.observacoesSaudeSexualEReprodutivaMeninas,
            isCadastro: true,
          ),
          const SizedBox(height: 10.0),
          InputRadioButtonsConsulta(
            options: const ["Sim", "Não"],
            label: "Semanarca",
            controller: _controllerRadio,
            secondController: state.semenarca,
            thirdController: state.quandoSemenarca,
            isChecked: semenarcaNotifier,
          ),
        ],
      ),
    );
  }
}

class ParaCasa extends StatelessWidget {
  final ConsultaState state;
  const ParaCasa({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 100.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputCaixaDeTexto(
            label: "Análise Geral",
            controller: state.analiseGeralCasa,
            isCadastro: true,
          ),
          const SizedBox(height: 10.0),
          InputCaixaDeTexto(
            label: "Exame Físico",
            controller: state.exameFisicoCasa,
            isCadastro: true,
          ),
          const SizedBox(height: 10.0),
          InputCaixaDeTexto(
            label: "Avaliações",
            controller: state.avaliacoesCasa,
            isCadastro: true,
          ),
          const SizedBox(height: 10.0),
          InputCaixaDeTexto(
            label: "Orientação para o cuidador",
            controller: state.oriParaCuidador,
            isCadastro: true,
          ),
          const SizedBox(height: 10.0),
          InputCaixaDeTexto(
            label: "Orientação para criança ou adolescente",
            controller: state.oriParaPaciente,
            isCadastro: true,
          ),
          const SizedBox(height: 10.0),
          InputCaixaDeTexto(
            label: "Orientação para coordenação da casa",
            controller: state.oriParaCoordenacao,
            isCadastro: true,
          )
        ],
      ),
    );
  }
}

class InputCaixaLambdoide extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isCadastro;
  final TextEditingController?
      optionalController; // Adicionando o optionalController

  const InputCaixaLambdoide({
    super.key,
    required this.label,
    required this.controller,
    required this.isCadastro,
    this.optionalController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              hintText: "______ cm",
              border: const OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          if (optionalController != null)
            Row(
              children: [
                Checkbox(
                  value: optionalController!.text.isNotEmpty,
                  onChanged: (bool? value) {
                    optionalController!.text =
                        value == true ? "Calcificada" : "";
                  },
                ),
                const Text("Calcificada"),
              ],
            ),
        ],
      ),
    );
  }
}

class RefeicoesCheckbox extends StatefulWidget {
  final TextEditingController refeicoesController;

  // Construtor que recebe o controller como argumento
  const RefeicoesCheckbox({super.key, required this.refeicoesController});

  @override
  State<RefeicoesCheckbox> createState() => _RefeicoesCheckboxState();
}

class _RefeicoesCheckboxState extends State<RefeicoesCheckbox> {
  // Lista de refeições
  final List<String> refeicoes = [
    "Café da manhã",
    "Lanche da manhã",
    "Almoço",
    "Lanche da tarde",
    "Jantar",
    "Ceia"
  ];

  // Lista para armazenar o estado dos checkboxes
  List<bool> selectedRefeicoes = List.generate(6, (index) => false);

  // Função para atualizar o TextEditingController com as refeições selecionadas
  void _updateRefeicoesDuranteODia() {
    List<String> refeicoesSelecionadas = [];
    for (int i = 0; i < refeicoes.length; i++) {
      if (selectedRefeicoes[i]) {
        refeicoesSelecionadas.add(refeicoes[i]);
      }
    }
    // Atualize o TextEditingController passado pelo construtor
    widget.refeicoesController.text = refeicoesSelecionadas.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Quais refeições você faz ao longo do dia?",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ...List.generate(refeicoes.length, (index) {
          return CheckboxListTile(
            title: Text(refeicoes[index]),
            value: selectedRefeicoes[index],
            onChanged: (bool? value) {
              setState(() {
                selectedRefeicoes[index] = value!;
                _updateRefeicoesDuranteODia();
              });
            },
          );
        }),
      ],
    );
  }
}

class EstaturaForm extends StatefulWidget {
  const EstaturaForm({super.key});

  @override
  State<EstaturaForm> createState() => _EstaturaFormState();
}

class _EstaturaFormState extends State<EstaturaForm> {
  String? estaturaValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Estatura X Idade:"),
        Row(
          children: [
            Radio<String>(
              value: "Adequado",
              groupValue: estaturaValue,
              onChanged: (value) {
                setState(() {
                  estaturaValue = value;
                });
              },
            ),
            const Text("Adequado"),
          ],
        ),
        Row(
          children: [
            Radio<String>(
              value: "Baixa estatura para a idade",
              groupValue: estaturaValue,
              onChanged: (value) {
                setState(() {
                  estaturaValue = value;
                });
              },
            ),
            const Text("Baixa estatura para a idade"),
          ],
        ),
        Row(
          children: [
            Radio<String>(
              value: "Baixa estatura para idade",
              groupValue: estaturaValue,
              onChanged: (value) {
                setState(() {
                  estaturaValue = value;
                });
              },
            ),
            const Text("Baixa estatura para idade"),
          ],
        ),
      ],
    );
  }
}

class ImcForm extends StatefulWidget {
  const ImcForm({super.key});

  @override
  State<ImcForm> createState() => _ImcFormState();
}

class _ImcFormState extends State<ImcForm> {
  String? imcValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("IMC X Idade:"),
        Row(
          children: [
            Radio<String>(
              value: "Obesidade",
              groupValue: imcValue,
              onChanged: (value) {
                setState(() {
                  imcValue = value;
                });
              },
            ),
            const Text("Obesidade"),
          ],
        ),
        Row(
          children: [
            Radio<String>(
              value: "Sobrepeso",
              groupValue: imcValue,
              onChanged: (value) {
                setState(() {
                  imcValue = value;
                });
              },
            ),
            const Text("Sobrepeso"),
          ],
        ),
        Row(
          children: [
            Radio<String>(
              value: "Eutrofia",
              groupValue: imcValue,
              onChanged: (value) {
                setState(() {
                  imcValue = value;
                });
              },
            ),
            const Text("Eutrofia"),
          ],
        ),
        Row(
          children: [
            Radio<String>(
              value: "Magreza",
              groupValue: imcValue,
              onChanged: (value) {
                setState(() {
                  imcValue = value;
                });
              },
            ),
            const Text("Magreza"),
          ],
        ),
        Row(
          children: [
            Radio<String>(
              value: "Magreza Acentuada",
              groupValue: imcValue,
              onChanged: (value) {
                setState(() {
                  imcValue = value;
                });
              },
            ),
            const Text("Magreza Acentuada"),
          ],
        ),
      ],
    );
  }
}

class InputCaixaBregmatica extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isCadastro;
  final TextEditingController?
      optionalController; // Adicionando o optionalController

  const InputCaixaBregmatica({
    super.key,
    required this.label,
    required this.controller,
    required this.isCadastro,
    this.optionalController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              hintText: "______ cm",
              border: const OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number, // Para aceitar apenas números
          ),
          if (optionalController !=
              null) // Verifica se optionalController foi passado
            Row(
              children: [
                Checkbox(
                  value: optionalController!.text
                      .isNotEmpty, // Verifica se há texto no optionalController
                  onChanged: (bool? value) {
                    optionalController!.text = value == true
                        ? "Calcificada"
                        : ""; // Atualiza o optionalController
                  },
                ),
                const Text("Calcificada"),
              ],
            ),
        ],
      ),
    );
  }
}

class ExibirConsulta extends StatefulWidget {
  final List<String> pageTitles;
  final List<Widget> pageWidgets;

  const ExibirConsulta(
      {super.key, required this.pageTitles, required this.pageWidgets});

  @override
  State<ExibirConsulta> createState() => _ExibirConsultaState();
}

class _ExibirConsultaState extends State<ExibirConsulta> {
  late PageController _pageController;
  int currentPageIndex = 0;

  List<String> get pageTitles => widget.pageTitles;
  List<Widget> get pageWidgets => widget.pageWidgets;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentPageIndex);
  }

  void _navigateToPage(int index) {
    setState(() {
      currentPageIndex = index;
      _pageController.animateToPage(
        currentPageIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  PreferredSizeWidget? _buildAppBar() {
    int prevIndex = currentPageIndex - 1;
    int nextIndex = currentPageIndex + 1;

    String? prevTitle = prevIndex >= 0 ? pageTitles[prevIndex] : null;
    String currentTitle = pageTitles[currentPageIndex];
    String? nextTitle =
        nextIndex < pageTitles.length ? pageTitles[nextIndex] : null;
    if (nextTitle != null) {
      List<String> parts = nextTitle.split(' ');
      if (parts.length > 2 && parts[1].length == 2) {
        nextTitle =
            '${parts[0]} ${parts[2].length > 3 ? '${parts[2].substring(0, 3)}.' : parts[2]}';
      } else if (parts.length >= 2) {
        nextTitle =
            '${parts[0]} ${parts[1].length > 3 ? '${parts[1].substring(0, 3)}.' : parts[1]}';
      } else if (parts.length > 1) {
        nextTitle = parts[0];
      }
    }
    if (prevTitle != null) {
      List<String> parts = prevTitle.split(' ');
      if (parts.length > 2 && parts[1].length == 2) {
        prevTitle =
            '${parts[0]} ${parts[2].length > 3 ? '${parts[2].substring(0, 3)}.' : parts[2]}';
      } else if (parts.length >= 2) {
        prevTitle =
            '${parts[0]} ${parts[1].length > 3 ? '${parts[1].substring(0, 3)}.' : parts[1]}';
      } else if (parts.length > 1) {
        prevTitle = parts[0];
      }
    }

    return PreferredSize(
      preferredSize: const Size.fromHeight(60.0), // Adjust height as needed
      child: AppBar(
        title: Row(
          children: [
            // Previous Page
            Flexible(
              flex: 1,
              child: prevTitle != null
                  ? GestureDetector(
                      onTap: () => _navigateToPage(prevIndex),
                      child: Center(
                        child: FittedBox(
                          child: Text(
                            prevTitle,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color.fromARGB(179, 0, 0, 0),
                              fontSize: 10,
                            ),
                            softWrap: true,
                          ),
                        ),
                      ),
                    )
                  : Container(), // Empty container when no previous page
            ),
            // Current Page
            Flexible(
              flex: 2,
              child: Center(
                child: FittedBox(
                  child: Text(
                    currentTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    softWrap: true,
                  ),
                ),
              ),
            ),
            // Next Page
            Flexible(
              flex: 1,
              child: nextTitle != null
                  ? GestureDetector(
                      onTap: () => _navigateToPage(nextIndex),
                      child: Center(
                        child: FittedBox(
                          child: Text(
                            nextTitle,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color.fromARGB(179, 0, 0, 0),
                              fontSize: 10,
                            ),
                            softWrap: true,
                          ),
                        ),
                      ),
                    )
                  : Container(), // Empty container when no next page
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ensure that pageTitles and pageWidgets have the same length
    int pageCount = pageTitles.length;
    if (pageWidgets.length < pageCount) {
      pageCount = pageWidgets.length;
    }

    return Scaffold(
      appBar: _buildAppBar(),
      body: PageView.builder(
        controller: _pageController,
        itemCount: pageCount,
        onPageChanged: (index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return pageWidgets[index];
        },
      ),
    );
  }
}
