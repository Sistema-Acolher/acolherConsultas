import 'package:acolherconsultas/modules/casasDeApoio/models/casaDeApoio.dart';
import 'package:acolherconsultas/modules/consultas/models/consulta.dart';
import 'package:acolherconsultas/modules/consultas/controllers/consultaController.dart';
import 'package:acolherconsultas/modules/consultas/state/consultaState.dart';
import 'package:acolherconsultas/modules/pacientes/controllers/pacienteController.dart';
import 'package:acolherconsultas/modules/pacientes/models/paciente.dart';
import 'package:acolherconsultas/modules/sistema/views/loadingLogo.dart';
import 'package:acolherconsultas/shared/components/bars/pageAppBar.dart';
import 'package:acolherconsultas/shared/components/buttons/bigRoundButton.dart';
import 'package:acolherconsultas/shared/components/inputs/inputRadioButtonsConsulta.dart';
import 'package:acolherconsultas/shared/components/inputs/inputTexto.dart';
import 'package:acolherconsultas/shared/components/list/listaHorarios.dart';
import 'package:acolherconsultas/shared/components/inputs/inputCaixaDeTexto.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:mask/mask/mask.dart';
import 'package:provider/provider.dart';

class ConsultarScreen extends StatefulWidget {
  const ConsultarScreen({super.key, this.dadosConsulta, this.readOnly=false});

  final ConsultaCadastro? dadosConsulta;
  final bool readOnly;

  @override
  State<ConsultarScreen> createState() => _ConsultarScreenState();
}

class _ConsultarScreenState extends State<ConsultarScreen> {
  final _formKey = GlobalKey<FormState>();
  ConsultaState _consultaState = ConsultaState();

  ConsultaCadastro? consultaSelecionado;
  late List<ConsultaCadastro> consultasDia;

  @override
  void initState() {
    super.initState();
    if (widget.dadosConsulta!=null && widget.dadosConsulta!.dadosConsulta!=null) {
      _consultaState=ConsultaState.fromConsulta(widget.dadosConsulta!.dadosConsulta!);
    }
  }

