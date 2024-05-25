import 'package:acolherconsultas/core/splashScreen.dart';
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
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Scaffold();
        } else if(snapshot.connectionState == ConnectionState.active && snapshot.hasData){
          // Widget que verifica o nível de acesso do usuário
          // E redireciona para a tela correta
          return FutureBuilder(
            future: context.read<UsuarioProvider>().checkUser(),
            builder: (context, nivelAcesso){
              if(nivelAcesso.connectionState == ConnectionState.waiting){
                return const SplashScreen();
              } else if(nivelAcesso.connectionState == ConnectionState.done){
                switch (nivelAcesso.data){
                  case NivelAcesso.admin:
                    return const HomeAdmin();
                  case NivelAcesso.acolher:
                    return const HomeAcolher();
                  case NivelAcesso.instituicao:
                    return const HomeInstituicao();
                  default: {
                    context.read<UsuarioProvider>().auth.signOut();
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