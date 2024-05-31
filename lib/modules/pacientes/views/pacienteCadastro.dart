import 'package:acolherconsultas/modules/casasDeApoio/controller/casaDeApoioController.dart';
import 'package:acolherconsultas/modules/pacientes/states/pacienteCadastroState.dart';
import 'package:acolherconsultas/modules/pacientes/controllers/pacienteCadastradoController.dart';
import 'package:acolherconsultas/modules/pacientes/models/paciente.dart';
import 'package:acolherconsultas/shared/colors.dart';
import 'package:acolherconsultas/shared/components/bars/pacienteAppbar.dart';
import 'package:acolherconsultas/shared/components/buttons/standartRoundButton.dart';
import 'package:acolherconsultas/shared/components/dropdown/inputDropdown.dart';
import 'package:acolherconsultas/shared/components/inputs/inputCaixaDeTexto.dart';
import 'package:acolherconsultas/shared/components/inputs/inputRadioButtons.dart';
import 'package:acolherconsultas/shared/components/inputs/inputTexto.dart';
import 'package:acolherconsultas/shared/components/text/confirmacao.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mask/mask.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';

// A classe CadastroPacienteScreen é a tela de cadastro de pacientes.

class CadastroPacienteScreen extends StatefulWidget {
  final Paciente? paciente;
  const CadastroPacienteScreen({super.key, this.paciente});

  @override
  State<CadastroPacienteScreen> createState() => _CadastroPacienteScreenState();
}

// A classe _CadastroPacienteScreenState é a classe que representa o estado da tela de cadastro de pacientes.

class _CadastroPacienteScreenState extends State<CadastroPacienteScreen> {
  final _stateCadastroPaciente = CadastroPacienteState();
  final _controllerRadio = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  ValueNotifier<bool> radiobuttonNotifier = ValueNotifier<bool>(false);
  ValueNotifier<bool> dropdownNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();

    _stateCadastroPaciente.dataNascimento.addListener(() {
      atualizaControllerIdade();
    });
  }

  void atualizaControllerIdade() {
    if (_stateCadastroPaciente.dataNascimento.text.length == 10) {
      DateTime data = DateFormat('dd/MM/yyyy')
          .parse(_stateCadastroPaciente.dataNascimento.text);
      String dataString = Paciente.calcularIdade(data);
      _stateCadastroPaciente.idade.text = dataString;
    } else {
      _stateCadastroPaciente.idade.text = "";
    }
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: PacienteAppbar(
          paciente: widget.paciente,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: StandartRoundButton(
          text: "Salvar",
          icon: Symbols.book,
          onPressed: () {
            // Se o formulário for válido, exibe um diálogo de confirmação.
            if (_stateCadastroPaciente.genero.text.isEmpty){
              setState((){
                dropdownNotifier.value = true;
              });
            }
            if (_formKey.currentState!.validate() && _stateCadastroPaciente.genero.text.isNotEmpty) {
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
                            context
                                .read<PacientesCadastradosController>()
                                .cadastrarPaciente(
                                    _stateCadastroPaciente.cadastro(),
                                    context
                                        .read<CasaDeApoioController>()
                                        .casaDeApoioSelecionada
                                        .value)
                                .then((value) {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(content: Text(value)));
                              if (!value.toLowerCase().contains("erro")) {
                                Navigator.pop(context);
                              }
                            });
                          }
                        )),
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
                      label: "Nome",
                      controller: _stateCadastroPaciente.nome,
                      keyboardType: TextInputType.name,
                      validation: (value) => Mask.validations
                          .generic(value, error: "Nome inválido", min: 3),
                      inputFormatter: [
                        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                        LengthLimitingTextInputFormatter(50),
                      ],
                      emptyMessage: "Informe o nome",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: InputTextoAcolher(
                      label: "CPF",
                      controller: _stateCadastroPaciente.cpf,
                      validation: (value) => Mask.validations.cpf(value),
                      inputFormatter: [Mask.cpf()],
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: InputTextoAcolher(
                      label: "RG (Apenas Números)",
                      controller: _stateCadastroPaciente.rg,
                      keyboardType: TextInputType.number,
                      validation: (value) => Mask.validations
                          .generic(value, error: "RG inválido", min: 8),
                      inputFormatter: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                        LengthLimitingTextInputFormatter(11),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: InputTextoAcolher(
                      label: "Número do Cartão do SUS",
                      controller: _stateCadastroPaciente.numeroCartaoSus,
                      validation: (value) => Mask.validations.generic(value,
                          error: "Número do Cartão do SUS inválido", min: 18),
                      inputFormatter: [
                        Mask.generic(
                            masks: ["### #### #### ####"],
                            hashtag: Hashtag.numbers)
                      ],
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    width: size.width,
                    constraints: BoxConstraints(maxWidth: size.width),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: InputTextoAcolher(
                            label: "Data de Nascimento",
                            placeHolder: "    /    /",
                            controller: _stateCadastroPaciente.dataNascimento,
                            keyboardType: TextInputType.datetime,
                            icone: Icons.date_range_outlined,
                            validation: (value) => Mask.validations.date(value),
                            inputFormatter: [Mask.date()],
                            readOnly: true,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: InputTextoAcolher(
                            label: "Idade",
                            placeHolder: "..a ..m ..d",
                            controller: _stateCadastroPaciente.idade,
                            readOnly: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: InputDropdown(
                      label: 'Gênero',
                      list: const [
                        'Masculino',
                        'Feminino',
                        'Prefiro não responder'
                      ],
                      controller: _stateCadastroPaciente.genero,
                      checkNotifier: dropdownNotifier,
                    ),
                  ),
                  InputCaixaDeTexto(
                    label: "Motivo do Acolhimento",
                    controller: _stateCadastroPaciente.motivoAcolhimento,
                  ),
                  InputRadioButtonsCadastroPaciente(
                    options: const ["Sim", "Não"],
                    label: "Acolhimento anterior",
                    controller: _controllerRadio,
                    optionalController:_stateCadastroPaciente.acolhimentoAnterior,
                    isChecked: radiobuttonNotifier,
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
  