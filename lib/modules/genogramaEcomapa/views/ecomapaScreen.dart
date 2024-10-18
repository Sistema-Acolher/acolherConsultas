import 'package:acolherconsultas/modules/genogramaEcomapa/controllers/ecomapaController.dart';
import 'package:acolherconsultas/modules/genogramaEcomapa/models/ecomapa.dart';
import 'package:acolherconsultas/modules/genogramaEcomapa/models/elementosDesenho.dart';
import 'package:acolherconsultas/modules/genogramaEcomapa/models/tipoDesenho.dart';
import 'package:acolherconsultas/modules/genogramaEcomapa/models/undoRedoPilha.dart';
import 'package:acolherconsultas/modules/pacientes/models/paciente.dart';
import 'package:acolherconsultas/modules/genogramaEcomapa/views/quadroBrancoEcomapa.dart';
import 'package:acolherconsultas/shared/colors.dart';
import 'package:acolherconsultas/shared/components/bars/animatedAppbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class EcomapaScreen extends HookWidget {
  final Ecomapa? ecomapaVelho;
  final Paciente? paciente;
  final bool isEditable;
  
  const EcomapaScreen({
    super.key,
    this.ecomapaVelho,
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
    final ValueNotifier<MapEntry<ElementosDesenho, Operacoes>> desenhoEditado = useState(MapEntry(ElementosDesenho(
      id: 0,
      pontos: [],
      tipo: TipoDesenho.semDesenho,
      tamanho: 0,
      texto: '',
    ), Operacoes.adicao));
    final ValueNotifier<Ecomapa> ecomapa = useState( ecomapaVelho ??
      Ecomapa(
        elementos: [
          ElementosDesenho(
            id: 1,
            tamanho: 80,
            tipo: TipoDesenho.circuloEcomapa,
            pontos: [const Offset(2000, 1000)],
            texto: paciente?.nome ?? '',
            isPaciente: true,
          )
        ],
        id: '1',
        height: 1000.0,
        width: 1000.0,
        scale: 1.0,
        dataCriacao: DateTime.now(),
        pacienteRaiz: {
          'nome': paciente?.nome ?? '',
          'sexo': paciente?.sexo ?? '',
          'idade': Paciente.calcularIdade(paciente?.dataNasc ?? DateTime.now()),
        }
      )
    );
    final ValueNotifier<bool> desenhoAtivo = useState(false);
    final ValueNotifier<bool> borrachaAtiva = useState(false);
    final ValueNotifier<bool> edicaoAtiva = useState(false);
    final ValueNotifier<bool> edicaoTextoAtiva = useState(false);
    final ValueNotifier<TipoDesenho> tipoDesenho = useState(TipoDesenho.semDesenho);
    final ValueNotifier<String> textoCirculo = useState("");
    final ValueNotifier<IconData> iconeDesenhoAtivo = useState(Icons.add_box_outlined);
    final ValueNotifier<List<Offset>> pontosDeConexao = useState([]);
    final ValueNotifier<Offset> ultimoPontoConexao = useState(Offset.zero);
    final ValueNotifier<bool> salvou = useState(false);
    final ValueNotifier<bool> temDesenho = useState(false);

    final undoRedoPilha = useState(
      UndoRedoPilha(
        desenhosNotifier: ecomapa,
        desenhoAtualNotifier: desenhoAtual,
        desenhoEditadoNotifier: desenhoEditado
      ),
    );

    final ValueNotifier<bool> opcoesAbertas = useState(false);
    final ValueNotifier<TransformationController> viewTransformationController;
    final ValueNotifier<double> zoomFactor;
    final ValueNotifier<double> xTranslate;
    final ValueNotifier<double> yTranslate;
    
    final ValueNotifier<TextEditingController> tituloController = useState(TextEditingController());
    final ValueNotifier<String?> ligacaoValue = useState<String?>("fraca");
    final ValueNotifier<String?> energiaGastaPacienteValue = useState<String?>("fraca");
    final ValueNotifier<String?> energiaGastaParteValue = useState<String?>("fraca");
    final ligacao = useState<String?>("fraca");
    final energiaGastaPaciente = useState<String?>("fraca");
    final energiaGastaParte = useState<String?>("fraca");


    final combinedNotifier = ValueNotifier<String?>(
      '${ligacao.value}-${energiaGastaPaciente.value}-${energiaGastaParte.value}'
    );

    void updateCombinedNotifier() {
      combinedNotifier.value = '${ligacao.value}-${energiaGastaPaciente.value}-${energiaGastaParte.value}';
    }

    ligacao.addListener(updateCombinedNotifier);
    energiaGastaPaciente.addListener(updateCombinedNotifier);
    energiaGastaParte.addListener(updateCombinedNotifier);


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

    opcaoSelecionada(IconData iconeAtivo, TipoDesenho tipo, [String texto = ""]){
      edicaoAtiva.value = false;
      edicaoTextoAtiva.value = false;
      temDesenho.value = false;
      iconeDesenhoAtivo.value = iconeAtivo;
      tipoDesenho.value = tipo;
      desenhoAtivo.value = true;
      textoCirculo.value = texto;
      ligacaoValue.value = ligacao.value;
      energiaGastaPacienteValue.value = energiaGastaPaciente.value;
      energiaGastaParteValue.value = energiaGastaParte.value;
      tituloController.value.clear();
      ligacao.value = "fraca";
      energiaGastaPaciente.value = "fraca";
      energiaGastaParte.value = "fraca";
    }

    Offset lastFocalPoint = Offset.zero;

    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          appBar: AppBarAnimada(
            title: "Ecomapa",
            showAppBar: showAppBar,
            sair: (ecomapa.value.elementos.length == 1 || salvou.value) || !isEditable,
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
                    // Mover para a direita
                    if(largura - details.localFocalPoint.dx < distanciaRelativaLargura && lastFocalPoint.dx - details.localFocalPoint.dx <= 0 && desenhoAtual.value.tipo != TipoDesenho.linhaVertical){
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
                    if(altura - details.localFocalPoint.dy < distanciaRelativaAltura && lastFocalPoint.dy - details.localFocalPoint.dy <= 0 && desenhoAtual.value.tipo != TipoDesenho.linhaHorizontal && desenhoAtual.value.tipo != TipoDesenho.linhaSeparacao){
                      changeTransformations(
                        viewTransformationController,
                        viewTransformationController.value.value.getMaxScaleOnAxis(), 
                        -viewTransformationController.value.value.getTranslation()[0], 
                        -viewTransformationController.value.value.getTranslation()[1] + (4)
                      );
                    }
                    // Mover para esquerda
                    if(details.localFocalPoint.dx < distanciaRelativaLargura * 1.5 && lastFocalPoint.dx - details.localFocalPoint.dx >= 0 && desenhoAtual.value.tipo != TipoDesenho.linhaVertical){
                      changeTransformations(
                        viewTransformationController, 
                        viewTransformationController.value.value.getMaxScaleOnAxis(), 
                        -viewTransformationController.value.value.getTranslation()[0] - (4), 
                        -viewTransformationController.value.value.getTranslation()[1]
                      );
                    }
                    // Mover para cima
                    if(details.localFocalPoint.dy < distanciaRelativaAltura && lastFocalPoint.dy - details.localFocalPoint.dy >= 0 && desenhoAtual.value.tipo != TipoDesenho.linhaHorizontal && desenhoAtual.value.tipo != TipoDesenho.linhaSeparacao){
                      changeTransformations(
                        viewTransformationController, 
                        viewTransformationController.value.value.getMaxScaleOnAxis(), 
                        -viewTransformationController.value.value.getTranslation()[0], 
                        -viewTransformationController.value.value.getTranslation()[1] - (4)
                      );
                    }
                    lastFocalPoint = details.localFocalPoint;
                  }
                },
                boundaryMargin: const EdgeInsets.all(100),
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
                    border: Border.all(color: amarelo, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: QuadroBrancoEcomapa(
                    ecomapa: ecomapa, 
                    desenhoAtual: desenhoAtual,
                    canvasGlobalKey: canvasGlobalKey,
                    desenhoAtivo: desenhoAtivo,
                    desenhoEditado: desenhoEditado,
                    tipoDesenho: tipoDesenho,
                    borrachaAtiva: borrachaAtiva,
                    edicaoAtiva: edicaoAtiva,
                    edicaoTextoAtiva: edicaoTextoAtiva,
                    pontosDeConexao: pontosDeConexao,
                    ultimoPontoConexao: ultimoPontoConexao,
                    textoCirculo: textoCirculo,
                    temDesenho: temDesenho,
                    ligacao: ligacaoValue,
                    energiaGastaPaciente: energiaGastaPacienteValue,
                    energiaGastaParte: energiaGastaParteValue,
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
                          //Salvar ecomapa com todos os elementos desenhados
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Salvar Ecomapa"),
                                content: const Text("Deseja salvar o Ecomapa?"),
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
                                      ecomapa.value.dataCriacao = DateTime.now();
                                      PacienteEcomapaController().saveEcomapa(ecomapa.value, paciente?.id ?? '');
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
              ) : Container()
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
                  child: const Icon(Icons.circle_outlined),
                  onTap: () {
                    showDialog(
                      context: context, 
                      builder: (context) {
                        var globalKey = GlobalKey<FormState>();
                        return ValueListenableBuilder(
                          valueListenable: combinedNotifier,
                          builder: ((context, value, child) {
                            return AlertDialog(
                            scrollable: true,
                            title: const Text("Adicionar Relacionamento"),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0))
                            ),
                            content: Builder(
                              builder: (context) {
                                var height = MediaQuery.of(context).size.height;
                                var width = MediaQuery.of(context).size.width;
                                return Form(
                                  key: globalKey,
                                  child: SizedBox(
                                    height: height * 0.4,
                                    width: width * 0.95,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              TextFormField(
                                                decoration: const InputDecoration(
                                                  hintText: "Título da Relação"
                                                ),
                                                controller: tituloController.value,
                                                validator: (value) {
                                                  if(value == null || value.isEmpty){
                                                    return "Título não pode ser vazio";
                                                  }
                                                  return null;
                                                },
                                              ),
                                              const SizedBox(height: 30),
                                              const Text(
                                                "Força da relação",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  const Text("Fraca"),
                                                  Radio(
                                                    value: "fraca",
                                                    groupValue: ligacao.value,
                                                    onChanged: (value) {
                                                      ligacao.value = value!;
                                                    },
                                                  ),
                                                  const Text("Média"),
                                                  Radio(
                                                    value: "media",
                                                    groupValue: ligacao.value,
                                                    onChanged: (value) {
                                                      ligacao.value = value!;
                                                    },
                                                  ),
                                                  const Text("Forte"),
                                                  Radio(
                                                    value: "forte",
                                                    groupValue: ligacao.value,
                                                    onChanged: (value) {
                                                      ligacao.value = value!;
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 30),
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Energia gasta pelo paciente",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  const Text("Fraca"),
                                                  Radio(
                                                    value: "fraca",
                                                    groupValue: energiaGastaPaciente.value,
                                                    onChanged: (value) {
                                                      energiaGastaPaciente.value = value!;
                                                    },
                                                  ),
                                                  const Text("Média"),
                                                  Radio(
                                                    value: "media",
                                                    groupValue: energiaGastaPaciente.value,
                                                    onChanged: (value) {
                                                      energiaGastaPaciente.value = value!;
                                                    },
                                                  ),
                                                  const Text("Forte"),
                                                  Radio(
                                                    value: "forte",
                                                    groupValue: energiaGastaPaciente.value,
                                                    onChanged: (value) {
                                                      energiaGastaPaciente.value = value!;
                                                    },
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              const Text(
                                                "Energia gasta pela parte",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  const Text("Fraca"),
                                                  Radio(
                                                    value: "fraca",
                                                    groupValue: energiaGastaParte.value,
                                                    onChanged: (value) {
                                                      energiaGastaParte.value = value!;
                                                    },
                                                  ),
                                                  const Text("Média"),
                                                  Radio(
                                                    value: "media",
                                                    groupValue: energiaGastaParte.value,
                                                    onChanged: (value) {
                                                      energiaGastaParte.value = value!;
                                                    },
                                                  ),
                                                  const Text("Forte"),
                                                  Radio(
                                                    value: "forte",
                                                    groupValue: energiaGastaParte.value,
                                                    onChanged: (value) {
                                                      energiaGastaParte.value = value!;
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
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
                                    opcaoSelecionada(Icons.circle_outlined, TipoDesenho.circuloEcomapa, tituloController.value.text);
                                  }
                                }, 
                                child: const Text("Adicionar")
                              ),
                            ],
                          );
                          })
                        );
                      }
                    );
                  },
              ),
              SpeedDialChild(
                  labelStyle: const TextStyle(color: branco),
                  backgroundColor: verde,
                  foregroundColor: branco,
                  labelBackgroundColor: verde,
                  child: const Icon(Icons.draw_outlined),
                  onTap: () {
                    opcaoSelecionada(Icons.draw_outlined, TipoDesenho.caneta);
                  },
              ),
              SpeedDialChild(
                  labelStyle: const TextStyle(color: branco),
                  backgroundColor: verde,
                  foregroundColor: branco,
                  labelBackgroundColor: verde,
                  child: const Icon(Icons.text_fields),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        TextEditingController textController = TextEditingController();
                        return AlertDialog(
                      title: const Text('Digite o Texto da sua Anotação'),
                      content:TextFormField(
                        controller: textController,
                        maxLines: 5,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.multiline,
                        textCapitalization: TextCapitalization.sentences,
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
                            opcaoSelecionada(Icons.text_fields, TipoDesenho.texto, textController.text);
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
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
                  child: const Icon(Icons.edit_note_outlined),
                  onTap: () {
                    iconeDesenhoAtivo.value = Icons.edit_note_outlined;
                    edicaoTextoAtiva.value = true;
                    edicaoAtiva.value = false;
                    desenhoAtivo.value = true;
                    temDesenho.value = true;
                  },
              ),
              SpeedDialChild(
                  labelStyle: const TextStyle(color: branco),
                  backgroundColor: verde,
                  foregroundColor: branco,
                  labelBackgroundColor: verde,
                  child: const Icon(Icons.backspace_outlined),
                  onTap: () {
                    desenhoAtivo.value = false;
                    iconeDesenhoAtivo.value = Icons.backspace_outlined;
                    borrachaAtiva.value = true;
                    edicaoAtiva.value = false;
                    edicaoTextoAtiva.value = false;
                  },
              ),
            ],
          ) : null
        );
      }
    );
  }
}