import 'package:acolherconsultas/modules/genogramaEcomapa/controllers/ecomapaController.dart';
import 'package:acolherconsultas/modules/genogramaEcomapa/controllers/genogramaController.dart';
import 'package:acolherconsultas/modules/pacientes/models/paciente.dart';
import 'package:acolherconsultas/modules/genogramaEcomapa/views/ecomapaScreen.dart';
import 'package:acolherconsultas/modules/genogramaEcomapa/views/genogramaScreen.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

class ListaGenogramaEcomapa extends StatefulWidget {
  const ListaGenogramaEcomapa({super.key, required this.elementos, required this.isGenograma, this.paciente, this.refreshFunction, required this.isRemoving});

  final List<dynamic> elementos;
  final Paciente? paciente;
  final bool isGenograma;
  final bool isRemoving;
  final Function? refreshFunction;

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
                onTap: () async {
                  
                  if(widget.isRemoving) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Remover"),
                          content: Text(
                            widget.isGenograma ?
                            "Deseja realmente remover este Genograma?" :
                            "Deseja realmente remover este Ecomapa?"
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancelar"),
                            ),
                            TextButton(
                              onPressed: () async {
                                if(widget.isGenograma) {
                                  await PacienteGenogramaController().removeGenograma(widget.elementos[index].id).then((value) {
                                    const snackBar = SnackBar(
                                        elevation: 0,
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.transparent,
                                        content: AwesomeSnackbarContent(
                                          title: 'Sucesso',
                                          message: 'Genograma removido com sucesso!',
                                          contentType: ContentType.success,
                                        ),
                                        duration: Duration(seconds: 10),
                                      );
                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(snackBar);
                                  });
                                } else {
                                  await PacienteEcomapaController().removeEcomapa(widget.elementos[index].id).then((value) {
                                    const snackBar = SnackBar(
                                        elevation: 0,
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.transparent,
                                        content: AwesomeSnackbarContent(
                                          title: 'Sucesso',
                                          message: 'Ecomapa removido com sucesso!',
                                          contentType: ContentType.success,
                                        ),
                                        duration: Duration(seconds: 10),
                                      );
                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(snackBar);
                                  });
                                }

                                widget.refreshFunction?.call();
                                Navigator.pop(context);
                              },
                              child: const Text("Remover"),
                            ),
                          ],
                        );
                      }
                    );
                    return;
                  }
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => widget.isGenograma ? 
                      GenogramaScreen(genogramaVelho: widget.elementos[index], paciente: widget.paciente, isEditable: true) : 
                      EcomapaScreen(ecomapaVelho: widget.elementos[index], paciente: widget.paciente, isEditable: true)
                    )
                  );

                  widget.refreshFunction?.call();
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
                        widget.isRemoving ? Icons.delete :
                        widget.isGenograma ? Symbols.family_history : Symbols.network_node,
                        size: 30,
                        color: widget.isRemoving ? Colors.red : Colors.black,
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