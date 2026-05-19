import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:coffee_cafe/main.dart';

void main() {
  testWidgets('Koffiqa intro loads', (WidgetTester tester) async {
    await tester.pumpWidget(const KoffiqaPitchApp());

    expect(find.text('KOFFIQA'), findsNothing);
    expect(find.text('CAF\u00C9 & ROASTERY'), findsNothing);

    expect(find.byType(Image), findsWidgets);
  });
}
