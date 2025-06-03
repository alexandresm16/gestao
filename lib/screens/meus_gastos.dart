import 'package:flutter/material.dart';

class MeusGastosPage extends StatefulWidget {
  const MeusGastosPage({super.key});

  @override
  State<MeusGastosPage> createState() => _MeusGastosPageState();
}

class _MeusGastosPageState extends State<MeusGastosPage> {
  String _mesSelecionado = 'Junho';

  final List<String> meses = [
    'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
    'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
  ];

  final Map<String, List<Map<String, dynamic>>> gastosPorMes = {
    'Junho': [
      {'titulo': 'Mercado', 'valor': 120.0, 'data': '01/06/2025'},
      {'titulo': 'Transporte', 'valor': 40.0, 'data': '02/06/2025'},
    ],
    'Maio': [
      {'titulo': 'Restaurante', 'valor': 70.0, 'data': '28/05/2025'},
      {'titulo': 'Cinema', 'valor': 30.0, 'data': '25/05/2025'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> gastos = gastosPorMes[_mesSelecionado] ?? [];

    double totalGasto = gastos.fold(
      0.0,
          (soma, item) => soma + (item['valor'] as double),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Gastos'),
        backgroundColor: Colors.green[600],
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
                  items: meses.map((String mes) {
                    return DropdownMenuItem<String>(
                      value: mes,
                      child: Text(mes),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Total gasto no mês
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Total gasto em $_mesSelecionado: R\$ ${totalGasto.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Lista de gastos
            Expanded(
              child: gastos.isEmpty
                  ? const Center(child: Text("Nenhum gasto encontrado."))
                  : ListView.builder(
                itemCount: gastos.length,
                itemBuilder: (context, index) {
                  final gasto = gastos[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(gasto['titulo']),
                      subtitle: Text(gasto['data']),
                      trailing: Text(
                        "R\$ ${gasto['valor'].toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
