import 'package:flutter/material.dart';

class InputDynamicTextField extends StatefulWidget {
  final String label; // Single label for the first field
  final List<String> inputValues; // List to store values for each field
  final TextEditingController controller; // Controller to show combined text

  InputDynamicTextField({
    Key? key,
    required this.label,
    required this.inputValues,
    required this.controller,
  }) : super(key: key);

  @override
  _InputDynamicTextFieldState createState() => _InputDynamicTextFieldState();
}

class _InputDynamicTextFieldState extends State<InputDynamicTextField> {
  @override
  void initState() {
    super.initState();
    // Do not initialize with any fields
  }

  void _updateController() {
    // Join all input values into a single string
    widget.controller.text = widget.inputValues.join(', ');
  }

  void _removeField(int index) {
    setState(() {
      widget.inputValues.removeAt(index); // Remove the specific input
      if (widget.inputValues.isEmpty) {
        widget.inputValues.add(''); // Ensure at least one field remains
      }
      _updateController(); // Update the controller value
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Always display the label
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Text(
            widget.label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
        // Display each TextField with a delete button
        ...widget.inputValues.asMap().entries.map((entry) {
          int index = entry.key;
          return Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      widget.inputValues[index] = value; // Update specific input
                      _updateController(); // Update the combined controller value
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => _removeField(index), // Remove field on press
                  icon: Icon(Icons.remove), // Use "-" symbol
                ),
              ],
            ),
          );
        }).toList(),
        // Only show the "+" button when there are no fields
        if (widget.inputValues.isEmpty || widget.inputValues.last.isNotEmpty)
          IconButton(
            onPressed: () {
              setState(() {
                widget.inputValues.add(''); // Add a new empty field
                _updateController(); // Update the controller value
              });
            },
            icon: Icon(Icons.add), // Use "+" symbol
          ),
      ],
    );
  }
}
