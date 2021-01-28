import 'package:dima_project/screens/authenticate/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:dima_project/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding
      .ensureInitialized(); // Must always be called at the start of the test

  testWidgets('PasswordReset', (WidgetTester tester) async {
    app.main(); // Load app
    await tester.pumpAndSettle();

    // Tap the User profile page card
    await tester.tap(find.text("Forgot password?"));
    await tester.pumpAndSettle();

    // Check if it is in User profile page
    expect(find.byType(ResetPassword), findsOneWidget);
    await tester.pumpAndSettle();

    //check if all the components are loaded
    expect(find.byType(TextFormField, skipOffstage: false), findsNWidgets(3));
    expect(find.text("Send reset password email"), findsOneWidget);
    await tester.pumpAndSettle();

    //try to register without any credential
    await tester.tap(find.byType(RaisedButton)); //tap register button
    await tester.pumpAndSettle(); // Wait for the animation to end
    expect(find.byType(ResetPassword, skipOffstage: false), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
  });
}
