import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart'; // For creating mock objects
import 'package:dbproject/main.dart'; // Ensure correct path to main.dart
import 'package:dbproject/dataprovider.dart'; // Ensure correct path to DataProvider

// Create a Mock DataProvider class
class MockDataProvider extends Mock implements DataProvider {}

void main() {
  testWidgets('MyApp widget test', (WidgetTester tester) async {
    // Create a mock instance of DataProvider
    final mockDataProvider = MockDataProvider();

    // Stub the employeeStream to return a simple stream of test data
    when(mockDataProvider.employeeStream).thenAnswer((_) => Stream.value([])); // Empty list for testing

    // Build the MyApp widget with the mock DataProvider
    await tester.pumpWidget(MyApp(dataProvider: mockDataProvider));

    // Verify that MyApp displays the correct UI elements
    expect(find.text('Employees'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
