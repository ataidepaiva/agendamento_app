import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class GerenciarCalendarioPage extends StatefulWidget {
  const GerenciarCalendarioPage({super.key});

  @override
  GerenciarCalendarioPageState createState() =>
      GerenciarCalendarioPageState();
}

class GerenciarCalendarioPageState extends State<GerenciarCalendarioPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  /// Mapa com datas e lista de carros (nome + cor)
  Map<DateTime, List<Map<String, dynamic>>> carAgendamentos = {
    DateTime.utc(2025, 7, 28): [
      {"nome": "Carro 1", "cor": Colors.red},
      {"nome": "Carro 2", "cor": Colors.blue},
    ],
    DateTime.utc(2025, 7, 30): [
      {"nome": "Carro 3", "cor": Colors.green},
    ],
  };

  List<Map<String, dynamic>> _getCarsForDay(DateTime day) {
    return carAgendamentos[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Gerenciar Calendário de Carros')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TableCalendar(
          firstDay: DateTime.utc(2024, 1, 1),
          lastDay: DateTime.utc(2026, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: TextStyle(
              color: colorScheme.onPrimaryContainer,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
            leftChevronIcon: Icon(
              Icons.chevron_left,
              color: colorScheme.onPrimaryContainer,
            ),
            rightChevronIcon: Icon(
              Icons.chevron_right,
              color: colorScheme.onPrimaryContainer,
            ),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8.0),
            ),
            headerPadding: const EdgeInsets.symmetric(vertical: 8.0),
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: TextStyle(color: colorScheme.onSurface),
            weekendStyle: TextStyle(color: colorScheme.error),
          ),
          calendarStyle: CalendarStyle(
            outsideDaysVisible: false,
            defaultTextStyle: TextStyle(color: colorScheme.onSurface),
            weekendTextStyle: TextStyle(color: colorScheme.error),
            todayDecoration: BoxDecoration(
              color: colorScheme.tertiary,
              shape: BoxShape.rectangle,
              border: Border.all(color: colorScheme.outline, width: 1.0),
            ),
            todayTextStyle: TextStyle(color: colorScheme.onTertiary),
            selectedDecoration: BoxDecoration(
              color: colorScheme.primary,
              shape: BoxShape.rectangle,
              border: Border.all(color: colorScheme.outline, width: 1.0),
            ),
            selectedTextStyle: TextStyle(color: colorScheme.onPrimary),
            defaultDecoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(color: colorScheme.outline, width: 1.0),
            ),
            weekendDecoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(color: colorScheme.outline, width: 1.0),
            ),
            outsideDecoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(color: colorScheme.outline, width: 1.0),
            ),
            markerDecoration: BoxDecoration(
              color: colorScheme.secondary,
              shape: BoxShape.circle,
            ),
          ),
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, day, focusedDay) {
              final carros = _getCarsForDay(day);
              return Container(
                margin: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: carros.isEmpty ? colorScheme.surfaceVariant : colorScheme.surfaceVariant.withOpacity(0.8),
                  border: Border.all(color: colorScheme.outline, width: 1.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${day.day}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (carros.isNotEmpty)
                      Wrap(
                        spacing: 2,
                        children: carros.map((carro) {
                          return Icon(
                            Icons.directions_car,
                            size: 14,
                            color: carro['cor'],
                          );
                        }).toList(),
                      ),
                  ],
                ),
              );
            },
            todayBuilder: (context, day, focusedDay) {
              return Container(
                margin: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: colorScheme.tertiary,
                  border: Border.all(color: colorScheme.outline, width: 1.0),
                ),
                child: Center(
                  child: Text(
                    '${day.day}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onTertiary,
                    ),
                  ),
                ),
              );
            },
            selectedBuilder: (context, day, focusedDay) {
              return Container(
                margin: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  border: Border.all(color: colorScheme.outline, width: 1.0),
                ),
                child: Center(
                  child: Text(
                    '${day.day}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

