import 'package:dima_project/screens/home/home.dart';
import 'package:dima_project/screens/homeRecipes/latest_recipes.dart';
import 'package:dima_project/screens/homeRecipes/recipe_card.dart';
import 'package:dima_project/screens/review/review_view.dart';
import 'package:dima_project/screens/review/write_review_view.dart';
import 'package:dima_project/screens/singleRecipe/ingredients_view.dart';
import 'package:dima_project/screens/singleRecipe/recipe_view.dart';
import 'package:dima_project/screens/singleRecipe/steps_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:dima_project/main.dart' as app;

import 'test_helper.dart';

void main() {
  // Must always be called at the start of the test
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Home, LatestRecipesView, RecipeView Test',
      (WidgetTester tester) async {
    app.main(); // Load app
    await tester.pumpAndSettle(); // Wait for the animation to end
    await ensureIsLoggedInWithTestAccount(tester); // Log in

    // Check if it is in LatestRecipes view
    expect(find.byType(Home), findsOneWidget);
    expect(find.byType(LatestRecipes), findsOneWidget);
    expect(find.byType(RecipeCard), findsWidgets);

    // Tap the first recipe card
    await tester.tap(find.byType(RecipeCard).first);
    await tester.pumpAndSettle();

    // Check if it is in RecipeView
    expect(find.byType(RecipeView), findsOneWidget);

    // Find the main scrollable since RecipeView uses more than one
    Finder scrollable = find.byType(Scrollable).first;

    // Check if the various sections are loaded
    expect(find.byType(MainPhoto), findsOneWidget);
    expect(find.byType(AuthorImage), findsOneWidget);
    await tester.scrollUntilVisible(
        find.byType(Servings, skipOffstage: false), 50,
        scrollable: scrollable);
    await tester.pumpAndSettle();
    expect(find.byType(Category, skipOffstage: false), findsOneWidget);
    expect(find.byType(Difficulty, skipOffstage: false), findsOneWidget);
    expect(find.byType(Time, skipOffstage: false), findsOneWidget);
    expect(find.byType(Servings, skipOffstage: false), findsOneWidget);
    await tester.scrollUntilVisible(
        find.byType(IngredientsView, skipOffstage: false), 50,
        scrollable: scrollable);
    await tester.pumpAndSettle();
    expect(find.byType(IngredientsView, skipOffstage: false), findsOneWidget);
    expect(find.byType(IngredientView, skipOffstage: false), findsWidgets);
    await tester.scrollUntilVisible(
        find.byType(StepsView, skipOffstage: false), 50,
        scrollable: scrollable);
    await tester.pumpAndSettle();
    expect(find.byType(StepsView, skipOffstage: false), findsOneWidget);
    expect(find.byType(StepView, skipOffstage: false), findsWidgets);
    await tester.scrollUntilVisible(
        find.byType(WriteReviewView, skipOffstage: false), 50,
        scrollable: scrollable, maxScrolls: 250);
    await tester.pumpAndSettle();
    expect(find.byType(WriteReviewView, skipOffstage: false), findsOneWidget);
    expect(find.byType(ReviewForm, skipOffstage: false), findsOneWidget);
    await tester.scrollUntilVisible(
        find.byType(ReviewView, skipOffstage: false), 50,
        scrollable: scrollable);
    await tester.pumpAndSettle();
    expect(find.byType(ReviewView, skipOffstage: false), findsOneWidget);

    // Return to the homepage
    await tester.pageBack();
    await tester.pumpAndSettle();

    await ensureIsLoggedOut(tester); // Log out
  });
}