  void loadConsultas() {
    if (widget.dadosConsulta==null) {
      consultasDia = Provider.of<List<ConsultaCadastro>>(context)
          .where((element) =>
              element.dataHorario.day == DateTime.now().day &&
              element.casaDeApoioId == Provider.of<CasaDeApoio>(context).id)
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    loadConsultas();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: widget.dadosConsulta != null
          ? PageAppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () => Navigator.pop(context)
            ),
            titulo: widget.dadosConsulta?.pacienteNome ?? "")
          : consultaSelecionado != null
          ? PageAppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () => setState(() {
                consultaSelecionado = null;
                _consultaState = ConsultaState();
              })
            ),
            titulo: consultaSelecionado?.pacienteNome ?? "",
            casaDeApoioSelecionada: Provider.of<CasaDeApoio>(context))
          : PageAppBar(
            titulo: "Consultar",
            casaDeApoioSelecionada:Provider.of<CasaDeApoio>(context)),
      ),
      body: widget.dadosConsulta != null || consultaSelecionado != null
        ? Center(
          child: Form(
            key: _formKey,
            child: Builder(
              builder: (context) {
                ConsultaCadastro consulta = (widget.dadosConsulta ?? consultaSelecionado)!;
                Paciente? paciente = Provider.of<List<CadastroPaciente>>(context)
                  .where((paciente) => paciente.paciente.id == consulta.pacienteId).firstOrNull?.paciente;
                if (paciente != null) {
                  String? idadeS = PacientesController.calcularIdade(paciente.dataNasc);
                  final match = RegExp(r'^(\d+)a').firstMatch(idadeS);
                  int idade = match != null ? int.parse(match.group(1)!) : 0;
                  String? sexo = paciente.sexo;
            
                  // Adiciona comuns iniciais
                  List<String> pageTitles = [
                    "Informações Básicas",
                    "Consumo Alimentar",
                    "Eliminações",
                    "Higiene",
                    "Sono",
                  ];
                  List<Widget> pageWidgets = [
                    InformacoesBasicas      (state: _consultaState, readOnly: widget.readOnly),
                    MarcosDeConsumoAlimentar(state: _consultaState, readOnly: widget.readOnly),
                    Eliminacoes             (state: _consultaState, readOnly: widget.readOnly),
                    Higiente                (state: _consultaState, readOnly: widget.readOnly),
                    Sono                    (state: _consultaState, readOnly: widget.readOnly),
                  ];
                  // Adiciona filtrados
                  if (idade > 12 && sexo == 'Feminino') {
                    pageTitles.addAll([
                      "Exame Físico",
                      "Identidade de Genêro",
                      "Estágio de Turner",
                      "Saúde Sexual Reprodutiva",
                    ]);
                    pageWidgets.addAll([
                      ExameFisico                  (state: _consultaState, readOnly: widget.readOnly),
                      IdentidadeGenero             (state: _consultaState, readOnly: widget.readOnly),
                      EstagioDeTurnerMeninas       (state: _consultaState, readOnly: widget.readOnly),
                      SaudeSexualReprodutivaMeninas(state: _consultaState, readOnly: widget.readOnly),
                    ]);
                  } else if (idade > 12 && sexo == 'Masculino') {
                    pageTitles.addAll([
                      "Exame Físico",
                      "Identidade de Genêro",
                      "Estágio de Turner",
                      "Saúde Sexual Reprodutiva"
                    ]);
                    pageWidgets.addAll([
                      ExameFisico                  (state: _consultaState, readOnly: widget.readOnly),
                      IdentidadeGenero             (state: _consultaState, readOnly: widget.readOnly),
                      EstagioDeTurnerMeninos       (state: _consultaState, readOnly: widget.readOnly),
                      SaudeSexualReprodutivaMeninos(state: _consultaState, readOnly: widget.readOnly),
                    ]);
                  } else {
                    pageTitles.addAll([
                      "Exame Físico",
                      "Avaliação Reflexos",
                      "Avaliação Nervos",
                    ]);
                    pageWidgets.addAll([
                      ExameFisicoCrianca       (state: _consultaState, readOnly: widget.readOnly),
                      AvaliacaoReflexosNervos  (state: _consultaState, readOnly: widget.readOnly, isReflexos: true,),
                      AvaliacaoReflexosNervos  (state: _consultaState, readOnly: widget.readOnly, isReflexos: false,),
                    ]);
                  }
                  // Adiciona comuns finais
                  pageTitles.addAll([
                    "Avaliação Psicoemocional",
                    "Conclusões",
                    "Casa de Apoio"
                  ]);
                  pageWidgets.addAll([
                    AvaliacaoPsicoemocional(state: _consultaState, readOnly: widget.readOnly),
                    Conclusoes      (state: _consultaState, readOnly: widget.readOnly),
                    ParaCasa               (state: _consultaState, readOnly: widget.readOnly)
                  ]);
            
                  return ExibirConsulta(
                    consulta: (widget.dadosConsulta??consultaSelecionado!),
                    consultaState: _consultaState,
                    pageTitles: pageTitles,
                    pageWidgets: pageWidgets,
                    readOnly: widget.readOnly,
                    onSuccess: () {
                        widget.dadosConsulta!=null
                        ? Navigator.pop(context)
                        : setState(() {
                          consultaSelecionado=null;
                          _consultaState = ConsultaState();
                        });
                        const snackBar = SnackBar(
                                elevation: 0,
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.transparent,
                                content: AwesomeSnackbarContent(
                                  title: 'Sucesso',
                                  message: 'Consulta enviada',
                                  contentType: ContentType.success,
                                ),
                                duration: Duration(seconds: 10),
                              );
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(snackBar);
                    }
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
                style: TextStyle(fontSize: 20, decoration: TextDecoration.underline, fontWeight: FontWeight.bold),
              ),
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(color: Colors.amber[100], borderRadius: BorderRadius.circular(15)),
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
        )
    );
  }
}

class InformacoesBasicas extends StatelessWidget {
  final ConsultaState state;
  final bool readOnly;
  const InformacoesBasicas({super.key, required this.state, this.readOnly = false});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 100.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
              readOnly: readOnly,
              label: "Cuidador Principal",
              controller: state.cuidadorPrincipal,
              emptyMessage: "Informe o cuidador princial",
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
              readOnly: readOnly,
              label: "Queixa Principal",
              controller: state.queixaPrincipal,
              emptyMessage: "Informe a queixa principal",
            ),
          ),
          InputCaixaDeTexto(
            readOnly: readOnly,
            label: "Descrição",
            controller: state.descricao,
            isCadastro: true,
          ),
          const SizedBox(height: 10.0),
          InputCaixaDeTexto(
            readOnly: readOnly,
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
  final bool readOnly;
  const MarcosDeConsumoAlimentar({super.key, required this.state, this.readOnly = false});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 100.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputRadioButtonsConsulta(
            readOnly: readOnly,
            options: const ["Sim ", "Não", "Não sabe"],
            label: "Você tem costume de realizar as refeições assistindo à TV, mexendo no computador e/ou celular?",
            controller: state.refeicoesComTecnologia,
            isChecked: state.notifierRefeicoesComTecnologia,
          ),
          RefeicoesCheckbox(
            readOnly: readOnly,
            refeicoesController: state.refeicoesDuranteODia,
          ),
          const Padding(
            padding: EdgeInsets.only(top:8.0),
            child: Text("Ontem você consumiu?",
              style: TextStyle(fontWeight: FontWeight.bold,decoration: TextDecoration.underline)),
          ),
          InputRadioButtonsConsulta(
            readOnly: readOnly,
            options: const ["Sim", "Não", "Não sabe"],
            label: "Feijão",
            controller: state.consumiuFeijao,
            isChecked: state.notifierConsumiuFeijao,
          ),
          InputRadioButtonsConsulta(
            readOnly: readOnly,
            options: const ["Sim", "Não", "Não sabe"],
            label: "Frutas frescas (não considerar suco de frutas)",
            controller: state.consumiuFrutas,
            isChecked: state.notifierConsumiuFrutas,
          ),
          InputRadioButtonsConsulta(
            readOnly: readOnly,
            options: const ["Sim", "Não", "Não sabe"],
            label: "Verduras e/ou legumes (não considerar batata, mandioca, aipim, macaxeira, cará e inhame)",
            controller: state.consumiuVerdurasLegumes,
            isChecked: state.notifierConsumiuVerdurasLegumes,
          ),
          InputRadioButtonsConsulta(
            readOnly: readOnly,
            options: const ["Sim", "Não", "Não sabe"],
            label: "Hambúrguer e/ou embutidos (presunto, mortadela, salame, linguiça, salsicha)",
            controller: state.consumiuEmbutidos,
            isChecked: state.notifierConsumiuEmbutidos,
          ),
          InputRadioButtonsConsulta(
            readOnly: readOnly,
            options: const ["Sim", "Não", "Não sabe"],
            label: "Bebidas adoçadas (refrigerante, suco de caixinha, suco em pó, água de coco de caixinha, xaropes de guaraná/groselha, suco de fruta com adição de açúcar)",
            controller: state.consumiuBebidasAdocicadas,
            isChecked: state.notifierConsumiuBebidasAdocicadas,
          ),
          InputRadioButtonsConsulta(
            readOnly: readOnly,
            options: const ["Sim", "Não", "Não sabe"],
            label: "Macarrão instantâneo, salgadinhos de pacote ou biscoitos salgados",
            controller: state.consumiuMacarraoInstantaneoSalgado,
            isChecked: state.notifierConsumiuMacarraoInstantaneoSalgado,
          ),
          InputRadioButtonsConsulta(
            readOnly: readOnly,
            options: const ["Sim", "Não", "Não sabe"],
            label: "Biscoito recheado, doces ou guloseimas (balas, pirulitos, chiclete, caramelo, gelatina)",
            controller: state.consumiuBiscoitoRecheado,
            isChecked: state.notifierConsumiuBiscoitoRecheado,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
              readOnly: readOnly,
              label: "Ingesta Hídrica (quantidade)",
              controller: state.ingestaoHidrica,
              emptyMessage: "Informe a ingestão hídrica",
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
              readOnly: readOnly,
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
  final bool readOnly;
  const Eliminacoes({super.key, required this.state, this.readOnly = false});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 100.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'src/images/Diurese.jpg',
            height: 200, // Ajuste o tamanho conforme necessário
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
              readOnly: readOnly,
              label: "Diurese: coloração, odor/dor, frequência",
              controller: state.diurese,
              emptyMessage: "Informe a diurese"
            ),
          ),
          Image.asset(
            'src/images/Evacuação.jpg',
            height: 200, // Ajuste o tamanho conforme necessário
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
              readOnly: readOnly,
              label: "Evacuações: aspecto, coloração, dor, frequência",
              controller: state.evacuacoes,
              emptyMessage: "Informe a evacuação"
            ),
          ),
        ],
      ),
    );
  }
}

