import 'package:acolherconsultas/modules/pacientes/models/cadastroPaciente.dart';
import 'package:acolherconsultas/shared/components/list/Consulta.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class ListaComIconeAcolher<T> extends StatefulWidget {
  const ListaComIconeAcolher({Key? key, required this.listaObjeto, this.icone});

  final List<T> listaObjeto;
  final IconData? icone;

  @override
  _ListaComIconeAcolherState<T> createState() =>
      _ListaComIconeAcolherState<T>();
}

class _ListaComIconeAcolherState<T> extends State<ListaComIconeAcolher<T>> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.listaObjeto.length,
      itemBuilder: (context, index) {
        final item = widget.listaObjeto[index];
        return ListTile(
          title: _buildListItem(item),
        );
      },
    );
  }

  Widget _buildListItem(T item) {
    if (item is CadastroPaciente) {
      return Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 117, 117, 117).withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(
                  0, 2), // altere os valores de offset conforme necessário
            ),
          ],
        ),
        child: ListTile(
          title: Row(
            children: [
              Expanded(
                child: Text(
                  item.paciente.nome,
                  textAlign: TextAlign.left,
                ),
              ),
              if (widget.icone != null)
                Icon(
                  widget.icone,
                ),
            ],
          ),
          onTap: () {},
        ),
      );
    } else if (item is Consulta) {
      final formattedDate = DateFormat.yMd().format(item.dataHorario); // Formatar a data
      final formattedTime = DateFormat.Hm().format(item.dataHorario); // Formatar o horário

      return Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 117, 117, 117).withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          title: Row(
            children: [
              Expanded(
                child: Text(
                  formattedDate,
                  textAlign: TextAlign.left,
                ),
              ),
              Text(
                formattedTime,
              ),
              Container(
                width: 2,
                height: 30,
                color: Colors.black,
                margin: EdgeInsets.symmetric(horizontal: 8), 
              ),
              SizedBox(width: 8), 
              if (widget.icone != null)
                Icon(
                  widget.icone,
                ),
            ],
          ),
          onTap: () {},
        ),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('aaaaa'),
          SizedBox(height: 4),
          Divider(color: Colors.grey),
        ],
      );
    }
  }
}
