import 'package:dima_project/screens/authenticate/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:dima_project/main.dart' as app;

import 'test_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding
      .ensureInitialized(); // Must always be called at the start of the test

  testWidgets('RegistrationPage', (WidgetTester tester) async {
    app.main(); // Load app
    await tester.pumpAndSettle();
    await ensureIsLoggedOut(tester); // Log out

    // Tap the User profile page card
    await tester.tap(find.text("If do not have an account register here"));
    await tester.pumpAndSettle();

    // Check if it is in User profile page
    expect(find.byType(Register), findsOneWidget);
    await tester.pumpAndSettle();

    //check if all the components are loaded
    expect(find.byType(TextFormField, skipOffstage: false), findsNWidgets(5));
    expect(find.text("Register"), findsOneWidget);
    await tester.pumpAndSettle();

    //try to register without any credential
    await tester.tap(find.byType(RaisedButton)); //tap register button
    await tester.pumpAndSettle(); // Wait for the animation to end
    expect(find.byType(Register, skipOffstage: false), findsOneWidget);

    //try only with username
    await tester.enterText(find.byType(TextFormField).first, 'name');
    await tester.tap(find.byType(RaisedButton)); //tap register button
    await tester.pumpAndSettle(); // Wait for the animation to end
    expect(find.byType(Register, skipOffstage: false), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    //try only with email
    await tester.tap(find.text("If do not have an account register here"));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(1), 'test2@test.com');
    await tester.tap(find.byType(RaisedButton)); //tap register button
    await tester.pumpAndSettle(); // Wait for the animation to end
    expect(find.byType(Register, skipOffstage: false), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    //try only with password
    await tester.tap(find.text("If do not have an account register here"));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(2), '123456789');
    await tester.tap(find.byType(RaisedButton)); //tap register button
    await tester.pumpAndSettle(); // Wait for the animation to end
    expect(find.byType(Register, skipOffstage: false), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    //try to register without username
    await tester.tap(find.text("If do not have an account register here"));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(1),
        'test2@test.com'); //Enter a valid email
    await tester.enterText(
        find.byType(TextFormField).at(2), '123456789'); //Enter a valid password
    await tester.tap(find.byType(RaisedButton)); //tap register button
    await tester.pumpAndSettle(); //Wait for the animation to end
    expect(find.byType(Register, skipOffstage: false), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    //try to register without email
    await tester.tap(find.text("If do not have an account register here"));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.byType(TextFormField).first, 'name'); //Enter a valid username
    await tester.enterText(
        find.byType(TextFormField).at(2), '123456789'); //Enter a valid password
    await tester.tap(find.byType(RaisedButton)); //tap register button
    await tester.pumpAndSettle(); // Wait for the animation to end
    expect(find.byType(Register, skipOffstage: false), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    //try to register without password
    await tester.tap(find.text("If do not have an account register here"));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.byType(TextFormField).first, 'name'); //Enter a valid username
    await tester.enterText(find.byType(TextFormField).at(1),
        'test2@test.com'); //Enter a valid email
    await tester.tap(find.byType(RaisedButton)); //tap register button
    await tester.pumpAndSettle(); // Wait for the animation to end
    expect(find.byType(Register, skipOffstage: false), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
  });
}
