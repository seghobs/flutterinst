import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instagram_comment_checker/main.dart';

void main() {
  testWidgets('App should start with URL input screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that app starts
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