class Higiente extends StatelessWidget {
  final ConsultaState state;
  final bool readOnly;
  const Higiente({super.key, required this.state, this.readOnly = false});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 100.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
              readOnly: readOnly,
              label: "Itens utilizados para higiene ( banho e escovação)",
              controller: state.itensHigiene,
              emptyMessage: "Informe os itens de higiene"
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
              readOnly: readOnly,
              label: "Higiene corporal  (sequência, frequência)",
              controller: state.higieneCorporal,
              emptyMessage: "Informe a higiene corporal"
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
              readOnly: readOnly,
              label: "Higiene Bucal (verificar presença de cáries, frequência escovação, uso correto do fio dental)",
              controller: state.higieneBucal,
              emptyMessage: "Informe a higiene bucal"
            ),
          ),
        ],
      ),
    );
  }
}

class Sono extends StatelessWidget {
  final ConsultaState state;
  final bool readOnly;
  const Sono({super.key, required this.state, this.readOnly = false});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 100.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputCaixaDeTexto(
            readOnly: readOnly,
            label: "Precisa de ajuda para dormir?,  compartilha quarto para dormir? Qual sua relação com quem compartilha o quarto?",
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
  final bool readOnly;
  const ExameFisico({super.key, required this.state, this.readOnly=false});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 100.0),
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
                    readOnly: readOnly,
                    keyboardType: TextInputType.number,
                    label: "Comprimento",
                    placeHolder: "cm",
                    controller: state.comprimento,
                    emptyMessage: "Informe o comprimento"
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: InputTextoAcolher(
                    readOnly: readOnly,
                    keyboardType: TextInputType.number,
                    label: "Peso",
                    placeHolder: "kg",
                    controller: state.peso,
                    emptyMessage: "Informe o peso"
                  ),
                ),
              ],
            ),
          ),
          InputRadioButtonsConsulta(
            readOnly: readOnly,
            options: const ["Adequado", "Baixa estatura pra idade"],
            label: "Estatura X Idade",
            controller: state.comprimentoPorIdade,
            isChecked: state.notifierComprimentoPorIdade),
          InputRadioButtonsConsulta(
            readOnly: readOnly,
            options: const [
              "Obsidade",
              "Sobrepeso",
              "Eutrofia",
              "Magreza",
              "Magreza Acentuada"
            ],
            label: "IMC X Idade",
            controller: state.imcPorIdade,
            isChecked: state.notifierIMCPorIdade),
          const SizedBox(height: 20), // Espaço entre os grupos
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
              readOnly: readOnly,
              label: "FC:",
              controller: state.frequenciaCardiaca,
              emptyMessage: "Informe a FC"),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
              readOnly: readOnly,
              label: "Saturação:",
              controller: state.saturacao,
              emptyMessage: "Informe a saturação"),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
              readOnly: readOnly,
              label: "Ausculta Cardíaca:",
              controller: state.auscultaCardiaca,
              emptyMessage: "Informe a ausculta cardíaca"),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
              readOnly: readOnly,
              label: "Ausculta Pulmonar:",
              controller: state.auscultaPulmonar,
              emptyMessage: "Informe a ausculta pulmonar"),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
              readOnly: readOnly,
              label: "PA:",
              controller: state.pressaoArterial,
              emptyMessage: "Informe a PA"),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
              readOnly: readOnly,
              label: "Temperatura:",
              controller: state.temperatura,
              emptyMessage: "Informe a temperatura"),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
              readOnly: readOnly,
              label: "Otoscopia:",
              controller: state.otoscopia,
              emptyMessage: "Informe a otoscopia"),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
              readOnly: readOnly,
              label: "Orofaringe:",
              controller: state.orofaringe,
              emptyMessage: "Informe a orofaringe"),
          ),
          InputCaixaDeTexto(
            readOnly: readOnly,
            label: "Avaliação Musculoesquelético (Postura, Desalinhamentos, Condição muscular, Tipo de andado)",
            controller: state.avaliacaoMuscoesqueletica,
            isCadastro: true,
          ),
          const SizedBox(height: 10.0),
          InputCaixaDeTexto(
            readOnly: readOnly,
            label: "Avaliação da Pele (eritemas, palidez, manchas, alterações hormonais, umidade, turgor)",
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
  final bool readOnly;
  const ExameFisicoCrianca({super.key, required this.state, this.readOnly = false,});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 100.0),
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
                    readOnly: readOnly,
                    label: "Comprimento",
                    placeHolder: "cm",
                    controller: state.comprimento,
                    emptyMessage: "Informe o comprimento"),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: InputTextoAcolher(
                    readOnly: readOnly,
                    label: "Peso",
                    placeHolder: "kg",
                    controller: state.peso,
                    emptyMessage: "Informe o peso"),
                ),
              ],
            ),
          ),
          InputRadioButtonsConsulta(
              readOnly: readOnly,
              options: const ["Adequado", "Baixa estatura pra idade"],
              label: "Estatura X Idade",
              controller: state.comprimentoPorIdade,
              isChecked: state.notifierComprimentoPorIdade),
          InputRadioButtonsConsulta(
              readOnly: readOnly,
              options: const [
                "Obsidade",
                "Sobrepeso",
                "Eutrofia",
                "Magreza",
                "Magreza Acentuada"
              ],
              label: "IMC X Idade",
              controller: state.imcPorIdade,
              isChecked: state.notifierIMCPorIdade),
          const SizedBox(height: 20), // Espaço entre os grupos
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
              readOnly: readOnly,
              label: "FC:",
              controller: state.frequenciaCardiaca,
              emptyMessage: "Informe a FC"),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
              readOnly: readOnly,
              label: "Saturação:",
              controller: state.saturacao,
              emptyMessage: "Informe a saturação"),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
              readOnly: readOnly,
              label: "Ausculta Cardíaca:",
              controller: state.auscultaCardiaca,
              emptyMessage: "Informe a ausculta cardíaca"),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
              readOnly: readOnly,
              label: "Ausculta Pulmonar:",
              controller: state.auscultaPulmonar,
              emptyMessage: "Informe a ausculta pulmonar"),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
              readOnly: readOnly,
              label: "PA:",
              controller: state.pressaoArterial,
              emptyMessage: "Informe a PA"),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
              readOnly: readOnly,
              label: "Temperatura:",
              controller: state.temperatura,
              emptyMessage: "Informe a temperatura"),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
              readOnly: readOnly,
              label: "Otoscopia:",
              controller: state.otoscopia,
              emptyMessage: "Informe a otoscopia"),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
              readOnly: readOnly,
              label: "Orofaringe:",
              controller: state.orofaringe,
              emptyMessage: "Informe a orofaringe"),
          ),
          InputCaixaDeTexto(
            readOnly: readOnly,
            label: "Avaliação Musculoesquelético (Postura, Desalinhamentos, Condição muscular, Tipo de andado)",
            controller: state.avaliacaoMuscoesqueletica,
            isCadastro: true,
          ),
          const SizedBox(height: 10.0),
          InputCaixaDeTexto(
            readOnly: readOnly,
            label: "Avaliação da Pele (eritemas, palidez, manchas, alterações hormonais, umidade, turgor)",
            controller: state.avaliacaoPele,
            isCadastro: true,
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
              readOnly: readOnly,
              label: "Fontanelas:",
              controller: state.fontanelas,
              validation: (value) => Mask.validations.generic(value, error: " ", min: 0)),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
              readOnly: readOnly,
              label: "Coto umbilical:",
              controller: state.cotoUmbilical,
              validation: (value) => Mask.validations.generic(value, error: " ", min: 0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
              readOnly: readOnly,
              label: "Genitalia:",
              controller: state.genitalia,
              emptyMessage: "Informe a notifierGenitalia"),
          ),
          const SizedBox(height: 10.0),
          InputCaixaExameFisico(
            readOnly: readOnly,
            label: "Bregmática:",
            controller: state.bregmatica,
            optionalController: state.bregmaticaCalcificada, // Passando o optionalController
          ),
          InputCaixaExameFisico(
            readOnly: readOnly,
            label: "Lambdoide:",
            controller: state.lambdoide,
            optionalController: state.lambdoideCalcificada, // Passando o optionalController
          ),
        ],
      ),
    );
  }
}

