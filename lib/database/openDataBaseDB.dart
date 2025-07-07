import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'despesa_dao.dart';
import 'limite_dao.dart';
import 'meta_dao.dart';

Future<Database> getDatabase() async {
  final String path = join(await getDatabasesPath(), 'dbgestao1.db');

  return openDatabase(
    path,
    version: 6, // aumente a versão para disparar o onUpgrade
    onCreate: (db, version) async {
      await db.execute(DespesaDAO.sqlTabelaDespesa);
      await db.execute(LimiteDAO.sqlTabelaLimite);
      await db.execute(MetaDAO.sqlTabelaMetas);
    },
    onUpgrade: (db, oldVersion, newVersion) async {
      // Cria as tabelas se não existirem
      await db.execute(DespesaDAO.sqlTabelaDespesa);
      await db.execute(LimiteDAO.sqlTabelaLimite);
      await db.execute(MetaDAO.sqlTabelaMetas);
    },
  );
}
