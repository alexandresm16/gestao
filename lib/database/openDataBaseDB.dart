import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'despesa_dao.dart';


Future<Database> getDatabase() async {
  final String path = join(await getDatabasesPath(), 'dbcovid2.db');

  return openDatabase(
    path,
    onCreate: (db, version) {
      db.execute(DespesaDAO.sqlTabelaDespesa);
    },
    version: 1,
  );
}