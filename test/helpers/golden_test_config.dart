import 'package:flutter_test/flutter_test.dart';

import 'widget_test_harness.dart';

Future<void> expectGolden(WidgetTester tester, {required String name}) async {
  await tester.pump(const Duration(milliseconds: 80));
  await expectLater(
    find.byKey(kWidgetTestSurfaceKey),
    matchesGoldenFile('../../goldens/$name.png'),
  );
}
