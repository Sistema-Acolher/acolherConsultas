import 'dart:async';

import 'package:acolherconsultas/modules/usuarios/models/usuario.dart';
import 'package:acolherconsultas/shared/colors.dart';
import 'package:acolherconsultas/shared/databases/repositories/usuarioRepository.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UsuarioController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UsuarioRepository _usuarioRepository = UsuarioRepository();
  NivelAcesso? _nivelAcesso;
  Usuario? _usuarioAtual;
  ValueNotifier<bool> _emailVerificado = ValueNotifier(false);

  NivelAcesso? get nivelAcesso => _nivelAcesso;
  Usuario? get usuarioAtual => _usuarioAtual;
  FirebaseAuth get auth => _auth;
  ValueNotifier<bool> get emailVerificado => _emailVerificado;

  // Função de login do controller
  Future<void> login(String email, String senha) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: senha);
    } catch (e) {
      rethrow;
    }
  }

  // Função de verificação do nível de acesso do usuário logado
  Future<NivelAcesso?> checkUser() async {
    try {
      final user = _auth.currentUser;

      if (user != null) {
        final usuario = await _usuarioRepository.selecionar(user.uid);

        if (usuario != null) {
          _usuarioAtual = usuario;
          _nivelAcesso = usuario.nivelAcesso;
          notifyListeners();
        }
        return usuario!.nivelAcesso;
      }

      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Função de logout do controller
  logout() async {
    _nivelAcesso = null;
    _usuarioAtual = null;
    await _auth.signOut();
  }

  // Função de cadastro de novos usuários do controller
  Future<Usuario?> cadastrar(Usuario usuario, String senha) async {
    try {
      FirebaseApp tempApp = await Firebase.initializeApp(name: 'Temporário', options: Firebase.app().options);
      final userCredential = await FirebaseAuth.instanceFor(app: tempApp).createUserWithEmailAndPassword(email: usuario.email, password: senha);
      usuario.id = userCredential.user!.uid;
      
      await FirebaseAuth.instanceFor(app: tempApp).currentUser!.updateDisplayName(usuario.nome);
      enviarEmailVerificacao(tempApp: tempApp).then((_) async {
        await FirebaseAuth.instanceFor(app: tempApp).signOut().then(
          (value) async {
            await tempApp.delete();
          }
        );
      });

      await _usuarioRepository.criar(usuario);
      notifyListeners();

      return usuario;
    } catch (e) {
      rethrow;
    }
  }

  // Função para enviar email de verificação
  enviarEmailVerificacao({FirebaseApp? tempApp}) async {
    try {
      if (tempApp != null) {
        await FirebaseAuth.instanceFor(app: tempApp).currentUser!.sendEmailVerification();
      } else {
        await _auth.currentUser!.sendEmailVerification();
      }
    } catch (e) {
      rethrow;
    }
  }

  // Função para redirecionar o usuário após verificar o email automaticamente
  Future<void> timerRedirect(BuildContext context) async{
    Timer.periodic(
      const Duration(seconds: 2), 
      (timer) async {
        try {
          if(_auth.currentUser == null){
            timer.cancel();
          } else {
            await _auth.currentUser!.reload();
            if(_auth.currentUser!.emailVerified){
              showLoading(context);
              _emailVerificado.value = _auth.currentUser!.emailVerified;
              final snackBar = SnackBar(
                elevation: 0,
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.transparent,
                content: AwesomeSnackbarContent(
                  title: 'Sucesso',
                  message:
                      'Seu e-mail foi verificado com sucesso!',
                  contentType: ContentType.success,
                ),
                duration: const Duration(seconds: 10),
              );
              Navigator.pop(context);
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(snackBar);
              timer.cancel();
            }
          }
        } on Exception catch (e) {
          timer.cancel();
        }
      }
    );
  }

  // Função para verificar se o email foi verificado manualmente
  verificarEmail(BuildContext context) async {
    showLoading(context);
    await _auth.currentUser!.reload().then((value) => Navigator.pop(context));
    _emailVerificado.value = _auth.currentUser!.emailVerified;
    if(_auth.currentUser!.emailVerified){
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Sucesso',
          message:
              'Seu e-mail foi verificado com sucesso!',
          contentType: ContentType.success,
        ),
        duration: const Duration(seconds: 10),
      );
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    } else {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Erro',
          message:
              'Seu e-mail ainda não foi verificado.',
          contentType: ContentType.failure,
        ),
        duration: const Duration(seconds: 10),
      );
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }

  showLoading(context){
    showDialog(
      context: context, 
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          color: preto,
        )
      ),
      barrierDismissible: false
    );
  }
}