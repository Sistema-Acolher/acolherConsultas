import 'package:acolherconsultas/modules/casasDeApoio/models/casaDeApoio.dart';
import 'package:acolherconsultas/modules/usuarios/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:acolherconsultas/modules/usuarios/controllers/usuarioController.dart';
import 'package:acolherconsultas/shared/colors.dart';
import 'package:acolherconsultas/shared/components/dropdown/casasDropdown.dart';
import 'package:acolherconsultas/shared/components/dropdown/perfilDropdown.dart';

class HomeAppbar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);


  @override
  Widget build(BuildContext context) {
    final casaDeApoioSelecionada = Provider.of<CasaDeApoio>(context);
    final listMapCasasDeApoio = Provider.of<List<CasaDeApoio>>(context);
    var usuario =context.read<UsuarioController>().usuarioAtual;
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: amareloNavbar,
      toolbarHeight: 50,
      leading: Padding(
        padding: const EdgeInsets.only(left: 20),
        // TODO: fazer função que retorna o widget correto, seja admin, a casa do usuario instituicao ou a lista de casas pro usuario acolher
        child: usuario?.nivelAcesso==NivelAcesso.admin
            ? const CasaItem(text: "Admin", color: 0xFF7A7A7A)
            : usuario?.nivelAcesso==NivelAcesso.acolher
            ? CasasDropdown(
                casas: listMapCasasDeApoio
              )
            : CasaItem(text: casaDeApoioSelecionada.nome ?? "", color: casaDeApoioSelecionada.cor ?? 0xFF000000)),
      leadingWidth: 220,
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: UserDropdown(
            // Passa o nome do usuário logado para o componente
            // userName: context.read<UsuarioProvider>().usuarioAtual!.nome,
            userName: context.read<UsuarioController>().usuarioAtual?.nome ??
                'Nome usuario',
          ),
        ),
      ],
    );
  }
}
