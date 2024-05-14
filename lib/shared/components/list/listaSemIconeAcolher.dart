import 'package:acolherconsultas/modules/pacientes/models/cadastroPaciente.dart';
import 'package:acolherconsultas/shared/components/list/Consulta.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ListaSemIconeAcolher<T> extends StatefulWidget {
  const ListaSemIconeAcolher({Key? key, required this.listaObjeto});

  final List<T> listaObjeto;

  @override
  _ListaSemIconeAcolherState<T> createState() =>
      _ListaSemIconeAcolherState<T>();
}

class _ListaSemIconeAcolherState<T> extends State<ListaSemIconeAcolher<T>> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.listaObjeto.length,
      itemBuilder: (context, index) {
        final item = widget.listaObjeto[index];
        return ListTile(
          title: _getTitle(item),
        );
      },
    );
  }

  Widget _getTitle(T item) {
    if (item is CadastroPaciente) {
    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.paciente.nome),
          SizedBox(height: 0), 
          Divider(color: Colors.grey), // Linha horizontal cinza
        ],
      ),
      onTap: () {},
    );
  } else if(item is Consulta) {
    final horario = TimeOfDay.fromDateTime(item.dataHorario).format(context); //so o horario da consulta
      return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item.pacienteId), 
              Text(horario), 
            ],
          ),
          SizedBox(height: 4), 
          Divider(color: Colors.grey), 
        ],
      ),
      onTap: () {
      },
    );
    }else{
      return Container();
    }
  }
}