class AvaliacaoReflexosNervos extends StatelessWidget {
  final ConsultaState state;
  final bool readOnly;
  final bool isReflexos;
  const AvaliacaoReflexosNervos({super.key, required this.state, this.readOnly = false, required this.isReflexos});

  @override
  Widget build(BuildContext context) {
    List radioButtons = isReflexos ? [
      ["Reflexo de busca (do nascimento aos 3-4 meses)", state.reflexoBusca, state.notifierReflexoBusca],
      ["Reflexo de sucção (do nascimento aos 10-12 meses)", state.reflexoSuccao, state.notifierReflexoSuccao],
      ["Reflexo de preensão palmar (do nascimento aos 3-4 meses)", state.reflexoPreensaoPalmar, state.notifierReflexoPreensaoPalmar],
      ["Reflexo de preensão plantar (do nascimento aos 8-10 meses)", state.reflexoPreensaoPlantar, state.notifierReflexoPreensaoPlantar],
      ["Reflexo de babinski (do nascimento aos 24 meses)", state.reflexoBabinski, state.notifierReflexoBabinski],
      ["Reflexo de tônico-cervical (dos 2-3 meses aos 4-6 meses)", state.reflexoTonicoCervical, state.notifierReflexoTonicoCervical],
      ["Reflexo de Moro (do nascimento aos 4-6 meses)", state.reflexoMoro, state.notifierReflexoMoro],
      ["Reflexo de Marcha (até o andar voluntário)", state.reflexoMarcha, state.notifierReflexoMarcha]
    ]:[
      ["Reflexo do piscar óptico", state.reflexoPiscarOptico, state.notifierReflexoPiscarOptico],
      ["Reflexo de busca e sucção", state.reflexoBuscaESuccao, state.notifierReflexoBuscaESuccao],
      ["Movimentos Simétricos Faciais", state.movimentosSimetricosFaciais, state.notifierMovimentosSimetricosFaciais],
      ["Reflexo piscar acústico", state.reflexoPiscarAcustico, state.notifierReflexoPiscarAcustico],
      ["Reflexo de vômito", state.reflexoVomito, state.notifierReflexoVomito],
      ["Aperte o nariz, a boca abre-se e a língua eleva-se na linha média", state.aperteNariz, state.notifierAperteNariz]
    ];
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 100.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for(var item in radioButtons)
            InputRadioButtonsConsulta(
              readOnly: readOnly,
              options: const ["P", "A", "N/V"],
              label: item[0],
              controller: item[1],
              isChecked: item[2],
            ),
        ],
      ),
    );
  }
}

