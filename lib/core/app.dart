import 'package:acolherconsultas/modules/home/pages/home.dart';
import 'package:acolherconsultas/modules/pacientes/controllers/pacientesCadastradosProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PacientesCadastradosProvider()),
      ],
      child: MaterialApp(
        supportedLocales: const [
          Locale('pt'),
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: false,
        title: 'Acolher Consultas',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomePage(title: 'Sistema Acolher Consultas v1.0'),
      ),
    );
  }
}