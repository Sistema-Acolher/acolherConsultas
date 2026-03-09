import 'package:acolherconsultas/shared/colors.dart';
import 'package:acolherconsultas/shared/components/inputs/inputTexto.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

class InputRadioButtonsConsulta extends StatefulWidget {
  const InputRadioButtonsConsulta({
    super.key,
    required this.options,
    required this.label,
    required this.controller,
    this.secondController,
    required this.isChecked,
    this.readOnly = false,
    this.obrigatorio = true
  });

  final bool obrigatorio;
  final List<String> options;
  final String label;
  final TextEditingController controller;
  final TextEditingController? secondController;
  final ValueNotifier<bool> isChecked;
  final bool readOnly;

  @override
  State<InputRadioButtonsConsulta> createState() => _InputRadioButtonsConsultaState();
}

class _InputRadioButtonsConsultaState
    extends State<InputRadioButtonsConsulta> {
  bool showTextBox = false;

  @override
  void initState() {
    super.initState();
    showTextBox = widget.controller.text == 'Sim';
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: (value) {
        if (widget.obrigatorio && widget.controller.text.isEmpty) {
          return 'Selecione pelo menos uma opção.';
        }
        return null; // Validation passed
      },
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                widget.label,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              children: [
                ...List.generate(
                  widget.options.length,
                  (index) => Expanded(
                    child: Opacity(
                      opacity: widget.controller.text == widget.options[index] ? 1.0 : 0.5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          widget.options.length<4 
                          ? RadioListTile(
                            activeColor: preto,
                            title:  AutoSizeText(
                              widget.options[index],
                              maxLines: 1,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                              minFontSize: 8,
                            ),
                            value: widget.options[index],
                            contentPadding: const EdgeInsets.all(0),
                            groupValue: widget.controller.text,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            visualDensity: const VisualDensity(
                              horizontal: VisualDensity.minimumDensity,
                              vertical: VisualDensity.minimumDensity,
                            ),
                            dense: true,
                            onChanged: widget.readOnly
                                ? null
                                : (value) {
                                    setState(() {
                                      widget.controller.text = value as String;
                                      widget.isChecked.value = true;
                                      showTextBox = value == 'Sim';
                                      context.didChange(value);
                                      context.validate();
                                    });
                                  },
                          )
                          :Radio(
                            activeColor: preto,
                            value: widget.options[index],
                            visualDensity: const VisualDensity(
                              horizontal: VisualDensity.minimumDensity,
                              vertical: VisualDensity.minimumDensity,
                            ),
                            groupValue: widget.controller.text,
                            onChanged: widget.readOnly
                                ? null
                                : (value) {
                                    setState(() {
                                      widget.controller.text = value as String;
                                      widget.isChecked.value = true;
                                      showTextBox = value == 'Sim';
                                      context.didChange(value);
                                      context.validate();
                                    });
                                  },
                          ),
                          widget.options.length>=4?Text(
                            widget.options[index],
                            style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 9),
                            textAlign: TextAlign.center,
                          ):const SizedBox.shrink()
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (context.hasError)
              Text(
                context.errorText??'',
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 10,
                ),
              ),
            if (showTextBox && widget.secondController != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 16),
                  Expanded(
                  child: widget.label == "Já fez preventivo"
                      ? InputTextoAcolher(
                          label: "Quando fez preventivo",
                          placeHolder: "    /    /",
                          controller: widget.secondController!,
                          keyboardType: TextInputType.datetime,
                          icone: Icons.date_range_outlined,
                          readOnly: true,
                        )
                      : InputTextoAcolher(
                          readOnly: widget.readOnly,
                          label: "Obs: ",
                          controller: widget.secondController!,
                        ),
                ),
                ],
              ),        
            Padding(
              padding: widget.options.length<4?const EdgeInsets.only(bottom: 2):const EdgeInsets.only(top: 2),
              child: const DottedLine(
                dashLength: 4.0,
                dashGapLength: 4.0,
                lineThickness: 1.0,
                dashColor: Color.fromARGB(255, 120, 120, 120),
              ),
            )
          ],
        );
      }
    );
  }
}
