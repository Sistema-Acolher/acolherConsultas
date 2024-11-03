import 'package:acolherconsultas/modules/casasDeApoio/models/casaDeApoio.dart';
import 'package:acolherconsultas/modules/consultas/models/consulta.dart';
import 'package:acolherconsultas/modules/consultas/state/consultaState.dart';
import 'package:acolherconsultas/modules/pacientes/controllers/pacienteController.dart';
import 'package:acolherconsultas/modules/pacientes/models/paciente.dart';
import 'package:acolherconsultas/modules/pacientes/states/pacienteState.dart';
import 'package:acolherconsultas/modules/pacientes/views/pacienteScreen.dart';
import 'package:acolherconsultas/shared/components/bars/pacienteAppbar.dart';
import 'package:acolherconsultas/shared/components/bars/pageAppBar.dart';
import 'package:acolherconsultas/shared/components/buttons/bigRoundButton.dart';
import 'package:acolherconsultas/shared/components/inputs/inputRadioButtons.dart';
import 'package:acolherconsultas/shared/components/inputs/inputTexto.dart';
import 'package:acolherconsultas/shared/components/list/listaHorarios.dart';
import 'package:acolherconsultas/shared/components/inputs/inputCaixaDeTexto.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConsultarScreen extends StatefulWidget {
  const ConsultarScreen({super.key, this.pacienteConsulta, this.dadosConsulta});

  final Paciente? pacienteConsulta;
  final ConsultaCadastro? dadosConsulta;

  @override
  State<ConsultarScreen> createState() => _ConsultarScreenState();
}

class _ConsultarScreenState extends State<ConsultarScreen> {
  final CadastroPacienteState _cadastroPacienteState = CadastroPacienteState();
  final ConsultaState _consultaState = ConsultaState();
  ValueNotifier<bool> radiobuttonNotifier = ValueNotifier<bool>(false);
  // Usado para selecionar o paciente e trocar o menu que aparece
  Paciente? pacienteSelecionado;
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

