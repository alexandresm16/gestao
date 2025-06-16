import 'package:sqflite/sqflite.dart';
import '../model/meta_model.dart';
import 'openDataBaseDB.dart';

class MetaDAO {
  static const String _nomeTabela = 'metas';

  static const String sqlTabelaMetas = '''
    CREATE TABLE IF NOT EXISTS $_nomeTabela (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      mes TEXT NOT NULL,
      ano INTEGER NOT NULL,
      valor REAL NOT NULL
    )
  ''';

  Future<void> adicionar(MetaModel m) async {
    final db = await getDatabase();
    await db.insert(_nomeTabela, m.toMap());
  }

  Future<void> atualizar(MetaModel m) async {
    final db = await getDatabase();
    await db.update(_nomeTabela, m.toMap(), where: 'id = ?', whereArgs: [m.id]);
  }

  Future<void> deletar(int id) async {
    final db = await getDatabase();
    await db.delete(_nomeTabela, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<MetaModel>> getMetas() async {
    final db = await getDatabase();
    final maps = await db.query(_nomeTabela);
    return List.generate(maps.length, (i) => MetaModel.fromMap(maps[i]));
  }
}
