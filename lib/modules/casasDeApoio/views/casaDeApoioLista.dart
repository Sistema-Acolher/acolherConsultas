import 'package:acolherconsultas/modules/casasDeApoio/models/casaDeApoio.dart';
import 'package:acolherconsultas/modules/casasDeApoio/views/casaDeApoioCadastro.dart';
import 'package:acolherconsultas/shared/components/list/listaComIcone.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class CasaDeApoioLista extends StatefulWidget {
  const CasaDeApoioLista({super.key});

  @override
  State<CasaDeApoioLista> createState() => _CasaDeApoioListaState();
}

class _CasaDeApoioListaState extends State<CasaDeApoioLista> {
  late ValueNotifier<List<CasaDeApoio>> todosCasaDeApoios;

  @override
  void initState() {
    super.initState();
    todosCasaDeApoios = ValueNotifier<List<CasaDeApoio>>([]);
  }

  void _buscarCasasDeApoio() {
    todosCasaDeApoios.value = Provider.of<List<CasaDeApoio>>(context)
      .toList();
  }

  @override
  Widget build(BuildContext context) {
    _buscarCasasDeApoio();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 16, bottom: 50),
      child: ValueListenableBuilder<List<CasaDeApoio>>(
        valueListenable: todosCasaDeApoios,
        builder: (context, casaDeApoios, child) => ListaComIcone(
          listaElementos: casaDeApoios,
          onEdit: (CasaDeApoio casaDeApoio){
            Navigator.push(context, MaterialPageRoute(builder: (context) => CadastroCasaDeApoioScreen(casaDeApoio: casaDeApoio)));
          },
        )
      ),
    );
  }
}