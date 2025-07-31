import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GerenciarAgendamentosPage extends StatelessWidget {
  const GerenciarAgendamentosPage({super.key});

  // Cache para evitar múltiplas consultas do mesmo usuário
  static final Map<String, Map<String, dynamic>?> _userCache = {};

  Future<Map<String, dynamic>?> _buscarSolicitante(String solicitanteId) async {
    if (solicitanteId.isEmpty) return null;

    // Verifica cache primeiro
    if (_userCache.containsKey(solicitanteId)) {
      return _userCache[solicitanteId];
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(solicitanteId)
          .get();

      final userData = doc.exists ? doc.data() : null;
      _userCache[solicitanteId] = userData; // Adiciona ao cache
      return userData;
    } catch (e) {
      debugPrint('Erro ao buscar solicitante: $e');
      return null;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmado':
        return Colors.green;
      case 'pendente':
        return Colors.orange;
      case 'cancelado':
        return Colors.red;
      case 'concluído':
      case 'concluido':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'confirmado':
        return Icons.check_circle;
      case 'pendente':
        return Icons.schedule;
      case 'cancelado':
        return Icons.cancel;
      case 'concluído':
      case 'concluido':
        return Icons.task_alt;
      default:
        return Icons.info;
    }
  }

  Widget _buildAgendamentoCard(
    BuildContext context,
    DocumentSnapshot agendamento,
    Map<String, dynamic>? solicitante,
  ) {
    final dados = agendamento.data() as Map<String, dynamic>;
    final status = dados['status'] ?? 'Sem status';
    final assunto = dados['assunto'] ?? 'Sem assunto';
    final rota = dados['rota'] ?? 'Não informada';
    final dataAgendamento = dados['dataAgendamento'];
    final horaAgendamento = dados['horaAgendamento'];

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Use the BuildContext from the widget tree instead of agendamento.context
          _mostrarDetalhesAgendamento(context, dados, solicitante);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabeçalho com assunto e status
              Row(
                children: [
                  Expanded(
                    child: Text(
                      assunto,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(status).withAlpha(26),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _getStatusColor(status),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getStatusIcon(status),
                          size: 16,
                          color: _getStatusColor(status),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          status,
                          style: TextStyle(
                            color: _getStatusColor(status),
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Informações do agendamento
              _buildInfoRow(Icons.route, 'Rota', rota),
              if (dataAgendamento != null || horaAgendamento != null) ...[
                const SizedBox(height: 8),
                _buildInfoRow(
                  Icons.calendar_today,
                  'Data/Hora',
                  '${dataAgendamento ?? 'Não informada'} ${horaAgendamento ?? ''}',
                ),
              ],

              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),

              // Informações do solicitante
              if (solicitante != null) ...[
                Row(
                  children: [
                    const Icon(Icons.person, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        solicitante['nome'] ?? 'Sem nome',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.email, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        solicitante['email'] ?? 'Sem email',
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                Row(
                  children: [
                    const Icon(Icons.person_off, size: 16, color: Colors.red),
                    const SizedBox(width: 8),
                    Text(
                      'Solicitante não encontrado',
                      style: TextStyle(
                        color: Colors.red[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(color: Colors.grey[700], fontSize: 13),
          ),
        ),
      ],
    );
  }

  void _mostrarDetalhesAgendamento(
    BuildContext context,
    Map<String, dynamic> dados,
    Map<String, dynamic>? solicitante,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(dados['assunto'] ?? 'Agendamento'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (dados['descricao'] != null) ...[
                const Text(
                  'Descrição:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(dados['descricao']),
                const SizedBox(height: 16),
              ],
              const Text(
                'Informações do Solicitante:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              if (solicitante != null) ...[
                Text('Nome: ${solicitante['nome'] ?? 'Sem nome'}'),
                Text('Email: ${solicitante['email'] ?? 'Sem email'}'),
                if (solicitante['telefone'] != null)
                  Text('Telefone: ${solicitante['telefone']}'),
              ] else
                const Text('Solicitante não encontrado'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Agendamentos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _userCache.clear(); // Limpa o cache ao atualizar
            },
            tooltip: 'Atualizar',
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('agendamentos')
            .orderBy('dataAgendamento', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            debugPrint(snapshot.error.toString());
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          debugPrint('Total de agendamentos: ${snapshot.data?.docs.length}');
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.event_busy, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhum agendamento encontrado',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Os agendamentos aparecerão aqui quando forem criados',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          final agendamentos = snapshot.data!.docs;

          return RefreshIndicator(
            onRefresh: () async {
              _userCache.clear();
              // O StreamBuilder automaticamente atualiza
            },
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: agendamentos.length,
              itemBuilder: (context, index) {
                final agendamento = agendamentos[index];
                final dados = agendamento.data() as Map<String, dynamic>;

                return FutureBuilder<Map<String, dynamic>?>(
                  future: _buscarSolicitante(dados['solicitanteId'] ?? ''),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                              SizedBox(width: 16),
                              Text('Carregando informações...'),
                            ],
                          ),
                        ),
                      );
                    }

                    return _buildAgendamentoCard(
                      context,
                      agendamento,
                      userSnapshot.data,
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
