import 'package:acolherconsultas/modules/pacientes/controllers/controllerCadastroPaciente.dart';
import 'package:acolherconsultas/modules/pacientes/controllers/pacientesCadastradosProvider.dart';
import 'package:acolherconsultas/shared/components/inputs/inputDateCadastroPaciente.dart';
import 'package:acolherconsultas/shared/components/inputs/inputRadioButtonsCadastroPaciente.dart';
import 'package:acolherconsultas/shared/components/inputs/inputTextCadastroPaciente.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask/mask.dart';
import 'package:provider/provider.dart';

class CadastroPacienteScreen extends StatefulWidget {
  const CadastroPacienteScreen({super.key, required this.title});

  final String title;

  @override
  State<CadastroPacienteScreen> createState() => _CadastroPacienteScreenState();
}

class _CadastroPacienteScreenState extends State<CadastroPacienteScreen> {
  final _controllerCadastroPaciente = ControllerCadastroPaciente();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // go back button
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                InputTextCadastroPaciente(
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
                InputTextCadastroPaciente(
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
                InputTextCadastroPaciente(
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
                InputTextCadastroPaciente(
                  label: "CPF", 
                  controller: _controllerCadastroPaciente.cpf,
                  validation: (value) => Mask.validations.cpf(value),
                  inputFormatter: [Mask.cpf()],
                  keyboardType: TextInputType.number,
                ),
                InputTextCadastroPaciente(
                  label: "Motivo do Acolhimento", 
                  controller: _controllerCadastroPaciente.motivoAcolhimento,
                  keyboardType: TextInputType.text,
                ),
                InputRadioButtonsCadastroPaciente(
                  options: const ["Sim", "Não"], 
                  label: "Já teve Acolhimento Anterior",
                  controller: _controllerCadastroPaciente.acolhimentoAnterior
                ),
                InputDateCadastroPaciente(
                  label: "Data de Nascimento", 
                  controllerDataNascimento: _controllerCadastroPaciente.dataNascimento,
                  controllerIdade: _controllerCadastroPaciente.idade
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: ElevatedButton(
                    onPressed: () {
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