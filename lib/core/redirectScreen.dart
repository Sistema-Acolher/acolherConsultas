import 'package:acolherconsultas/modules/casasDeApoio/models/casaDeApoio.dart';
import 'package:acolherconsultas/modules/consultas/controllers/consultaController.dart';
import 'package:acolherconsultas/modules/sistema/views/loadingLogo.dart';
import 'package:acolherconsultas/modules/usuarios/views/usuarioVerificaEmail.dart';
import "package:collection/collection.dart";
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
        stream: context.read<UsuarioController>().auth.authStateChanges(),
        builder: (context, snapshotUser) {
          // Podemos tirar esse if, mas isso faz com que seja redirecionado para uma nova tela de login enquanto carrega
          if (snapshotUser.connectionState == ConnectionState.waiting) {
            return const LoadingLogo();
          } else if (snapshotUser.connectionState == ConnectionState.active &&
              snapshotUser.hasData) {
            context.read<UsuarioController>().emailVerificado.value = context
                .read<UsuarioController>()
                .auth
                .currentUser!
                .emailVerified;
            // Widget que verifica o nível de acesso do usuário
            // E redireciona para a tela correta
            return FutureBuilder(
                future: Future.wait(
                    [context.read<UsuarioController>().checkUser()]),
                builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                  // Podemos tirar esse if, mas isso faz com que seja redirecionado para uma nova tela de login enquanto carrega
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const LoadingLogo();
                  } else if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    return ValueListenableBuilder(
                        valueListenable:
                            context.read<UsuarioController>().emailVerificado,
                        builder: (context, emailVerificado, child) {
                          if (emailVerificado) {
                            ConsultaController().mudarEstadoConsultas();
                            final listaCasas =
                                Provider.of<List<CasaDeApoio>>(context);
                            switch (snapshot.data![0]) {
                              case NivelAcesso.admin:
                                return const HomeAdmin();
                              case NivelAcesso.acolher:
                                // Seleciona a casa de apoio Servos como padrão
                                if (listaCasas.isNotEmpty) {
                                  Provider.of<CasaDeApoioController>(context,
                                          listen: false)
                                      .selecionarCasaDeApoio(listaCasas
                                          .sorted((CasaDeApoio a,
                                                  CasaDeApoio b) =>
                                              a.nome?.compareTo(b.nome ?? "") ??
                                              0)
                                          .first);
                                  return const HomeAcolher();
                                } else {
                                  // Exibir um indicador de carregamento enquanto os dados estão vazios.
                                  return const LoadingLogo();
                                }
                              case NivelAcesso.casaDeApoio:
                                // Seleciona a casa de apoio do usuário da instituição
                                if (listaCasas.isNotEmpty) {
                                  Provider.of<CasaDeApoioController>(context,
                                          listen: false)
                                      .selecionarCasaDeApoio(
                                          listaCasas.firstWhere((element) =>
                                              element.id ==
                                              context
                                                  .read<UsuarioController>()
                                                  .usuarioAtual!
                                                  .casaDeApoioId));
                                  return const HomeInstituicao();
                                } else {
                                  // Exibir um indicador de carregamento enquanto os dados estão vazios.
                                  return const LoadingLogo();
                                }
                              default:
                                {
                                  context.read<UsuarioController>().logout();
                                  return const UsuarioLoginScreen();
                                }
                            }
                          } else {
                            return const VerificaEmailScreen();
                          }
                        });
                  } else {
                    return const UsuarioLoginScreen();
                  }
                });
          } else {
            return const UsuarioLoginScreen();
          }
        });
  }
}
