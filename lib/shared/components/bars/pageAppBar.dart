import 'package:acolherconsultas/shared/components/dropdown/perfilDropdown.dart';
import 'package:acolherconsultas/shared/components/text/textoColorido.dart';
import 'package:flutter/material.dart';

class PageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PageAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: const TextoColorido(palavra: "titulo"),
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
