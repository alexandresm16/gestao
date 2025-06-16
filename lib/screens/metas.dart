import 'package:flutter/material.dart';
import '../database/meta_dao.dart';
import '../model/meta_model.dart';

class MetasPage extends StatefulWidget {
  const MetasPage({super.key});

  @override
  State<MetasPage> createState() => _MetasPageState();
}

class _MetasPageState extends State<MetasPage> {
  final MetaDAO _metaDAO = MetaDAO();
  List<MetaModel> metas = [];
  bool _isLoading = true;

  final List<String> meses = [
    'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
    'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro',
  ];
  final TextEditingController valorController = TextEditingController();
  String? mesSelecionado;
  int anoSelecionado = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _carregarMetas();
  }

  Future<void> _carregarMetas() async {
    setState(() => _isLoading = true);
    metas = await _metaDAO.getMetas();
    setState(() => _isLoading = false);
  }

  void _abrirFormulario({MetaModel? meta}) {
    if (meta != null) {
      mesSelecionado = meta.mes;
      anoSelecionado = meta.ano;
      valorController.text = meta.valor.toString();
    } else {
      mesSelecionado = null;
      anoSelecionado = DateTime.now().year;
      valorController.clear();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(meta != null ? 'Editar Meta' : 'Nova Meta'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: mesSelecionado,
              items: meses.map((mes) => DropdownMenuItem(value: mes, child: Text(mes))).toList(),
              decoration: const InputDecoration(labelText: 'Mês'),
              onChanged: (valor) {
                setState(() {
                  mesSelecionado = valor;
                });
              },
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Ano'),
              controller: TextEditingController(text: anoSelecionado.toString()),
              onChanged: (val) => anoSelecionado = int.tryParse(val) ?? DateTime.now().year,
            ),
            TextField(
              controller: valorController,
              decoration: const InputDecoration(labelText: 'Valor da Meta'),
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
              if (mesSelecionado != null && double.tryParse(valorController.text) != null) {
                final novaMeta = MetaModel(
                  meta?.id,
                  mesSelecionado!,
                  anoSelecionado,
                  double.parse(valorController.text),
                );

                if (meta == null) {
                  await _metaDAO.adicionar(novaMeta);
                } else {
                  await _metaDAO.atualizar(novaMeta);
                }

                await _carregarMetas();
                Navigator.pop(context);
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _removerMeta(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir Meta'),
        content: const Text('Deseja realmente excluir esta meta?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              await _metaDAO.deletar(id);
              await _carregarMetas();
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
        title: const Text('Metas Mensais'),
        backgroundColor: Colors.green[600],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : metas.isEmpty
          ? const Center(child: Text('Nenhuma meta cadastrada.'))
          : ListView.builder(
        itemCount: metas.length,
        itemBuilder: (context, index) {
          final meta = metas[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text('${meta.mes} ${meta.ano}'),
              subtitle: Text('Meta: R\$ ${meta.valor.toStringAsFixed(2)}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _abrirFormulario(meta: meta),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removerMeta(meta.id!),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirFormulario(),
        backgroundColor: Colors.green[600],
        child: const Icon(Icons.add),
      ),
    );
  }
}
