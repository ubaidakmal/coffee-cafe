import 'package:flutter_test/flutter_test.dart';

import 'package:coffee_cafe/main.dart';

void main() {
  testWidgets('Koffiqa intro loads', (WidgetTester tester) async {
    await tester.pumpWidget(const KoffiqaPitchApp());

    expect(find.text('KOFFIQA'), findsWidgets);
    expect(find.text('CAF\u00C9 & ROASTERY'), findsWidgets);
    expect(
      find.text('EST. \u00B7 AL KHOBAR, KSA \u00B7 AJDAN WALK'),
      findsWidgets,
    );

    await tester.tapAt(tester.view.physicalSize.center(Offset.zero));
    await tester.pump();
  });
}
