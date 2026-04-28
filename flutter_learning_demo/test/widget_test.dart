import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_learning_demo/main.dart';

void main() {
  testWidgets('shows the learning page title', (tester) async {
    await tester.pumpWidget(const CrossPlatformApp());

    expect(find.text('Learn Flutter Cross-Platform'), findsOneWidget);
    expect(find.text('Why Flutter'), findsOneWidget);
  });
}
