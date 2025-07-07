import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wagbty/widgets/main_scaffold.dart';

void main() {
  testWidgets('MainScaffold renders correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: MainScaffold(
          currentIndex: 0,
          body: const Center(child: Text('Test Body')),
          appBar: AppBar(title: const Text('Test AppBar')),
        ),
      ),
    );

    // Verify that MainScaffold is found
    expect(find.byType(MainScaffold), findsOneWidget);
    
    // Verify that the body text is displayed
    expect(find.text('Test Body'), findsOneWidget);
    
    // Verify that the app bar is displayed
    expect(find.text('Test AppBar'), findsOneWidget);
  });
}
