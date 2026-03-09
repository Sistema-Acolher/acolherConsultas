import 'package:acolherconsultas/modules/casasDeApoio/models/casaDeApoio.dart';
import 'package:acolherconsultas/modules/pacientes/controllers/pacienteController.dart';
import 'package:acolherconsultas/modules/pacientes/models/paciente.dart';
import 'package:acolherconsultas/modules/pacientes/states/pacienteState.dart';
import 'package:acolherconsultas/shared/colors.dart';
import 'package:acolherconsultas/shared/components/bars/pacienteAppbar.dart';
import 'package:acolherconsultas/shared/components/buttons/standartRoundButton.dart';
import 'package:acolherconsultas/shared/components/inputs/inputDynamicTextField.dart';
import 'package:acolherconsultas/shared/components/inputs/inputTexto.dart';
import 'package:acolherconsultas/shared/components/text/confirmacao.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';

class PacienteCadastroContinuacao extends StatefulWidget {
  const PacienteCadastroContinuacao({super.key, required this.cadastroPacienteState, required this.paciente});
  final CadastroPacienteState cadastroPacienteState;
  final Paciente? paciente;


  @override
  State<PacienteCadastroContinuacao> createState() => PacienteCadastroContinuacaoState();
}

class PacienteCadastroContinuacaoState extends State<PacienteCadastroContinuacao> {
  final _formKey = GlobalKey<FormState>();
  final List<String> listaDeMedicamentosUsados = [];
  final List<String> listaDeDificuldadesEscolares = [];
  final List<String> listaDeAcompanhamentosProfissionais = [];
  final List<String> listaDeVacinasFaltantes = [];
  final List<dynamic> listaDeAulasECursos = [];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PacienteAppbar(
          paciente: widget.paciente,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: StandartRoundButton(
          text: "Salvar",
          icon: Symbols.book,
          onPressed: () {
            if (_formKey.currentState!.validate() &&
                widget.cadastroPacienteState.sexo.text.isNotEmpty) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                    contentPadding:
                        const EdgeInsets.only(top: 10, left: 10, right: 10),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    content: Confirmacao(
                        body: false,
                        nome: "",
                        dataHorario: DateTime.now(),
                        confimacao: () async {
                          showLoading(context);
                          var actualContext = context;

                          var statusConexao = context.read<List<ConnectivityResult>>();
                          bool isOffline = statusConexao.contains(ConnectivityResult.none);

                          // Salva o mensageiro ANTES de desempilhar as telas
                          final messenger = ScaffoldMessenger.of(context);

                          if (isOffline) {
                            // 🛑 MODO OFFLINE
                            PacientesController().cadastrarPaciente(
                                widget.cadastroPacienteState.cadastro(),
                                Provider.of<CasaDeApoio>(context, listen: false));
                            
                            // FECHANDO AS 4 CAMADAS PARA VOLTAR À LISTA
                            Navigator.pop(actualContext); // 1. Fecha o Loading
                            Navigator.pop(actualContext); // 2. Fecha o Alert de Confirmação
                            Navigator.pop(actualContext); // 3. Fecha a Tela de Continuação
                            Navigator.pop(actualContext); // 4. Fecha a Tela de Cadastro 1
                            
                            final snackBar = SnackBar(
                              elevation: 0, behavior: SnackBarBehavior.floating, backgroundColor: Colors.transparent,
                              content: AwesomeSnackbarContent(
                                title: 'Salvo Localmente',
                                message: 'Sem internet. O paciente foi salvo no aparelho e será enviado em breve.',
                                contentType: ContentType.warning,
                              ),
                              duration: const Duration(seconds: 6),
                            );
                            messenger..hideCurrentSnackBar()..showSnackBar(snackBar);
                            
                          } else {
                            // ✅ MODO ONLINE
                            await PacientesController().cadastrarPaciente(
                                widget.cadastroPacienteState.cadastro(),
                                Provider.of<CasaDeApoio>(context, listen: false))
                            .then((value) {
                                
                              Navigator.pop(actualContext); // 1. Fecha o Loading
                              Navigator.pop(actualContext); // 2. Fecha o Alert de Confirmação
                              Navigator.pop(actualContext); // 3. Fecha a Tela de Continuação
                              Navigator.pop(actualContext); // 4. Fecha a Tela de Cadastro 1
                              
                              final snackBar = SnackBar(
                                elevation: 0, behavior: SnackBarBehavior.floating, backgroundColor: Colors.transparent,
                                content: AwesomeSnackbarContent(
                                  title: 'Sucesso', message: 'Paciente cadastrado com sucesso!', contentType: ContentType.success,
                                ),
                                duration: const Duration(seconds: 6),
                              );
                              messenger..hideCurrentSnackBar()..showSnackBar(snackBar);
                              
                            }).onError((error, stackTrace) {
                              Navigator.pop(actualContext); // Fecha só o loading em caso de erro
                              final snackBar = SnackBar(
                                elevation: 0, behavior: SnackBarBehavior.floating, backgroundColor: Colors.transparent,
                                content: AwesomeSnackbarContent(
                                  title: 'Erro', message: error.toString(), contentType: ContentType.failure,
                                ),
                                duration: const Duration(seconds: 6),
                              );
                              messenger..hideCurrentSnackBar()..showSnackBar(snackBar);
                            });
                          }
                        })),
              );
            }
          },
        ),
        body: Center(
          child: Container(
            // Define o espaçamento em volta da decoração e do widget filho do Container.
            margin: const EdgeInsets.all(20),
            // Form é um widget que implementa um formulário.
            child: Form(
              // Atribui uma chave única ao formulário para validação.
              key: _formKey,
              // ListView é um widget que implementa uma lista de widgets filhos, onde os itens são organizados em uma lista vertical e com scroll.
              child: ListView(
                children: [
                  // Cada um dos campos de entrada para o cadastro de pacientes, utilizando os componentes criados.
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: InputTextoAcolher(
                      label: "Escola:",
                      controller: widget.cadastroPacienteState.nomeEscola,
                      keyboardType: TextInputType.name,
                      inputFormatter: [
                        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z\u00C0-\u00D6\u00D8-\u00F6\u00F8-\u024F' 0-9]")),
                        LengthLimitingTextInputFormatter(50),
                      ],
                      emptyMessage: "Informe a escola:",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: InputTextoAcolher(
                      label: "Série/Turno:",
                      controller: widget.cadastroPacienteState.serieTurnoEscola,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: InputDynamicTextField(
                      label: "Dificuldades escolares:",
                      controller: widget.cadastroPacienteState.dificuldadesEscolares,
                      inputValues: listaDeDificuldadesEscolares,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: InputDynamicTextField(
                      label: "Aulas especializadas ou cursos:",
                      controller: widget.cadastroPacienteState.aulasEspecializadas,
                      inputValues: listaDeAulasECursos,    
                      isDualField: true,                  
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: InputDynamicTextField(
                      label: "Medicamentos utilizados:",
                      controller: widget.cadastroPacienteState.medicamentosUsados,
                      inputValues: listaDeMedicamentosUsados,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: InputDynamicTextField(
                      label: "Profissionais de saúde acompanhantes:",
                      controller: widget.cadastroPacienteState.acompanhamentoProfissionalDeSaude,
                      inputValues: listaDeAcompanhamentosProfissionais,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: InputDynamicTextField(
                      label: "Vacinas faltantes:",
                      controller: widget.cadastroPacienteState.vacinasFaltando,
                      inputValues: listaDeVacinasFaltantes,
                    ),
                  ),                 
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: InputTextoAcolher(
                      label: "Observações:",
                      controller: widget.cadastroPacienteState.observacoes,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
      }
    showLoading(context) {
      showDialog(
          context: context,
          builder: (context) => const Center(
                  child: CircularProgressIndicator(
                color: preto,
              )),
          barrierDismissible: false);
  }
}