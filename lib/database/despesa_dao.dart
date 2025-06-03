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

  static const String sqlTabelaDespesa = 'CREATE TABLE $_nomeTabela ('
      '$_col_id INTEGER PRIMARY KEY, '
      '$_col_titulo TEXT, '
      '$_col_valor TEXT, '
      '$_col_categoria TEXT, '
      '$_col_data INTEGER, )';


  adicionar(DespesaModel d) async {
    // _despesa.add(d);

    final Database db = await getDatabase();
    await db.insert(_nomeTabela, d.toMap());

  }

  atualizar(DespesaModel d) async {

    final Database db = await getDatabase();
    db.update(_nomeTabela, d.toMap(), where: 'id=?', whereArgs: [d.id]);

  }

  Future<List<DespesaModel>>  getDespesa() async {

    final Database db = await getDatabase();

    final List<Map<String, dynamic>> maps = await db.query(_nomeTabela);

    return List.generate(maps.length, (i){
      return DespesaModel(
        maps[i][_col_id],
        maps[i][_col_titulo],
        maps[i][_col_valor],
        maps[i][_col_categoria],
        maps[i][_col_data],
      );
    });

  }


}