  @override
  Widget build(BuildContext context) {
    loadConsultas();

    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            // Caso venha a partir da pagina do paciente, troca a appbar
            child: widget.pacienteConsulta == null
                ? PageAppBar(
                    titulo: "Consultar",
                    casaDeApoioSelecionada: Provider.of<CasaDeApoio>(context))
                : PacienteAppbar(paciente: widget.pacienteConsulta)),
        floatingActionButtonLocation:
            widget.pacienteConsulta != null || pacienteSelecionado != null
                ? FloatingActionButtonLocation.endFloat
                : null,
        floatingActionButton:
            widget.pacienteConsulta != null || pacienteSelecionado != null
                ? BigRoundButton(
                    text: "Historia Pregressa",
                    icon: Icons.history_edu,
                    onPressed: () => Navigator.of(context, rootNavigator: true)
                        .push(MaterialPageRoute(
                            builder: (context) => Scaffold(
                                  appBar: PacienteAppbar(
                                      paciente: widget.pacienteConsulta ??
                                          pacienteSelecionado),
                                  body: HistPregressa(
                                      cadastroPacienteState:
                                          _cadastroPacienteState),
                                ))),
                  )
                : null,
        body: widget.pacienteConsulta != null || pacienteSelecionado != null
            ? Center(
                child: Builder(
                  builder: (context) {
                    Paciente paciente =
                        (widget.pacienteConsulta ?? pacienteSelecionado)!; 

                    String? idadeS = PacientesController.calcularIdade(paciente.dataNasc);
                    int? idade;

                    final match = RegExp(r'^(\d+)a').firstMatch(idadeS);
                    if (match != null) {
                      idade= int.tryParse(match.group(1)!);
                    }
                    String? sexo = paciente.sexo;

                    List<String> pageTitles;
                    List<Widget> pageWidgets;

                    if (idade != null) {
                      if (idade > 12 || sexo == 'Feminino') {
                        pageTitles = [
                          "Informações básicas",
                          "Higiene",
                          "Exame físico",
                          "Saúde sexual reprodutiva - Meninas",
                          "Conclusões"
                        ];
                        pageWidgets = [
                          InformacoesBasicas(state: _consultaState),
                          Higiente(state: _consultaState),
                          ExameFisico(
                              state: _consultaState,
                              radiobuttonNotifier: radiobuttonNotifier),
                          SaudeSexualReprodutivaMeninas(
                              state: _consultaState,
                              radiobuttonNotifier: radiobuttonNotifier),
                          ObservacoesFinais(state: _consultaState),
                        ];
                      } else if (idade > 12 && sexo == 'Masculino') {
                        pageTitles = [
                          "Informações básicas",
                          "Higiene",
                          "Exame físico",
                          "Saúde sexual reprodutiva - Meninos",
                          "Conclusões"
                        ];
                        pageWidgets = [
                          InformacoesBasicas(state: _consultaState),
                          Higiente(state: _consultaState),
                          ExameFisico(
                              state: _consultaState,
                              radiobuttonNotifier: radiobuttonNotifier),
                          SaudeSexualReprodutivaMeninos(
                              state: _consultaState,
                              radiobuttonNotifier: radiobuttonNotifier),
                          ObservacoesFinais(state: _consultaState),
                        ];
                      } else {
                        pageTitles = [
                          "Informações básicas",
                          "Marcados de consumo alimentar",
                          "Eliminações",
                          "Sono",
                          "Exame físico",
                          "Avaliação psicoemocional",
                          "Conclusões"
                        ];
                        pageWidgets = [
                          InformacoesBasicas(state: _consultaState),
                          MarcosDeConsumoAlimentar(
                              state: _consultaState,
                              radiobuttonNotifier: radiobuttonNotifier),
                          Eliminacoes(state: _consultaState),
                          Sono(state: _consultaState),
                          ExameFisico(
                              state: _consultaState,
                              radiobuttonNotifier: radiobuttonNotifier),
                          AvaliacaoPsicoemocional(state: _consultaState),
                          ObservacoesFinais(state: _consultaState),
                        ];
                      }
                    } else {
                      pageTitles = [
                          "Informações básicas",
                          "Conclusões"
                        ];
                        pageWidgets = [
                          InformacoesBasicas(state: _consultaState),
                          ObservacoesFinais(state: _consultaState),
                        ];
                    }
                    return MyHomePage(
                      pageTitles: pageTitles,
                      pageWidgets: pageWidgets,
                    );
                  },
                ),
              )
            : Column(
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
                          pacienteSelecionado = p;
                        }),
                      ),
                    ),
                  ),
                ],
              ));
  }
}

