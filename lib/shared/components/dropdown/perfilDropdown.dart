import 'package:acolherconsultas/modules/usuarios/controllers/usuarioController.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:provider/provider.dart';

class UserDropdown extends StatefulWidget {
  final String userName;

  const UserDropdown({Key? key, required this.userName}) : super(key: key);

  @override
  _UserDropdownState createState() => _UserDropdownState();
}

class _UserDropdownState extends State<UserDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        customButton: const Icon(
          Icons.account_circle,
          size: 40,
          color: Colors.black,
        ),
        items: [
          DropdownMenuItem(
            value: widget.userName,
            child: Text(
              widget.userName,
              style: const TextStyle(
                fontFamily: 'BobbyJonesSoft',
                fontSize: 22,
                color: Colors.black,
              ),
            ),
          ),
          const DropdownMenuItem(
            value: 'Divider',
            child: Divider(
              color: Colors.black,
              thickness: 2,
            ),
          ),
          const DropdownMenuItem(
            value: 'Sair',
            child: Row(
              children: [
                Icon(Icons.exit_to_app, color: Colors.red),
                Text('Sair', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ],
        dropdownStyleData: DropdownStyleData(
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
          ),
          offset: const Offset(1, 1),
        ),
        menuItemStyleData: const MenuItemStyleData(
          padding: EdgeInsets.symmetric(horizontal: 16),
          height: 27,
        ),
        onChanged: (value) {
          if (value == 'Sair') {
            setState(() {
              // Desloga o usuário e redireciona para a tela de login
              context.read<UsuarioController>().logout();
            });
          }
        },
      ),
    );
  }
}
