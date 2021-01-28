import 'package:dima_project/screens/home/home.dart';
import 'package:dima_project/screens/homeRecipes/recipe_card.dart';
import 'package:dima_project/screens/search/search_screen.dart';
import 'package:dima_project/screens/singleRecipe/recipe_view.dart';
import 'package:dima_project/shared/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:dima_project/main.dart' as app;

import 'test_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding
      .ensureInitialized(); // Must always be called at the start of the test

  testWidgets('Home, FilterPage', (WidgetTester tester) async {
    app.main(); // Load app
    await tester.pumpAndSettle(); // Wait for the animation to end
    await ensureIsLoggedInWithTestAccount(tester); // Log in

    // Tap the User profile page card
    await tester.tap(find.text("Search"));
    await tester.pumpAndSettle();

    // Check if it is in User profile page
    expect(find.byType(SearchScreen), findsOneWidget);
    await tester.pumpAndSettle();

    // Check if the various sections are loaded
    expect(find.text("Search for recipes"), findsOneWidget);
    await tester.pumpAndSettle();

    //open the filter panel
    await tester.tap(find.byIcon(Icons.filter_alt).at(1)); // Tap filter button
    await tester.pumpAndSettle(); // Wait for the animation to end
    expect(find.text("Select maximum difficulty:"), findsOneWidget);

    //filter
    await tester.tap(find.text("Filter"));
    await tester.pumpAndSettle();

    //find some filtered recipe
    expect(find.byType(RecipeCard), findsWidgets);
    await tester.pumpAndSettle();

    //try to open a recipe
    await tester.tap(find.byType(RecipeCard).at(0));
    await tester.pumpAndSettle();

    //Check if it is in RecipeView
    expect(find.byType(RecipeView), findsOneWidget);

    //Return to the filter page
    await tester.pageBack();
    await tester.pumpAndSettle();

    //TRY FILTERING SOME VEGAN RECIPES
    //open the filter panel
    await tester.tap(find.byIcon(Icons.filter_alt)); // Tap filter button
    await tester.pumpAndSettle(); // Wait for the animation to end

    await tester.tap(find.byType(Checkbox).first);
    await tester.pumpAndSettle();

    //filter
    await tester.tap(find.text("Filter"));
    await tester.pumpAndSettle();

    //try to open a vegan recipe
    await tester.tap(find.byType(RecipeCard).at(0));
    await tester.pumpAndSettle();

    Finder scrollable = find.byType(Scrollable).first;
    await tester.scrollUntilVisible(
        find.byType(Servings, skipOffstage: false), 50,
        scrollable: scrollable);
    await tester.pumpAndSettle();
    expect(find.byIcon(AppIcons.vegan, skipOffstage: false), findsWidgets);

    //Return to the filter page
    await tester.pageBack();
    await tester.pumpAndSettle();

    //Return to the homepage
    await tester.tap(find.text("Home"));
    await tester.pumpAndSettle();

    //TRY FILTERING SOME MEDIUM DIFFICULT RECIPES
    await tester.tap(find.text("Search"));
    await tester.pumpAndSettle();
    //open the filter panel
    await tester.tap(find.byIcon(Icons.filter_alt).at(1)); // Tap filter button
    await tester.pumpAndSettle(); // Wait for the animation to end

    await tester
        .tap(find.byIcon(AppIcons.chef_hat).at(1)); // Tap medium difficult icon

    //filter
    await tester.tap(find.text("Filter"));
    await tester.pumpAndSettle();

    //FINISH THE TEST
    //Return to the homepage
    await tester.tap(find.text("Home"));
    await tester.pumpAndSettle();

    //Check if it is the homepage
    expect(find.byType(Home), findsOneWidget);
    await tester.pumpAndSettle();

    await ensureIsLoggedOut(tester); // Log out
  });
}