class IdentidadeGenero extends StatelessWidget {
  final ConsultaState state;
  final bool readOnly;
  const IdentidadeGenero({super.key, required this.state, this.readOnly = false});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 100.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputRadioButtonsConsulta(
            readOnly: readOnly,
            options: const [
              "Transgênero",
              "Cisgênero",
              "Agênero",
              "Bigênero"
            ],
            label: "Identidade de gênero",
            controller: state.identidadeGenero,
            isChecked: state.notifierIdentidadeGenero),
          InputRadioButtonsConsulta(
            readOnly: readOnly,
            options: const ["Heterossexual", "Homossexual", "Bissexual"],
            label: "Sexualidade",
            controller: state.sexualidade,
            isChecked: state.notifierSexo),
        ],
      ),
    );
  }
}

class EstagioDeTurnerMeninas extends StatelessWidget {
  final ConsultaState state;
  final bool readOnly;
  const EstagioDeTurnerMeninas({super.key,required this.state, this.readOnly = false});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 100.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'src/images/EstagioTurnerMeninasSuperior.jpg',
            height: 500, // Ajuste o tamanho conforme necessário
          ),
          InputRadioButtonsConsulta(
            readOnly: readOnly,
            options: const ["M1", "M2", "M3", "M4", "M5"],
            label: "ESTÁGIOS DE TURNER MAMAS",
            controller: state.estagioTurnerMeninasMamas,
            isChecked: state.notifierMamas,
          ),
          const SizedBox(height: 10.0),
          Image.asset(
            'src/images/EstagioTurnerMeninasInferior.jpg',
            height: 500, // Ajuste o tamanho conforme necessário
          ),
          InputRadioButtonsConsulta(
            readOnly: readOnly,
            options: const ["P1", "P2", "P3", "P4", "P5"],
            label: "ESTÁGIOS DE TURNER PELOS PUBIANOS",
            controller: state.estagioTurnerMeninasPelosPubianos,
            isChecked: state.notifierPelosPubianos,
          ),
        ],
      ),
    );
  }
}

