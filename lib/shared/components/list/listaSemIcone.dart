import 'package:acolherconsultas/modules/pacientes/models/pacienteCadastro.dart';
import 'package:acolherconsultas/modules/consultas/models/consulta.dart';
import 'package:acolherconsultas/modules/sistema/views/homePaciente.dart';
import 'package:flutter/material.dart';

class ListaSemIconeAcolher<T> extends StatefulWidget {
  const ListaSemIconeAcolher({super.key, required this.listaObjeto});

  final List<T> listaObjeto;

  @override
  _ListaSemIconeAcolherState<T> createState() => _ListaSemIconeAcolherState<T>();
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
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(builder: (context) => HomePaciente(paciente: item.paciente))
        );
      },
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
