import 'package:acolherconsultas/modules/usuarios/models/usuario.dart';
import 'package:acolherconsultas/shared/databases/repositories/usuarioRepository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UsuarioProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UsuarioRepository _usuarioRepository = UsuarioRepository();
  NivelAcesso? _nivelAcesso;
  Usuario? _usuarioAtual;

  NivelAcesso? get nivelAcesso => _nivelAcesso;
  Usuario? get usuarioAtual => _usuarioAtual;
  FirebaseAuth get auth => _auth;

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
    _auth.signOut();
  }

  // Função de cadastro de novos usuários do controller
  Future<Usuario?> cadastrar(Usuario usuario, String senha) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(email: usuario.email, password: senha);
      usuario.id = userCredential.user!.uid;

      await _usuarioRepository.criar(usuario);
      notifyListeners();

      return usuario;
    } catch (e) {
      rethrow;
    }
  }
}