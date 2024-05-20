import 'package:acolherconsultas/modules/casasDeApoio/views/casaDeApoioLista.dart';
import 'package:acolherconsultas/modules/usuarios/views/usuarioLista.dart';
import 'package:acolherconsultas/shared/components/bars/homeAppbar.dart';
import 'package:acolherconsultas/shared/components/bars/tabBar.dart';
import 'package:acolherconsultas/shared/components/buttons/standartRoundButton.dart';
import 'package:flutter/material.dart';

class HomeAdmin extends StatelessWidget {
  const HomeAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomTabBar(
      appBar: HomeAppbar(admin: true),
      fabs_: [
        StandartRoundButton(text: "Novo Usuário", icon: Icons.add_box_outlined),
        StandartRoundButton(text: "Nova Casa",    icon: Icons.add_box_outlined),
      ], 
      tabs_: [
        "Usuários", 
        "Casas de Apoio"
      ], 
      views_: [
        UsuarioLista(),
        CasaDeApoioLista()
      ], 
    );
  }
}