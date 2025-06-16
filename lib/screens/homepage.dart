import 'package:flutter/material.dart';
import 'package:app/database/despesa_dao.dart';
import 'package:app/database/limite_dao.dart'; // Import do DAO de limites
import 'package:app/model/despesa_model.dart';
import 'package:app/model/limite_model.dart';
import 'package:app/screens/despesas.dart';
import 'package:app/screens/meus_gastos.dart';
import 'package:app/screens/metas.dart';
import 'package:app/screens/limites.dart';

import '../database/meta_dao.dart';
import '../model/meta_model.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<LimiteModel>> _futureLimites;
  late Future<List<DespesaModel>> _futureDespesas;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _futureLimites = LimiteDAO().getLimites();
    _futureDespesas = DespesaDAO().getDespesa();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Minhas Despesas"),
        centerTitle: true,
        backgroundColor: Colors.green[600],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.green[600]),
              child: const Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Lançar Gastos'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => NovaDespesaPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Meus Gastos'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MeusGastosPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.speed),
              title: const Text('Limites'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LimitesPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.flag),
              title: const Text('Metas'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MetasPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                children: [
                  const Text(
                    "Últimas Despesas",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  _futureBuilderDespesa(),

                  const SizedBox(height: 32),

                  const Text(
                    "Limites",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),

                  // Limites
                  FutureBuilder<List<LimiteModel>>(
                    future: LimiteDAO().getLimites(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text('Erro ao carregar limites.'),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text('Nenhum limite cadastrado.');
                      } else {
                        final limites = snapshot.data!;
                        return Column(
                          children:
                              limites.map((limite) {
                                return FutureBuilder<List<DespesaModel>>(
                                  future: DespesaDAO().getDespesaPorCategoria(
                                    limite.tipo,
                                  ),
                                  builder: (context, despesaSnapshot) {
                                    if (despesaSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const SizedBox(
                                        height: 80,
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    } else if (despesaSnapshot.hasError) {
                                      return const Text(
                                        'Erro ao carregar despesas.',
                                      );
                                    } else {
                                      final despesas =
                                          despesaSnapshot.data ?? [];
                                      final gastoTotal = despesas.fold<double>(
                                        0.0,
                                        (sum, d) => sum + d.valor,
                                      );

                                      return GoalCard(
                                        category: limite.tipo,
                                        maxAmount: limite.valor,
                                        spentAmount: gastoTotal,
                                      );
                                    }
                                  },
                                );
                              }).toList(),
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 32),
                  const Text(
                    "Meta do mês",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),

                  FutureBuilder<List<MetaModel>>(
                    future: MetaDAO().getMetas(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Text('Erro ao carregar a meta.');
                      } else {
                        final metas = snapshot.data ?? [];

                        final DateTime agora = DateTime.now();
                        final String mesAtual = _nomeDoMes(agora.month);
                        final int anoAtual = agora.year;

                        final metaDoMes = metas.firstWhere(
                          (meta) =>
                              meta.mes == mesAtual && meta.ano == anoAtual,
                          orElse:
                              () => MetaModel(null, mesAtual, anoAtual, 0.0),
                        );

                        return FutureBuilder<List<DespesaModel>>(
                          future: DespesaDAO().getDespesaPorMes(
                            agora.month,
                            agora.year,
                          ),
                          builder: (context, despesaSnapshot) {
                            if (despesaSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (despesaSnapshot.hasError) {
                              return const Text(
                                'Erro ao carregar as despesas.',
                              );
                            }

                            final despesas = despesaSnapshot.data ?? [];
                            final totalGasto = despesas.fold<double>(
                              0.0,
                              (sum, d) => sum + d.valor,
                            );

                            return GoalCard(
                              category: '${metaDoMes.mes} ${metaDoMes.ano}',
                              maxAmount: metaDoMes.valor,
                              spentAmount: totalGasto,
                            );
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green[600],
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => NovaDespesaPage()))
              .then((value) {
                setState(() {
                  _loadData();
                  debugPrint('RETORNOU DO ADD DESPESA');
                });
              });
        },
      ),
    );
  }

  Widget _futureBuilderDespesa() {
    return FutureBuilder<List<DespesaModel>>(
      future: _futureDespesas,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());

          case ConnectionState.done:
            if (snapshot.hasError) {
              return const Center(child: Text('Erro ao carregar os dados.'));
            }

            final List<DespesaModel> despesas = snapshot.data ?? [];

            if (despesas.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text('Nenhuma despesa encontrada.'),
              );
            }

            return Column(
              children:
                  despesas.map((d) {
                    return ItemDespesa(
                      d,
                      onClick: () {
                        Navigator.of(context)
                            .push(
                              MaterialPageRoute(
                                builder:
                                    (context) => NovaDespesaPage(despesa: d),
                              ),
                            )
                            .then(
                              (_) => setState(() {
                                _loadData();
                              }),
                            );
                      },
                    );
                  }).toList(),
            );

          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}

String _nomeDoMes(int numeroMes) {
  const meses = [
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
  return meses[numeroMes - 1];
}

class ItemDespesa extends StatelessWidget {
  final DespesaModel _despesa;
  final Function onClick;

  ItemDespesa(this._despesa, {required this.onClick});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => this.onClick(),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(this._despesa.titulo,
            style: TextStyle(fontSize: 16, color: Colors.black),),
          Text(
            this._despesa.categoria,
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
          ),
        ],
      ),
      subtitle: Text(
        'Data: ${_despesa.data.day}/${_despesa.data.month}/${_despesa.data.year}',
      ),
      trailing: Text('R\$ ${this._despesa.valor.toStringAsFixed(2)}'),
    );
  }
}

class GoalCard extends StatelessWidget {
  final String category;
  final double maxAmount;
  final double spentAmount;

  const GoalCard({
    required this.category,
    required this.maxAmount,
    required this.spentAmount,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (spentAmount / maxAmount).clamp(0.0, 1.0);

    return Card(
      child: ListTile(
        title: Text(category),
        subtitle: LinearProgressIndicator(
          value: percent,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
        ),
        trailing: Text(
          "${spentAmount.toStringAsFixed(0)} / ${maxAmount.toStringAsFixed(0)}",
        ),
      ),
    );
  }
}