class SaudeSexualReprodutivaMeninas extends StatelessWidget {
  final ConsultaState state;
  final bool readOnly;

  const SaudeSexualReprodutivaMeninas({super.key, required this.state, this.readOnly = false});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 100.0),
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
            readOnly: readOnly,
            options: const ["Leve", "Moderado", "Intenso"],
            label: "Fluxo menstrual",
            controller: state.fluxoMenstrual,
            isChecked: state.notifierFluxoMenstrual,
          ),
          InputRadioButtonsConsulta(
            readOnly: readOnly,
            options: const ["Regular", "Irregular"],
            label: "Regularidade",
            controller: state.regularidadeMenstruacao,
            isChecked: state.notifierRegularidadeMenstrual,
          ),
          InputRadioButtonsConsulta(
            readOnly: readOnly,
            options: const ["Presente", "Ausente"],
            label: "Dismenorréia",
            controller: state.dimenorreia,
            isChecked: state.notifierDismenorreia,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
              readOnly: readOnly,
              label: "Uso de absorvente (trocas/higienização):",
              controller: state.usoAbsorvente,
              validation: (value) => Mask.validations.generic(value, error: "", min: 0),
            ),
          ),
          InputRadioButtonsConsulta(
            readOnly: readOnly,
            options: const ["Sim", "Não"],
            label: "Usa medicamento",
            controller: state.usaMedicamento,
            secondController: state.qualMedicamento,
            isChecked: state.notifierUsaMedicamento,
          ),
          InputRadioButtonsConsulta(
            readOnly: readOnly,
            options: const ["Sim ", "Não"],
            label: "Tem vida sexual ativa",
            controller: state.vidaSexualAtiva,
            isChecked: state.notifierVidaSexualAtiva,
          ),
          InputRadioButtonsConsulta(
            readOnly: readOnly,
            options: const ["Sim", "Não"],
            label: "Usa algum método contraceptivo",
            controller: state.usaMetodoContraceptivo,
            secondController: state.qualMetodoContraceptivo,
            isChecked: state.notifierMetodoContraceptivo,
          ),
          InputRadioButtonsConsulta(
            readOnly: readOnly,
            options: const ["Sim", "Não"],
            label: "Já fez preventivo",
            controller: state.jaFezPreventivo,
            secondController: state.quandoFezPreventivo,
            isChecked: state.notifierJaFezPreventivo,
          ),
          InputRadioButtonsConsulta(
            readOnly: readOnly,
            options: const ["Sim", "Não"],
            label: "Você se masturba",
            controller: state.seMasturba,
            secondController: state.frequenciaMasturbacao,
            isChecked: state.notifierSeMasturba,
          ),
          const SizedBox(height: 6,),
          InputCaixaDeTexto(
            readOnly: readOnly,
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
  final bool readOnly;
  const EstagioDeTurnerMeninos({super.key, required this.state, this.readOnly = false});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 100.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'src/images/EstagioTurnerMeninos.jpg',
            height: 500, // Ajuste o tamanho conforme necessário
          ),
          InputRadioButtonsConsulta(
            options: const ["G1", "G2", "G3", "G4", "G5"],
            label: "ESTÁGIOS DE TURNER GENITALIA",
            controller: state.estagioTurnerMeninosGenitalia,
            isChecked: state.notifierGenitalia,
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
  final bool readOnly;

  const SaudeSexualReprodutivaMeninos({super.key, required this.state, this.readOnly = false});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 100.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputRadioButtonsConsulta(
            readOnly: readOnly,
            options: const ["Sim ", "Não"],
            label: "Tem vida sexual ativa",
            controller: state.vidaSexualAtiva,
            isChecked: state.notifierVidaSexualAtiva,
          ),
          InputRadioButtonsConsulta(
            readOnly: readOnly,
            options: const ["Sim", "Não"],
            label: "Usa algum método contraceptivo",
            controller: state.usaMetodoContraceptivo,
            secondController: state.qualMetodoContraceptivo,
            isChecked: state.notifierMetodoContraceptivo,
          ),
          InputRadioButtonsConsulta(
            readOnly: readOnly,
            options: const ["Sim", "Não"],
            label: "Você se masturba",
            controller: state.seMasturba,
            secondController: state.frequenciaMasturbacao,
            isChecked: state.notifierSeMasturba,
          ),
          const SizedBox(height: 4,),
          InputCaixaDeTexto(
            readOnly: readOnly,
            label: "Observações",
            controller: state.observacoesSaudeSexualEReprodutivaMeninas,
            isCadastro: true,
          ),
          const SizedBox(height: 10.0),
          InputRadioButtonsConsulta(
            readOnly: readOnly,
            options: const ["Sim", "Não"],
            label: "Semanarca",
            controller: state.semenarca,
            secondController: state.quandoSemenarca,
            isChecked: state.notifierSemenarca,
          ),
        ],
      ),
    );
  }
}

