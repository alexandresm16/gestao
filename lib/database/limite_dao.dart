import 'package:sqflite/sqflite.dart';
import '../model/limite_model.dart';
import 'openDataBaseDB.dart';

class LimiteDAO {
  static const String _nomeTabela = 'limites';
  static const String _col_id = 'id';
  static const String _col_tipo = 'tipo';
  static const String _col_valor = 'valor';

  static const String sqlTabelaLimite = 'CREATE TABLE IF NOT EXISTS $_nomeTabela ('
      '$_col_id INTEGER PRIMARY KEY AUTOINCREMENT, '
      '$_col_tipo TEXT NOT NULL UNIQUE, '
      '$_col_valor REAL NOT NULL)';

  Future<void> adicionar(LimiteModel l) async {
    final Database db = await getDatabase();
    await db.insert(_nomeTabela, l.toMap());
  }

  Future<void> atualizar(LimiteModel l) async {
    final Database db = await getDatabase();
    await db.update(_nomeTabela, l.toMap(), where: 'id=?', whereArgs: [l.id]);
  }

  Future<void> deletar(int id) async {
    final Database db = await getDatabase();
    await db.delete(_nomeTabela, where: 'id=?', whereArgs: [id]);
  }

  Future<List<LimiteModel>> getLimites() async {
    final db = await getDatabase();
    final maps = await db.query(_nomeTabela);
    return List.generate(maps.length, (i) => LimiteModel.fromMap(maps[i]));
  }

}
