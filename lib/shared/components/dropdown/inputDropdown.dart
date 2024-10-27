import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class InputDropdown extends StatefulWidget {
  final List<String> list;
  final String label;
  final TextEditingController controller;
  final ValueNotifier<bool> checkNotifier;
  final bool isEdit;
  final Function? checkEdit;

  const InputDropdown({
    super.key,
    required this.list,
    required this.label,
    required this.checkNotifier,
    required this.controller,
    this.isEdit = false,
    this.checkEdit,
  });

  @override
  _InputDropdownState createState() => _InputDropdownState();
}

class _InputDropdownState extends State<InputDropdown> {
  bool mostrarErro = true;

  @override
  Widget build(BuildContext context) {
    String? selectedItem = widget.list.contains(widget.controller.text)
        ? widget.controller.text
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
          child: Text(
            widget.label,
            style: const TextStyle(
              fontFamily: "Roboto",
              fontWeight: FontWeight.bold,
            ),
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
                  child: Text(
                    value,
                    style: TextStyle(
                      color: widget.isEdit ? Colors.grey : Colors.black,
                    ),
                  ),
                );
              }).toList(),
              value: selectedItem,
              onChanged: (String? newValue) {
                setState(() {
                  selectedItem = newValue ?? '';
                  widget.controller.text = selectedItem!;
                  widget.checkNotifier.value = true;
                  mostrarErro = false;

                  if (widget.checkEdit != null) {
                    widget.checkEdit!();
                  }
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