class AvaliacaoPsicoemocional extends StatelessWidget {
  final ConsultaState state;
  final bool readOnly;
  const AvaliacaoPsicoemocional({super.key, required this.state, this.readOnly = false});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 100.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputCaixaDeTexto(
            readOnly: readOnly,
            label: "Como está se sentindo hoje? Por que?",
            controller: state.comoSeSenteHoje,
            isCadastro: true,
          ),
          const SizedBox(height: 10.0),
          InputCaixaDeTexto(
            readOnly: readOnly,
            label: "Observações psicoemocionais",
            controller: state.observacoesPsicoemocionais,
            isCadastro: true,
          ),
        ],
      ),
    );
  }
}

class Conclusoes extends StatelessWidget {
  final ConsultaState state;
  final bool readOnly;
  const Conclusoes({super.key, required this.state, this.readOnly = false});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 100.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
              readOnly: readOnly,
              label: "Marcos presentes:",
              controller: state.marcosPresentes,
              emptyMessage: "Informe os marcos presentes",
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: InputTextoAcolher(
              readOnly: readOnly,
              label: "Marcos ausentes:",
              controller: state.marcosAusentes,
              emptyMessage: "Informe os marcos ausentes",
            ),
          ),
          InputCaixaDeTexto(
            readOnly: readOnly,
            label: "Observações do desenvolvimento",
            controller: state.observacoesDesenvolvimento,
            isCadastro: true,
          ),
          const SizedBox(height: 10.0),
          InputCaixaDeTexto(
            readOnly: readOnly,
            label: "Análise geral",
            controller: state.analiseGeral,
            isCadastro: true,
          ),
          const SizedBox(height: 10.0),
          InputCaixaDeTexto(
            readOnly: readOnly,
            label: "Avaliações",
            controller: state.avaliacoes,
            isCadastro: true,
          ),
          const SizedBox(height: 10.0),
          InputCaixaDeTexto(
            readOnly: readOnly,
            label: "Intervenções",
            controller: state.intervencoes,
            isCadastro: true,
          ),
        ],
      ),
    );
  }
}

class ParaCasa extends StatelessWidget {
  final ConsultaState state;
  final bool readOnly;
  const ParaCasa({super.key, required this.state, this.readOnly = false});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 100.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputCaixaDeTexto(
            readOnly: readOnly,
            label: "Análise Geral",
            controller: state.analiseGeralCasa,
            isCadastro: true,
          ),
          const SizedBox(height: 10.0),
          InputCaixaDeTexto(
            readOnly: readOnly,
            label: "Exame Físico",
            controller: state.exameFisicoCasa,
            isCadastro: true,
          ),
          const SizedBox(height: 10.0),
          InputCaixaDeTexto(
            readOnly: readOnly,
            label: "Avaliações",
            controller: state.avaliacoesCasa,
            isCadastro: true,
          ),
          const SizedBox(height: 10.0),
          InputCaixaDeTexto(
            readOnly: readOnly,
            label: "Orientação para o cuidador",
            controller: state.oriParaCuidador,
            isCadastro: true,
          ),
          const SizedBox(height: 10.0),
          InputCaixaDeTexto(
            readOnly: readOnly,
            label: "Orientação para criança ou adolescente",
            controller: state.oriParaPaciente,
            isCadastro: true,
          ),
          const SizedBox(height: 10.0),
          InputCaixaDeTexto(
            readOnly: readOnly,
            label: "Orientação para coordenação da casa",
            controller: state.oriParaCoordenacao,
            isCadastro: true,
          )
        ],
      ),
    );
  }
}

