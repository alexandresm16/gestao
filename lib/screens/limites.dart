import 'package:flutter/material.dart';
import '../database/limite_dao.dart';
import '../model/limite_model.dart';

class LimitesPage extends StatefulWidget {
  const LimitesPage({super.key});

  @override
  State<LimitesPage> createState() => _LimitesPageState();
}

class _LimitesPageState extends State<LimitesPage> {
  final LimiteDAO _limiteDAO = LimiteDAO();
  List<LimiteModel> limites = [];
  bool _isLoading = true;

  final List<String> tiposDespesa = [
    'Alimentação',
    'Transporte',
    'Lazer',
    'Educação',
    'Saúde',
    'Outros',
  ];

  String? tipoSelecionado;
  final TextEditingController valorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarLimites();
  }

  Future<void> _carregarLimites() async {
    setState(() => _isLoading = true);
    limites = await _limiteDAO.getLimites();
    setState(() => _isLoading = false);
  }

  void _adicionarOuEditarLimite({LimiteModel? limite}) {
    if (limite != null) {
      tipoSelecionado = limite.tipo;
      valorController.text = limite.valor.toString();
    } else {
      tipoSelecionado = null;
      valorController.clear();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(limite != null ? 'Editar Limite' : 'Novo Limite'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: tipoSelecionado,
              items: tiposDespesa.map((tipo) {
                return DropdownMenuItem(
                  value: tipo,
                  child: Text(tipo),
                );
              }).toList(),
              decoration: const InputDecoration(labelText: 'Tipo de Despesa'),
              onChanged: (valor) {
                setState(() {
                  tipoSelecionado = valor;
                });
              },
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
            onPressed: () async {
              final tipo = tipoSelecionado;
              final valor = double.tryParse(valorController.text) ?? 0.0;

              if (tipo != null && valor > 0) {
                if (limite != null) {
                  // Editar
                  final limiteEditado = LimiteModel(limite.id, tipo, valor);
                  await _limiteDAO.atualizar(limiteEditado);
                } else {
                  // Adicionar
                  final novoLimite = LimiteModel(null, tipo, valor);
                  await _limiteDAO.adicionar(novoLimite);
                }
                await _carregarLimites();
                Navigator.pop(context);
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _removerLimite(int id) {
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
            onPressed: () async {
              await _limiteDAO.deletar(id);
              await _carregarLimites();
              Navigator.pop(context);
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    valorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Limites'),
        backgroundColor: Colors.green[600],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : limites.isEmpty
          ? const Center(child: Text('Nenhum limite cadastrado.'))
          : ListView.builder(
        itemCount: limites.length,
        itemBuilder: (context, index) {
          final limite = limites[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(limite.tipo),
              subtitle: Text('Limite: R\$ ${limite.valor.toStringAsFixed(2)}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _adicionarOuEditarLimite(limite: limite),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removerLimite(limite.id!),
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
