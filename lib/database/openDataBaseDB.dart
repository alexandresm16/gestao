import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'despesa_dao.dart';


Future<Database> getDatabase() async {
  final String path = join(await getDatabasesPath(), 'dbgestao1.db');

  return openDatabase(
    path,
    version: 3, // aumente para forçar upgrade
    onCreate: (db, version) {
      db.execute(DespesaDAO.sqlTabelaDespesa);
    },
    onUpgrade: (db, oldVersion, newVersion) {
      // Cria a tabela se não existir
      db.execute(DespesaDAO.sqlTabelaDespesa);
    },
  );
}
