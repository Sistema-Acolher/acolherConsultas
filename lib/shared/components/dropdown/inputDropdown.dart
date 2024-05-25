import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class InputDropdown extends StatefulWidget {
  final List<String> list;
  final String label;
  final TextEditingController controller;
  final ValueNotifier<bool> checkNotifier;

  const InputDropdown(
      {super.key,
      required this.list,
      required this.label,
      required this.checkNotifier,
      required this.controller});

  @override
  _InputDropdownState createState() => _InputDropdownState();
}

class _InputDropdownState extends State<InputDropdown> {
  bool mostrarErro = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
          child: Text(
            widget.label,
            style: const TextStyle(
                fontFamily: "Roboto", fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              isExpanded: true,
              hint: Text(
                'Selecione um item',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).hintColor,
                ),
              ),
              iconStyleData:
                  const IconStyleData(icon: Icon(Icons.keyboard_arrow_down)),
              items: widget.list.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              value: widget.controller.text,
              onChanged: (String? newValue) {
                setState(() {
                  widget.controller.text = newValue ?? '';
                  widget.checkNotifier.value = true;
                  mostrarErro = false;
                });
              },
              buttonStyleData: ButtonStyleData(
                height: 40,
                width: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              dropdownStyleData: DropdownStyleData(
                maxHeight: 200,
                width: 350,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
        ),
        if (mostrarErro && widget.checkNotifier.value)
          const Text(
            'Selecione pelo menos uma opção.',
            style: TextStyle(
              color: Colors.red,
              fontSize: 13,
            ),
          ),
      ],
    );
  }
}
