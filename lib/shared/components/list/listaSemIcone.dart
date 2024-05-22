import 'package:acolherconsultas/modules/pacientes/models/pacienteCadastro.dart';
import 'package:acolherconsultas/modules/sistema/views/homePaciente.dart';
import 'package:flutter/material.dart';

class ListaSemIcone extends StatelessWidget {
  const ListaSemIcone({super.key, required this.listaObjeto});

  final List<CadastroPaciente> listaObjeto;

  List<Widget> data(BuildContext context){
    List<Widget> listaWidgets=[];
    for (var item in listaObjeto) {
      listaWidgets.add(
        Padding(
          padding: EdgeInsets.only(top: item!=listaObjeto.first?8.0:0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(builder: (context) => HomePaciente(paciente: item.paciente))
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        item.paciente.nome,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: 20
                        )
                      ),
                    )
                  ),
                ],
              ),
              item!=listaObjeto.last?const Divider(thickness: 1, height: 0,color: Color(0x1E212121),):const SizedBox.shrink()
            ],
          ),
        )
      );
    }
    return listaWidgets;
  }

  @override
  Widget build(BuildContext context) {
  return Column(
      mainAxisSize: MainAxisSize.min,
      children: data(context),
    );
  }
}
