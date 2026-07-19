import 'package:flutter_test/flutter_test.dart';
import 'package:ui_background_task_example/main.dart';

void main() {
  testWidgets('shows the background task controls', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Background Task Example app'), findsOneWidget);
    expect(find.text('Begin background task'), findsOneWidget);
    expect(find.textContaining('End background task:'), findsNothing);
  });
}
