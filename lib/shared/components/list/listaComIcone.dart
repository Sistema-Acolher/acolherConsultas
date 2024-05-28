import 'package:acolherconsultas/modules/casasDeApoio/models/casaDeApoio.dart';
import 'package:acolherconsultas/modules/consultas/models/consulta.dart';
import 'package:acolherconsultas/modules/consultas/views/consultaAgendar.dart';
import 'package:acolherconsultas/modules/consultas/views/consultaNovaScreen.dart';
import 'package:acolherconsultas/modules/pacientes/models/paciente.dart';
import 'package:acolherconsultas/modules/usuarios/models/usuario.dart';
import 'package:acolherconsultas/shared/components/buttons/circleButton.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class ListaComIcone extends StatefulWidget {
  const ListaComIcone({super.key, this.listaConsulta, this.listaCasaApoio, this.listaUsuario, this.paciente, required this.label});

  final Paciente? paciente;
  final String label;
  final List<CasaDeApoio>? listaCasaApoio;
  final List<Usuario>? listaUsuario;
  final List<Consulta>? listaConsulta;

  @override
  _ListaComIconeState createState() => _ListaComIconeState();
}

class _ListaComIconeState extends State<ListaComIcone> {
  @override
  Widget build(BuildContext context) {
    if(widget.listaConsulta!=null){
      return Column(
        children: [ 
          // Builder da lista de consultas
          for(int i=0; i<(widget.listaConsulta!.length>=3?3:widget.listaConsulta!.length); i++)
            _buildListItem(widget.listaConsulta![i])
          ,
          // Reticencias
          if(widget.listaConsulta!.length>3)
            Padding(
              padding: const EdgeInsets.only(top:8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 30,
                    width: 40,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 117, 117, 117).withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: IconButton(
                        padding: const EdgeInsets.all(0),
                        onPressed: () => _consultasDialogBuilder(context),
                        icon: const Icon(
                          Symbols.more_horiz,
                          size: 30,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildListItem(var item, {bool dialog=false}) {
    if (item is Consulta) {
      final formattedDate = DateFormat.yMMMd("pt_BR").format(item.dataHorario); // Formatar a data
      final formattedDateDialog = DateFormat.yMd("pt_BR").format(item.dataHorario); // Formatar a data
      final formattedTime = DateFormat.Hm().format(item.dataHorario); // Formatar o horário

      return Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 117, 117, 117).withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
            children: [
              // Data
              Expanded(child: Text(dialog?formattedDateDialog:formattedDate)), 
              // Horário
              Text(formattedTime),
              // Divisor
              Container(
                width: 2,
                height: 30,
                color: Colors.black,
                margin: const EdgeInsets.symmetric(horizontal: 8), 
              ),
              // Icone
              IconButton(
                visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity),
                padding: EdgeInsets.zero,
                icon: Icon(
                  item.estado=="concluida"?Icons.remove_red_eye:(item.estado=="agendada"||item.estado=="atrasada")?Icons.edit_outlined:null,
                  size: 30,
                ),
                onPressed: (){
                  if (item.estado=="concluida") {
                    
                  }
                  else if(item.estado=="agendada"||item.estado=="atrasada"){
                    _optionsDialogBuilder(context);
                  }
                }
              )
            ],
          ),
      );
    } else {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('aaaaa'),
          SizedBox(height: 4),
          Divider(color: Colors.grey),
        ],
      );
    }
  }

  // Dialog que abre a opcao de reagendar e de consultar.
  Future<void> _optionsDialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleButton(title: "Reagendar", icon: Icons.edit_calendar_outlined, onPressed: (){
                Navigator.of(context, rootNavigator: true).pop(false);
                Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder:(context) => ConsultaAgendar(paciente: widget.paciente,)));
              }),
              CircleButton(title: "Consultar", icon: Icons.edit_calendar_outlined, onPressed: (){
                Navigator.of(context, rootNavigator: true).pop(false);
                Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder:(context) => ConsultaNovaScreen(pacienteConsulta: widget.paciente,)));
              })
            ],
          )
        );
      },
    );
  }

  // Dialog que abre as consultas.
  Future<void> _consultasDialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.only(left: 10,top: 5),
          title: Text(
            widget.label,
            style: const TextStyle(decoration: TextDecoration.underline),
          ),
          contentPadding: const EdgeInsets.only(left: 10,right: 10,bottom: 20),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
          scrollable: true,
          content: Column(
            children: [
              for(var item in widget.listaConsulta!.sublist(3))
                _buildListItem(item,dialog: true)
            ],
          )
        );
      },
    );
  }
}
