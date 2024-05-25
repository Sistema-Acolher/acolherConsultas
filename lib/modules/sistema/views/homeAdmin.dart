import 'package:acolherconsultas/modules/casasDeApoio/views/casaDeApoioCadastro.dart';
import 'package:acolherconsultas/modules/casasDeApoio/views/casaDeApoioLista.dart';
import 'package:acolherconsultas/modules/usuarios/views/usuarioCadastro.dart';
import 'package:acolherconsultas/modules/usuarios/views/usuarioLista.dart';
import 'package:acolherconsultas/shared/components/bars/homeAppbar.dart';
import 'package:acolherconsultas/shared/components/bars/tabBar.dart';
import 'package:acolherconsultas/shared/components/buttons/standartRoundButton.dart';
import 'package:flutter/material.dart';

class HomeAdmin extends StatelessWidget {
  const HomeAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return  CustomTabBar(
      appBar: const HomeAppbar(),
      fabs_: [
        StandartRoundButton(text: "Novo Usuário", icon: Icons.add_box_outlined, onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CadastroUsuarioScreen()))),
        StandartRoundButton(text: "Nova Casa",    icon: Icons.add_box_outlined, onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CadastroCasaDeApoioScreen()))),
      ], 
      tabs_: const [
        "Usuários", 
        "Casas de Apoio"
      ], 
      views_: const [
        UsuarioLista(),
        CasaDeApoioLista()
      ], 
    );
  }
}