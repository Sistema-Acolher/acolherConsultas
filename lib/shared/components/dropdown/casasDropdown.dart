import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 3),
          ),
        ],
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
              child: _buildMenuItem('Servos', 'src/icons/servos.svg'),
            ),
            DropdownMenuItem<String>(
              value: 'Maria Paola',
              child: _buildMenuItem('Maria Paola', 'src/icons/mariaPaola.svg'),
            ),
            DropdownMenuItem<String>(
              value: 'Santa Isabel',
              child:
                  _buildMenuItem('Santa Isabel', 'src/icons/santaIsabel.svg'),
            ),
          ],
          buttonStyleData: const ButtonStyleData(
              height: 50, width: 155, padding: EdgeInsets.all(5)),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 200,
            width: 155,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(String text, String iconPath) {
    return Row(
      children: [
        SvgPicture.asset(
          iconPath,
          width: 24,
          height: 24,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontFamily: "BobbyJonesSoft",
            fontSize: 16,
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
