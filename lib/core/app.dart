import 'package:acolherconsultas/modules/home/pages/home.dart';
import 'package:acolherconsultas/modules/pacientes/controllers/pacientesCadastradosProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

//Generate appropriate comments for the code at the top of the class and its functions in portuguese

// A classe MyApp é a classe principal do aplicativo, onde é definido o tema do aplicativo e a página inicial.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // O método build é responsável por construir a interface do aplicativo.
  @override
  Widget build(BuildContext context) {
    // O MultiProvider é um widget que permite que vários provedores de estado sejam usados em um único widget.
    return MultiProvider(
      providers: [
        // O ChangeNotifierProvider é um provedor de estado que notifica os 'ouvintes' quando o objeto fornecido muda.
        ChangeNotifierProvider(create: (_) => PacientesCadastradosProvider()),
      ],
      // O MaterialApp é um widget que define a interface do aplicativo (apenas um por aplicativo).
      child: MaterialApp(
        // O suportedLocales é uma lista de localizações suportadas pelo aplicativo.
        supportedLocales: const [
          Locale('pt'),
        ],
        // O localizationsDelegates é uma lista de delegados de localização que fornecem traduções para o aplicativo.
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        // O debugShowCheckedModeBanner é uma propriedade que define se a faixa de depuração é exibida.
        debugShowCheckedModeBanner: false,
        // O title é uma propriedade que define o título do aplicativo.
        title: 'Acolher Consultas',
        // O theme é uma propriedade que define o tema do aplicativo.
        theme: ThemeData(
          // O colorScheme é uma propriedade que define o esquema de cores do aplicativo.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          // O useMaterial3 é uma propriedade que define se o aplicativo usa o Material Design 3.
          useMaterial3: true,
        ),
        // O home é uma propriedade que define a página inicial do aplicativo.
        home: const HomePage(title: 'Sistema Acolher Consultas v1.0'),
      ),
    );
  }
}