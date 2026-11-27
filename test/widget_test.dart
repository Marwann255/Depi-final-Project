import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pharoh_lense/main.dart' as app;
import 'package:pharoh_lense/ui/onboarding/screen/onboarding_screen.dart';
import 'package:pharoh_lense/ui/splash/screen/splash_screen.dart';

void main() {
  testWidgets('Splash opens onboarding and all three images load', (tester) async {
    app.main();
    await tester.pump();
    expect(find.byType(SplashScreen), findsOneWidget);
    await tester.pump(const Duration(seconds: 6));
    await tester.pumpAndSettle();
    expect(find.byType(OnboardingScreen), findsOneWidget);
    for (var page = 1; page <= 3; page++) {
      final asset = AssetImage('assets/img/onboardinge ($page).jpeg');
      expect(find.image(asset), findsOneWidget);
      await tester.runAsync(() async {
        await precacheImage(asset, tester.element(find.byType(PageView)));
      });
      expect(tester.takeException(), isNull);
      if (page < 3) {
        await tester.drag(find.byType(PageView), const Offset(-800, 0));
        await tester.pumpAndSettle();
      }
    }
  });
}
