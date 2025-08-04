import 'package:flutter/material.dart';
import 'package:agendamento_app/pages/admin/gerenciar_agendamentos_page.dart';
import 'package:agendamento_app/pages/admin/gerenciar_calendario_page.dart';
import 'package:agendamento_app/pages/admin/graficos_page.dart';
import 'package:agendamento_app/pages/admin/admin_home_content_page.dart';
import 'package:agendamento_app/pages/admin/gerenciar_page.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    AdminHomeContentPage(),
    GerenciarAgendamentosPage(),
    GerenciarCalendarioPage(),
    GraficosPage(),
    GerenciarPage(),
  ];

  static const List<String> _widgetTitles = <String>[
    'Painel Administrativo',
    'Gerenciar Agendamentos',
    'Calendário de Agendamentos',
    'Gráficos e Estatísticas',
    'Gerenciar',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_widgetTitles.elementAt(_selectedIndex)),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Agendamentos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendário',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Gráficos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.manage_accounts),
            label: 'Gerenciar',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
