import 'package:dima_project/screens/userProfile/user_profile.dart';
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
    await tester.tap(find.byType(UserProfilePage).at(0));
    await tester.pumpAndSettle();

    // Check if it is in User profile page
    expect(find.byType(UserProfilePage), findsOneWidget);
    await tester.pumpAndSettle();

    // Check if the various sections are loaded
    expect(find.byType(UserProfileInfo, skipOffstage: false), findsOneWidget);
    expect(find.byType(UserStatistics, skipOffstage: false), findsOneWidget);
    expect(find.byType(UserRecipeList, skipOffstage: false), findsOneWidget);
    await tester.pumpAndSettle();

    //try to open a recipe

    // Return to the homepage
    await tester.pageBack();
    await tester.pumpAndSettle();

    await ensureIsLoggedOut(tester); // Log out
  });
}
