import 'package:acolherconsultas/modules/genogramaEcomapa/controllers/genogramaController.dart';
import 'package:acolherconsultas/modules/genogramaEcomapa/models/elementosDesenho.dart';
import 'package:acolherconsultas/modules/genogramaEcomapa/models/genograma.dart';
import 'package:acolherconsultas/modules/genogramaEcomapa/models/tipoDesenho.dart';
import 'package:acolherconsultas/modules/genogramaEcomapa/models/undoRedoPilha.dart';
import 'package:acolherconsultas/modules/pacientes/controllers/pacienteController.dart';
import 'package:acolherconsultas/modules/pacientes/models/paciente.dart';
import 'package:acolherconsultas/modules/genogramaEcomapa/views/quadroBrancoGenograma.dart';
import 'package:acolherconsultas/shared/colors.dart';
import 'package:acolherconsultas/shared/components/bars/animatedAppbar.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter/services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:provider/provider.dart';

class GenogramaScreen extends HookWidget {
  final Genograma? genogramaVelho;
  final Paciente? paciente;
  final bool isEditable;

  const GenogramaScreen({
    super.key,
    this.genogramaVelho,
    this.paciente,
    required this.isEditable,
  });

  dispose(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  changeTransformations(ValueNotifier<TransformationController> viewTransformationController, double zoomFactor, double xTranslate, double yTranslate){
    viewTransformationController.value.value.setEntry(0, 0, zoomFactor);
    viewTransformationController.value.value.setEntry(1, 1, zoomFactor);
    viewTransformationController.value.value.setEntry(2, 2, zoomFactor);
    viewTransformationController.value.value.setEntry(0, 3, -xTranslate);
    viewTransformationController.value.value.setEntry(1, 3, -yTranslate);
  }

  @override
  Widget build(BuildContext context) {
    final canvasGlobalKey = GlobalKey();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    final ValueNotifier<bool> showAppBar = useState(true);
    final ValueNotifier<ElementosDesenho> desenhoAtual = useState(ElementosDesenho(
      id: 0,
      pontos: [],
      tipo: TipoDesenho.semDesenho,
      tamanho: 0,
      texto: '',
    ));
    final ValueNotifier<Genograma> genograma = useState( genogramaVelho ??
      Genograma(
        elementos: [],
        dataCriacao: DateTime.now(),
        pacienteRaiz: {
          'nome': paciente?.nome ?? 'Paciente',
          'sexo': paciente?.sexo ?? 'Masculino',
          'idade': PacientesController.calcularIdade(paciente?.dataNasc ?? DateTime.now()),
        }
      )
    );
    final ValueNotifier<MapEntry<ElementosDesenho, Operacoes>> desenhoEditado = useState(MapEntry(ElementosDesenho(
      id: 0,
      pontos: [],
      tipo: TipoDesenho.semDesenho,
      tamanho: 0,
      texto: '',
    ), Operacoes.adicao));
    final ValueNotifier<bool> desenhoAtivo = useState(false);
    final ValueNotifier<bool> borrachaAtiva = useState(false);
    final ValueNotifier<bool> edicaoAtiva = useState(false);
    final ValueNotifier<bool> edicaoTextoAtiva = useState(false);
    final ValueNotifier<TipoDesenho> tipoDesenho = useState(TipoDesenho.semDesenho);
    final ValueNotifier<String> textoCirculo = useState("");
    final ValueNotifier<IconData> iconeDesenhoAtivo = useState(Icons.add_box_outlined);
    Map<Offset, TipoDesenho> pontosDeConexaoIniciais = {};
    bool temIndiceInicial = false;
    if(genogramaVelho != null){
      for (var element in genograma.value.elementos) {
        for(var e in element.pontosConexao){
          pontosDeConexaoIniciais[e] = element.tipo;
        }
        if(element.isPaciente){
          temIndiceInicial = true;
        }
      }
    }
    final ValueNotifier<Map<Offset, TipoDesenho>> pontosDeConexao = useState(pontosDeConexaoIniciais);
    final ValueNotifier<MapEntry<Offset, TipoDesenho>> ultimoPontoConexao = useState(const MapEntry(Offset.zero, TipoDesenho.semDesenho));
    final ValueNotifier<bool> salvou = useState(false);
    final ValueNotifier<bool> temDesenho = useState(false);
    final ValueNotifier<Color> corDesenho = useState(Colors.black);
    final ValueNotifier<bool> temIndice = useState(temIndiceInicial);

    final undoRedoPilha = useState(
      UndoRedoPilha(
        desenhosNotifier: genograma,
        desenhoAtualNotifier: desenhoAtual,
        desenhoEditadoNotifier: desenhoEditado
      ),
    );

    final ValueNotifier<bool> opcoesAbertas = useState(false);
    final ValueNotifier<TransformationController> viewTransformationController;
    final ValueNotifier<double> zoomFactor;
    final ValueNotifier<double> xTranslate;
    final ValueNotifier<double> yTranslate;

    final estadoPessoa = useState<String?>("viva");

    viewTransformationController = useState(TransformationController());
    zoomFactor = useState(2);
    xTranslate = useState(4000.0 - (MediaQuery.of(context).size.height / 2.0));
    yTranslate = useState(2000.0 - (MediaQuery.of(context).size.width / 2.0));

    useEffect(() {
      changeTransformations(viewTransformationController, zoomFactor.value, xTranslate.value, yTranslate.value);
      return () {
        dispose();
      };
    }, const []);

    opcaoSelecionada(IconData iconeAtivo, TipoDesenho tipo, Color cor, [String texto = ""]){
      corDesenho.value = cor;
      iconeDesenhoAtivo.value = iconeAtivo;
      tipoDesenho.value = tipo;
      desenhoAtivo.value = true;
      edicaoAtiva.value = false;
      edicaoTextoAtiva.value = false;
      temDesenho.value = false;
      textoCirculo.value = texto;
    }
    Offset lastFocalPoint = Offset.zero;


    elementoPadrao(String sexo){
      TextEditingController? nomeController = TextEditingController();
      TextEditingController? idadeController = TextEditingController();
      TextEditingController? motivoFalecimentoController = TextEditingController();

      showDialog(
          context: context, 
          builder: (context) {
            var globalKey = GlobalKey<FormState>();
            return ValueListenableBuilder(
              valueListenable: estadoPessoa,
              builder: ((context, value, child) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(viewInsets: EdgeInsets.zero),
                  child: AlertDialog(
                  scrollable: true,
                  title: Text("Adicionar Pessoa do Sexo $sexo"),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))
                  ),
                  content: Builder(
                    builder: (context) {
                      return Form(
                        key: globalKey,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      hintText: "Nome da Pessoa",
                                    ),
                                    controller: nomeController,
                                  ),
                                  const SizedBox(height: 30),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      hintText: "Idade da Pessoa",
                                    ),
                                    controller: idadeController,
                                    keyboardType: TextInputType.number,
                                    // only numbers are allowed
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    // max 100 and min 0
                                    validator: (value) {
                                      if (value!.isNotEmpty && (int.parse(value) > 100 || int.parse(value) < 0)) {
                                        return 'Idade inválida';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 30),
                            Expanded(
                              flex: 3,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Qual o Estado?",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Radio(
                                        value: "viva",
                                        groupValue: estadoPessoa.value,
                                        onChanged: (value) {
                                          estadoPessoa.value = value!;
                                        },
                                      ),
                                      const Text("Viva"),
                                      Radio(
                                        value: "falecida",
                                        groupValue: estadoPessoa.value,
                                        onChanged: (value) {
                                          estadoPessoa.value = value!;
                                        },
                                      ),
                                      const Text("Falecida"),
                                      Radio(
                                        value: "desconhecida",
                                        groupValue: estadoPessoa.value,
                                        onChanged: (value) {
                                          estadoPessoa.value = value!;
                                        },
                                      ),
                                      const Text("Desconhecida"),
                                    ],
                                  ),
                                  estadoPessoa.value == "falecida" ?
                                    // motivo do falecimento
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Qual o Motivo do Falecimento?",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        TextFormField(
                                          decoration: const InputDecoration(
                                            hintText: "Motivo do Falecimento",
                                          ),
                                          controller: motivoFalecimentoController,
                                        )
                                      ],
                                    ) : const SizedBox()
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    }
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      }, 
                      child: const Text("Cancelar")
                    ),
                    TextButton(
                      onPressed: () {
                        if(globalKey.currentState!.validate()){
                          Navigator.of(context).pop();
                          TipoDesenho desenho = TipoDesenho.semDesenho;
                          if(sexo == "Masculino") {
                            desenho = estadoPessoa.value == "viva" ? TipoDesenho.quadrado : estadoPessoa.value == "falecida" ? TipoDesenho.quadradoFalecido : TipoDesenho.quadradoDesconhecido;
                          }
                          if(sexo == "Feminino") {
                            desenho = estadoPessoa.value == "viva" ? TipoDesenho.circulo : estadoPessoa.value == "falecida" ? TipoDesenho.circuloFalecido : TipoDesenho.circuloDesconhecido;
                          }
                          String texto = "";
                          if(nomeController.value.text.isNotEmpty){
                            texto = "${nomeController.value.text.trim()[0]}, ";
                          } else {
                            texto = "?, ";
                          }
                              
                          if(idadeController.value.text.isNotEmpty){
                            texto += idadeController.value.text.trim();
                          } else {
                            texto += "?";
                          }
                              
                          texto = texto == "?, ?" ? "?" : texto;
                              
                          if(motivoFalecimentoController.value.text.isNotEmpty){
                            texto += "\n${motivoFalecimentoController.value.text.trim()}";
                          }
                              
                          opcaoSelecionada(sexo == "Masculino" ? Icons.square_outlined : Icons.circle_outlined, desenho, preto, texto);
                        }
                      }, 
                      child: const Text("Adicionar")
                    ),
                  ],
                                ),
                );
              })
            );
          }
      );
    }

    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          appBar: AppBarAnimada(
            title: "Genograma",
            showAppBar: showAppBar,
            sair: genogramaVelho == genograma.value || genograma.value.elementos.isEmpty || salvou.value || !isEditable,
          ),
          body: Stack(
            children: [
              InteractiveViewer(
                onInteractionStart: (details) {
                  if(desenhoAtivo.value){
                    lastFocalPoint = details.localFocalPoint;
                  }
                },
                onInteractionUpdate: (details) {
                  if (desenhoAtivo.value) {
                    double altura = MediaQuery.of(context).size.height;
                    double largura = MediaQuery.of(context).size.width;
                    double distanciaRelativaAltura = altura * 0.2;
                    double distanciaRelativaLargura = largura * 0.2;

                    // Ajusta para a barra de aplicativo, se visível
                    if (showAppBar.value) {
                      altura -= MediaQuery.of(context).padding.top;
                      altura -= kToolbarHeight;
                    }

                    // Obtém o escala e a translação atuais
                    Matrix4 matrix = viewTransformationController.value.value;
                    double scale = matrix.getMaxScaleOnAxis();

                    // Acessa os componentes de translação diretamente da matriz
                    double tx = matrix[12]; // Equivalente a matrix.m14
                    double ty = matrix[13]; // Equivalente a matrix.m24

                    double viewportWidth = largura;
                    double viewportHeight = altura;

                    double dx = 0;
                    double dy = 0;

                    // Determina os incrementos de movimento
                    // Move para a direita
                    if (largura - details.localFocalPoint.dx < distanciaRelativaLargura &&
                        lastFocalPoint.dx - details.localFocalPoint.dx <= 0 &&
                        desenhoAtual.value.tipo != TipoDesenho.linhaVertical) {
                      dx = -4; // Negativo para mover para a direita
                    }

                    // Move para a esquerda
                    if (details.localFocalPoint.dx < distanciaRelativaLargura * 1.5 &&
                        lastFocalPoint.dx - details.localFocalPoint.dx >= 0 &&
                        desenhoAtual.value.tipo != TipoDesenho.linhaVertical) {
                      dx = 4; // Positivo para mover para a esquerda
                    }

                    // Move para baixo
                    if (altura - details.localFocalPoint.dy < distanciaRelativaAltura &&
                        lastFocalPoint.dy - details.localFocalPoint.dy <= 0 &&
                        desenhoAtual.value.tipo != TipoDesenho.linhaHorizontal &&
                        desenhoAtual.value.tipo != TipoDesenho.linhaSeparacao) {
                      dy = -4; // Negativo para mover para baixo
                    }

                    // Move para cima
                    if (details.localFocalPoint.dy < distanciaRelativaAltura &&
                        lastFocalPoint.dy - details.localFocalPoint.dy >= 0 &&
                        desenhoAtual.value.tipo != TipoDesenho.linhaHorizontal &&
                        desenhoAtual.value.tipo != TipoDesenho.linhaSeparacao) {
                      dy = 4; // Positivo para mover para cima
                    }

                    // Atualiza os valores de translação
                    tx += dx;
                    ty += dy;

                    // Calcula os valores mínimos e máximos de translação
                    double minX = viewportWidth - (4000 * scale);
                    double maxX = 0;
                    double minY = viewportHeight - (2000 * scale);
                    double maxY = 0;

                    // Trata casos em que o conteúdo é menor que o viewport
                    if (minX > maxX) {
                      minX = maxX = (viewportWidth - (4000 * scale)) / 2;
                    }
                    if (minY > maxY) {
                      minY = maxY = (viewportHeight - (2000 * scale)) / 2;
                    }

                    // Restringe os valores de translação para evitar excesso de rolagem
                    tx = tx.clamp(minX, maxX);
                    ty = ty.clamp(minY, maxY);

                    // Atualiza a matriz de transformação
                    Matrix4 newMatrix = Matrix4.identity()
                      ..scale(scale)
                      ..translate(tx / scale, ty / scale);

                    viewTransformationController.value.value = newMatrix;

                    lastFocalPoint = details.localFocalPoint;
                  }
                },
                // boundaryMargin: EdgeInsets.all(100),
                panEnabled: !desenhoAtivo.value,
                scaleEnabled: !desenhoAtivo.value,
                transformationController: viewTransformationController.value,
                constrained: false,
                minScale: .2,
                maxScale: 6,
                child: Container(
                  width: 4000,
                  height: 2000,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: amareloEscuro, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: QuadroBrancoGenograma(
                    corDesenho: corDesenho,
                    genograma: genograma, 
                    desenhoAtual: desenhoAtual,
                    canvasGlobalKey: canvasGlobalKey,
                    desenhoAtivo: desenhoAtivo,
                    tipoDesenho: tipoDesenho,
                    borrachaAtiva: borrachaAtiva,
                    edicaoAtiva: edicaoAtiva,
                    edicaoTextoAtiva: edicaoTextoAtiva,
                    temDesenho: temDesenho,
                    pontosDeConexao: pontosDeConexao,
                    ultimoPontoConexao: ultimoPontoConexao,
                    textoCirculo: textoCirculo,
                    temIndice: temIndice,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(
                    heroTag: null,
                    onPressed: () {
                      showAppBar.value = !showAppBar.value;
                      changeTransformations(viewTransformationController, viewTransformationController.value.value.getMaxScaleOnAxis(), -viewTransformationController.value.value.getTranslation()[0], -viewTransformationController.value.value.getTranslation()[1]);
                    },
                    child: Icon(
                      showAppBar.value ? Icons.expand_less : Icons.expand_more,
                      color: branco
                    ),
                  ),
                ),
              ),
              isEditable ? Align(
                alignment: Alignment.bottomLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Mudar a cor do desenho se for caneta
                    tipoDesenho.value == TipoDesenho.caneta ? 
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        //container que mostra a cor do desenho com uma borda amareloEscuro
                        child: GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                              color: corDesenho.value,
                              border: Border.all(color: amareloEscuro, width: 1.5),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            height: 55,
                            width: 55,
                          ),
                          onTap: () {
                            // mostrar ColorPicker para escolher a cor do desenho
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  surfaceTintColor: Colors.transparent,
                                  backgroundColor: Colors.transparent,
                                  scrollable: true,
                                  content: ColorPicker(
                                    enableShadesSelection: false,
                                    color: corDesenho.value,
                                    onColorChanged: (Color color) {
                                      opcaoSelecionada(Icons.draw_outlined, TipoDesenho.caneta, color);
                                    },
                                    pickersEnabled: const <ColorPickerType, bool>{
                                      ColorPickerType.accent: false,
                                      ColorPickerType.bw: false,
                                      ColorPickerType.primary: false,
                                      ColorPickerType.wheel: true,
                                      ColorPickerType.customSecondary: false,
                                      ColorPickerType.both: false,
                                      ColorPickerType.custom: false
                                    },
                                  ),
                                );
                              }
                            );
                          },
                        ),
                      ),
                    ) : const SizedBox(),
                    Row(
                      children: [
                        Visibility(
                          visible: (genogramaVelho != genograma.value && genograma.value.elementos.isNotEmpty),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FloatingActionButton(
                              heroTag: null,
                              backgroundColor: amarelo,
                              onPressed: () {
                                //Salvar genograma com todos os elementos desenhados
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Salvar Genograma"),
                                      content: const Text("Deseja salvar o Genograma?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          }, 
                                          child: const Text("Cancelar")
                                        ),
                                        if(genogramaVelho != null)
                                          TextButton(
                                            onPressed: () {
                                              var statusConexao = context.read<List<ConnectivityResult>>();
                                              bool isOffline = statusConexao.contains(ConnectivityResult.none);
                                              
                                              Navigator.of(context).pop();
                                              genograma.value.dataCriacao = DateTime.now();
                                              PacienteGenogramaController().saveGenograma(genograma.value, paciente?.id ?? '');
                                              salvou.value = true;
                                              Navigator.of(context).pop();

                                              final snackBar = SnackBar(
                                                elevation: 0,
                                                behavior: SnackBarBehavior.floating,
                                                backgroundColor: Colors.transparent,
                                                content: AwesomeSnackbarContent(
                                                  title: isOffline ? 'Salvo Localmente' : 'Sucesso',
                                                  message: isOffline ? 'Sem internet. O diagrama foi salvo e será enviado em breve.' : 'Diagrama atualizado!',
                                                  contentType: isOffline ? ContentType.warning : ContentType.success,
                                                ),
                                                duration: const Duration(seconds: 6),
                                              );
                                              ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(snackBar);
                                            }, 
                                            child: const Text("Salvar")
                                          ),
                                        TextButton(
                                          onPressed: () {
                                              var statusConexao = context.read<List<ConnectivityResult>>();
                                              bool isOffline = statusConexao.contains(ConnectivityResult.none);

                                              Navigator.of(context).pop();
                                              genograma.value.dataCriacao = DateTime.now();
                                              PacienteGenogramaController().saveNewGenograma(genograma.value, paciente?.id ?? '');
                                              salvou.value = true;
                                              Navigator.of(context).pop();

                                              final snackBar = SnackBar(
                                                elevation: 0,
                                                behavior: SnackBarBehavior.floating,
                                                backgroundColor: Colors.transparent,
                                                content: AwesomeSnackbarContent(
                                                  title: isOffline ? 'Salvo Localmente' : 'Sucesso',
                                                  message: isOffline ? 'Sem internet. O novo diagrama foi salvo e será enviado em breve.' : 'Novo diagrama salvo!',
                                                  contentType: isOffline ? ContentType.warning : ContentType.success,
                                                ),
                                                duration: const Duration(seconds: 6),
                                              );
                                              ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(snackBar);
                                          }, 
                                          child: const Text("Salvar novo")
                                        ),
                                      ],
                                    );
                                  }
                                );
                              },
                              child: const Icon(
                                Icons.save,
                                color: branco
                              ),
                            ),
                          ),
                        ),
                        ValueListenableBuilder<bool>(
                          valueListenable: undoRedoPilha.value.canUndo,
                          builder: (_, canUndo, __) {
                            return Visibility(
                              visible: (canUndo),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FloatingActionButton(
                                  heroTag: null,
                                  backgroundColor: amarelo,
                                  onPressed: canUndo
                                    ? () => undoRedoPilha.value.undo()
                                    : null,
                                  child: const Icon(
                                    Icons.undo_outlined,
                                    color: branco
                                  ),
                                ),
                              ),
                            );
                          }
                        ),
                        ValueListenableBuilder<bool>(
                          valueListenable: undoRedoPilha.value.canRedo,
                          builder: (_, canRedo, __) {
                            return Visibility(
                              visible: canRedo,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FloatingActionButton(
                                  heroTag: null,
                                  backgroundColor: amarelo,
                                  onPressed: canRedo ? () => undoRedoPilha.value.redo() : null,
                                  child: const Icon(
                                    Icons.redo_outlined,
                                    color: branco
                                  ),
                                ),
                              ),
                            );
                          }
                        ),
                      ],
                    ),
                  ],
                ),
              ) : Container(),
            ],
          ),
          floatingActionButton: isEditable ? SpeedDial(
            heroTag: null,
            direction: orientation == Orientation.portrait ? SpeedDialDirection.up : SpeedDialDirection.left,
            backgroundColor: verde,
            icon: iconeDesenhoAtivo.value,
            activeIcon: Icons.expand_more,
            spacing: 0,
            spaceBetweenChildren: 5,
            openCloseDial: opcoesAbertas,
            foregroundColor: branco,
            activeBackgroundColor: verde,
            activeForegroundColor: branco,
            renderOverlay: false,
            children: [
              SpeedDialChild(
                  labelStyle: const TextStyle(color: branco),
                  backgroundColor: verde,
                  foregroundColor: branco,
                  labelBackgroundColor: verde,
                  child: const Icon(Icons.square_outlined),
                  onTap: () {
                    elementoPadrao("Masculino");
                  },
              ),
              SpeedDialChild(
                  labelStyle: const TextStyle(color: branco),
                  backgroundColor: verde,
                  foregroundColor: branco,
                  labelBackgroundColor: verde,
                  child: const Icon(Icons.circle_outlined),
                  onTap: () {
                   elementoPadrao("Feminino");
                  },
              ),
              SpeedDialChild(
                  labelStyle: const TextStyle(color: branco),
                  backgroundColor: verde,
                  foregroundColor: branco,
                  labelBackgroundColor: verde,
                  child: const Icon(Icons.horizontal_rule_outlined),
                  onTap: () {
                    opcaoSelecionada(Icons.horizontal_rule_outlined, TipoDesenho.linha, preto);
                  },
              ),
              SpeedDialChild(
                  labelStyle: const TextStyle(color: branco),
                  backgroundColor: verde,
                  foregroundColor: branco,
                  labelBackgroundColor: verde,
                  child: const Icon(LinhaSeparacao.linhaSeparacao),
                  onTap: () {
                    opcaoSelecionada(LinhaSeparacao.linhaSeparacao, TipoDesenho.linhaSeparacao, preto);
                  },
              ),
              SpeedDialChild(
                  labelStyle: const TextStyle(color: branco),
                  backgroundColor: verde,
                  foregroundColor: branco,
                  labelBackgroundColor: verde,
                  child: const Icon(Icons.draw_outlined),
                  onTap: () {
                    opcaoSelecionada(Icons.draw_outlined, TipoDesenho.caneta, preto);
                  },
              ),
              SpeedDialChild(
                  labelStyle: const TextStyle(color: branco),
                  backgroundColor: verde,
                  foregroundColor: branco,
                  labelBackgroundColor: verde,
                  child: const Icon(Icons.text_fields),
                  onTap: () {
                    TextEditingController textController = TextEditingController();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return MediaQuery(
                          data: MediaQuery.of(context).copyWith(viewInsets: EdgeInsets.zero),
                          child: AlertDialog(
                                                title: const Text('Digite o Texto da sua Anotação'),
                                                content:TextFormField(
                          controller: textController,
                          maxLines: 5,
                          keyboardType: TextInputType.multiline,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                          ),
                          cursorColor: preto,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: 'Anotação',
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 13,
                            ),
                          ),
                                                ),
                                                actions: <Widget>[
                          TextButton(
                            child: const Text('Cancelar'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Adicionar'),
                            onPressed: () {
                              opcaoSelecionada(Icons.text_fields, TipoDesenho.texto, preto, textController.text);
                              Navigator.of(context).pop();
                            },
                          ),
                                                ],
                          ),
                        );
                      },
                    );
                  },
              ),
              SpeedDialChild(
                  labelStyle: const TextStyle(color: branco),
                  backgroundColor: verde,
                  foregroundColor: branco,
                  labelBackgroundColor: verde,
                  child: const Icon(Icons.pan_tool_alt_outlined),
                  onTap: () {
                    iconeDesenhoAtivo.value = Icons.pan_tool_alt_outlined;
                    edicaoAtiva.value = true;
                    edicaoTextoAtiva.value = false;
                    desenhoAtivo.value = true;
                    temDesenho.value = false;
                  },
              ),
              SpeedDialChild(
                  labelStyle: const TextStyle(color: branco),
                  backgroundColor: verde,
                  foregroundColor: branco,
                  labelBackgroundColor: verde,
                  child: const Icon(Icons.backspace_outlined),
                  onTap: () {
                    iconeDesenhoAtivo.value = Icons.backspace_outlined;
                    tipoDesenho.value = TipoDesenho.semDesenho;
                    borrachaAtiva.value = true;
                    edicaoAtiva.value = false;
                    edicaoTextoAtiva.value = false;
                    desenhoAtivo.value = false;
                  },
              ),
            ],
          ) : null
        );
      }
    );
  }
}

class LinhaSeparacao {
  static const IconData linhaSeparacao = IconData(
    0xe000,
    fontFamily: 'LinhaSeparacao',
  );
}