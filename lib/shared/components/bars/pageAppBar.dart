import 'package:acolherconsultas/shared/colors.dart';
import 'package:acolherconsultas/shared/components/text/textoColorido.dart';
import 'package:flutter/material.dart';

class PageAppBar extends StatefulWidget implements PreferredSizeWidget {
  const PageAppBar({super.key, required this.titulo});

  final String titulo;
  
  @override
  State<PageAppBar> createState() => _PageAppBarState();
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _PageAppBarState extends State<PageAppBar> {

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: amareloNavbar,
      toolbarHeight: 60,
      centerTitle: true,
      title: TextoColorido(palavra: widget.titulo),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 28,
                child: const Icon(
                  Icons.cottage_outlined, 
                  color: Color(0xFF2277AE),
                  size: 35,
                ),
              ),
              Text(
                "Casa",
                style: TextStyle(
                  fontFamily: "BobbyJonesSoft",
                  fontSize: 18,
                ),
              )
            ]
          )
        ),
      ],
    );
  }
}
