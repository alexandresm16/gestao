import 'package:flutter/material.dart';
import 'package:app/database/despesa_dao.dart';
import 'package:app/model/despesa_model.dart';

class MeusGastosPage extends StatefulWidget {
  const MeusGastosPage({super.key});

  @override
  State<MeusGastosPage> createState() => _MeusGastosPageState();
}

class _MeusGastosPageState extends State<MeusGastosPage> {
  late String _mesSelecionado;

  @override
  void initState() {
    super.initState();
    final mesAtualIndex = DateTime.now().month - 1; // Janeiro = 0
    _mesSelecionado = meses[mesAtualIndex];
  }

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

  Future<List<DespesaModel>> _buscarDespesasDoMes(String mes) async {
    final todasDespesas = await DespesaDAO().getDespesa();
    final int indexMes = meses.indexOf(mes) + 1;

    return todasDespesas.where((despesa) {
      return despesa.data.month == indexMes;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
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
                future: _buscarDespesasDoMes(_mesSelecionado),
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
                                title: Text(d.titulo),
                                subtitle: Text(
                                  '${d.data.day.toString().padLeft(2, '0')}/${d.data.month.toString().padLeft(2, '0')}/${d.data.year}',
                                ),
                                trailing: Text(
                                  "R\$ ${d.valor.toStringAsFixed(2)}",
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
