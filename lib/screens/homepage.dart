import 'package:app/screens/despesas.dart';
import 'package:app/screens/meus_gastos.dart';
import 'package:app/screens/metas.dart';
import 'package:app/screens/limites.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
                  MaterialPageRoute(builder: (_) => const NovaDespesaPage()),
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
            const Text(
              "Últimas Despesas",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: const [
                  TransactionTile(title: "Mercado", amount: -80, date: "19 Mai"),
                  TransactionTile(title: "Uber", amount: -25, date: "18 Mai"),
                  TransactionTile(title: "Restaurante", amount: -50, date: "17 Mai"),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text("Limites", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                  ),
                  GoalCard(category: "Alimentação", maxAmount: 500, spentAmount: 320),
                  GoalCard(category: "Lazer", maxAmount: 300, spentAmount: 180),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 22),
                    child: Text("Meta do mês", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                  ),
                  GoalCard(category: "Janeiro", maxAmount: 3000, spentAmount: 500),
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NovaDespesaPage()),
          );
        },
      ),
    );
  }
}

class TransactionTile extends StatelessWidget {
  final String title;
  final int amount;
  final String date;

  const TransactionTile({
    required this.title,
    required this.amount,
    required this.date,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(date),
      trailing: Text(
        'R\$ ${amount.toString()}',
        style: TextStyle(
          color: amount < 0 ? Colors.red : Colors.green,
        ),
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



