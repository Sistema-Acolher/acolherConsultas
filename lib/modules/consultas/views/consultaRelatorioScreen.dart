import 'package:acolherconsultas/modules/casasDeApoio/models/casaDeApoio.dart';
import 'package:acolherconsultas/modules/consultas/controllers/consultaRelatorioController.dart';
import 'package:acolherconsultas/shared/colors.dart';
import 'package:acolherconsultas/shared/components/bars/pageAppBar.dart';
import 'package:acolherconsultas/shared/components/buttons/standartRoundButton.dart';
import 'package:acolherconsultas/shared/components/dropdown/consultaDropdown.dart';
import 'package:acolherconsultas/shared/components/inputs/inputCheckBox.dart';
import 'package:acolherconsultas/shared/components/inputs/inputTexto.dart';
import 'package:acolherconsultas/shared/components/list/listaComIconeConsultas.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:mask/mask/mask.dart';
import 'package:provider/provider.dart';

class RelatorioCasasScreen extends StatefulWidget {
  const RelatorioCasasScreen({super.key});

  @override
  State<RelatorioCasasScreen> createState() => _RelatorioCasasScreenState();
}

class _RelatorioCasasScreenState extends State<RelatorioCasasScreen> {
  final _controllerRelatorioCasas = ConsultaRelatorioController();
  late ValueNotifier<List<CasaDeApoio>> todosCasaDeApoios;
  final ValueNotifier<bool> isChecked = ValueNotifier<bool>(false);
  final ValueNotifier<bool> changed = ValueNotifier<bool>(false);
  final _formKey = GlobalKey<FormState>();
  String resultado = ""; 

  @override
  void initState() {
    super.initState();
    todosCasaDeApoios = ValueNotifier<List<CasaDeApoio>>([]);
    _controllerRelatorioCasas.periodoInicial.addListener(() {
      changed.value = !changed.value;
    });
    _controllerRelatorioCasas.periodoFinal.addListener(() {
      changed.value = !changed.value;
    });
  }

  void _buscarCasasDeApoio() {
    todosCasaDeApoios.value = Provider.of<List<CasaDeApoio>>(context)
      .toList();
  }

  @override
  Widget build(BuildContext context) {
    _buscarCasasDeApoio();

    return Scaffold(
      appBar: const PageAppBar(titulo: "Relatórios"/*, casaDeApoioSelecionada: Provider.of<CasaDeApoio>(context)*/),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(                
                      child: ValueListenableBuilder(
                        valueListenable: changed,
                        builder: (context, value, child) => InputTextoAcolher(
                            label: "De",
                            placeHolder: "    /    /",
                            controller:_controllerRelatorioCasas.periodoInicial,
                            keyboardType: TextInputType.datetime,
                            icone: Icons.date_range_outlined,
                            validation: (value) => Mask.validations.date(value),
                            inputFormatter: [Mask.date()],
                            readOnly: true,
                            emptyMessage: "Informe a data inicial",
                            lastDate: _controllerRelatorioCasas.periodoFinal.text.isNotEmpty ?
                                DateFormat('dd/MM/yyyy').parse(_controllerRelatorioCasas.periodoFinal.text) :
                                null,
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
                    Expanded(
                      child: ValueListenableBuilder(
                        valueListenable: changed,
                        builder: (context, value, child) => InputTextoAcolher(
                            label: "Até",
                            placeHolder: "    /    /",
                            controller:_controllerRelatorioCasas.periodoFinal,
                            keyboardType: TextInputType.datetime,
                            icone: Icons.date_range_outlined,
                            validation: (value) => Mask.validations.date(value),
                            inputFormatter: [Mask.date()],
                            readOnly: true,
                            emptyMessage: "Informe a data final",
                            firstDate: _controllerRelatorioCasas.periodoInicial.text.isNotEmpty ?
                              DateFormat('dd/MM/yyyy').parse(_controllerRelatorioCasas.periodoInicial.text) :
                              null,
                        ),
                      ),
                    ),
                  ],
                ),         
                const SizedBox(height: 20),
                ValueListenableBuilder(
                  valueListenable: todosCasaDeApoios,
                  builder: (context, casaDeApoios, child) => InputCheckBoxAcolher(
                    options: todosCasaDeApoios.value,
                    label: "Casas",
                    controller: _controllerRelatorioCasas.casas,
                    isChecked: isChecked,
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: StandartRoundButton(
                    color: verdeBotoes,
                    horizontalPaddingFactor: 2.8,
                    verticalPaddingFactor: 1.5,
                    text: "Gerar",
                    onPressed: () {
                      setState(() {
                        resultado = "";
                        isChecked.value = true;
                      });
                      if(_formKey.currentState!.validate() && _controllerRelatorioCasas.casas.text.isNotEmpty) {
                          _controllerRelatorioCasas.realizarBusca(_controllerRelatorioCasas.relatorio(), context);
                          setState(() {
                            resultado = "${_controllerRelatorioCasas.consultasEncontradas.value.length} consultas encontradas";
                            if(_controllerRelatorioCasas.consultasEncontradas.value.isEmpty) {
                              resultado = "Nenhuma consulta encontrada";
                            }
                          });
                      }
                    },
                  ),
                ),
                const SizedBox(height: 20),
                if(resultado.isNotEmpty && _controllerRelatorioCasas.consultasEncontradas.value.isEmpty)
                  AutoSizeText(
                    resultado,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      // fontSize: 22
                    ),
                    maxLines: 2,
                    minFontSize: 18,
                  ),
                if(resultado.isNotEmpty && _controllerRelatorioCasas.consultasEncontradas.value.isNotEmpty)
                  Column(
                    children: [
                      ConsultaDropdown(
                        text: resultado,
                        child: ListaComIconeConsultas(
                          label: "Realizadas",
                          listaConsulta: _controllerRelatorioCasas.consultasEncontradas.value,
                          // eInstituicao: widget.eInstituicao,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}