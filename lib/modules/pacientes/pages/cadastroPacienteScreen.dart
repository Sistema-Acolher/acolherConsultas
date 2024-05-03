import 'package:acolherconsultas/modules/pacientes/controllers/controllerCadastroPaciente.dart';
import 'package:acolherconsultas/modules/pacientes/controllers/pacientesCadastradosProvider.dart';
import 'package:acolherconsultas/modules/pacientes/models/paciente.dart';
import 'package:acolherconsultas/shared/components/inputs/inputDateCadastroPaciente.dart';
import 'package:acolherconsultas/shared/components/inputs/inputRadioButtonsCadastroPaciente.dart';
import 'package:acolherconsultas/shared/components/inputs/inputTextoAcolher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mask/mask.dart';
import 'package:provider/provider.dart';

// A classe CadastroPacienteScreen é a tela de cadastro de pacientes.

class CadastroPacienteScreen extends StatefulWidget {
  const CadastroPacienteScreen({super.key, required this.title});

  // Atributo que define o título da tela.
  final String title;

  @override
  State<CadastroPacienteScreen> createState() => _CadastroPacienteScreenState();
}

// A classe _CadastroPacienteScreenState é a classe que representa o estado da tela de cadastro de pacientes.

class _CadastroPacienteScreenState extends State<CadastroPacienteScreen> {
  final _controllerCadastroPaciente = ControllerCadastroPaciente();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _controllerCadastroPaciente.dataNascimento.addListener(() {
      atualizaControllerIdade();
    });
  }

  void atualizaControllerIdade() {
    if(_controllerCadastroPaciente.dataNascimento.text.length == 10){
      DateTime data = DateFormat('dd/MM/yyyy').parse(_controllerCadastroPaciente.dataNascimento.text);
      String dataString =  Paciente.calcularIdade(data);
      _controllerCadastroPaciente.idade.text = dataString;
    } else {
      _controllerCadastroPaciente.idade.text = "";
    }
}

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        // Botão de voltar, na barra superior.
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.title),
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
                InputTextoAcolher(
                  label: "Nome", 
                  controller: _controllerCadastroPaciente.nome,
                  keyboardType: TextInputType.name,
                  validation: (value) => Mask.validations.generic(
                    value,
                    error: "Nome inválido", 
                    min: 3
                  ),
                  inputFormatter: [
                    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                    LengthLimitingTextInputFormatter(50),
                  ],
                ),
                InputRadioButtonsCadastroPaciente(
                  options: const ["Masculino", "Feminino"], 
                  label: "Gênero",
                  controller: _controllerCadastroPaciente.genero
                ),
                InputTextoAcolher(
                  label: "RG (Apenas Números)", 
                  controller: _controllerCadastroPaciente.rg,
                  keyboardType: TextInputType.number,
                  validation:  (value) => Mask.validations.generic(
                    value,
                    error: "RG inválido", 
                    min: 8
                  ),
                  inputFormatter: [
                    FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                    LengthLimitingTextInputFormatter(11),
                  ],
                ),
                InputTextoAcolher(
                  label: "Número do Cartão do SUS", 
                  controller: _controllerCadastroPaciente.numeroCartaoSus, 
                  validation: (value) => Mask.validations.generic(
                    value, error: "Número do Cartão do SUS inválido", 
                    min: 18
                  ),
                  inputFormatter: [
                    Mask.generic(
                      masks: ["### #### #### ####"],
                      hashtag: Hashtag.numbers
                    )
                  ],
                  keyboardType: TextInputType.number,
                ),
                InputTextoAcolher(
                  label: "CPF", 
                  controller: _controllerCadastroPaciente.cpf,
                  validation: (value) => Mask.validations.cpf(value),
                  inputFormatter: [Mask.cpf()],
                  keyboardType: TextInputType.number,
                ),
                InputTextoAcolher(
                  label: "Motivo do Acolhimento", 
                  controller: _controllerCadastroPaciente.motivoAcolhimento,
                ),
                InputRadioButtonsCadastroPaciente(
                  options: const ["Sim", "Não"], 
                  label: "Já teve Acolhimento Anterior",
                  controller: _controllerCadastroPaciente.acolhimentoAnterior
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
                          hintText: "    /    /",
                          controller: _controllerCadastroPaciente.dataNascimento,
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
                          hintText: "..a ..m ..d",
                          controller: _controllerCadastroPaciente.idade,
                          readOnly: true,
                        ),
                      ),
                    ],
                  ),
                ),
                InputTextoAcolher(
                  label: "Senha", 
                  controller: _controllerCadastroPaciente.nome, 
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                ),
                InputTextoAcolher(
                  label: "Editar", 
                  controller: _controllerCadastroPaciente.nome,
                  icone: Icons.edit,
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
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 10),
                                    const Text(
                                      "Certeza de que deseja prosseguir?",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                            child: const Text("Revisar Dados"),
                                            onPressed: () async {
                                              Navigator.pop(context);
                                            }),
                                        TextButton(
                                            child: const Text("Cadastrar"),
                                            onPressed: () async {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text('Cadastrando paciente...'), duration: Duration())
                                              );
                                              // Chama o método de cadastro de paciente do Provider, através 
                                              context.read<PacientesCadastradosProvider>().cadastrarPaciente(_controllerCadastroPaciente.cadastro())
                                              .then((value) {
                                                Navigator.pop(context);
                                                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text(value)),
                                                );
                                                if(!value.toLowerCase().contains("erro")) Navigator.pop(context);
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
                    child: const Text("Cadastrar")
                  ),
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}