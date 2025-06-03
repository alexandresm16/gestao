import 'package:flutter/material.dart';

class LimitesPage extends StatefulWidget {
  const LimitesPage({super.key});

  @override
  State<LimitesPage> createState() => _LimitesPageState();
}

class _LimitesPageState extends State<LimitesPage> {
  final List<Map<String, dynamic>> limites = [
    {'tipo': 'Transporte', 'valor': 200.0},
    {'tipo': 'Alimentação', 'valor': 500.0},
  ];

  final TextEditingController tipoController = TextEditingController();
  final TextEditingController valorController = TextEditingController();

  void _adicionarOuEditarLimite({int? index}) {
    if (index != null) {
      tipoController.text = limites[index]['tipo'];
      valorController.text = limites[index]['valor'].toString();
    } else {
      tipoController.clear();
      valorController.clear();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(index != null ? 'Editar Limite' : 'Novo Limite'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: tipoController,
              decoration: const InputDecoration(labelText: 'Tipo de Despesa'),
            ),
            TextField(
              controller: valorController,
              decoration: const InputDecoration(labelText: 'Valor Limite'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final tipo = tipoController.text;
              final valor = double.tryParse(valorController.text) ?? 0.0;

              if (tipo.isNotEmpty && valor > 0) {
                setState(() {
                  if (index != null) {
                    limites[index] = {'tipo': tipo, 'valor': valor};
                  } else {
                    limites.add({'tipo': tipo, 'valor': valor});
                  }
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _removerLimite(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: const Text('Deseja realmente excluir este limite?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                limites.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Limites'),
        backgroundColor: Colors.green[600],
      ),
      body: limites.isEmpty
          ? const Center(child: Text('Nenhum limite cadastrado.'))
          : ListView.builder(
        itemCount: limites.length,
        itemBuilder: (context, index) {
          final limite = limites[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(limite['tipo']),
              subtitle: Text('Limite: R\$ ${limite['valor'].toStringAsFixed(2)}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _adicionarOuEditarLimite(index: index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removerLimite(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _adicionarOuEditarLimite(),
        backgroundColor: Colors.green[600],
        child: const Icon(Icons.add),
        tooltip: 'Adicionar novo limite',
      ),
    );
  }
}
