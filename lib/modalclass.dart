class Employee {
  final int id;
  final String name;
  final double salary;

  Employee({required this.id, required this.name, required this.salary});

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['empId'],
      name: map['name'],
      salary: map['sal'],
    );
  }

  Map<String, dynamic> employeeMap() {
    return {
      'empId': id,
      'name': name,
      'sal': salary,
    };
  }
}
