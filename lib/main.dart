import 'package:dbproject/Home.dart';
import 'package:flutter/material.dart';
import 'dataprovider.dart'; // Import your DataProvider class
// Import your EmployeeListScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dataProvider = DataProvider();

  try {
    await dataProvider.init();
  } catch (e) {
    print("Error initializing DataProvider: $e");
  }

  runApp(MyApp(dataProvider: dataProvider));
}

class MyApp extends StatelessWidget {
  final DataProvider dataProvider;

  const MyApp({required this.dataProvider});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Employee Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EmployeeListScreen(dataProvider: dataProvider),
    );
  }
}
