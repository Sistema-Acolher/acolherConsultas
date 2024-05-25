import 'package:acolherconsultas/modules/casasDeApoio/models/casaDeApoio.dart';
import 'package:acolherconsultas/modules/usuarios/controllers/usuarioController.dart';
import 'package:acolherconsultas/modules/usuarios/models/usuario.dart';
import 'package:acolherconsultas/shared/colors.dart';
import 'package:acolherconsultas/shared/components/text/textoColorido.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageAppBar extends StatefulWidget implements PreferredSizeWidget {
  const PageAppBar({super.key, required this.titulo, required this.casaDeApoioSelecionada});

  final String titulo;
  final CasaDeApoio casaDeApoioSelecionada;
  
  @override
  State<PageAppBar> createState() => _PageAppBarState();
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _PageAppBarState extends State<PageAppBar> {
  @override
  Widget build(BuildContext context) {
  var usuario =context.read<UsuarioProvider>().usuarioAtual;
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: amareloNavbar,
      toolbarHeight: 60,
      centerTitle: true,
      leading: usuario?.nivelAcesso==NivelAcesso.casaDeApoio ? IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black,),
        onPressed: () => Navigator.of(context).pop(),
      ):null,
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
                child: Icon(
                  Icons.cottage_outlined, 
                  color: Color(widget.casaDeApoioSelecionada.cor ?? 0xFF000000),
                  size: 35,
                ),
              ),
              Text(
                widget.casaDeApoioSelecionada.nome ?? "",
                style: const TextStyle(
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
