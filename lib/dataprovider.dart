import 'package:dbproject/database.dart';
import 'package:sqflite/sqflite.dart';
//import 'package:path/path.dart';
import 'package:rxdart/rxdart.dart';
import 'modalclass.dart';

class DataProvider {
  late Database _db;
  final BehaviorSubject<List<Employee>> _employeeSubject = BehaviorSubject<List<Employee>>();

  Stream<List<Employee>> get employeeStream => _employeeSubject.stream;

  Future<void> init() async {
    _db = await getDatabase();
    try {
      await _loadEmployees();
    } catch (e) {
      print("Error initializing DataProvider: $e");
    }
  }

  Future<void> _loadEmployees() async {
    final List<Map<String, dynamic>> maps = await _db.query('employee');
    final employees = List.generate(maps.length, (i) {
      return Employee.fromMap(maps[i]);
    });
    _employeeSubject.add(employees);
  }

  Future<void> insertEmployee(Employee employee) async {
    await _db.insert(
      'employee',
      employee.employeeMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    try {
      await _loadEmployees();
    } catch (e) {
      print("Error while loading employees: $e");
    }
  }

  Future<void> updateEmployee(Employee employee) async {
    await _db.update(
      'employee',
      employee.employeeMap(),
      where: 'empId = ?',
      whereArgs: [employee.id],
    );
    await _loadEmployees();
  }

  Future<void> deleteEmployee(int empId) async {
    await _db.delete(
      'employee',
      where: 'empId = ?',
      whereArgs: [empId],
    );
    await _loadEmployees();
  }


  void dispose() {
    _employeeSubject.close();
  }
}
