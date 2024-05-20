// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:acolherconsultas/modules/usuarios/controllers/usuarioController.dart';
import 'package:acolherconsultas/shared/colors.dart';
import 'package:acolherconsultas/shared/components/dropdown/casasDropdown.dart';
import 'package:acolherconsultas/shared/components/dropdown/perfilDropdown.dart';

class HomeAppbar extends StatelessWidget implements PreferredSizeWidget {
  final bool admin;
  const HomeAppbar({super.key, this.admin=false});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: amareloNavbar,
      toolbarHeight: 50,
      leading:  Padding(
        padding: const EdgeInsets.only(left: 20),
        child: admin?const CasaItem(text: "Admin", color: Color(0xFF7A7A7A)):const CasasDropdown(
          casas: [
            {'name': 'Servos', 'color': Color(0xFF2277AE)},
            {'name': 'Maria Paola', 'color': Color(0xFFFF0000)},
            {'name': 'Santa Isabel', 'color': Color(0xFF78B158)},
          ],
        ),
      ),
      leadingWidth: 220,
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: UserDropdown(
            // Passa o nome do usuário logado para o componente
            userName: context.read<UsuarioProvider>().usuarioAtual!.nome,
          ),
        ),
      ],
    );
  }
}