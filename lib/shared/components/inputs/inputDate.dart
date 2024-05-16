import 'package:acolherconsultas/modules/pacientes/models/paciente.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// O InputDateCadastroPaciente é um componente que representa um campo de data de nascimento e idade de um paciente.

class InputDateCadastroPaciente extends StatefulWidget {
  const InputDateCadastroPaciente({super.key, required this.label, required this.controllerDataNascimento, this.controllerIdade});

  // Atributos do componente.
  final String label;
  final TextEditingController controllerDataNascimento;
  final TextEditingController? controllerIdade;

  @override
  State<InputDateCadastroPaciente> createState() => _InputDateCadastroPacienteState();
}

class _InputDateCadastroPacienteState extends State<InputDateCadastroPaciente> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Padding é um widget que implementa um espaçamento ao redor de um widget filho.
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
          // Campo de data de nascimento do paciente.
          child: TextFormField(
            // Propriedades do TextFormField de acordo com os atributos do componente.
            autovalidateMode: widget.controllerDataNascimento.text.isNotEmpty ? AutovalidateMode.always : AutovalidateMode.disabled,
            readOnly: true,
            decoration: InputDecoration(
              labelText: widget.label,
              border: const OutlineInputBorder(),
              errorStyle: const TextStyle(
                      fontSize: 10,
                      height: 1
                    ),
              alignLabelWithHint: true,
            ),
            controller: widget.controllerDataNascimento,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Informe a ${widget.label} do paciente";
              }
              return null;
            },
            // O onTap é uma propriedade que define a ação de toque no widget.
            onTap: () async {
              // O showDatePicker é um método que exibe uma caixa/dialog de seleção de data e retorna a data selecionada.
              final DateTime? data = await showDatePicker(
                // Propriedades do showDatePicker de acordo com os atributos do componente.
                keyboardType: TextInputType.datetime,
                context: context,
                locale: const Locale('pt', "BR"),
                initialDate: widget.controllerDataNascimento.text.isNotEmpty
                            ? DateFormat('dd/MM/yyyy').parse(widget.controllerDataNascimento.text) 
                            : DateTime.now(),
                firstDate: DateTime(1980),
                lastDate: DateTime.now(),
              );
          
              if (data != null) {
                // O setState é um método que atualiza o estado do widget.
                setState(() {
                  // Atribuição da data de nascimento e idade do paciente aos respectivos campos.
                  widget.controllerDataNascimento.text = DateFormat('dd/MM/yyyy').format(data);
                  widget.controllerIdade!.text = Paciente.calcularIdade(data);
                });
              }
            }
          ),
        ),
        // Container é um widget que implementa um container retangular e pode ser decorado com bordas, cor, sombra, etc.
        Container(
          child: widget.controllerDataNascimento.text != "" ?
          // Campo de idade do paciente. 
          TextFormField(
            autovalidateMode: widget.controllerIdade!.text.isNotEmpty ? AutovalidateMode.always : AutovalidateMode.disabled,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: "Idade",
              border: OutlineInputBorder(),
              error: null,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorStyle: TextStyle(
                      fontSize: 10,
                      height: 1
                    ),
              alignLabelWithHint: true,
            ),
            controller: widget.controllerIdade,
          ) 
          // Se o campo de data de nascimento não estiver preenchido, o campo de idade não é exibido.
          : null
        ),
      ],
    );
  }
}