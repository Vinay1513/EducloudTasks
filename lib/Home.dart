import 'package:flutter/material.dart';
import 'dataprovider.dart'; // Import your DataProvider class
import 'modalclass.dart'; // Import your Employee class

class EmployeeItem extends StatelessWidget {
  final Employee employee;
  final DataProvider dataProvider;

  const EmployeeItem({required this.employee, required this.dataProvider});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(employee.name),
      subtitle: Text('ID: ${employee.id}, Salary: \$${employee.salary.toStringAsFixed(2)}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => _showUpdateEmployeeDialog(context, employee),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _deleteEmployee(context, employee.id),
          ),
        ],
      ),
    );
  }

  void _showUpdateEmployeeDialog(BuildContext context, Employee employee) {
    final nameController = TextEditingController(text: employee.name);
    final salaryController = TextEditingController(text: employee.salary.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Employee'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: salaryController,
                decoration: InputDecoration(labelText: 'Salary'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Update'),
              onPressed: () async {
                final name = nameController.text;
                final salary = double.tryParse(salaryController.text) ?? 0.0;

                if (name.isNotEmpty) {
                  final updatedEmployee = Employee(id: employee.id, name: name, salary: salary);
                  await dataProvider.updateEmployee(updatedEmployee);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteEmployee(BuildContext context, int empId) async {
    await dataProvider.deleteEmployee(empId);
  }
}

class EmployeeListScreen extends StatefulWidget {
  final DataProvider dataProvider;

  const EmployeeListScreen({required this.dataProvider});

  @override
  _EmployeeListScreenState createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  late Stream<List<Employee>> _employeeStream;

  @override
  void initState() {
    super.initState();
    _employeeStream = widget.dataProvider.employeeStream;
    _addHardcodedEmployees(); // Add hardcoded data when the screen initializes
  }

  void _addHardcodedEmployees() async {
    // List of hardcoded employees
    final employees = [
      Employee(id: 1, name: 'Alice Smith', salary: 50000.0),
      Employee(id: 2, name: 'Bob Johnson', salary: 60000.0),
      Employee(id: 3, name: 'Charlie Brown', salary: 55000.0),
    ];

    // Insert each employee into the database
    for (var employee in employees) {
      await widget.dataProvider.insertEmployee(employee);
    }
  }

  void _showAddEmployeeDialog() {
    final nameController = TextEditingController();
    final salaryController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Employee'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: salaryController,
                decoration: InputDecoration(labelText: 'Salary'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () async {
                final name = nameController.text;
                final salary = double.tryParse(salaryController.text) ?? 0.0;

                if (name.isNotEmpty) {
                  final newEmployee = Employee(
                    id: DateTime.now().millisecondsSinceEpoch, // Use a unique ID for simplicity
                    name: name,
                    salary: salary,
                  );
                  await widget.dataProvider.insertEmployee(newEmployee);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employees'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _addHardcodedEmployees, // Button to add hardcoded data
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showAddEmployeeDialog, // Button to add new employee
          ),
        ],
      ),
      body: StreamBuilder<List<Employee>>(
        stream: _employeeStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No employees found.'));
          } else {
            final employees = snapshot.data!;
            return ListView.builder(
              itemCount: employees.length,
              itemBuilder: (context, index) {
                final employee = employees[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.blue,
                    ),
                    child: EmployeeItem(employee: employee, dataProvider: widget.dataProvider),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
