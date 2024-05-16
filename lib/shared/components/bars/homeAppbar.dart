import 'package:acolherconsultas/shared/colors.dart';
import 'package:acolherconsultas/shared/components/dropdown/casasDropdown.dart';
import 'package:acolherconsultas/shared/components/dropdown/perfilDropdown.dart';
import 'package:flutter/material.dart';

class HomeAppbar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: amareloNavbar,
      toolbarHeight: 50,
      leading: const Padding(
        padding: EdgeInsets.only(left: 20),
        child: CasasDropdown(
          casas: [
            {'name': 'Servos', 'color': Color(0xFF2277AE)},
            {'name': 'Maria Paola', 'color': Color(0xFFFF0000)},
            {'name': 'Santa Isabel', 'color': Color(0xFF78B158)},
          ],
        ),
      ),
      leadingWidth: 220,
      centerTitle: true,
      actions: const [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: UserDropdown(
            userName: "Nome usuário",
          ),
        ),
      ],
    );
  }
}
