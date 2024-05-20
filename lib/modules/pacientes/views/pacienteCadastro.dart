import 'package:acolherconsultas/modules/pacientes/states/pacienteCadastroState.dart';
import 'package:acolherconsultas/modules/pacientes/controllers/pacienteCadastradoController.dart';
import 'package:acolherconsultas/modules/pacientes/models/paciente.dart';
import 'package:acolherconsultas/shared/components/bars/pacienteAppbar.dart';
import 'package:acolherconsultas/shared/components/dropdown/inputDropdown.dart';

import 'package:acolherconsultas/shared/components/inputs/inputCaixaDeTextoAcolhimento.dart';
import 'package:acolherconsultas/shared/components/inputs/inputRadioButtons.dart';
import 'package:acolherconsultas/shared/components/inputs/inputTexto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mask/mask.dart';
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
  final _formKey = GlobalKey<FormState>();
  bool isChecked = false;

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
      appBar: PacienteAppbar(paciente: widget.paciente,),
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
                  InputTextoAcolher(
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
                  const Padding(
                    //dorpdown padrão, passe a lista e label
                    padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: InputDropdown(list: [
                      'Masculino',
                      'Feminino',
                      'Prefiro não responder'
                    ], label: 'Gênero'),
                  ),
                  InputTextoAcolher(
                    label: "RG (Apenas Números)",
                    controller: _stateCadastroPaciente.rg,
                    keyboardType: TextInputType.number,
                    validation: (value) => Mask.validations
                        .generic(value, error: "RG inválido", min: 8),
                    inputFormatter: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                      LengthLimitingTextInputFormatter(11),
                    ],
                    emptyMessage: "Informe o RG",
                  ),
                  InputTextoAcolher(
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
                    emptyMessage: "Informe o número do cartão do SUS",
                  ),
                  InputTextoAcolher(
                    label: "CPF",
                    controller: _stateCadastroPaciente.cpf,
                    validation: (value) => Mask.validations.cpf(value),
                    inputFormatter: [Mask.cpf()],
                    keyboardType: TextInputType.number,
                    emptyMessage: "Informe o CPF",
                  ),
                  InputCaixaDeTextoAcolhimento(
                    label: "Motivo do Acolhimento",
                    controller: _stateCadastroPaciente.motivoAcolhimento,
                  ),
                  InputRadioButtonsCadastroPaciente(
                    options: const ["Sim", "Não"],
                    label: "Acolhimento anterior",
                    controller: TextEditingController(),
                    optionalController:_stateCadastroPaciente.acolhimentoAnterior,
                    isChecked: isChecked,
                  ),
                  Container(
                    width: size.width,
                    constraints: BoxConstraints(maxWidth: size.width),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: InputTextoAcolher(
                            label: "Data de Nascimento",
                            placeHolder: "    /    /",
                            controller:
                                _stateCadastroPaciente.dataNascimento,
                            keyboardType: TextInputType.datetime,
                            icone: Icons.date_range_outlined,
                            validation: (value) => Mask.validations.date(value),
                            inputFormatter: [Mask.date()],
                            readOnly: true,
                            emptyMessage: "Informe a data de nascimento",
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
                            emptyMessage: "Informe a idade",
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: ElevatedButton(
                        onPressed: () {
                          // Se o formulário for válido, exibe um diálogo de confirmação.
                          if (_formKey.currentState!.validate()) {
                            showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 5),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const SizedBox(height: 10),
                                        const Text(
                                          "Certeza de que deseja prosseguir?",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                                child:
                                                    const Text("Revisar Dados"),
                                                onPressed: () async {
                                                  Navigator.pop(context);
                                                }),
                                            TextButton(
                                                child: const Text("Cadastrar"),
                                                onPressed: () async {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(const SnackBar(
                                                          content: Text(
                                                              'Cadastrando paciente...'),
                                                          duration:
                                                              Duration()));
                                                  // Chama o método de cadastro de paciente do Provider, através
                                                  context
                                                      .read<
                                                          PacientesCadastradosController>()
                                                      .cadastrarPaciente(
                                                          _stateCadastroPaciente
                                                              .cadastro())
                                                      .then((value) {
                                                    Navigator.pop(context);
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .hideCurrentSnackBar();
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                          content: Text(value)),
                                                    );
                                                    if (!value
                                                        .toLowerCase()
                                                        .contains("erro"))
                                                      Navigator.pop(context);
                                                  });
                                                }),
                                          ],
                                        )
                                      ],
                                    ),
                                  )),
                            );
                          }
                        },
                        child: const Text("Cadastrar")),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
