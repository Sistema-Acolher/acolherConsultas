import 'package:acolherconsultas/modules/pacientes/models/paciente.dart';
import 'package:acolherconsultas/modules/genogramaEcomapa/views/ecomapaScreen.dart';
import 'package:acolherconsultas/modules/genogramaEcomapa/views/genogramaScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

class ListaGenogramaEcomapa extends StatefulWidget {
  const ListaGenogramaEcomapa({super.key, required this.elementos, required this.isGenograma, this.paciente});

  final List<dynamic> elementos;
  final Paciente? paciente;
  final bool isGenograma;

  @override
  State<ListaGenogramaEcomapa> createState() => _ListaGenogramaEcomapaState();
}

class _ListaGenogramaEcomapaState extends State<ListaGenogramaEcomapa> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: widget.elementos.isNotEmpty ? ListView.builder(
          itemCount: widget.elementos.length,
          itemBuilder: (context, index) {
            final formattedDate = DateFormat.yMMMd("pt_BR").format(widget.elementos[index].dataCriacao); // Formatar a data
            final formattedTime = DateFormat.Hm().format(widget.elementos[index].dataCriacao); // Formatar o horário
      
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
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => widget.isGenograma ? 
                      GenogramaScreen(genogramaVelho: widget.elementos[index], paciente: widget.paciente, isEditable: false) : 
                      EcomapaScreen(ecomapaVelho: widget.elementos[index], paciente: widget.paciente, isEditable: false)
                    )
                  );
                },
                child: Row(
                    children: [
                      // Data
                      Expanded(child: Text(formattedDate)), 
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
                      Icon(
                        widget.isGenograma ? Symbols.family_history : Symbols.network_node,
                        size: 30,
                      ),
                    ],
                  ),
              ),
            );
          }
        ) : Text(
          widget.isGenograma ? "Sem Genogramas" : "Sem Ecomapas",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        )
      ),
    );
  }
}