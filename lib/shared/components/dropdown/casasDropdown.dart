import 'package:acolherconsultas/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class CasasDropdown extends StatefulWidget {
  const CasasDropdown({Key? key}) : super(key: key);

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
              _handleSelectedItem(context, newValue);
            });
          },
          items: [
            DropdownMenuItem<String>(
              value: 'Servos',
              child: _buildMenuItem('Servos',0xFF2277AE),
            ),
            DropdownMenuItem<String>(
              value: 'Maria Paola',
              child: _buildMenuItem('Maria Paola',0xFFFF0000),
            ),
            DropdownMenuItem<String>(
              value: 'Santa Isabel',
              child: _buildMenuItem('Santa Isabel',0xFF78B158),
            ),
          ],
          buttonStyleData: const ButtonStyleData(
            height: 20,
            width: 180,
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 200,
            width: 220,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(String text,int colorHex) {
    return Row(
      children: [
        Icon(
          Icons.cottage_outlined, 
          color: Color(colorHex),
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

void _handleSelectedItem(BuildContext context, String value) {
  switch (value) {
    case 'Servos':
      /*Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ServosScreen()),
      );*/

      //print('Você selecionou Servos');
      break;
    case 'Maria Paola':
      /*Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MariaPaolaScreen()),
      );*/
      //print('Você selecionou Maria Paola');
      break;
    case 'Santa Isabel':
      /*Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SantaIsabelScreen()),
      );*/
      //print('Você selecionou Santa Isabel');
      break;
    default:
    //print('Erro ao encontrar casa!');
  }
}
