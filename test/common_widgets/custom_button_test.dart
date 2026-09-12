import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tremley_cutomer/common_widgets/custom_button.dart';

import '../helpers/test_helpers.dart';

void main() {
  setUpAll(() async {
    await setUpTestDependencies();
  });

  tearDownAll(() async {
    await tearDownTestDependencies();
  });

  group('CustomButton (class widget)', () {
    testWidgets('renders with correct title text', (WidgetTester tester) async {
      await tester.pumpWidget(
        testableWidget(
          const CustomButton(
            onPressed: null,
            title: 'Test Button',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Test Button'), findsOneWidget);
    });

    testWidgets('calls onPressed callback when tapped',
        (WidgetTester tester) async {
      bool wasTapped = false;

      await tester.pumpWidget(
        testableWidget(
          CustomButton(
            onPressed: () => wasTapped = true,
            title: 'Tap Me',
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Tap Me'));
      await tester.pump();

      expect(wasTapped, isTrue);
    });

    testWidgets('shows CircularProgressIndicator when isLoading is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        testableWidget(
          const CustomButton(
            onPressed: null,
            title: 'Loading',
            isLoading: true,
          ),
        ),
      );
      // Don't use pumpAndSettle — CircularProgressIndicator animates forever
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // Title text should NOT be visible when loading
      expect(find.text('Loading'), findsNothing);
    });

    testWidgets('does not call onPressed when isLoading is true',
        (WidgetTester tester) async {
      bool wasTapped = false;

      await tester.pumpWidget(
        testableWidget(
          CustomButton(
            onPressed: () => wasTapped = true,
            title: 'Loading',
            isLoading: true,
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(wasTapped, isFalse);
    });

    testWidgets('renders as ElevatedButton', (WidgetTester tester) async {
      await tester.pumpWidget(
        testableWidget(
          const CustomButton(
            onPressed: null,
            title: 'Check Type',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ElevatedButton), findsOneWidget);
    });
  });

  group('customButton (function widget)', () {
    testWidgets('renders with correct title text', (WidgetTester tester) async {
      await tester.pumpWidget(
        testableWidget(
          customButton(
            onPressed: () {},
            title: 'Function Button',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Function Button'), findsOneWidget);
    });

    testWidgets('shows loading indicator when isLoading',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        testableWidget(
          customButton(
            onPressed: () {},
            title: 'Loading',
            isLoading: true,
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
