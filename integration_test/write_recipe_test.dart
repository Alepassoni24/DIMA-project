import 'dart:io';
import 'dart:typed_data';

import 'package:dima_project/screens/home/home.dart';
import 'package:dima_project/screens/homeRecipes/latest_recipes.dart';
import 'package:dima_project/screens/homeRecipes/recipe_card.dart';
import 'package:dima_project/screens/singleRecipe/recipe_view.dart';
import 'package:dima_project/screens/userProfile/user_profile.dart';
import 'package:dima_project/screens/userProfile/user_recipe_card.dart';
import 'package:dima_project/screens/writeRecipe/add_image_button.dart';
import 'package:dima_project/screens/writeRecipe/write_ingredient_view.dart';
import 'package:dima_project/screens/writeRecipe/write_recipe_view.dart';
import 'package:dima_project/screens/writeRecipe/write_step_view.dart';
import 'package:dima_project/shared/app_icons.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:dima_project/main.dart' as app;
import 'package:path/path.dart' as Path;

import 'test_helper.dart';

void main() {
  // Must always be called at the start of the test
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('WriteRecipeView Test', (WidgetTester tester) async {
    app.main(); // Load app
    await tester.pumpAndSettle(); // Wait for the animation to end
    await ensureIsLoggedInWithTestAccount(tester);

    // Check if it is in LatestRecipes view
    expect(find.byType(Home), findsOneWidget);
    expect(find.byType(LatestRecipes), findsOneWidget);
    expect(find.byType(RecipeCard), findsWidgets);

    // Tap write recipe button
    await tester.tap(find.text("Write"));
    await tester.pumpAndSettle();

    // Check if it is in WriteRecipeView
    expect(find.byType(WriteRecipeView), findsOneWidget);

    // Since we cannot use ImagePicker in tests, we force the setState with the url of an image
    final WriteRecipeViewState writeRecipeViewState =
        tester.state<WriteRecipeViewState>(find.byType(WriteRecipeView));
    final String recipeImageURL = await getAndUploadImage("img1",
        "https://firebasestorage.googleapis.com/v0/b/dima-project-a5bc9.appspot.com/o/test%2Ftest_recipe.jpg?alt=media&token=1b54f0f9-bda1-458e-ad66-453706ad3d0f");
    final String stepImageURL = await getAndUploadImage("img2",
        "https://firebasestorage.googleapis.com/v0/b/dima-project-a5bc9.appspot.com/o/test%2Ftest_recipe_2.jpg?alt=media&token=f628a351-7640-4696-9872-d6b6c7281f2a");
    final Finder scrollable = find.byType(Scrollable).first;

    // Test main photo
    expect(find.byType(AddImageButton), findsWidgets);
    writeRecipeViewState.setRecipeImageURL(recipeImageURL);
    await tester.pumpAndSettle();
    expect(find.byType(PickedImageContainer), findsOneWidget);

    // Test title, subtitle, description, time, servings
    final Finder textFormFields =
        find.byType(TextFormField, skipOffstage: false);
    await tester.enterText(textFormFields.at(0), "Test recipe title");
    await tester.enterText(textFormFields.at(1), "Test recipe subtitle");
    await tester.enterText(textFormFields.at(2), "Test recipe description");
    await tester.enterText(textFormFields.at(3), "45");
    await tester.enterText(textFormFields.at(4), "6");
    expect(find.byType(TimeRow), findsOneWidget);
    expect(find.byType(ServingsRow, skipOffstage: false), findsOneWidget);

    // Test difficulty, category, checkmarks
    await tester.scrollUntilVisible(
        find.byType(WriteIngredientView, skipOffstage: false), 50,
        scrollable: scrollable);
    await tester.pumpAndSettle();
    expect(find.byType(DifficultyRow, skipOffstage: false), findsOneWidget);
    expect(
        find.byIcon(AppIcons.chef_hat, skipOffstage: false), findsNWidgets(3));
    await tester.tap(find.byIcon(AppIcons.chef_hat, skipOffstage: false).at(1));
    await tester.pumpAndSettle();
    expect(find.byType(CategoryDropdown, skipOffstage: false), findsOneWidget);
    await tester.tap(find.text("First course"));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Single course").last);
    await tester.pumpAndSettle();
    expect(
        find.byType(CheckboxListTile, skipOffstage: false), findsNWidgets(4));
    await tester.tap(find.byType(CheckboxListTile).at(1));
    await tester.pumpAndSettle();

    // Test ingredients
    await tester.scrollUntilVisible(
        find.byType(WriteStepView, skipOffstage: false), 50,
        scrollable: scrollable);
    await tester.pumpAndSettle();
    expect(
        find.byType(WriteIngredientView, skipOffstage: false), findsOneWidget);
    await tester.tap(find.byIcon(Icons.add_outlined).first);
    await tester.pumpAndSettle();
    expect(find.byType(WriteIngredientView, skipOffstage: false),
        findsNWidgets(2));
    await tester.tap(find.byIcon(Icons.add_outlined).first);
    await tester.pumpAndSettle();
    expect(find.byType(WriteIngredientView, skipOffstage: false),
        findsNWidgets(3));

    // Add three ingredients then remove one
    // I do not know why but `descendant of WriteIngredientView` does not work here, the offset is 5
    await tester.enterText(
        find.byType(TextFormField, skipOffstage: false).at(5), "1");
    await tester.enterText(
        find.byType(TextFormField, skipOffstage: false).at(6), "a");
    await tester.enterText(
        find.byType(TextFormField, skipOffstage: false).at(7), "IngTest1");
    await tester.enterText(
        find.byType(TextFormField, skipOffstage: false).at(8), "2");
    await tester.enterText(
        find.byType(TextFormField, skipOffstage: false).at(9), "b");
    await tester.enterText(
        find.byType(TextFormField, skipOffstage: false).at(10), "IngTest2");
    await tester.enterText(
        find.byType(TextFormField, skipOffstage: false).at(11), "3");
    await tester.enterText(
        find.byType(TextFormField, skipOffstage: false).at(12), "c");
    await tester.enterText(
        find.byType(TextFormField, skipOffstage: false).at(13), "IngTest3");
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.cancel).at(1));
    await tester.pumpAndSettle();
    expect(find.byType(WriteIngredientView, skipOffstage: false),
        findsNWidgets(2));
    expect(find.text("IngTest1", skipOffstage: false), findsOneWidget);
    expect(find.text("IngTest2", skipOffstage: false), findsNothing);
    expect(find.text("IngTest3", skipOffstage: false), findsOneWidget);

    // Test addition and deletion of steps
    await tester.scrollUntilVisible(
        find.text("Submit", skipOffstage: false), 50,
        scrollable: scrollable);
    await tester.pumpAndSettle();
    expect(find.byType(WriteStepView, skipOffstage: false), findsOneWidget);
    await tester.tap(find.byIcon(Icons.add_outlined).at(1));
    await tester.pumpAndSettle();
    expect(find.byType(WriteStepView, skipOffstage: false), findsNWidgets(2));
    await tester.tap(find.byIcon(Icons.cancel).last);
    await tester.pumpAndSettle();

    // Test submit button does not work
    expect(find.byType(WriteStepView, skipOffstage: false), findsOneWidget);
    await tester.tap(find.text("Submit"));
    await tester.pumpAndSettle();
    expect(find.byType(WriteRecipeView), findsOneWidget);

    // Add one step
    await tester.enterText(
        find.byType(TextFormField, skipOffstage: false).at(11),
        "StepTitleTest");
    await tester.enterText(
        find.byType(TextFormField, skipOffstage: false).at(12), "StepDescTest");
    writeRecipeViewState.setStepImageURL(0)(stepImageURL);
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.add_a_photo_outlined), findsNothing);

    // Submit recipe
    await tester.scrollUntilVisible(
        find.text("Submit", skipOffstage: false), 50,
        scrollable: scrollable);
    await tester.pumpAndSettle();
    await tester.tap(find.text("Submit"));
    await tester.pumpAndSettle();
    expect(find.byType(RecipeView), findsOneWidget);
    expect(find.text("Test recipe title"), findsOneWidget);
    expect(find.text("Test recipe description"), findsOneWidget);
    expect(find.text("Single course"), findsOneWidget);
    expect(find.text("Time: 45 minutes"), findsOneWidget);
    expect(find.text("Servings: 6 people"), findsOneWidget);

    // Check presence on user profile
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text("Account"));
    await tester.pumpAndSettle();
    expect(find.byType(UserProfilePage), findsOneWidget);
    expect(find.byType(UserStatistics), findsOneWidget);
    expect(find.text("1"), findsNothing);
    expect(find.text("2"), findsOneWidget);
    expect(find.byType(UserRecipeList), findsOneWidget);

    // Update recipe title
    await tester.tap(find.byType(UserRecipeCard).first);
    await tester.pumpAndSettle();
    expect(find.byType(RecipeView), findsOneWidget);
    expect(find.text("Test recipe title"), findsOneWidget);
    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();
    expect(find.byType(WriteRecipeView), findsOneWidget);
    expect(find.text("Test recipe title"), findsOneWidget);
    await tester.enterText(
        textFormFields.at(2), "Test recipe description updated");
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
        find.text("Submit", skipOffstage: false), 50,
        scrollable: scrollable);
    await tester.tap(find.text("Submit"));
    await tester.pumpAndSettle();
    expect(find.byType(RecipeView), findsOneWidget);
    expect(find.text("Test recipe description updated"), findsOneWidget);

    // Check presence on user profile
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text("Account"));
    await tester.pumpAndSettle();
    expect(find.byType(UserProfilePage), findsOneWidget);
    expect(find.byType(UserStatistics), findsOneWidget);
    expect(find.text("1"), findsNothing);
    expect(find.text("2"), findsOneWidget);
    expect(find.byType(UserRecipeList), findsOneWidget);

    // Delete the new recipe
    await tester.tap(find.byType(UserRecipeCard).first);
    await tester.pumpAndSettle();
    expect(find.byType(RecipeView), findsOneWidget);
    expect(find.text("Test recipe title"), findsOneWidget);
    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();
    expect(find.byType(WriteRecipeView), findsOneWidget);
    expect(find.text("Test recipe title"), findsOneWidget);
    await tester.tap(find.byIcon(Icons.delete).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text("Yes"));
    await tester.pumpAndSettle();

    // Check absence on user profile
    expect(find.byType(UserProfilePage), findsOneWidget);
    expect(find.byType(UserStatistics), findsOneWidget);
    expect(find.text("1"), findsOneWidget);
    expect(find.text("2"), findsNothing);

    // Firestore will throw no permissions exception if we try to log out
  });
}

// Helper to upload an image outside the app beacuse we cannot test the image picker
Future<String> getAndUploadImage(String imagePath, String imageURL) async {
  final http.Response responseData = await http.get(imageURL);
  Uint8List uint8list = responseData.bodyBytes;
  ByteBuffer buffer = uint8list.buffer;
  ByteData byteData = ByteData.view(buffer);
  Directory tempDir = await getTemporaryDirectory();
  File imageFile = await File(tempDir.path + "/" + imagePath).writeAsBytes(
      buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  Reference storageReference = FirebaseStorage.instance
      .ref()
      .child("test/" + Path.basename(imageFile.path));
  await storageReference.putFile(imageFile);
  return await storageReference.getDownloadURL();
}
