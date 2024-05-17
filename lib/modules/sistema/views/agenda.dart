// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';

import 'package:acolherconsultas/modules/consultas/controllers/consultaController.dart';
import 'package:acolherconsultas/modules/consultas/models/consulta.dart';
import 'package:acolherconsultas/shared/components/bars/pageAppBar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0


/// Example event class.
class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}

/// Example events.
///
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

final _kEventSource = Map.fromIterable(List.generate(50, (index) => index),
    key: (item) => DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5),
    value: (item) => List.generate(item % 4 + 1, (index) => Event('Event $item | ${index + 1}')))
  ..addAll({
    kToday: [
      Event('Today\'s Event 1'),
      Event('Today\'s Event 2'),
    ],
  });

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);

class Agenda extends StatefulWidget {
  const Agenda({super.key, this.cor = 0xFF2277AE});
  final int cor;

  @override
  _AgendaState createState() => _AgendaState();
}

class _AgendaState extends State<Agenda> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  final ValueNotifier<DateTime> _focusedDay = ValueNotifier(DateTime.now());
  final Set<DateTime> _selectedDays = LinkedHashSet<DateTime>(
    equals: isSameDay,
    hashCode: getHashCode,
  );

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    context.read<ConsultaController>().getConsultas();

    _selectedDays.add(_focusedDay.value);
    _selectedEvents = ValueNotifier(_getEventsForDay(_focusedDay.value));
  }

  @override
  void dispose() {
    _focusedDay.dispose();
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    return kEvents[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    AlertDialog(
        title: const Text('AlertDialog Title'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('This is a demo alert dialog.'),
              Text('Would you like to approve of this message?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Approve'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    setState(() {
      if (_selectedDays.contains(selectedDay)) {
        _selectedDays.remove(selectedDay);
      } else {
        _selectedDays.add(selectedDay);
      }

      _focusedDay.value = focusedDay;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Consulta> consultas = Provider.of<ConsultaController>(context).consultas.where((element) => element.dataHorario.day==DateTime.now().day).toList();
    return Scaffold(
      appBar: const PageAppBar(titulo: "Agenda"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 28),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(widget.cor),
                borderRadius: BorderRadius.circular(16)
              ),
              padding: EdgeInsets.all(20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16)
                ),
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  children: [
                    ValueListenableBuilder<DateTime>(
                      valueListenable: _focusedDay,
                      builder: (context, value, _) {
                        return _CalendarHeader(
                          focusedDay: value,
                          onLeftArrowTap: () {
                            _pageController.previousPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            );
                          },
                          onRightArrowTap: () {
                            _pageController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            );
                          },
                        );
                      },
                    ),
                    TableCalendar<Event>(
                      firstDay: DateTime.utc(DateTime.now().year,1,1),
                      lastDay: DateTime.utc(DateTime.now().year,12,31),
                      focusedDay: DateTime.now(),
                      headerVisible: false,
                      calendarFormat: CalendarFormat.month,
                      selectedDayPredicate: (day) => _selectedDays.contains(day),
                      eventLoader: _getEventsForDay,
                      onDaySelected: _onDaySelected,
                      onCalendarCreated: (controller) => _pageController = controller,
                      onPageChanged: (focusedDay) => _focusedDay.value = focusedDay,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
                style: const TextStyle(
                  color: Color(0xFFFFFFFF)
                ),
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