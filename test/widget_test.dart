// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calculator/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}




// BoxDecoration(
//   border: Border.all(color: Colors.blueAccent, width: 3.0),
//   borderRadius: BorderRadius.circular(15),
//   boxShadow: [
//     BoxShadow(
//       color: Colors.blueAccent.withOpacity(0.5),
//       spreadRadius: 5,
//       blurRadius: 7,
//       offset: Offset(0, 3),
//     ),
//   ],
// ),
// child: Column(
//   children: [
//     Text(
//       'Selected Genres:',
//       style:
//           TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//     ),
//     SizedBox(height: 10),
//     for (var genre in widget.selectedGenres)
//       Text(
//         genre,
//         style: TextStyle(fontSize: 18),
//       ),
//   ],
// ),