// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:polylog/features/auth/presentation/onboarding_page.dart';
import 'package:polylog/providers.dart';

void main() {
  testWidgets('shows sign-in button when no user is logged in', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateProvider.overrideWith((ref) => Stream.value(null)),
        ],
        child: const MaterialApp(
          home: OnboardingPage(),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('PolyLog'), findsOneWidget);
    expect(find.text('Sign in with Google'), findsOneWidget);
  });
}
