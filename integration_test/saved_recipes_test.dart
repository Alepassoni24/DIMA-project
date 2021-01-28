import 'package:dima_project/screens/home/home.dart';
import 'package:dima_project/screens/homeRecipes/latest_recipes.dart';
import 'package:dima_project/screens/homeRecipes/recipe_card.dart';
import 'package:dima_project/screens/savedRecipes/saved_recipes_view.dart';
import 'package:dima_project/screens/singleRecipe/recipe_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:dima_project/main.dart' as app;

import 'test_helper.dart';

void main() {
  // Must always be called at the start of the test
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('SavedRecipes Test', (WidgetTester tester) async {
    app.main(); // Load app
    await tester.pumpAndSettle(); // Wait for the animation to end
    await ensureIsLoggedInWithTestAccount(tester); // Log in

    // Check if it is in LatestRecipes view
    expect(find.byType(Home), findsOneWidget);
    expect(find.byType(LatestRecipes), findsOneWidget);
    expect(find.byType(RecipeCard), findsWidgets);

    // Check if SavedRecipesView is empty
    await tester.tap(find.text("Saved"));
    await tester.pumpAndSettle();
    expect(find.byType(SavedRecipesView), findsOneWidget);
    expect(find.byIcon(Icons.bookmark_outline), findsOneWidget);
    expect(find.byIcon(Icons.bookmark), findsOneWidget);
    await tester.tap(find.text("Home"));
    await tester.pumpAndSettle();

    // Save one recipes
    await tester.tap(find.byType(RecipeCard).at(1));
    await tester.pumpAndSettle();
    expect(find.byType(RecipeView), findsOneWidget);
    expect(find.byIcon(Icons.bookmark_outline), findsOneWidget);
    expect(find.byIcon(Icons.bookmark), findsNothing);
    await tester.tap(find.byIcon(Icons.bookmark_outline).first);
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.bookmark_outline), findsNothing);
    expect(find.byIcon(Icons.bookmark), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    // Save another recipe
    await tester.tap(find.byType(RecipeCard).at(0));
    await tester.pumpAndSettle();
    expect(find.byType(RecipeView), findsOneWidget);
    expect(find.byIcon(Icons.bookmark_outline), findsOneWidget);
    expect(find.byIcon(Icons.bookmark), findsNothing);
    await tester.tap(find.byIcon(Icons.bookmark_outline).first);
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.bookmark_outline), findsNothing);
    expect(find.byIcon(Icons.bookmark), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    // Go to saved recipes view
    await tester.tap(find.text("Saved"));
    await tester.pumpAndSettle();
    expect(find.byType(SavedRecipesView), findsOneWidget);
    expect(find.byType(RecipeCard), findsNWidgets(2));
    expect(find.byIcon(Icons.bookmark_outline), findsOneWidget);
    expect(find.byIcon(Icons.bookmark), findsNothing);

    // Remove the first recipe
    await tester.tap(find.byType(RecipeCard).first);
    await tester.pumpAndSettle();
    expect(find.byType(RecipeView), findsOneWidget);
    expect(find.byIcon(Icons.bookmark_outline), findsNothing);
    expect(find.byIcon(Icons.bookmark), findsOneWidget);
    await tester.tap(find.byIcon(Icons.bookmark));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.bookmark_outline), findsOneWidget);
    expect(find.byIcon(Icons.bookmark), findsNothing);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(SavedRecipesView), findsOneWidget);
    await tester.drag(find.byType(RefreshIndicator), Offset(0.0, 500.0));
    await tester.pumpAndSettle();

    // Remove the second recipe
    await tester.tap(find.byType(RecipeCard));
    await tester.pumpAndSettle();
    expect(find.byType(RecipeView), findsOneWidget);
    expect(find.byIcon(Icons.bookmark_outline), findsNothing);
    expect(find.byIcon(Icons.bookmark), findsOneWidget);
    await tester.tap(find.byIcon(Icons.bookmark));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.bookmark_outline), findsOneWidget);
    expect(find.byIcon(Icons.bookmark), findsNothing);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(SavedRecipesView), findsOneWidget);
    await tester.drag(find.byType(RefreshIndicator), Offset(0.0, 500.0));
    await tester.pumpAndSettle();

    // Go back
    expect(find.byIcon(Icons.bookmark_outline), findsOneWidget);
    expect(find.byIcon(Icons.bookmark), findsOneWidget);

    await ensureIsLoggedOut(tester); // Log out
  });
}
