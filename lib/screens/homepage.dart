import 'package:app/database/despesa_dao.dart';
import 'package:app/model/despesa_model.dart';
import 'package:app/screens/despesas.dart';
import 'package:app/screens/meus_gastos.dart';
import 'package:app/screens/metas.dart';
import 'package:app/screens/limites.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _DespesaListState();
}

class _DespesaListState extends State<HomePage> {
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
              decoration: BoxDecoration(
                color: Colors.green[600],
              ),
              child: const Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
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
              leading: const Icon(Icons.flag),
              title: const Text('Metas'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MetasPage()),
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
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text("Últimas Despesas", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  ),
                  _futureBuilderDespesa(),

                  const Text(
                    "Limites",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),

                  const GoalCard(category: "Alimentação", maxAmount: 500, spentAmount: 320),
                  const GoalCard(category: "Lazer", maxAmount: 300, spentAmount: 180),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 22),
                    child: Text("Meta do mês", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  ),
                  const GoalCard(category: "Janeiro", maxAmount: 3000, spentAmount: 500),
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
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => NovaDespesaPage()
          )).then((value){

            setState(() {
              debugPrint('RETORNOU DO ADD DESPESA');
            });

          });

          setState(() {
            debugPrint('ADICIONAR DESPESA.........');
          });
        },
      ),
    );
  }

  Widget _futureBuilderDespesa() {
    return FutureBuilder<List<DespesaModel>>(
      future: DespesaDAO().getDespesa(),
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

            // Retornando os itens
            return Column(
              children: despesas.map((d) {
                return ItemDespesa(
                  d,
                  onClick: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                      builder: (context) => NovaDespesaPage(despesa: d),
                    ))
                        .then((_) => setState(() {}));
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




class ItemDespesa extends StatelessWidget {
  final DespesaModel _despesa;
  final Function onClick;

  ItemDespesa(this._despesa, {required this.onClick});


  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => this.onClick(),
      title: Text(this._despesa.titulo),
      subtitle: Text('Data: ${_despesa.data.day}/${_despesa.data.month}/${_despesa.data.year}'),
      trailing: Text(
        'R\$ ${this._despesa.valor.toString()}',
      ),
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
        trailing: Text("${spentAmount.toStringAsFixed(0)} / ${maxAmount.toStringAsFixed(0)}"),
      ),
    );
  }
}



