import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_skin_wise/app.dart';
import 'package:flutter_application_skin_wise/providers/app_provider.dart';

void main() {
  testWidgets('AfriGlow app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppProvider(),
        child: const AfriGlowApp(),
      ),
    );
    await tester.pump();
    expect(find.byType(AfriGlowApp), findsOneWidget);
  });
}
