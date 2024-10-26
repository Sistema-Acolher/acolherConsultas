import 'package:acolherconsultas/modules/casasDeApoio/models/casaDeApoio.dart';
import 'package:acolherconsultas/modules/consultas/controllers/consultaController.dart';
import 'package:acolherconsultas/modules/consultas/models/consulta.dart';
import 'package:acolherconsultas/modules/consultas/views/consultaAgendar.dart';
import 'package:acolherconsultas/modules/consultas/views/consultaNovaScreen.dart';
import 'package:acolherconsultas/modules/pacientes/models/paciente.dart';
import 'package:acolherconsultas/modules/usuarios/models/usuario.dart';
import 'package:acolherconsultas/shared/components/buttons/circleButton.dart';
import 'package:acolherconsultas/shared/components/text/confirmacao.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class ListaComIcone extends StatefulWidget {
  const ListaComIcone({super.key, this.listaConsulta, this.listaCasaApoio, this.listaUsuario, this.paciente, required this.label});

  final Paciente? paciente;
  final String label;
  final List<CasaDeApoio>? listaCasaApoio;
  final List<Usuario>? listaUsuario;
  final List<ConsultaCadastro>? listaConsulta;

  @override
  _ListaComIconeState createState() => _ListaComIconeState();
}

class _ListaComIconeState extends State<ListaComIcone> {
  // Cria instancia de controller para chamar funções
  final consultaController = ConsultaController();

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
    if (item is ConsultaCadastro) {
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
                    _optionsDialogBuilder(context,item);
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
  Future<void> _optionsDialogBuilder(BuildContext context, ConsultaCadastro consulta) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleButton(title: "Reagendar", icon: Icons.edit_calendar_outlined, onPressed: (){
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(builder:(context) => ConsultaAgendar(paciente: widget.paciente,consulta: consulta,)));
              }),
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: CircleButton(title: "Consultar", icon: Icons.content_paste, onPressed: (){
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(builder:(context) => ConsultaNovaScreen(pacienteConsulta: widget.paciente,)));
                }),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: CircleButton(title: "Cancelar", icon: Icons.delete, onPressed: (){
                  _consultaDeleteDialogBuilder(context,consulta);
                }),
              )
            ],
          )
        );
      },
    );
  }

  // Dialog que abre o resto das consultas.
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

  // Dialog que confirma deletar a consulta.
  Future<void> _consultaDeleteDialogBuilder(BuildContext context,ConsultaCadastro consultaRemove) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.only(top: 10,left: 10,right: 10),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
          content: Confirmacao(
            body: false, 
            nome:"", dataHorario: DateTime.now(), confimacao: () async {
            await consultaController.remover(consultaRemove.id??"").then((value){
                Navigator.pop(context);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Cancelada com sucesso")));
              });
          })
        );
      },
    );
  }


}
