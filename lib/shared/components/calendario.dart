import 'dart:collection';

import 'package:acolherconsultas/modules/casasDeApoio/models/casaDeApoio.dart';
import 'package:acolherconsultas/modules/consultas/controllers/consultaController.dart';
import 'package:acolherconsultas/modules/consultas/models/consulta.dart';
import 'package:acolherconsultas/modules/pacientes/models/paciente.dart';
import 'package:acolherconsultas/shared/colors.dart';
import 'package:acolherconsultas/shared/components/list/listaHorarios.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

// Padrão das quantidades
double qtdConsultas = 11;
double p80 = 0.8*11;
double p50 = 0.5*11;
double p20 = 0.2*11;

// Hash de consultas por dia
var kEvents = LinkedHashMap<DateTime, List<ConsultaCadastro>>(
  equals: isSameDay,
  hashCode: getHashCode,
);

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}


class Calendario extends StatefulWidget {
  const Calendario({super.key, this.paciente, this.casaDeApoio, this.consulta});
  final ConsultaCadastro? consulta;
  final CasaDeApoio? casaDeApoio;
  final Paciente? paciente;

  @override
  _CalendarioState createState() => _CalendarioState();
}

class _CalendarioState extends State<Calendario> {
  List<ConsultaCadastro> consultasDoDia = [];
  final ValueNotifier<DateTime> _focusedDay = ValueNotifier(DateTime.now());
  DateTime _selectedDay = DateTime.now();
  // Responsavel por tornar o loadConsultas como assincrono, trazendo os dados corretamente
  late Future<void> _loadConsultasFuture;

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _loadConsultasFuture = loadConsultas();
  }

  @override
  void didUpdateWidget(Calendario oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.casaDeApoio != oldWidget.casaDeApoio) {
      _loadConsultasFuture = loadConsultas();
    }
  }

  @override
  void dispose() {
    _focusedDay.dispose();
    super.dispose();
  }

  // Carrega as consultas para a variavel kEvents, para ser usado na HASH de dias
   Future<void> loadConsultas() async{
    String casaId="";
    if (widget.paciente != null) {
      casaId=widget.paciente!.casaDeApoioId;
    }else{
      casaId=widget.casaDeApoio?.id ?? "";
    }
    await context.read<ConsultaController>().getConsultas();
    List<DateTime> dias = Provider.of<ConsultaController>(context,listen: false).consultas
      .where((element) => 
        element.dataHorario.isAfter(DateTime.utc(DateTime.now().year,1,1)) && 
        element.dataHorario.isBefore(DateTime.utc(DateTime.now().year,12,31)) &&
        element.casaDeApoioId == casaId)
      .toList()
      .map((e) => e.dataHorario).toSet().toList();
    var source = { for (var e in dias) e : Provider.of<ConsultaController>(context,listen: false).consultas.where((element) =>element.dataHorario.day==e.day).toList() };
    kEvents.clear();
    kEvents.addAll(source);
  }

  // Seleciona todas as consultas do dia a partir da hash gerada
  List<ConsultaCadastro> _getEventsForDay(DateTime day) {
    return kEvents[day] ?? [];
  }

  // Ao clicar muda o dia selecionado e abre o dialog de lista de pacientes
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay=selectedDay;
      _focusedDay.value = focusedDay;
      consultasDoDia.clear();
      consultasDoDia.addAll(
        Provider.of<ConsultaController>(context, listen: false).consultas.where((element) =>
          element.dataHorario.day==selectedDay.day
        ).toList());
    });
    _dialogBuilder(context,selectedDay);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 28),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(widget.casaDeApoio?.cor??azul.value).withOpacity(0.7),
              borderRadius: BorderRadius.circular(16)
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                FutureBuilder(
                  future: _loadConsultasFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Erro ao carregar consultas: ${snapshot.error}'));
                    } else {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16)
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Column(
                          children: [
                            // Controlador pra trocar de mês
                            ValueListenableBuilder<DateTime>(
                              valueListenable: _focusedDay,
                              builder: (context, value, _) {
                                return _CalendarHeader(
                                  focusedDay: value,
                                  onLeftArrowTap: () {
                                    _pageController.previousPage(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeOut,
                                    );
                                  },
                                  onRightArrowTap: () {
                                    _pageController.nextPage(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeOut,
                                    );
                                  },
                                );
                              },
                            ),
                            // Calendário
                            TableCalendar<ConsultaCadastro>(
                              locale: "pt_BR",
                              firstDay: DateTime.utc(DateTime.now().year,1,1),
                              lastDay: DateTime.utc(DateTime.now().year,12,31),
                              focusedDay: _focusedDay.value,
                              // Usando header customizado
                              headerVisible: false,
                              calendarFormat: CalendarFormat.month,
                              selectedDayPredicate: (day) => _selectedDay==day,
                              eventLoader: _getEventsForDay,
                              onDaySelected: _onDaySelected,
                              // Para trocar página do mês
                              onCalendarCreated: (controller) => _pageController = controller,
                              onPageChanged: (focusedDay) => _focusedDay.value = focusedDay,
                              calendarBuilders: CalendarBuilders(
                                // Customização do hoje
                                todayBuilder: (context, day, focusedDay) => Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.all(Radius.circular(8))
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      child: Center(child: AutoSizeText(day.day.toString(), style: const TextStyle(color: Colors.white))),
                                    ),
                                  ),
                                ),
                                // Customização do marcador de quantidade de consultas
                                markerBuilder: (context, day, event) => Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: Container(
                                    width: 30,
                                    height: 5,
                                    decoration: BoxDecoration(
                                      color:  event.length>p80?const Color(0xFFFF1111):
                                              event.length>p50?const Color(0xFFEFF340):
                                              event.length>p20?const Color(0xFF2E992C):null,
                                      borderRadius: const BorderRadius.all(Radius.circular(3))
                                    ),
                                  ),
                                ),
                                // Customização do dia selecionado
                                selectedBuilder: (context, day, focusedDay) => Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF333333),
                                        borderRadius: BorderRadius.all(Radius.circular(8))
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      child: Center(child: AutoSizeText(day.day.toString(), style: const TextStyle(color: Colors.white))),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                ),
                const SizedBox(height: 16,),
                // Legenda
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16)
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 8),
                  child: const Column(
                    children: [
                      RowItem(texto: " - 80% dos horários preenchidos", cor: 0xFFFF1111),
                      Divider(),
                      RowItem(texto: " - 50% dos horários preenchidos", cor: 0xFFEFF340),
                      Divider(),
                      RowItem(texto: " - 20% dos horários preenchidos", cor: 0xFF2E992C),
                      Divider(),
                      RowItem(texto: " - Hoje", cor: 0xFF000000),
                    ],
                  )
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Dialog que abre a lista de horários do dia.
  Future<void> _dialogBuilder(BuildContext context, DateTime selectedDay) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(2),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
          content: ListaHorario(consultasDoDia: consultasDoDia, paciente: widget.paciente, dia: selectedDay,consulta: widget.consulta,)
        );
      },
    );
  }
}

// Item da legenda
class RowItem  extends StatelessWidget{
  final String texto;
  final int cor;

  const RowItem({super.key, required this.texto, required this.cor});

  @override
    Widget build(BuildContext context){
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 30,
            height: 10,
            decoration: BoxDecoration(
              color:  Color(cor),
              borderRadius: const BorderRadius.all(Radius.circular(3))
            ),
          ),
          Text(texto)
        ],
      );
    }
}

// Header customizado
class _CalendarHeader extends StatelessWidget {
  final DateTime focusedDay;
  final VoidCallback onLeftArrowTap;
  final VoidCallback onRightArrowTap;

  const _CalendarHeader({
    required this.focusedDay,
    required this.onLeftArrowTap,
    required this.onRightArrowTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: onLeftArrowTap,
            ),
            const Spacer(),
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFF000000),
                borderRadius: BorderRadius.all(Radius.circular(4))
              ),
              padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 8),
              child: Text(
                DateFormat.MMMM('pt_BR').format(focusedDay),
                style: const TextStyle(color: Color(0xFFFFFFFF)),
              )
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: onRightArrowTap,
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(left: 8,right: 8,bottom: 12),
          child: Divider(height: 3,color: Colors.black,),
        )
      ],
    );
  }
}