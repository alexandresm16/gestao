import 'package:app/screens/despesas.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
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
                  // Cards de Metas
                  GoalCard(category: "Alimentação", maxAmount: 500, spentAmount: 320),
                  GoalCard(category: "Lazer", maxAmount: 300, spentAmount: 180),
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
  final double amount;
  final String date;

  const TransactionTile({
    required this.title,
    required this.amount,
    required this.date,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool isExpense = amount < 0;
    return Card(
      color: isExpense ? Colors.red[50] : Colors.green[50],
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(
          Icons.arrow_upward,
          color: isExpense ? Colors.red : Colors.green,
        ),
        title: Text(title),
        subtitle: Text(date),
        trailing: Text(
          "- R\$ ${amount.abs().toStringAsFixed(2)}",
          style: TextStyle(
            color: isExpense ? Colors.red : Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class GoalCard extends StatelessWidget {
  final String category;
  final double maxAmount; // Valor máximo que pode ser gasto
  final double spentAmount; // Valor já gasto

  const GoalCard({
    required this.category,
    required this.maxAmount,
    required this.spentAmount,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double remainingAmount = maxAmount - spentAmount; // Cálculo do restante da meta

    return Card(
      color: Colors.blue[50],
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(
          category,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("Meta para o mês"),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "R\$ ${spentAmount.toStringAsFixed(2)} / R\$ ${maxAmount.toStringAsFixed(2)}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              "Restante: R\$ ${remainingAmount.toStringAsFixed(2)}",
              style: TextStyle(
                color: remainingAmount < 0 ? Colors.red : Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
