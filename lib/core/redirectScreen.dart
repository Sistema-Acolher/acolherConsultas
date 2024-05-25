import 'package:acolherconsultas/core/splashScreen.dart';
import 'package:acolherconsultas/modules/casasDeApoio/controller/casaDeApoioController.dart';
import 'package:acolherconsultas/modules/sistema/views/homeAcolher.dart';
import 'package:acolherconsultas/modules/sistema/views/homeAdmin.dart';
import 'package:acolherconsultas/modules/sistema/views/homeInstituicao.dart';
import 'package:acolherconsultas/modules/usuarios/controllers/usuarioController.dart';
import 'package:acolherconsultas/modules/usuarios/models/usuario.dart';
import 'package:acolherconsultas/modules/usuarios/views/usuarioLogin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RedirectScreen extends StatelessWidget {
  const RedirectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Widget que redireciona o usuário para a tela correta
    // Verifica se o usuário está logado
    return StreamBuilder<User?>(
      stream: context.read<UsuarioProvider>().auth.authStateChanges(), 
      builder: (context, snapshot) {
        // Podemos tirar esse if, mas isso faz com que seja redirecionado para uma nova tela de login enquanto carrega
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Scaffold();
        } else if(snapshot.connectionState == ConnectionState.active && snapshot.hasData){
          // Widget que verifica o nível de acesso do usuário
          // E redireciona para a tela correta
          return FutureBuilder(
            future: Future.wait([context.read<UsuarioProvider>().checkUser(), context.read<CasaDeApoioProvider>().getCasasDeApoio()]),
            builder: (context, AsyncSnapshot<List<dynamic>> snapshot){
              // Podemos tirar esse if, mas isso faz com que seja redirecionado para uma nova tela de login enquanto carrega
              if(snapshot.connectionState == ConnectionState.waiting){
                return const Scaffold();
              } else if(snapshot.connectionState == ConnectionState.done){
                switch (snapshot.data![0]){
                  case NivelAcesso.admin:
                    return const HomeAdmin();
                  case NivelAcesso.acolher:
                    // Seleciona a casa de apoio Servos como padrão
                    context.read<CasaDeApoioProvider>().selecionarCasaDeApoio(
                      context.read<CasaDeApoioProvider>().casasDeApoio.firstWhere((element) => element.nome == "Servos")
                    );
                    return const HomeAcolher();
                  case NivelAcesso.casaDeApoio:
                    // Seleciona a casa de apoio do usuário da instituição
                    context.read<CasaDeApoioProvider>().selecionarCasaDeApoio(
                      context.read<CasaDeApoioProvider>().casasDeApoio.firstWhere((element) => element.id == context.read<UsuarioProvider>().usuarioAtual!.casaDeApoioId)
                    );
                    return const HomeInstituicao();
                  default: {
                    context.read<UsuarioProvider>().logout();
                    return const UsuarioLoginScreen();
                  }
                }
              } else {
                return const UsuarioLoginScreen();
              }
            }
          );
        } else {
          return const UsuarioLoginScreen();
        }
      }
    );
  }
}