class ObservacoesFinais extends StatelessWidget {
  final ConsultaState state;
  const ObservacoesFinais({required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputCaixaDeTexto(
            label: "Como está se sentindo hoje? Por que?",
            controller: state.comoSeSenteHoje,
            isCadastro: true,
          ),
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

class AvaliacaoPsicoemocional extends StatelessWidget {
  final ConsultaState state;
  const AvaliacaoPsicoemocional({required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
                label: "Marcos presentes:", controller: state.marcosPresentes),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
                label: "Marcos ausentes:", controller: state.marcosAusentes),
          ),
          InputCaixaDeTexto(
            label: "Observações do desenvolvimento",
            controller: state.observacoesDesenvolvimento,
            isCadastro: true,
          ),
          InputCaixaDeTexto(
            label: "Análise geral",
            controller: state.analiseGeral,
            isCadastro: true,
          ),
          InputCaixaDeTexto(
            label: "Avaliações",
            controller: state.avaliacoes,
            isCadastro: true,
          ),
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
  const InformacoesBasicas({required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
              label: "Cuidador Principal",
              controller: state.cuidadorPrincipal,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
              label: "Queixa Principal",
              controller: state.queixaPrincipal,
            ),
          ),
          InputCaixaDeTexto(
            label: "Descrição",
            controller: state.descricao,
            isCadastro: true,
          ),
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
  final ValueNotifier<bool> radiobuttonNotifier;

  // Construtor sem `const` e com parâmetro de `Key`
  MarcosDeConsumoAlimentar({
    Key? key,
    required this.state,
    required this.radiobuttonNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputRadioButtonsCadastroPaciente(
            options: const ["Sim", "Não", "Não sabe"],
            label:
                "Você tem costume de realizar as refeições assistindo à TV, mexendo no computador e/ou celular?",
            controller: state.refeicoesComTecnologia,
            secondController: state.refeicoesComTecnologia,
            isChecked: radiobuttonNotifier,
          ),
          RefeicoesCheckbox(
            refeicoesController: state.refeicoesDuranteODia,
          ),
          const Text("Ontem você consumiu?"),
          InputRadioButtonsCadastroPaciente(
            options: const ["Sim", "Não", "Não sabe"],
            label: "Feijão",
            controller: state.consumiuFeijao,
            isChecked: radiobuttonNotifier,
          ),
          InputRadioButtonsCadastroPaciente(
            options: const ["Sim", "Não", "Não sabe"],
            label: "Frutas frescas (não considerar suco de frutas)",
            controller: state.consumiuFrutas,
            isChecked: radiobuttonNotifier,
          ),
          InputRadioButtonsCadastroPaciente(
            options: const ["Sim", "Não", "Não sabe"],
            label:
                "Verduras e/ou legumes (não considerar batata, mandioca, aipim, macaxeira, cará e inhame)",
            controller: state.consumiuVerdurasLegumes,
            isChecked: radiobuttonNotifier,
          ),
          InputRadioButtonsCadastroPaciente(
            options: const ["Sim", "Não", "Não sabe"],
            label:
                "Hambúrguer e/ou embutidos (presunto, mortadela, salame, linguiça, salsicha)",
            controller: state.consumiuEmbutidos,
            isChecked: radiobuttonNotifier,
          ),
          InputRadioButtonsCadastroPaciente(
            options: const ["Sim", "Não", "Não sabe"],
            label:
                "Bebidas adoçadas (refrigerante, suco de caixinha, suco em pó, água de coco de caixinha, xaropes de guaraná/groselha, suco de fruta com adição de açúcar)",
            controller: state.consumiuBebidasAdocicadas,
            isChecked: radiobuttonNotifier,
          ),
          InputRadioButtonsCadastroPaciente(
            options: const ["Sim", "Não", "Não sabe"],
            label:
                "Macarrão instantâneo, salgadinhos de pacote ou biscoitos salgados",
            controller: state.consumiuMacarraoInstantaneoSalgado,
            isChecked: radiobuttonNotifier,
          ),
          InputRadioButtonsCadastroPaciente(
            options: const ["Sim", "Não", "Não sabe"],
            label:
                "Biscoito recheado, doces ou guloseimas (balas, pirulitos, chiclete, caramelo, gelatina)",
            controller: state.consumiuBiscoitoRecheado,
            isChecked: radiobuttonNotifier,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
              label: "Ingesta Hídrica (quantidade)",
              controller: state.ingestaoHidrica,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
              label: "Suplementação de Ferro e/ou vitaminas",
              controller: state.suplementacao,
            ),
          ),
        ],
      ),
    );
  }
}

class Eliminacoes extends StatelessWidget {
  final ConsultaState state;
  const Eliminacoes({required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
                label: "Diurese: coloração, odor/dor, frequência",
                controller: state.diurese),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
                label: "Evacuações: aspecto, coloração, dor, frequência",
                controller: state.evacuacoes),
          ),
        ],
      ),
    );
  }
}

class Higiente extends StatelessWidget {
  final ConsultaState state;

