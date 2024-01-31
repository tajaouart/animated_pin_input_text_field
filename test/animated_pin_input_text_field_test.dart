import 'package:animated_pin_input_text_field/animated_pin_input_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  MaterialApp getWidget([Function(String)? onChanged]) {
    return MaterialApp(
      home: SizedBox(
        width: 300,
        height: 200,
        child: Scaffold(
          body: PinInputTextField(
            pinLength: 6,
            onChanged: (String value) {
              onChanged?.call(value);
            },
          ),
        ),
      ),
    );
  }

  testWidgets('Renders PinInputTextField', (tester) async {
    await tester.pumpWidget(getWidget());
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.byType(TextField), findsNWidgets(6));
  });

  testWidgets('Pastes multiple characters into PinInputTextField',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: getWidget())),
    );
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // Tap the first text field and paste a sequence
    await tester.tap(find.byType(TextField).first);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '123456');
    await tester.pumpAndSettle();

    for (int i = 0; i < 6; i++) {
      expect(find.widgetWithText(TextField, '${i + 1}'), findsOneWidget);
    }
  });

  testWidgets('Types single characters into PinInputTextField', (tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: getWidget())));

    await tester.pumpAndSettle(const Duration(seconds: 1));

    for (int i = 0; i < 6; i++) {
      await tester.enterText(find.byType(TextField).at(i), '${i + 1}');
      await tester.pumpAndSettle();
    }

    for (int i = 0; i < 6; i++) {
      expect(find.widgetWithText(TextField, '${i + 1}'), findsOneWidget);
    }
  });

  testWidgets('Clears characters from PinInputTextField', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: getWidget())),
    );

    await tester.pumpAndSettle(const Duration(seconds: 1));

    // Input a sequence
    await tester.enterText(find.byType(TextField).first, '123456');
    await tester.pumpAndSettle();

    // Clear the last text field
    await tester.enterText(find.byType(TextField).last, '');
    await tester.pumpAndSettle();

    expect(find.widgetWithText(TextField, '6'), findsNothing);
  });

  testWidgets('Clears characters from PinInputTextField', (tester) async {
    final callBacks = [];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: getWidget((value) {
            callBacks.add(value);
          }),
        ),
      ),
    );

    await tester.pumpAndSettle(const Duration(seconds: 1));

    // Input a sequence
    for (int i = 0; i < 6; i++) {
      await tester.enterText(find.byType(TextField).at(i), '${i + 1}');
      await tester.pumpAndSettle();
    }

    expect(callBacks.length, 6);
    expect(callBacks, ['1', '12', '123', '1234', '12345', '123456']);
  });
}
