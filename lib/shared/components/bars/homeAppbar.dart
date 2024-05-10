import 'package:acolherconsultas/shared/colors.dart';
import 'package:acolherconsultas/shared/components/dropdown/casasDropdown.dart';
import 'package:acolherconsultas/shared/components/dropdown/perfilDropdown.dart';
import 'package:flutter/material.dart';

class HomeAppbar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppbar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: amareloNavbar,
      toolbarHeight: 50,
      flexibleSpace: const FlexibleSpaceBar(
        title: CasasDropdown(),
        titlePadding: EdgeInsets.only(left: 16, bottom: 8),
        centerTitle: false,
      ),
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
