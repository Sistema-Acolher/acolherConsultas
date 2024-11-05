import 'dart:async';

import 'package:acolherconsultas/modules/usuarios/models/usuario.dart';
import 'package:acolherconsultas/shared/colors.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class UsuarioController extends ChangeNotifier {
  // Instância do Firestore, que é a classe responsável por realizar a comunicação com o banco de dados Firebase Firestore.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  NivelAcesso? _nivelAcesso;
  Usuario? _usuarioAtual;
  final ValueNotifier<bool> _emailVerificado = ValueNotifier(false);

  NivelAcesso? get nivelAcesso => _nivelAcesso;
  Usuario? get usuarioAtual => _usuarioAtual;
  FirebaseAuth get auth => _auth;
  ValueNotifier<bool> get emailVerificado => _emailVerificado;

  // CRUD -----------------------------------
  Future<Map<String, dynamic>?> criarUsuario(Usuario usuario) async {
    Map<String, dynamic> usuarioMap = usuario.toMap();
    // Remove o id do map usuário, pois o id é gerado automaticamente pelo Firebase.
    final id = usuarioMap["id"];
    usuarioMap.remove("id");
    // Adiciona o usuário no banco de dados com o nome do documento sendo o id do usuário.
    await _firestore.collection("usuarios").doc(id).set(usuarioMap);

    return usuarioMap;
  }

  Future<List<Map<String, dynamic>>> selecionarTodosUsuarios() async {
    QuerySnapshot querySnapshot = await _firestore.collection("usuarios").get();
    List<Map<String, dynamic>> usuarios = [];

    for (var element in querySnapshot.docs) {
      var usuario = element.data() as Map<String, dynamic>;
      usuario["id"] = element.id;
      usuarios.add(usuario);
    }

    return usuarios;
  }

  Future<void> atualizarUsuario(Map<String, dynamic> usuario) async {
    if(usuario["nivelAcesso"] != "casaDeApoio"){
      usuario.remove("casaDeApoioId");
    }
    String id = usuario["id"];
    usuario.remove("id");
    await _firestore.collection("usuarios").doc(id).update(usuario);    
  }

  Future<void> removerUsuario(Map<String, dynamic> usuario) async {
  }

  // Funções extras do banco -----------------------------------
  Stream<List<Usuario>> get usuariosStream {
    return _firestore.collection('usuarios').snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          var temp = doc.data();
          temp.addAll({'id':doc.id});
          return Usuario.fromMap(temp);
        }).toList();
      },
    );
  }


  Future<Map<String, dynamic>?> selecionar(String uid) async {
    DocumentSnapshot docSnapshot = await _firestore.collection("usuarios").doc(uid).get();

    return docSnapshot.data() as Map<String, dynamic>?;
  }

  // Funções da controller -----------------------------------
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
        final usuarioMap = await selecionar(user.uid);

        if (usuarioMap != null) {
          final usuario=Usuario.fromMap(usuarioMap);
          _usuarioAtual = usuario;
          _nivelAcesso = usuario.nivelAcesso;
          notifyListeners();
          return usuario.nivelAcesso;
        }
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

      await criarUsuario(usuario);
      notifyListeners();

      return usuario;
    } catch (e) {
      rethrow;
    }
  }

  enviarEmailRecuperacaoSenha(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
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
            await _auth.currentUser!.reload().then((value) {
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
            });
          }
        } on Exception {
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