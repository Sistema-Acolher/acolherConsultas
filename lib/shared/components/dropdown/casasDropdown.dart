import 'package:acolherconsultas/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class CasasDropdown extends StatefulWidget {
  final List<Map<String, dynamic>> casas;

  const CasasDropdown({Key? key, required this.casas}) : super(key: key);

  @override
  _CasasDropdownState createState() => _CasasDropdownState();
}

class _CasasDropdownState extends State<CasasDropdown> {
  String _selectedItem = 'Servos';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: amareloNavbar,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          value: _selectedItem,
          iconStyleData: const IconStyleData(iconSize: 0),
          onChanged: (String? newValue) {
            setState(() {
              _selectedItem = newValue!;
              //  _handleSelectedItem(context, newValue);
            });
          },
          items: widget.casas.map((casa) {
            return DropdownMenuItem<String>(
              value: casa['name'],
              child: CasaItem(text:casa['name'], color:casa['color']),
            );
          }).toList(),
          buttonStyleData: const ButtonStyleData(
            height: 20,
            width: 180,
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 200, // se precisar mudar o tamanho do scroll
            width: 220,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            scrollbarTheme: ScrollbarThemeData(
              thumbVisibility: MaterialStateProperty.all(true),
              thickness: MaterialStateProperty.all(5),
              radius: const Radius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}

class CasaItem extends StatelessWidget {
  final String text;
  final Color color;
  final bool reverse;
  const CasaItem({super.key, required this.text, required this.color, this.reverse=false});

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: reverse?TextDirection.rtl:TextDirection.ltr,
      children: [
        Icon(
          Icons.cottage_outlined,
          color: color,
          size: 40,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5, left: 5),
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: "BobbyJonesSoft",
              fontSize: 25,
            ),
          ),
        ),
      ],
    );
  }
}

/*void _handleSelectedItem(BuildContext context, String value) {
  switch (value) {
    case 'Servos':
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ServosScreen()),
      );
      break;
    case 'Maria Paola':
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MariaPaolaScreen()),
      );
      break;
    case 'Santa Isabel':
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SantaIsabelScreen()),
      );
      break;
  }
}*/
