import 'package:acolherconsultas/modules/home/pages/consultasScreen.dart';
import 'package:acolherconsultas/modules/pacientes/pages/cadastroPacienteScreen.dart';
import 'package:acolherconsultas/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

// A classe HomePage é a classe que representa a página inicial do aplicativo.
class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  // O título da página inicial.
  final String title;

  // O método createState é responsável por criar o estado da página inicial.
  @override
  State<HomePage> createState() => _HomePageState();
}

// A classe _HomePageState é a classe que representa o estado da página inicial do aplicativo.
class _HomePageState extends State<HomePage> {
  // O método build é responsável por construir a interface da página inicial.
  @override
  Widget build(BuildContext context) {
    // O Scaffold é um widget que implementa o layout visual básico do Material Design (tela branca de fundo).
    return Scaffold(
      // O AppBar é um widget que implementa a barra superior do aplicativo, normalmente com título, botões e ícones de funcionaliades do app.
      appBar: AppBar(
        title: Text(
          widget.title,
          // Exemplo de uso de fonte e cor personalizada.
          style: const TextStyle(
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
              color: amareloEscuro),
        ),
      ),
      // O body é um widget que implementa o corpo do aplicativo, onde são exibidos os conteúdos da página, abaixo do Appbar.
      // O Center é um widget que centraliza o conteúdo do widget filho.
      body: PersistentTabView(
        tabs: [
          PersistentTabConfig(
            screen: const ConsultasScreen(),
            item: ItemConfig(
                icon: const Icon(Icons.medical_information, color: verde),
                title: "Consultas",
                textStyle: const TextStyle(color: verde),
                inactiveForegroundColor: verde,
                activeForegroundColor: verdeEscuro),
          ),
          PersistentTabConfig(
            screen: _buildPage('Agenda'),
            item: ItemConfig(
                icon: const Icon(Icons.date_range, color: vermelho),
                title: "Agenda",
                textStyle: const TextStyle(color: vermelho),
                inactiveForegroundColor: vermelho,
                activeForegroundColor: vermelhoEscuro),
          ),
          PersistentTabConfig(
            screen:
                const CadastroPacienteScreen(title: "Cadastro de Pacientes"),
            item: ItemConfig(
                icon: const Icon(Icons.menu_book, color: azul),
                title: "Cadastro",
                textStyle: const TextStyle(color: azul),
                inactiveForegroundColor: azul,
                activeForegroundColor: azulEscuro),
          ),
          PersistentTabConfig(
            screen: _buildPage('Relatório'),
            item: ItemConfig(
                icon: const Icon(
                  Icons.description,
                  color: cinzaClaro,
                ),
                title: "Relatório",
                textStyle: const TextStyle(color: cinzaClaro),
                inactiveForegroundColor: cinzaClaro,
                activeForegroundColor: cinza),
          ),
        ],
        navBarBuilder: (navBarConfig) => Style1BottomNavBar(
          navBarDecoration: const NavBarDecoration(color: amarelo),
          navBarConfig: navBarConfig,
        ),
      ),
    );
  }
}

Widget _buildPage(String title) {
  return Center(
    child: Text(
      title,
      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    ),
  );
}
