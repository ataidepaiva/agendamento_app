import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GerenciarVeiculosPage extends StatefulWidget {
  const GerenciarVeiculosPage({super.key});

  @override
  State<GerenciarVeiculosPage> createState() => _GerenciarVeiculosPageState();
}

class _GerenciarVeiculosPageState extends State<GerenciarVeiculosPage> {
  final CollectionReference veiculosCollection =
      FirebaseFirestore.instance.collection('veiculos');

  final _formKey = GlobalKey<FormState>();
  final _modeloCtrl = TextEditingController();
  final _placaCtrl = TextEditingController();

  Future<void> _adicionarVeiculo() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await veiculosCollection.add({
        'modelo': _modeloCtrl.text.trim(),
        'placa': _placaCtrl.text.trim(),
      });
      _modeloCtrl.clear();
      _placaCtrl.clear();
      if (!mounted) return;
      Navigator.of(context).pop();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veículo adicionado com sucesso!')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao adicionar veículo.')),
      );
    }
  }

  Future<void> _mostrarDialogoAdicionar() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adicionar Veículo'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _modeloCtrl,
                decoration: const InputDecoration(labelText: 'Modelo'),
                validator: (v) => v == null || v.isEmpty ? 'Informe o modelo' : null,
              ),
              TextFormField(
                controller: _placaCtrl,
                decoration: const InputDecoration(labelText: 'Placa'),
                validator: (v) => v == null || v.isEmpty ? 'Informe a placa' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _modeloCtrl.clear();
              _placaCtrl.clear();
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: _adicionarVeiculo,
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }

  Future<void> _excluirVeiculo(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: const Text('Excluir este veículo?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Excluir')),
        ],
      ),
    );
    if (confirm == true) {
      await veiculosCollection.doc(id).delete();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veículo excluído')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Veículos'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Adicionar Veículo',
            onPressed: _mostrarDialogoAdicionar,
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: veiculosCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar veículos'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final veiculos = snapshot.data!.docs;
          if (veiculos.isEmpty) {
            return const Center(child: Text('Nenhum veículo cadastrado'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: veiculos.length,
            itemBuilder: (context, index) {
              final doc = veiculos[index];
              final data = doc.data() as Map<String, dynamic>;
              final modelo = data['modelo'] ?? 'Sem modelo';
              final placa = data['placa'] ?? 'Sem placa';

              return Card(
                color: Colors.deepPurple.shade600,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(
                    modelo,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Placa: $placa',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    tooltip: 'Excluir veículo',
                    onPressed: () => _excluirVeiculo(doc.id),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
