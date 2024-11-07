import 'package:flutter/material.dart';

// Define the AulaEspecializada class
class AulaEspecializada {
  String name;
  String location;
  String hour;

  AulaEspecializada({this.name = '', this.location = '', this.hour = ''});
}

class InputDynamicTextField extends StatefulWidget {
  final String label;
  final List<dynamic> inputValues; // List can contain String or AulaEspecializada
  final TextEditingController? controller;
  final bool isDualField;

  InputDynamicTextField({
    Key? key,
    required this.label,
    required this.inputValues,
    this.controller,
    this.isDualField = false,
  }) : super(key: key);

  @override
  _InputDynamicTextFieldState createState() => _InputDynamicTextFieldState();
}

class _InputDynamicTextFieldState extends State<InputDynamicTextField> {
  @override
  void initState() {
    super.initState();
    _updateController(); // Initialize controller with empty text
  }

  void _updateController() {
    if (widget.controller != null) {
      widget.controller!.text = widget.inputValues.map((input) {
        if (input is String) {
          return input; // Simple String entry
        } else if (input is AulaEspecializada) {
          // Format for AulaEspecializada
          return widget.isDualField
              ? '${input.name} - ${input.location} - ${input.hour}'
              : input.name;
        }
        return '';
      }).join(' | '); // Use ' | ' as a separator between entries
    }
  }

  void _addNewField() {
    setState(() {
      widget.inputValues.add(widget.isDualField ? AulaEspecializada() : ''); // Add either String or AulaEspecializada
      _updateController();
    });
  }

  void _removeField(int index) {
    setState(() {
      widget.inputValues.removeAt(index); // Remove at specified index
      _updateController();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Text(
            widget.label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        // Render each entry in inputValues if it exists
        ...widget.inputValues.asMap().entries.map((entry) {
          int index = entry.key;
          var value = entry.value;

          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (value is String)
                  Row(
                    children: [
                      // Render single String input
                      Expanded(
                        child: TextField(
                          onChanged: (val) {
                            widget.inputValues[index] = val;
                            _updateController();
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => _removeField(index),
                        icon: Icon(Icons.remove),
                      ),
                    ],
                  ),
                if (value is AulaEspecializada)
                  Column(
                    children: [
                      Row(
                        children: [
                          // Name field for AulaEspecializada
                          Expanded(
                            child: TextField(                              
                              onChanged: (val) {
                                value.name = val;
                                _updateController();
                              },
                              decoration: InputDecoration(    
                                labelText: 'Nome',                            
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => _removeField(index),
                            icon: Icon(Icons.remove),
                          ),
                        ],
                      ),
                      if (widget.isDualField) ...[
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                onChanged: (val) {
                                  value.location = val;
                                  _updateController();
                                },
                                decoration: InputDecoration(
                                  labelText: 'Local',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                onChanged: (val) {
                                  value.hour = val;
                                  _updateController();
                                },
                                decoration: InputDecoration(
                                  labelText: 'Horário',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
              ],
            ),
          );
        }).toList(),
        // "+" button to add a new entry
        IconButton(
          onPressed: _addNewField,
          icon: Icon(Icons.add),
        ),
      ],
    );
  }
}
