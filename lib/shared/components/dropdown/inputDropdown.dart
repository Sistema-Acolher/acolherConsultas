import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class InputDropdown extends StatefulWidget {
  final List<String> list;
  final String label;

  const InputDropdown({Key? key, required this.list, required this.label})
      : super(key: key);

  @override
  _InputDropdownState createState() => _InputDropdownState();
}

class _InputDropdownState extends State<InputDropdown> {
  String? _selectedItem;

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
              value: _selectedItem,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedItem = newValue;
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
      ],
    );
  }
}
