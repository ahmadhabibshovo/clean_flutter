import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:clean/main.dart';

void main() {
  testWidgets('Todo page smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: App()));

    // App bar title should render
    expect(find.text('TODO (Riverpod + Bloc + Mock API)'), findsOneWidget);

    // Let the mock API load finish
    await tester.pump(const Duration(milliseconds: 20));
    await tester.pumpAndSettle(const Duration(milliseconds: 200));

    // Seeded mock todos should appear
    expect(find.text('Read Clean Architecture'), findsOneWidget);
    expect(find.text('Implement offline mock API'), findsOneWidget);
  });
}
