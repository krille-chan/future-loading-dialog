// Copyright (c) 2020 Famedly
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:future_loading_dialog/future_loading_dialog.dart';

void main() {
  testWidgets('Future Loading Dialog', (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(
      MaterialApp(
        title: 'Test',
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showFutureLoadingDialog(
                context: context,
                future: () => Future.delayed(const Duration(seconds: 1)),
              ),
              child: const Text('Test'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Loading... Please Wait!'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Loading... Please Wait!'), findsNothing);
    expect(find.byType(LinearProgressIndicator), findsNothing);
  });
  testWidgets('Future Loading Dialog with Exception',
      (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(
      MaterialApp(
        title: 'Test',
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showFutureLoadingDialog(
                  context: context,
                  future: () async {
                    await Future.delayed(const Duration(seconds: 1));
                    throw 'Oops';
                  }),
              child: const Text('Test'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Loading... Please Wait!'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Oops'), findsOneWidget);
    expect(find.byType(TextButton), findsOneWidget);
  });
}
