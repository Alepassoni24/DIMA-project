import 'package:dima_project/screens/authenticate/sign_in.dart';
import 'package:dima_project/screens/home/home.dart';
import 'package:dima_project/screens/homeRecipes/latest_recipes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// The test may start in the SignIn or Home (LatestRecipesView) beacuse of the automatic login,
// using these two method we can ensure the starting state is always the same, with the test account logged in

// This method ensures the test is in the LatestRecipesView in the Home with the test account logged in
Future<void> ensureIsLoggedInWithTestAccount(WidgetTester tester) async {
  await ensureIsLoggedOut(tester); // Log out if we are not in SignIn view

  // Then do the login with the tester account
  await tester.enterText(
      find.byType(TextFormField).at(0), 'test@test.com'); // Enter email
  await tester.enterText(
      find.byType(TextFormField).at(1), '123456789'); // Enter password
  await tester.tap(find.byType(RaisedButton).at(0)); // Sign in
  await tester.pumpAndSettle(); // Wait for the animation to end

  // Now me must be in the homepage, in the LatestRecipes view
  expect(find.byType(Home), findsOneWidget);
  expect(find.byType(LatestRecipes), findsOneWidget);

  // Return the await for the animation to end
  return await tester.pumpAndSettle();
}

// This method ensures the test is in the SignIn view
Future<void> ensureIsLoggedOut(WidgetTester tester) async {
  // If we are in the SignIn view we are ok
  try {
    expect(find.byType(SignIn), findsOneWidget);
  }

  // Otherwise do the logout
  catch (exception) {
    await tester.tap(find.text("Account")); // Tap write review button
    await tester.pumpAndSettle(); // Wait for the animation to end
    await tester.tap(find.byIcon(Icons.logout)); // Tap logout button
    await tester.pumpAndSettle(); // Wait for the animation to end

    // Now we must be in the SignIn view
    expect(find.byType(SignIn), findsOneWidget);

    // Return the await for the animation to end
    return await tester.pumpAndSettle();
  }
}
