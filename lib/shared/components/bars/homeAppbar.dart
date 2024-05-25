// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:acolherconsultas/modules/casasDeApoio/controller/casaDeApoioController.dart';
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
    final casaDeApoioSelecionada = context.read<CasaDeApoioProvider>().casaDeApoioSelecionada;
    final listaCasasDeApoio = context.read<CasaDeApoioProvider>().casasDeApoio;
    final listMapCasasDeApoio = listaCasasDeApoio.map((e) => {'name': e.nome, 'color': e.cor}).toList();
    var usuario =context.read<UsuarioProvider>().usuarioAtual;
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
            : CasaItem(text: casaDeApoioSelecionada.value.nome ?? "", color: casaDeApoioSelecionada.value.cor ?? 0xFF000000)),
      leadingWidth: 220,
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: UserDropdown(
            // Passa o nome do usuário logado para o componente
            // userName: context.read<UsuarioProvider>().usuarioAtual!.nome,
            userName: context.read<UsuarioProvider>().usuarioAtual?.nome ??
                'Nome usuario',
          ),
        ),
      ],
    );
  }
}
