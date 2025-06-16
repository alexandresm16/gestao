import 'package:sqflite/sqflite.dart';

import '../model/despesa_model.dart';
import 'openDataBaseDB.dart';

class DespesaDAO {
  //static final List<DespesaModel> _despesa = <DespesaModel>[];

  static const String _nomeTabela = 'despesas';
  static const String _col_id = 'id';
  static const String _col_titulo = 'titulo';
  static const String _col_valor = 'valor';
  static const String _col_categoria = 'categoria';
  static const String _col_data = 'data';

  static const String sqlTabelaDespesa =
      'CREATE TABLE IF NOT EXISTS $_nomeTabela ('
      '$_col_id INTEGER PRIMARY KEY, '
      '$_col_titulo TEXT, '
      '$_col_valor REAL, '
      '$_col_categoria TEXT, '
      '$_col_data INTEGER)';

  Future<void> adicionar(DespesaModel d) async {
    final Database db = await getDatabase();
    await db.insert(_nomeTabela, d.toMap());
  }

  Future<void> atualizar(DespesaModel d) async {
    final Database db = await getDatabase();
    await db.update(_nomeTabela, d.toMap(), where: 'id = ?', whereArgs: [d.id]);
  }

  Future<void> deletar(int id) async {
    final Database db = await getDatabase();
    await db.delete(_nomeTabela, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<DespesaModel>> getDespesa() async {
    final Database db = await getDatabase();

    final List<Map<String, dynamic>> maps = await db.query(_nomeTabela);

    return List.generate(maps.length, (i) {
      return DespesaModel(
        maps[i][_col_id],
        maps[i][_col_titulo],
        maps[i][_col_valor],
        maps[i][_col_categoria],
        DateTime.fromMillisecondsSinceEpoch(maps[i][_col_data]),
      );
    });
  }

  Future<List<DespesaModel>> getDespesaPorCategoria(String categoria) async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      _nomeTabela,
      where: 'categoria = ?',
      whereArgs: [categoria],
    );
    return List.generate(maps.length, (i) {
      return DespesaModel(
        maps[i][_col_id],
        maps[i][_col_titulo],
        maps[i][_col_valor],
        maps[i][_col_categoria],
        DateTime.fromMillisecondsSinceEpoch(maps[i][_col_data]),
      );
    });
  }

  Future<List<DespesaModel>> getDespesaPorMes(int mes, int ano) async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      _nomeTabela,
      where:
          "strftime('%m', data / 1000, 'unixepoch') = ? AND strftime('%Y', data / 1000, 'unixepoch') = ?",
      whereArgs: [mes.toString().padLeft(2, '0'), ano.toString()],
    );

    return List.generate(maps.length, (i) {
      return DespesaModel(
        maps[i][_col_id],
        maps[i][_col_titulo],
        maps[i][_col_valor],
        maps[i][_col_categoria],
        DateTime.fromMillisecondsSinceEpoch(maps[i][_col_data]),
      );
    });
  }
}
