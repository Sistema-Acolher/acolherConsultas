import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:acolherconsultas/core/app.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// A função main é a função principal do aplicativo, onde são inicializados o aplicativo e o Firebase (até então).
void main() async {
  // O método ensureInitialized é responsável por garantir que o Flutter esteja inicializado.
  WidgetsFlutterBinding.ensureInitialized();

  // O método initializeApp é responsável por inicializar o Firebase.
  await Firebase.initializeApp(
    // O parâmetro options é responsável por definir quais as plataformas aceitas e suas configurações (definidas em firebase_options.dart).
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // O método settings é responsável por definir as configurações do Firebase.
  // Aqui eu estou definindo o cache local, para o funcionamento do aplicativo offline.
  // Se passar de 100MB, o Firebase apaga os dados locais mais antigos automaticamente.
  
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  // O método runApp é responsável por executar o aplicativo.
  runApp(const MyApp());
}
