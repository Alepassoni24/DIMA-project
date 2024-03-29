import 'package:dima_project/model/user_obj.dart';
import 'package:dima_project/screens/authenticate/register.dart';
import 'package:dima_project/screens/authenticate/reset_password.dart';
import 'package:dima_project/screens/singleRecipe/recipe_view.dart';
import 'package:dima_project/screens/userProfile/user_setting.dart';
import 'package:dima_project/screens/wrapper.dart';
import 'package:dima_project/screens/writeRecipe/write_recipe_view.dart';
import 'package:dima_project/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        return StreamProvider<UserObj>.value(
            value: AuthService().user,
            child: MaterialApp(
              initialRoute: '/',
              routes: {
                '/': (context) => Wrapper(),
                '/register': (context) => Register(),
                '/recipeView': (context) => RecipeView(),
                '/writeRecipe': (context) => WriteRecipeView(),
                '/resetPsw': (context) => ResetPassword(),
                '/settings': (context) => UserSettings(),
              },
              title: 'CookingTime',
            ));
      },
    );
  }
}