class RefeicoesCheckbox extends StatefulWidget {
  final TextEditingController refeicoesController;
  final bool readOnly;

  // Construtor que recebe o controller como argumento
  const RefeicoesCheckbox({super.key, required this.refeicoesController, this.readOnly = false});

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
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        ...List.generate(refeicoes.length, (index) {
          return CheckboxListTile(
            enabled: !widget.readOnly,
            dense: true,
            title: Text(
              refeicoes[index],
              style: const TextStyle(fontSize: 14), // Smaller font size
            ),
            value: selectedRefeicoes[index],
            onChanged: (bool? value) {
              setState(() {
                selectedRefeicoes[index] = value!;
                _updateRefeicoesDuranteODia();
              });
            },
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: -6),
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

class InputCaixaExameFisico extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool readOnly;
  final ValueNotifier<bool>? optionalController; // Adicionando o optionalController

  const InputCaixaExameFisico({
    super.key,
    required this.label,
    required this.controller,
    this.readOnly = false,
    this.optionalController,
  });

  @override
  State<InputCaixaExameFisico> createState() => _InputCaixaExameFisicoState();
}

class _InputCaixaExameFisicoState extends State<InputCaixaExameFisico> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            enabled: !widget.readOnly,
            controller: widget.controller,
            decoration: InputDecoration(
              labelText: widget.label,
              hintText: "______ cm",
              border: const OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number, // Para aceitar apenas números
          ),
          if (widget.optionalController !=
              null) // Verifica se optionalController foi passado
            Row(
              children: [
                Checkbox(
                  value: widget.optionalController!.value, // Verifica se há texto no optionalController
                  onChanged: widget.readOnly==false? (bool? value) {
                    setState(() {});
                    widget.optionalController!.value=!widget.optionalController!.value;
                  }:null,
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
  final ConsultaCadastro consulta;
  final ConsultaState consultaState;
  final List<String> pageTitles;
  final List<Widget> pageWidgets;
  final Function onSuccess;
  final bool readOnly;

  const ExibirConsulta({super.key, required this.pageTitles, required this.pageWidgets, required this.consulta, required this.consultaState, required this.onSuccess, this.readOnly = false});

  @override
  State<ExibirConsulta> createState() => _ExibirConsultaState();
}

class _ExibirConsultaState extends State<ExibirConsulta> {
  late PageController _pageController;
  late List<GlobalKey<FormState>> _formKeys;
  int currentPageIndex = 0;

  List<String> get pageTitles => widget.pageTitles;
  List<Widget> get pageWidgets => widget.pageWidgets;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentPageIndex);
    _formKeys = List.generate(pageWidgets.length, (_) => GlobalKey<FormState>());
  }

  Future<void> _enviarConsulta() async {
    if (_validateCurrentPage()) {
      await ConsultaController().realizarConsulta(widget.consulta.id!, widget.consultaState.cadastro())
      .then((v) => widget.onSuccess())
      .onError((error, stackTrace) {
        const snackBar = SnackBar(
                elevation: 0,
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.transparent,
                content: AwesomeSnackbarContent(
                  title: 'Erro',
                  message: 'Erro no envio da consulta',
                  contentType: ContentType.failure,
                ),
                duration: Duration(seconds: 10),
              );
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      });
    } else {
      const snackBar = SnackBar(
              elevation: 0,
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              content: AwesomeSnackbarContent(
                title: 'Incorreto',
                message: 'Dados mal preenchidos',
                contentType: ContentType.success,
              ),
              duration: Duration(seconds: 10),
            );
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }

  void _navigateToPage(int index) {
    FocusScope.of(context).unfocus();
    setState(() {
      currentPageIndex = index;
      _pageController.animateToPage(
        currentPageIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  bool _validateCurrentPage() {
    final currentKey = _formKeys[currentPageIndex];
    if (currentKey.currentState?.validate() ?? false) {
      currentKey.currentState?.save();
      return true;
    }
    return false;
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
        leading: const SizedBox.shrink(),
        leadingWidth: 0,
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
                      onTap: () {
                        if (widget.readOnly || (_validateCurrentPage() && currentPageIndex < pageWidgets.length - 1)) {
                          _navigateToPage(currentPageIndex + 1);
                        }
                      },
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
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return Form(
            key: _formKeys[index],
            child: widget.pageWidgets[index],
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: (currentPageIndex == pageWidgets.length - 1) && !widget.readOnly?BigRoundButton(
        text: "Enviar Consulta",
        icon: Icons.send,
        onPressed: _enviarConsulta, // Chama a função para enviar a consulta
      ):null,
    );
  }
}
