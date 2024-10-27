import 'package:flutter/material.dart';

class TextoColorido extends StatefulWidget {
  const TextoColorido({super.key, required this.palavra});

  final String palavra;

  @override
  _TextoColoridoState createState() => _TextoColoridoState();
}

class _TextoColoridoState extends State<TextoColorido> {
  int _colorIndex = 0;
  List<Color> colorList = [
            Colors.blue,
            Colors.lightGreen,
            Colors.blue,
            Colors.red,
            Colors.white,
            Colors.lightGreen,
            Colors.blue,
            Colors.white,
            Colors.red,
          ];

  @override
  Widget build(BuildContext context) {
    List<TextSpan> char = [];

    for (int i = 0; i < widget.palavra.length; i++) {
      char.add(
        TextSpan(
          text: widget.palavra[i],
          style: TextStyle(color: colorList[_colorIndex]),
        ),
      );
      _colorIndex = (_colorIndex + 1) % colorList.length;
    }

    return Text.rich(
      TextSpan(children: char),
      style: const TextStyle(
        fontSize: 30,
        fontFamily: "BobbyJonesSoft"
      ),
      
    );
  }
}
