import 'package:acolherconsultas/modules/genogramaEcomapa/controllers/genogramaController.dart';
import 'package:acolherconsultas/modules/genogramaEcomapa/models/elementosDesenho.dart';
import 'package:acolherconsultas/modules/genogramaEcomapa/models/genograma.dart';
import 'package:acolherconsultas/modules/genogramaEcomapa/models/tipoDesenho.dart';
import 'package:acolherconsultas/modules/genogramaEcomapa/models/undoRedoPilha.dart';
import 'package:acolherconsultas/modules/pacientes/models/paciente.dart';
import 'package:acolherconsultas/modules/genogramaEcomapa/views/quadroBrancoGenograma.dart';
import 'package:acolherconsultas/shared/colors.dart';
import 'package:acolherconsultas/shared/components/bars/animatedAppbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter/services.dart';

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
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
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
        id: '1',
        height: 1000.0,
        width: 1000.0,
        scale: 1.0,
        dataCriacao: DateTime.now(),
        pacienteRaiz: {
          'nome': paciente?.nome ?? 'Paciente',
          'sexo': paciente?.sexo ?? 'Masculino',
          'idade': Paciente.calcularIdade(paciente?.dataNasc ?? DateTime.now()),
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
    final ValueNotifier<TipoDesenho> tipoDesenho = useState(TipoDesenho.semDesenho);
    final ValueNotifier<IconData> iconeDesenhoAtivo = useState(Icons.add_box_outlined);
    final ValueNotifier<List<Offset>> pontosDeConexao = useState([]);
    final ValueNotifier<Offset> ultimoPontoConexao = useState(Offset.zero);
    final ValueNotifier<bool> salvou = useState(false);

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

    opcaoSelecionada(IconData iconeAtivo, TipoDesenho tipo){
      iconeDesenhoAtivo.value = iconeAtivo;
      tipoDesenho.value = tipo;
      desenhoAtivo.value = true;
      //viewTransformationController.value.value = Matrix4.identity()..setEntry(3, 0, -1)..setEntry(3, 1, -1);
    }
    Offset _lastFocalPoint = Offset.zero;

    _centerOnTouch() {
        if (_lastFocalPoint == Offset.zero) return;

        // Get the size of the InteractiveViewer's child
        final RenderBox renderBox = context.findRenderObject() as RenderBox;
        final Size size = renderBox.size;

        // Calculate the translation required to center on the touch point
        final double dx = -_lastFocalPoint.dx + size.width / 2;
        final double dy = -_lastFocalPoint.dy + size.height / 2;

        // Apply the translation to the current transformation matrix
        final Matrix4 currentMatrix = viewTransformationController.value.value;
        final Matrix4 translationMatrix = Matrix4.identity()..translate(dx, dy);

        // Update the transformation controller's value
        viewTransformationController.value.value = currentMatrix * translationMatrix;
    }

    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          appBar: AppBarAnimada(
            title: "Genograma",
            showAppBar: showAppBar,
            sair: (genograma.value.elementos.length == 1 || salvou.value) || !isEditable,
          ),
          body: Stack(
            children: [
              InteractiveViewer(
                onInteractionStart: (details) {
                  if(desenhoAtivo.value){
                    _lastFocalPoint = details.localFocalPoint;
                  }
                },
                onInteractionUpdate: (details) {
                  if (desenhoAtivo.value) {
                    double altura = MediaQuery.of(context).size.height;
                    double largura = MediaQuery.of(context).size.width;
                    double distanciaRelativaAltura = altura * 0.2;
                    double distanciaRelativaLargura = largura * 0.2;
                    // Mover para a direita
                    if(largura - details.localFocalPoint.dx < distanciaRelativaLargura && _lastFocalPoint.dx - details.localFocalPoint.dx <= 0 && desenhoAtual.value.tipo != TipoDesenho.linhaVertical){
                      changeTransformations(
                        viewTransformationController, 
                        viewTransformationController.value.value.getMaxScaleOnAxis(), 
                        -viewTransformationController.value.value.getTranslation()[0] + (4), 
                        -viewTransformationController.value.value.getTranslation()[1]
                      );
                    }
                    // Mover para a baixo
                    if(showAppBar.value){
                      altura -= MediaQuery.of(context).padding.top;
                      altura -= kToolbarHeight;
                    }
                    if(altura - details.localFocalPoint.dy < distanciaRelativaAltura && _lastFocalPoint.dy - details.localFocalPoint.dy <= 0 && desenhoAtual.value.tipo != TipoDesenho.linhaHorizontal && desenhoAtual.value.tipo != TipoDesenho.linhaSeparacao){
                      changeTransformations(
                        viewTransformationController,
                        viewTransformationController.value.value.getMaxScaleOnAxis(), 
                        -viewTransformationController.value.value.getTranslation()[0], 
                        -viewTransformationController.value.value.getTranslation()[1] + (4)
                      );
                    }
                    // Mover para esquerda
                    if(details.localFocalPoint.dx < distanciaRelativaLargura * 1.5 && _lastFocalPoint.dx - details.localFocalPoint.dx >= 0 && desenhoAtual.value.tipo != TipoDesenho.linhaVertical){
                      changeTransformations(
                        viewTransformationController, 
                        viewTransformationController.value.value.getMaxScaleOnAxis(), 
                        -viewTransformationController.value.value.getTranslation()[0] - (4), 
                        -viewTransformationController.value.value.getTranslation()[1]
                      );
                    }
                    // Mover para cima
                    if(details.localFocalPoint.dy < distanciaRelativaAltura && _lastFocalPoint.dy - details.localFocalPoint.dy >= 0 && desenhoAtual.value.tipo != TipoDesenho.linhaHorizontal && desenhoAtual.value.tipo != TipoDesenho.linhaSeparacao){
                      changeTransformations(
                        viewTransformationController, 
                        viewTransformationController.value.value.getMaxScaleOnAxis(), 
                        -viewTransformationController.value.value.getTranslation()[0], 
                        -viewTransformationController.value.value.getTranslation()[1] - (4)
                      );
                    }
                    _lastFocalPoint = details.localFocalPoint;
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
                    genograma: genograma, 
                    desenhoAtual: desenhoAtual,
                    canvasGlobalKey: canvasGlobalKey,
                    desenhoAtivo: desenhoAtivo,
                    tipoDesenho: tipoDesenho,
                    borrachaAtiva: borrachaAtiva,
                    pontosDeConexao: pontosDeConexao,
                    ultimoPontoConexao: ultimoPontoConexao,
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
                child: Row(
                  children: [
                    Padding(
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
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      genograma.value.dataCriacao = DateTime.now();
                                      PacienteGenogramaController().saveGenograma(genograma.value, paciente?.id ?? '');
                                      salvou.value = true;
                                    }, 
                                    child: const Text("Salvar")
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
                    ValueListenableBuilder<bool>(
                      valueListenable: undoRedoPilha.value.canUndo,
                      builder: (_, canUndo, __) {
                        print("Can Undo: $canUndo");
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
                        print("Can Redo: $canRedo");
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
            spaceBetweenChildren: 1,
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
                    opcaoSelecionada(Icons.square_outlined, TipoDesenho.quadrado);
                  },
              ),
              SpeedDialChild(
                  labelStyle: const TextStyle(color: branco),
                  backgroundColor: verde,
                  foregroundColor: branco,
                  labelBackgroundColor: verde,
                  child: const Icon(Icons.circle_outlined),
                  onTap: () {
                    opcaoSelecionada(Icons.circle_outlined, TipoDesenho.circulo);
                  },
              ),
              //Circulo falecido
              SpeedDialChild(
                  labelStyle: const TextStyle(color: branco),
                  backgroundColor: verde,
                  foregroundColor: branco,
                  labelBackgroundColor: verde,
                  child: const Icon(Icons.cancel_outlined),
                  onTap: () {
                    opcaoSelecionada(Icons.cancel_outlined, TipoDesenho.circuloFalecido);
                  },
              ),
              SpeedDialChild(
                  labelStyle: const TextStyle(color: branco),
                  backgroundColor: verde,
                  foregroundColor: branco,
                  labelBackgroundColor: verde,
                  child: const Icon(Icons.horizontal_rule_outlined),
                  onTap: () {
                    opcaoSelecionada(Icons.horizontal_rule_outlined, TipoDesenho.linhaHorizontal);
                  },
              ),
              SpeedDialChild(
                  labelStyle: const TextStyle(color: branco),
                  backgroundColor: verde,
                  foregroundColor: branco,
                  labelBackgroundColor: verde,
                  child: const Icon(Icons.vertical_align_bottom_outlined),
                  onTap: () {
                    opcaoSelecionada(Icons.vertical_align_bottom_outlined, TipoDesenho.linhaVertical);
                  },
              ),
              SpeedDialChild(
                  labelStyle: const TextStyle(color: branco),
                  backgroundColor: verde,
                  foregroundColor: branco,
                  labelBackgroundColor: verde,
                  child: const Icon(Icons.text_fields_outlined),
                  onTap: () {
                    opcaoSelecionada(Icons.text_fields_outlined, TipoDesenho.texto);
                  },
              ),
              SpeedDialChild(
                  labelStyle: const TextStyle(color: branco),
                  backgroundColor: verde,
                  foregroundColor: branco,
                  labelBackgroundColor: verde,
                  child: const Icon(Icons.help),
                  onTap: () {
                    opcaoSelecionada(Icons.help, TipoDesenho.circuloDesconhecido);
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
                    borrachaAtiva.value = true;
                  },
              ),
            ],
          ) : null
        );
      }
    );
  }
}