import 'package:dima_project/screens/home/home.dart';
import 'package:dima_project/screens/userProfile/user_profile.dart';
import 'package:dima_project/screens/userProfile/user_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:dima_project/main.dart' as app;

import 'test_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding
      .ensureInitialized(); // Must always be called at the start of the test

  testWidgets('Home, UserProfilePage', (WidgetTester tester) async {
    app.main(); // Load app
    await tester.pumpAndSettle(); // Wait for the animation to end
    await ensureIsLoggedInWithTestAccount(tester); // Log in

    // Tap the User profile page card
    await tester.tap(find.text("Account"));
    await tester.pumpAndSettle();

    // Check if it is in User profile page
    expect(find.byType(UserProfilePage), findsOneWidget);
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.settings)); // Tap logout button
    await tester.pumpAndSettle(); // Wait for the animation to end

    // Now we must be in the user settings view
    expect(find.byType(UserSettings), findsOneWidget);
    await tester.pumpAndSettle();

    // Check if the various sections are loaded
    expect(find.byType(InkWell, skipOffstage: false), findsNWidgets(2));
    expect(find.byType(TextFormField, skipOffstage: false), findsNWidgets(3));
    await tester.pumpAndSettle();

    //Return to the profile page
    await tester.pageBack();
    await tester.pumpAndSettle();

    //Return to the homepage
    await tester.tap(find.text("Home"));
    await tester.pumpAndSettle();

    //Check if it is the homepage
    expect(find.byType(Home), findsOneWidget);
    await tester.pumpAndSettle();

    await ensureIsLoggedOut(tester); // Log out
  });
}
