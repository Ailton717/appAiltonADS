import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_ailton_ads/main.dart';

void main() {
  testWidgets('El feed muestra articulos al iniciar', (tester) async {
    await tester.pumpWidget(const AppAiltonAds());

    expect(find.text('Mi Feed'), findsOneWidget);
    expect(find.byType(Card), findsWidgets);
  });
}
