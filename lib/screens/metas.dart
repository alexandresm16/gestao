import 'package:flutter/material.dart';

class MetasPage extends StatefulWidget {
  const MetasPage({super.key});

  @override
  State<MetasPage> createState() => _MetasPageState();
}

class _MetasPageState extends State<MetasPage> {
  final List<Map<String, dynamic>> metas = [
    {'categoria': 'Alimentação', 'valor': 500.0},
    {'categoria': 'Lazer', 'valor': 300.0},
  ];

  final TextEditingController categoriaController = TextEditingController();
  final TextEditingController valorController = TextEditingController();

  void _adicionarOuEditarMeta({int? index}) {
    if (index != null) {
      categoriaController.text = metas[index]['categoria'];
      valorController.text = metas[index]['valor'].toString();
    } else {
      categoriaController.clear();
      valorController.clear();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(index != null ? 'Editar Meta' : 'Nova Meta'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: categoriaController,
              decoration: const InputDecoration(labelText: 'Categoria'),
            ),
            TextField(
              controller: valorController,
              decoration: const InputDecoration(labelText: 'Valor'),
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
              final categoria = categoriaController.text;
              final valor = double.tryParse(valorController.text) ?? 0.0;

              if (categoria.isNotEmpty && valor > 0) {
                setState(() {
                  if (index != null) {
                    metas[index] = {'categoria': categoria, 'valor': valor};
                  } else {
                    metas.add({'categoria': categoria, 'valor': valor});
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

  void _removerMeta(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: const Text('Deseja realmente excluir esta meta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                metas.removeAt(index);
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
        title: const Text('Metas'),
        backgroundColor: Colors.green[600],
      ),
      body: metas.isEmpty
          ? const Center(child: Text('Nenhuma meta cadastrada.'))
          : ListView.builder(
        itemCount: metas.length,
        itemBuilder: (context, index) {
          final meta = metas[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(meta['categoria']),
              subtitle: Text('Meta: R\$ ${meta['valor'].toStringAsFixed(2)}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _adicionarOuEditarMeta(index: index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removerMeta(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _adicionarOuEditarMeta(),
        backgroundColor: Colors.green[600],
        child: const Icon(Icons.add),
        tooltip: 'Adicionar nova meta',
      ),
    );
  }
}
