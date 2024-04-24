import 'package:acolherconsultas/modules/pacientes/models/paciente.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InputDateCadastroPaciente extends StatefulWidget {
  const InputDateCadastroPaciente({super.key, required this.label, required this.controllerDataNascimento, required this.controllerIdade});

  final String label;
  final TextEditingController controllerDataNascimento;
  final TextEditingController controllerIdade;

  @override
  State<InputDateCadastroPaciente> createState() => _InputDateCadastroPacienteState();
}

class _InputDateCadastroPacienteState extends State<InputDateCadastroPaciente> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
          child: TextFormField(
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
            onTap: () async {
              final DateTime? data = await showDatePicker(
                context: context,
                locale: const Locale('pt', "BR"),
                initialDate: widget.controllerDataNascimento.text.isNotEmpty
                            ? DateFormat('dd/MM/yyyy').parse(widget.controllerDataNascimento.text) 
                            : DateTime.now(),
                firstDate: DateTime(1980),
                lastDate: DateTime.now(),
              );
          
              if (data != null) {
                setState(() {
                  widget.controllerDataNascimento.text = DateFormat('dd/MM/yyyy').format(data);
                  widget.controllerIdade.text = Paciente.calcularIdade(data);
                });
              }
            }
          ),
        ),
        Container(
          child: widget.controllerDataNascimento.text != "" ? 
          TextFormField(
            autovalidateMode: widget.controllerIdade.text.isNotEmpty ? AutovalidateMode.always : AutovalidateMode.disabled,
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
          ) : null
        ),
      ],
    );
  }
}