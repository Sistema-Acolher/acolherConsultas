import 'package:acolherconsultas/modules/pacientes/pages/cadastroPacienteScreen.dart';
import 'package:acolherconsultas/modules/pacientes/pages/pacientesCadastradosScreen.dart';
import 'package:acolherconsultas/shared/colors.dart';
import 'package:acolherconsultas/shared/components/dropdown/casasDropdown.dart';
import 'package:acolherconsultas/shared/components/dropdown/perfilDropdown.dart';
import 'package:flutter/material.dart';

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
      body: Center(
        // O Column é um widget que organiza os widgets filhos em uma coluna vertical e sem scroll.
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topRight,
                child: UserDropdown(
                  userName: "Nome usuário",
                ),
              ),
            ),
            const CasasDropdown(),
            TextButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CadastroPacienteScreen(
                          title: "Cadastro de Pacientes"))),
              child: const Text(
                "Cadastro de Pacientes",
                style: TextStyle(
                  fontFamily: "BobbyJonesCondensed",
                  color: vermelhoEscuro,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const PacientesCadastradosScreen())),
              child: const Text(
                "Lista de Pacientes Cadastrados",
                style: TextStyle(
                  fontFamily: "BobbyJonesSoft",
                  color: verdeEscuro,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