  const Higiente({required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
                label: "Itens utilizados para higiene ( banho e escovação)",
                controller: state.itensHigiene),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
                label: "Higiene corporal  (sequência, frequência)",
                controller: state.higieneCorporal),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
                label:
                    "Higiene Bucal (verificar presença de cáries, frequência escovação, uso correto do fio dental)",
                controller: state.higieneBucal),
          ),
        ],
      ),
    );
  }
}

class Sono extends StatelessWidget {
  final ConsultaState state;
  const Sono({required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
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
  final ValueNotifier<bool> radiobuttonNotifier;

  ExameFisico({
    Key? key,
    required this.state,
    required this.radiobuttonNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
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
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: InputTextoAcolher(
                    label: "Peso",
                    placeHolder: "kg",
                    controller: state.peso,
                  ),
                ),
              ],
            ),
          ),
          //EstaturaForm(),
          InputRadioButtonsCadastroPaciente(
              options: const ["Adequado", "Baixa estatura pra idade"],
              label: "Estatura X Idade",
              controller: state.comprimentoPorIdade,
              isChecked: radiobuttonNotifier),
          InputRadioButtonsCadastroPaciente(
              options: const [
                "Obsidade",
                "Sobrepeso",
                "Eutrofia",
                "Magreza",
                "Magreza Acentuada"
              ],
              label: "IMC X Idade",
              controller: state.imcPorIdade,
              isChecked: radiobuttonNotifier),
          SizedBox(height: 20), // Espaço entre os grupos
          //ImcForm(),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(label: "FC:", controller: state.frequenciaCardiaca),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
                label: "Saturação:", controller: state.saturacao),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
                label: "Ausculta Cardíaca:",
                controller: state.auscultaCardiaca),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
                label: "Ausculta Pulmonar:",
                controller: state.auscultaPulmonar),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(label: "PA:", controller: state.pressaoArterial),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
                label: "Temperatura:", controller: state.temperatura),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
                label: "Otoscopia:", controller: state.otoscopia),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
                label: "Orofaringe:", controller: state.orofaringe),
          ),
          InputCaixaDeTexto(
            label:
                "Avaliação Musculoesquelético (Postura, Desalinhamentos, Condição muscular, Tipo de andado)",
            controller: state.avaliacaoMuscoesqueletica,
            isCadastro: true,
          ),
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
  final ValueNotifier<bool> radiobuttonNotifier;

  ExameFisicoCrianca({
    Key? key,
    required this.state,
    required this.radiobuttonNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
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
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: InputTextoAcolher(
                    label: "Peso",
                    placeHolder: "kg",
                    controller: state.peso,
                  ),
                ),
              ],
            ),
          ),
          //EstaturaForm(),
          InputRadioButtonsCadastroPaciente(
              options: const ["Adequado", "Baixa estatura pra idade"],
              label: "Estatura X Idade",
              controller: state.comprimentoPorIdade,
              isChecked: radiobuttonNotifier),
          InputRadioButtonsCadastroPaciente(
              options: const [
                "Obsidade",
                "Sobrepeso",
                "Eutrofia",
                "Magreza",
                "Magreza Acentuada"
              ],
              label: "IMC X Idade",
              controller: state.imcPorIdade,
              isChecked: radiobuttonNotifier),
          SizedBox(height: 20), // Espaço entre os grupos
          //ImcForm(),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(label: "FC:", controller: state.frequenciaCardiaca),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
                label: "Saturação:", controller: state.saturacao),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
                label: "Ausculta Cardíaca:",
                controller: state.auscultaCardiaca),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
                label: "Ausculta Pulmonar:",
                controller: state.auscultaPulmonar),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(label: "PA:", controller: state.pressaoArterial),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
                label: "Temperatura:", controller: state.temperatura),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
                label: "Otoscopia:", controller: state.otoscopia),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
                label: "Orofaringe:", controller: state.orofaringe),
          ),
          InputCaixaDeTexto(
            label:
                "Avaliação Musculoesquelético (Postura, Desalinhamentos, Condição muscular, Tipo de andado)",
            controller: state.avaliacaoMuscoesqueletica,
            isCadastro: true,
          ),
          InputCaixaDeTexto(
            label:
                "Avaliação da Pele (eritemas, palidez, manchas, alterações hormonais, umidade, turgor)",
            controller: state.avaliacaoPele,
            isCadastro: true,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
                label: "Fontanelas:", controller: state.fontanelas),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
                label: "Coto umbilical:", controller: state.cotoUmbilical),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
                label: "Genitalia:", controller: state.genitalia),
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
  final ValueNotifier<bool> radiobuttonNotifier;

  AvaliacaoReflexos({
    Key? key,
    required this.state,
    required this.radiobuttonNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputRadioButtonsCadastroPaciente(
              options: const ["P", "A", "N/V"],
              label: "Reflexo de busca (do nascimento aos 3-4 meses)",
              controller: state.reflexoBusca,
              isChecked: radiobuttonNotifier),
          InputRadioButtonsCadastroPaciente(
              options: const ["P", "A", "N/V"],
              label: "Reflexo de sucção (do nascimento aos 10-12 meses)",
              controller: state.reflexoSuccao,
              isChecked: radiobuttonNotifier),
          InputRadioButtonsCadastroPaciente(
              options: const ["P", "A", "N/V"],
              label: "Reflexo de preensão palmar (do nascimento aos 3-4 meses)",
              controller: state.reflexoPreensaoPalmar,
              isChecked: radiobuttonNotifier),
          InputRadioButtonsCadastroPaciente(
              options: const ["P", "A", "N/V"],
              label:
                  "Reflexo de preensão plantar ( do nascimento aos 8-10 meses)",
              controller: state.reflexoPreensaoPlantar,
              isChecked: radiobuttonNotifier),
          InputRadioButtonsCadastroPaciente(
              options: const ["P", "A", "N/V"],
              label: "Reflexo de babinski ( do nascimento aos 24 meses)",
              controller: state.reflexoBabinski,
              isChecked: radiobuttonNotifier),
          InputRadioButtonsCadastroPaciente(
              options: const ["P", "A", "N/V"],
              label:
                  "Reflexo de tônico-cervical ( dos 2-3 meses aos 4-6 meses)",
              controller: state.reflexoTonicoCervical,
              isChecked: radiobuttonNotifier),
          InputRadioButtonsCadastroPaciente(
              options: const ["P", "A", "N/V"],
              label: "Reflexo de Moro ( do nascimento aos 4-6 meses)",
              controller: state.reflexoMoro,
              isChecked: radiobuttonNotifier),
          InputRadioButtonsCadastroPaciente(
              options: const ["P", "A", "N/V"],
              label: "Reflexo de Marcha ( até o andar voluntário)",
              controller: state.reflexoMarcha,
              isChecked: radiobuttonNotifier),
          InputRadioButtonsCadastroPaciente(
              options: const ["P", "A", "N/V"],
              label: "Reflexo do piscar óptico",
              controller: state.reflexoPiscarOptico,
              isChecked: radiobuttonNotifier),
        ],
      ),
    );
  }
}

