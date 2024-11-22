import 'package:acolherconsultas/core/redirectScreen.dart';
import 'package:acolherconsultas/core/splashScreen.dart';
import 'package:acolherconsultas/modules/casasDeApoio/controller/casaDeApoioController.dart';
import 'package:acolherconsultas/modules/casasDeApoio/models/casaDeApoio.dart';
import 'package:acolherconsultas/modules/consultas/controllers/consultaController.dart';
import 'package:acolherconsultas/modules/consultas/models/consulta.dart';
import 'package:acolherconsultas/modules/pacientes/controllers/pacienteController.dart';
import 'package:acolherconsultas/modules/pacientes/models/paciente.dart';
import 'package:acolherconsultas/modules/usuarios/controllers/usuarioController.dart';
import 'package:acolherconsultas/modules/usuarios/models/usuario.dart';
import 'package:acolherconsultas/shared/colors.dart';
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
        StreamProvider<List<CadastroPaciente>>(
          create: (context) => PacientesController().pacientesStream,
          initialData: const [],
        ),
        StreamProvider<List<ConsultaCadastro>>(
          create: (context) => ConsultaController().consultasStream,
          initialData: const [],
        ),
        StreamProvider<List<Usuario>>(
          create: (context) => UsuarioController().usuariosStream,
          initialData: const [],
        ),
        ChangeNotifierProvider(create: (_) => UsuarioController()),
        ChangeNotifierProvider <CasaDeApoioController>(
          create: (_) => CasaDeApoioController()
        ),
        StreamProvider<List<CasaDeApoio>>(
          create: (context) => Provider.of<CasaDeApoioController>(context, listen: false).casasDeApoioStream,
          initialData: const [],
        ),
        StreamProvider<CasaDeApoio>(
          create: (context) => Provider.of<CasaDeApoioController>(context, listen: false).casaDeApoioSelecionadaStream.stream,
          initialData: CasaDeApoio.vazio(),
        ),
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
          textSelectionTheme: const TextSelectionThemeData(selectionHandleColor: amareloEscuro),
          // O colorScheme é uma propriedade que define o esquema de cores do aplicativo.
          colorScheme: ColorScheme.fromSeed(seedColor: amarelo),
          disabledColor: const Color.fromARGB(255, 37, 37, 37),
          // O useMaterial3 é uma propriedade que define se o aplicativo usa o Material Design 3.
          useMaterial3: true,
          fontFamily: "Montserrat",
        ),
        // O home é uma propriedade que define a página inicial do aplicativo.
        home: const SplashScreen(
          nextScreen: RedirectScreen(),
          duration: Duration(milliseconds: 3515),
        ),
      ),
    );
  }
}