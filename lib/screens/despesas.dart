import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/despesa_dao.dart';
import '../model/despesa_model.dart';

class NovaDespesaPage extends StatefulWidget {
  int? index;
  DespesaModel? despesa;

  NovaDespesaPage({this.despesa}) {
    if (despesa == null) {
      index = -1;
    } else {
      index = despesa!.id;
      this.despesa = despesa;
    }
  }

  @override
  State<NovaDespesaPage> createState() => _NovaDespesaPageState();
}

class _NovaDespesaPageState extends State<NovaDespesaPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();
  String _categoriaSelecionada = 'Alimentação';
  DateTime _dataSelecionada = DateTime.now();


  @override
  void initState() {
    super.initState();

    if (widget.despesa != null) {
      _tituloController.text = widget.despesa!.titulo;
      _valorController.text = widget.despesa!.valor.toString();
      _categoriaSelecionada = widget.despesa!.categoria;
      _dataSelecionada = widget.despesa!.data;
    }
  }

  final List<String> _categorias = [
    'Alimentação',
    'Transporte',
    'Lazer',
    'Educação',
    'Saúde',
    'Outros',
  ];

  void _selecionarData() async {
    final DateTime? dataEscolhida = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (dataEscolhida != null) {
      setState(() {
        _dataSelecionada = dataEscolhida;
      });
    }
  }

  void _salvarDespesa() async {
    if (_formKey.currentState!.validate()) {
      String titulo = _tituloController.text;
      double valor = double.parse(_valorController.text.replaceAll(',', '.'));

      DespesaModel despesa = DespesaModel(
        widget.despesa?.id, // mantém o id existente se for edição
        titulo,
        valor,
        _categoriaSelecionada,
        _dataSelecionada,
      );

      if (widget.despesa == null) {
        // Inserir nova despesa
        await DespesaDAO().adicionar(despesa);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Despesa "$titulo" salva com sucesso!')),
        );
      } else {
        // Atualizar despesa existente
        await DespesaDAO().atualizar(despesa);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Despesa "$titulo" atualizada com sucesso!')),
        );
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Despesa'),
        backgroundColor: Colors.green[600],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Informe o título'
                            : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _valorController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Valor (R\$)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o valor';
                  }
                  final valor = double.tryParse(value.replaceAll(',', '.'));
                  if (valor == null || valor <= 0) {
                    return 'Informe um valor válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _categoriaSelecionada,
                decoration: const InputDecoration(
                  labelText: 'Categoria',
                  border: OutlineInputBorder(),
                ),
                items:
                    _categorias
                        .map(
                          (cat) =>
                              DropdownMenuItem(value: cat, child: Text(cat)),
                        )
                        .toList(),
                onChanged: (valor) {
                  setState(() {
                    _categoriaSelecionada = valor!;
                  });
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Data: ${DateFormat('dd/MM/yyyy').format(_dataSelecionada)}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: _selecionarData,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _salvarDespesa,
                icon: const Icon(Icons.save),
                label: const Text('Salvar Despesa'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