class AvaliacaoNervos extends StatelessWidget {
  final ConsultaState state;
  final ValueNotifier<bool> radiobuttonNotifier;

  AvaliacaoNervos({
    Key? key,
    required this.state,
    required this.radiobuttonNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputRadioButtonsCadastroPaciente(
              options: const ["P", "A", "N/V"],
              label: "Reflexo do piscar óptico",
              controller: state.reflexoPiscarOptico,
              isChecked: radiobuttonNotifier),
          InputRadioButtonsCadastroPaciente(
              options: const ["P", "A", "N/V"],
              label: "Reflexo de busca e sucção",
              controller: state.reflexoBuscaESuccao,
              isChecked: radiobuttonNotifier),
          InputRadioButtonsCadastroPaciente(
              options: const ["P", "A", "N/V"],
              label: "Movimentos Simétricos Faciais",
              controller: state.movimentosSimetricosFaciais,
              isChecked: radiobuttonNotifier),
          InputRadioButtonsCadastroPaciente(
              options: const ["P", "A", "N/V"],
              label: "Reflexo piscar acústico",
              controller: state.reflexoPiscarAcustico,
              isChecked: radiobuttonNotifier),
          InputRadioButtonsCadastroPaciente(
              options: const ["P", "A", "N/V"],
              label: "Reflexo de vômito",
              controller: state.reflexoVomito,
              isChecked: radiobuttonNotifier),
          InputRadioButtonsCadastroPaciente(
              options: const ["P", "A", "N/V"],
              label:
                  "Aperte o nariz, a boca abre-se e a língua eleva-se na linha média",
              controller: state.aperteNariz,
              isChecked: radiobuttonNotifier),
        ],
      ),
    );
  }
}

