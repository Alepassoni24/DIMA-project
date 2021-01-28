import 'package:dima_project/screens/home/home.dart';
import 'package:dima_project/screens/homeRecipes/latest_recipes.dart';
import 'package:dima_project/screens/homeRecipes/recipe_card.dart';
import 'package:dima_project/screens/review/review_view.dart';
import 'package:dima_project/screens/review/write_review_view.dart';
import 'package:dima_project/screens/singleRecipe/recipe_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:dima_project/main.dart' as app;

import 'test_helper.dart';

void main() {
  // Must always be called at the start of the test
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('WriteReviewView Test', (WidgetTester tester) async {
    app.main(); // Load app
    await tester.pumpAndSettle(); // Wait for the animation to end
    await ensureIsLoggedInWithTestAccount(tester);

    // Check if it is in LatestRecipes view
    expect(find.byType(Home), findsOneWidget);
    expect(find.byType(LatestRecipes), findsOneWidget);
    expect(find.byType(RecipeCard), findsWidgets);

    // Tap the first recipe card
    await tester.tap(find.byType(RecipeCard).first);
    await tester.pumpAndSettle();

    // Check if it is in RecipeView
    expect(find.byType(RecipeView), findsOneWidget);

    // Go to WriteReviewView
    final Finder scrollable = find.byType(Scrollable).first;
    await tester.scrollUntilVisible(
        find.byType(ReviewView, skipOffstage: false), 50,
        scrollable: scrollable);
    await tester.pumpAndSettle();
    expect(find.byType(WriteReviewView, skipOffstage: false), findsOneWidget);
    final Finder reviewForm = find.byType(ReviewForm, skipOffstage: false);
    expect(reviewForm, findsOneWidget);
    expect(find.byType(YourReviewView, skipOffstage: false), findsNothing);
    expect(
        find.byIcon(Icons.star_border, skipOffstage: false), findsNWidgets(5));

    // Submit must fail
    await tester.tap(find.text("Submit", skipOffstage: false));
    await tester.pumpAndSettle();
    expect(find.byType(ReviewForm, skipOffstage: false), findsOneWidget);

    // Write and submit review
    await tester.tap(find.byIcon(Icons.star_border, skipOffstage: false).last);
    await tester.enterText(
        find.descendant(
            of: reviewForm,
            matching: find.byType(TextFormField, skipOffstage: false).first),
        "Test review description");
    await tester.tap(find.text("Submit", skipOffstage: false));
    await tester.pumpAndSettle();

    // Check review just written
    final Finder yourReviewView =
        find.byType(YourReviewView, skipOffstage: false);
    expect(yourReviewView, findsOneWidget);
    expect(find.byType(ReviewForm, skipOffstage: false), findsNothing);
    expect(find.byIcon(Icons.star, skipOffstage: false), findsNWidgets(5));
    expect(find.text("Test review description"), findsWidgets);

    // Delete review
    await tester.tap(find.descendant(
        of: yourReviewView,
        matching: find.byIcon(Icons.delete, skipOffstage: false).first));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Yes"));
    await tester.pumpAndSettle();
    expect(find.byType(ReviewForm, skipOffstage: false), findsOneWidget);
    expect(find.byType(YourReviewView, skipOffstage: false), findsNothing);
    expect(
        find.byIcon(Icons.star_border, skipOffstage: false), findsNWidgets(5));

    // Return to the homepage
    await tester.pageBack();
    await tester.pumpAndSettle();

    await ensureIsLoggedOut(tester);
  });
}
