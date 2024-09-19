import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> getDatabase() async {
  return openDatabase(
    join(await getDatabasesPath(), 'employeeDB.db'),
    version: 1,
    onCreate: (db, version) {
      return db.execute('''
        CREATE TABLE employee(
          empId INTEGER PRIMARY KEY,
          name TEXT,
          sal double
        )
      ''');
    },
  );
}
