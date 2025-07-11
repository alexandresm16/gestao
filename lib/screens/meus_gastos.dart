import 'package:flutter/material.dart';
import 'package:app/database/despesa_dao.dart';
import 'package:app/model/despesa_model.dart';

import 'despesas.dart';

class MeusGastosPage extends StatefulWidget {
  const MeusGastosPage({super.key});

  @override
  State<MeusGastosPage> createState() => _MeusGastosPageState();
}

class _MeusGastosPageState extends State<MeusGastosPage> {
  final List<String> meses = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro',
  ];

  late String _mesSelecionado;
  late int _anoSelecionado;

  @override
  void initState() {
    super.initState();
    final agora = DateTime.now();
    _mesSelecionado = meses[agora.month - 1];
    _anoSelecionado = agora.year;
  }

  Future<List<DespesaModel>> _buscarDespesasPorMesEAno(
    String mes,
    int ano,
  ) async {
    final todasDespesas = await DespesaDAO().getDespesa();
    final int indexMes = meses.indexOf(mes) + 1;

    return todasDespesas.where((despesa) {
      return despesa.data.month == indexMes && despesa.data.year == ano;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Gastos'),
        backgroundColor: Colors.green[600],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green[600],
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => NovaDespesaPage()),
          );
          setState(() {}); // Atualiza a lista ao voltar
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Filtro por mês
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filtrar por mês:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  value: _mesSelecionado,
                  onChanged: (String? novoMes) {
                    if (novoMes != null) {
                      setState(() {
                        _mesSelecionado = novoMes;
                      });
                    }
                  },
                  items:
                      meses.map((String mes) {
                        return DropdownMenuItem<String>(
                          value: mes,
                          child: Text(mes),
                        );
                      }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Lista de gastos com FutureBuilder
            Expanded(
              child: FutureBuilder<List<DespesaModel>>(
                future: _buscarDespesasPorMesEAno(
                  _mesSelecionado,
                  _anoSelecionado,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("Erro ao carregar os dados."),
                    );
                  }

                  final despesas = snapshot.data ?? [];

                  if (despesas.isEmpty) {
                    return const Center(
                      child: Text("Nenhum gasto encontrado."),
                    );
                  }

                  final total = despesas.fold(
                    0.0,
                    (soma, item) => soma + item.valor,
                  );

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total gasto em $_mesSelecionado: R\$ ${total.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: despesas.length,
                          itemBuilder: (context, index) {
                            final d = despesas[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => NovaDespesaPage(despesa: d),
                                    ),
                                  );
                                  setState(
                                    () {},
                                  ); // Atualiza ao voltar da edição
                                },
                                title: Text(d.titulo),
                                subtitle: Text(
                                  '${d.data.day.toString().padLeft(2, '0')}/${d.data.month.toString().padLeft(2, '0')}/${d.data.year}',
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "R\$ ${d.valor.toStringAsFixed(2)}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () => _confirmarExclusao(d),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmarExclusao(DespesaModel despesa) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Excluir Despesa'),
            content: const Text('Deseja realmente excluir esta despesa?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await DespesaDAO().deletar(despesa.id!);
                  Navigator.pop(context);
                  setState(() {}); // Atualiza a tela
                },
                child: const Text('Excluir'),
              ),
            ],
          ),
    );
  }
}
