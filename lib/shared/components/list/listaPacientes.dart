import 'package:acolherconsultas/modules/pacientes/models/paciente.dart';
import 'package:acolherconsultas/modules/pacientes/views/pacienteScreen.dart';
import 'package:acolherconsultas/modules/sistema/views/homePaciente.dart';
import 'package:acolherconsultas/modules/usuarios/controllers/usuarioController.dart';
import 'package:acolherconsultas/modules/usuarios/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ListaDePacientes extends StatelessWidget {
  const ListaDePacientes({super.key, required this.listaObjeto});

  final List<CadastroPaciente> listaObjeto;

  List<Widget> data(BuildContext context){
    var usuario =context.read<UsuarioController>().usuarioAtual;
    List<Widget> listaWidgets=[];
    for (var item in listaObjeto) {
      listaWidgets.add(
        Padding(
          padding: EdgeInsets.only(top: item!=listaObjeto.first?8.0:0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(builder: (context) => 
                      usuario?.nivelAcesso==NivelAcesso.acolher?HomePaciente(paciente: item.paciente):PacienteScreen(paciente: item.paciente))
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        item.paciente.nome,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: 20
                        )
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2,right: 10),
                      child: 
                      // IntrinsicHeight(
                      //   child: Row(
                      //     children: [
                      //       Padding(
                      //         padding: const EdgeInsets.only(right: 2),
                      //         child: SvgPicture.asset("src/icons/menino.svg",height: 35, color: item.paciente.sexo=="masculino"?Colors.black:Colors.grey,),
                      //       ),
                      //       const VerticalDivider(
                      //         width: 10,
                      //         thickness: 2,
                      //         color: Colors.black,
                      //       ),
                      //       SvgPicture.asset("src/icons/menina.svg",height: 35, color: item.paciente.sexo=="feminino"?Colors.black:Colors.grey),
                      //     ],
                      //   ),
                      // ),
                      item.paciente.sexo=="masculino"?
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          // O desenvolvedor da biblioteca tirou o suporte pq "quer q os usuarios pensem em uma maneira melhor", o issue: https://github.com/dnfield/flutter_svg/issues/856
                          // ignore: deprecated_member_use
                          child: SvgPicture.asset("src/icons/menino.svg",height: 35, color: Colors.black),
                        ):
                      item.paciente.sexo=="feminino"?
                        // ignore: deprecated_member_use
                        SvgPicture.asset("src/icons/menina.svg",height: 35, color: Colors.black):
                        const SizedBox.shrink()
                    )
                  ],
                ),
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
