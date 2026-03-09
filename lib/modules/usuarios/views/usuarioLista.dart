import 'package:acolherconsultas/modules/usuarios/models/usuario.dart';
import 'package:acolherconsultas/modules/usuarios/views/usuarioCadastro.dart';
import 'package:acolherconsultas/shared/components/list/listaComIcone.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class UsuarioLista extends StatefulWidget {
  const UsuarioLista({super.key});

  @override
  State<UsuarioLista> createState() => _UsuarioListaState();
}

class _UsuarioListaState extends State<UsuarioLista> {
  late ValueNotifier<List<Usuario>> todosUsuarios;

  @override
  void initState() {
    super.initState();
    todosUsuarios = ValueNotifier<List<Usuario>>([]);

  }

  void _buscarUsuarios() {
    todosUsuarios.value = Provider.of<List<Usuario>>(context)
      .toList();

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _buscarUsuarios();
  }

  @override
  Widget build(BuildContext context) {    
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 16, bottom: 50),
      child: ValueListenableBuilder<List<Usuario>>(
        valueListenable: todosUsuarios,
        builder: (context, usuarios, child) => ListaComIcone(
          listaElementos: usuarios,
          onEdit: (Usuario usuario){
            Navigator.push(context, MaterialPageRoute(builder: (context) => CadastroUsuarioScreen(usuario: usuario)));
          },
        )
      ),
    );
  }
}