class IdentidadeGenero extends StatelessWidget {
  final ConsultaState state;
  final ValueNotifier<bool> radiobuttonNotifier;

  IdentidadeGenero({
    Key? key,
    required this.state,
    required this.radiobuttonNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputRadioButtonsCadastroPaciente(
              options: const [
                "Transgênero",
                "Cisgênero",
                "Agênero",
                "Bigênero"
              ],
              label: "Identidade de gênero",
              controller: state.identidadeGenero,
              isChecked: radiobuttonNotifier),
          InputRadioButtonsCadastroPaciente(
              options: const ["Heterossexual", "Homossexual", "Bissexual"],
              label: "Sexualidade",
              controller: state.sexualidade,
              isChecked: radiobuttonNotifier),
        ],
      ),
    );
  }
}

class EstagioDeTurnerMeninas extends StatelessWidget {
  final ConsultaState state;
  const EstagioDeTurnerMeninas({required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputCaixaDeTexto(
            label: "ESTÁGIOS DE TURNER MAMAS",
            controller: state.estagioTurnerMeninasMamas,
            isCadastro: true,
          ),
          InputCaixaDeTexto(
            label: "ESTÁGIOS DE TURNER PELOS PUBIANOS",
            controller: state.estagioTurnerMeninasPelosPubianos,
            isCadastro: true,
          ),
        ],
      ),
    );
  }
}

class SaudeSexualReprodutivaMeninas extends StatelessWidget {
  final ConsultaState state;
  final ValueNotifier<bool> radiobuttonNotifier;

