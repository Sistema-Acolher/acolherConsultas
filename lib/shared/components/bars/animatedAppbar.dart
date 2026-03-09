import 'package:flutter/material.dart';

class AppBarAnimada extends StatefulWidget implements PreferredSizeWidget {
  const AppBarAnimada({
    super.key,
    required this.title,
    required this.showAppBar,
    required this.sair,
  });

  final String title;
  final ValueNotifier<bool> showAppBar;
  final bool sair;

  @override
  State<AppBarAnimada> createState() => _AppBarAnimadaState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppBarAnimadaState extends State<AppBarAnimada> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: widget.showAppBar.value ? MediaQuery.of(context).padding.top + kToolbarHeight : 0,
      duration: const Duration(milliseconds: 300),
      child: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => {
            if(widget.sair)
              Navigator.of(context).pop()
            else{
              // mostrar alertDialog perguntando se deseja sair sem salvar
              showDialog(
                context: context, 
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Deseja sair sem salvar?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Não'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: const Text('Sim'),
                      ),
                    ],
                  );
                }
              )

            }

          },
        ),
      ),
    );
  }
}