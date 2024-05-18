import 'package:acolherconsultas/modules/usuarios/models/usuario.dart';
import 'package:acolherconsultas/shared/databases/repositories/usuarioRepository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UsuarioProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UsuarioRepository _usuarioRepository = UsuarioRepository();
  NivelAcesso? _nivelAcesso;
  Usuario? _usuarioAtual;

  Future<NivelAcesso?> login(String email, String senha) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: senha);

      final user = _auth.currentUser;
      final usuario = await _usuarioRepository.selecionar(user!.uid);

      if (usuario != null) {
        _usuarioAtual = usuario;
        _nivelAcesso = usuario.nivelAcesso;
        notifyListeners();
      }

      return usuario?.nivelAcesso;
    } catch (e) {
      rethrow;
    }
  }

  logout() async {
    _nivelAcesso = null;
    _usuarioAtual = null;
    _auth.signOut();
  }
}