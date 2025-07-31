import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar saída'),
        content: const Text('Deseja realmente sair do sistema?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sair'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      if (!mounted) return;
      context.go('/login');
    }
  }


  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 760;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Painel Administrativo',
              style: TextStyle(
                color: Colors.blue[900],
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Você está logado como Administrador',
              style: TextStyle(color: Colors.blueGrey[400], fontSize: 12),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black26,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue[900],
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Icon(Icons.dashboard, color: Colors.white),
              onPressed: () {},
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: TextButton.icon(
              onPressed: _logout,
              icon: Icon(Icons.logout, color: Colors.blue[900], size: 22),
              label: Text(
                'Sair',
                style: TextStyle(
                  color: Colors.blue[900],
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue[50],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildSectionTitle('GESTÃO DE PESSOAS'),
            _buildModuleGrid(context, isLargeScreen, [
              _Module(
                icon: Icons.people_outline,
                title: 'Usuários',
                route: '/gerenciar_usuarios_page',
                color: Colors.blue,
              ),
              _Module(
                icon: Icons.person_outline,
                title: 'Motoristas',
                route: '/gerenciar_motoristas_page',
                color: Colors.amber,
              ),
            ]),
            const SizedBox(height: 32),
            _buildSectionTitle('FROTA E LOGÍSTICA'),
            _buildModuleGrid(context, isLargeScreen, [
              _Module(
                icon: Icons.directions_car_filled_outlined,
                title: 'Frota',
                route: '/gerenciar_veiculos_page',
                color: Colors.green,
              ),
              _Module(
                icon: Icons.route_outlined,
                title: 'Rotas',
                route: '/gerenciar_escolas_page',
                color: Colors.purple,
              ),
              _Module(
                icon: Icons.calendar_month_outlined,
                title: 'Agendamentos',
                route: '/gerenciar_agendamentos_page',
                color: Colors.red,
              ),
              _Module(
                icon: Icons.event_available_outlined,
                title: 'Calendário',
                route: '/gerenciar_calendario_page',
                color: Colors.orange,
              ),
            ]),
            const SizedBox(height: 32),
            _buildSectionTitle('ADMINISTRAÇÃO'),
            _buildModuleGrid(context, isLargeScreen, [
              _Module(
                icon: Icons.analytics_outlined,
                title: 'Relatórios',
                route: '/graficos_page',
                color: Colors.teal,
              ),
              _Module(
                icon: Icons.settings_outlined,
                title: 'Configurações',
                route: '/admin/configuracoes',
                color: Colors.blueGrey,
              ),
              _Module(
                icon: Icons.help_outline,
                title: 'Ajuda',
                route: '/admin/ajuda',
                color: Colors.pink,
              ),
            ]),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: 'Bem-vindo ao ',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Colors.blue[900],
                height: 1.3,
              ),
              children: [
                TextSpan(
                  text: 'Portal Administrativo',
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Gerencie todas as operações do sistema de transporte corporativo',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Colors.blue[900],
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildModuleGrid(
    BuildContext context,
    bool isLargeScreen,
    List<_Module> modules,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: isLargeScreen ? 4 : 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.0,
        children: modules
            .map(
              (module) => _buildFeaturedModuleCard(
                context,
                icon: module.icon,
                title: module.title,
                route: module.route,
                color: module.color,
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildFeaturedModuleCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
    required MaterialColor color,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        splashColor: color.withAlpha(26),
        highlightColor: Colors.transparent,
        onTap: () => context.push(route),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.shade50, Colors.white],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: color.withAlpha(51),
                  shape: BoxShape.circle,
                  border: Border.all(color: color.withAlpha(102), width: 2),
                ),
                child: Icon(icon, size: 42, color: color.shade800),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: color.shade900,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Module {
  final IconData icon;
  final String title;
  final String route;
  final MaterialColor color;

  _Module({
    required this.icon,
    required this.title,
    required this.route,
    required this.color,
  });
}