  SaudeSexualReprodutivaMeninas({
    Key? key,
    required this.state,
    required this.radiobuttonNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
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
          InputRadioButtonsCadastroPaciente(
              options: const ["Leve", "Moderado", "Intenso"],
              label: "Fluxo menstrual",
              controller: state.fluxoMenstrual,
              isChecked: radiobuttonNotifier),
          InputRadioButtonsCadastroPaciente(
              options: const ["Regular", "Irregular"],
              label: "Regularidade",
              controller: state.regularidadeMenstruacao,
              isChecked: radiobuttonNotifier),
          InputRadioButtonsCadastroPaciente(
              options: const ["Presente", "Ausente"],
              label: "Dismenorréia",
              controller: state.dimenorreia,
              isChecked: radiobuttonNotifier),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
                label: "Uso de absorvente ( trocas/higienização) :",
                controller: state.usoAbsorvente),
          ),
          InputRadioButtonsCadastroPaciente(
              options: const ["Sim", "Não"],
              label: "Usa medicamento",
              controller: state.usaMedicamento,
              secondController: state.qualMedicamento,
              isChecked: radiobuttonNotifier),
          InputRadioButtonsCadastroPaciente(
              options: const ["Sim ", "Não"],
              label: "Tem vida sexual ativa",
              controller: state.vidaSexualAtiva,
              isChecked: radiobuttonNotifier),
          InputRadioButtonsCadastroPaciente(
              options: const ["Sim", "Não"],
              label: "Usa algum método contraceptivo",
              controller: state.usaMetodoContraceptivo,
              secondController: state.qualMetodoContraceptivo,
              isChecked: radiobuttonNotifier),
          InputRadioButtonsCadastroPaciente(
              options: const ["Sim", "Não"],
              label: "Ja fez preventivo",
              controller: state.jaFezPreventivo,
              secondController: state.quandoFezPreventivo,
              isChecked: radiobuttonNotifier),
          InputRadioButtonsCadastroPaciente(
              options: const ["Sim", "Não"],
              label: "Você se masturba",
              controller: state.seMasturba,
              secondController: state.frequenciaMasturbacao,
              isChecked: radiobuttonNotifier),
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
  const EstagioDeTurnerMeninos({required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputCaixaDeTexto(
            label: "ESTÁGIOS DE TURNER GENITALIA",
            controller: state.estagioTurnerMeninosGenitalia,
            isCadastro: true,
          ),
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
  final ValueNotifier<bool> radiobuttonNotifier;

  SaudeSexualReprodutivaMeninos({
    Key? key,
    required this.state,
    required this.radiobuttonNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputRadioButtonsCadastroPaciente(
              options: const ["Sim ", "Não"],
              label: "Tem vida sexual ativa",
              controller: state.vidaSexualAtiva,
              isChecked: radiobuttonNotifier),
          InputRadioButtonsCadastroPaciente(
              options: const ["Sim", "Não"],
              label: "Usa algum método contraceptivo",
              controller: state.usaMetodoContraceptivo,
              secondController: state.qualMetodoContraceptivo,
              isChecked: radiobuttonNotifier),
          InputRadioButtonsCadastroPaciente(
              options: const ["Sim", "Não"],
              label: "Você se masturba",
              controller: state.seMasturba,
              secondController: state.frequenciaMasturbacao,
              isChecked: radiobuttonNotifier),
          InputCaixaDeTexto(
            label: "Observações",
            controller: state.observacoesSaudeSexualEReprodutivaMeninas,
            isCadastro: true,
          ),
          InputRadioButtonsCadastroPaciente(
              options: const ["Sim", "Não"],
              label: "Semanarca",
              controller: state.semenarca,
              secondController: state.quandoSemenarca,
              isChecked: radiobuttonNotifier),
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

  InputCaixaLambdoide({
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
              border: OutlineInputBorder(),
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
  RefeicoesCheckbox({required this.refeicoesController});

  @override
  _RefeicoesCheckboxState createState() => _RefeicoesCheckboxState();
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
  @override
  _EstaturaFormState createState() => _EstaturaFormState();
}

class _EstaturaFormState extends State<EstaturaForm> {
  String? estaturaValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Estatura X Idade:"),
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
            Text("Adequado"),
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
            Text("Baixa estatura para a idade"),
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
            Text("Baixa estatura para idade"),
          ],
        ),
      ],
    );
  }
}

class ImcForm extends StatefulWidget {
  @override
  _ImcFormState createState() => _ImcFormState();
}

class _ImcFormState extends State<ImcForm> {
  String? imcValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("IMC X Idade:"),
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
            Text("Obesidade"),
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
            Text("Sobrepeso"),
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
            Text("Eutrofia"),
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
            Text("Magreza"),
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
            Text("Magreza Acentuada"),
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

  InputCaixaBregmatica({
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
              border: OutlineInputBorder(),
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

class MyHomePage extends StatefulWidget {
  final List<String> pageTitles;
  final List<Widget> pageWidgets;

  MyHomePage({required this.pageTitles, required this.pageWidgets});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
        duration: Duration(milliseconds: 300),
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

    return PreferredSize(
      preferredSize: Size.fromHeight(80.0), // Adjust height as needed
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
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
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
                    style: TextStyle(
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
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
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
