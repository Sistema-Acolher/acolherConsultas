import 'package:acolherconsultas/shared/colors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  final PageController _pageController = PageController();

  int paginaAtual = 0;

  List<String> titulos = ["Quem Somos", "Objetivo", "Como nos encontrar"];

  List<String> textos = [
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
  ];

  //list of controllers for the scrollbars
  final List<ScrollController> _scrollControllers = [];
  _InfoScreenState() {
    for (int i = 0; i < textos.length; i++) {
      _scrollControllers.add(
        ScrollController(
          initialScrollOffset: -500, keepScrollOffset: true, debugLabel: i.toString()
      ));
    }
  }

  // Cores do "gradiente" de cima
  final listaCoresCima = [
    verdeEscuro,
    const Color(0xFF363636),
    const Color(0xFF363636),
    amarelo,
    amarelo,
    azul,
  ];

  // Cores do "gradiente" de baixo
  final listaCoresBaixo = [
    vermelho,
    verdeEscuro,
    verdeEscuro,
    azul,
    azul,
    amarelo,
  ];

  // Paradas do "gradiente"
  final listaParadas = [0.25, 0.25, 0.5, 0.5, 0.75, 0.75];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double paddingtop = MediaQuery.of(context).padding.top;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Hero(
            tag: "gradienteCima",
            child: Container(
              height: paddingtop + (size.height * 0.065),
              width: size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: listaCoresCima,
                  stops: listaParadas,
                  end: Alignment.centerRight,
                  begin: Alignment.centerLeft,
                ),
              ),
            ),
          ),
          Container(
              margin: EdgeInsets.symmetric(horizontal: size.width * 0.15),
              child: const Hero(
                  tag: "logo",
                  child: Image(image: AssetImage('src/images/logo.gif'))
              )
          ),
          Stack(
            children: [
              Hero(
                tag: "containerLogin",
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    height: size.height * 0.45,
                    padding: const EdgeInsets.all(20),
                    margin: EdgeInsets.symmetric(horizontal: size.width * 0.07),
                    decoration: const BoxDecoration(
                        color: amareloEscuro,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(25),
                            topRight: Radius.circular(25))),
                  ),
                ),
              ),
              Container(
                height: size.height * 0.45,
                padding: const EdgeInsets.all(20),
                margin: EdgeInsets.symmetric(horizontal: size.width * 0.07),
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Hero(
                            tag: "botaoInfoLogin",
                            child: IconButton(
                              iconSize: 34,
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                              icon: const Icon(
                                Icons.arrow_circle_left_outlined,
                                color: preto,
                              ),
                            ),
                          ),
                          Hero(
                            tag: "tituloLogin",
                            child: Padding(
                              padding: const EdgeInsets.only(top: 3, right: 12),
                              child: AutoSizeText(
                                titulos[paginaAtual],
                                maxLines: 1,
                                style: const TextStyle(
                                  fontFamily: "BobbyJonesSoft",
                                  fontWeight: FontWeight.bold,
                                  color: preto,
                                  decoration: TextDecoration.none,
                                ),
                                textAlign: TextAlign.right,
                                minFontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            paginaAtual = index;
                          });
                        },
                        itemCount: textos.length,
                        itemBuilder: (context, index) {
                          return RawScrollbar(
                            thumbColor: preto,
                            controller: _scrollControllers[index],
                            thickness: 3,
                            thumbVisibility: true,
                            radius: const Radius.circular(10),
                            child: Hero(
                              tag: "esqueciSenha",
                              child: Material(
                                type: MaterialType.transparency,
                                child: SingleChildScrollView(
                                  controller: _scrollControllers[index],
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 12, right: 12, top: 22),
                                    child: Text(
                                      textos[index],
                                      style: const TextStyle(
                                        fontFamily: "Montserrat",
                                        fontSize: 14
                                      ),
                                      textAlign: TextAlign.justify,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: paginaAtual == 0
                            ? MainAxisAlignment.end
                            : paginaAtual == textos.length - 1
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.spaceBetween,
                        children: [
                          if(paginaAtual != 0)
                            IconButton(
                              icon: const Icon(
                                Icons.chevron_left,
                                color: preto,
                                size: 30,
                              ),
                              onPressed: () {
                                if (paginaAtual > 0) {
                                  _pageController.previousPage(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut);
                                }
                              },
                            ),
                          if(paginaAtual != textos.length - 1)
                            Hero(
                              tag: "botaoEnviarLogin",
                              child: IconButton(
                                icon: const Icon(
                                  Icons.chevron_right,
                                  color: preto,
                                  size: 30,
                                ),
                                onPressed: () {
                                  if (paginaAtual < textos.length - 1) {
                                    _pageController.nextPage(
                                        duration: const Duration(milliseconds: 300),
                                        curve: Curves.easeInOut);
                                  }
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // row com as logos das instituições
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image(
                image: const AssetImage('src/images/logoCefet.png'),
                width: size.width * 0.2,
              ),
              Image(
                image: const AssetImage('src/images/logoUFSJ.png'),
                width: size.width * 0.2,
              ),
              // Image(
              //   image: const AssetImage('src/images/logoUFSJ1.png'),
              //   width: size.width * 0.15,
              // ),
              // Image(
              //   image: const AssetImage('src/images/logoUFSJ2.png'),
              //   width: size.width * 0.15,
              // ),
            ],
          ),
          // SizedBox(
          //   height: size.height * 0.005,
          // ),
          Hero(
            tag: "gradienteBaixo",
            child: Container(
              height: size.height * 0.065,
              width: size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: listaCoresBaixo,
                  stops: listaParadas,
                  end: Alignment.centerRight,
                  begin: Alignment.centerLeft,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}