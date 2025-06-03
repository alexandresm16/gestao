import 'package:flutter/material.dart';

class LimitesPage extends StatelessWidget {
  const LimitesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Limites')),
      body: const Center(child: Text('Página para gerenciar limites por tipo de despesa')),
    );
  }
}