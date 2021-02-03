import 'package:dima_project/model/user_obj.dart';
import 'package:dima_project/screens/userProfile/user_recipe_card.dart';
import 'package:dima_project/screens/userProfile/user_setting.dart';
import 'package:dima_project/services/auth.dart';
import 'package:dima_project/services/database.dart';
import 'package:dima_project/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    //variable to provide database instance to each ancestors
    final user = Provider.of<UserObj>(context);
    final databaseService = new DatabaseService(uid: user.uid);
    //Provide database service to his descendants
    return Provider<DatabaseService>.value(
      value: databaseService,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: mainAppColor,
          title: Text('User profile page'),
          elevation: 0,
          actions: [
            //setting page button
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Provider<DatabaseService>.value(
                              value: databaseService,
                              child: UserSettings(),
                            )));
              },
            ),
            //signout button
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                _auth.signOut();
              },
            )
          ],
        ),
        body: Center(
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 25.0),
                UserProfileInfo(),
                SizedBox(height: 10.0),
                orangeDivider,
                UserStatistics(),
                orangeDivider,
                SizedBox(height: 5),
                Text(
                  'Your recipes:',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 17,
                  ),
                ),
                UserRecipeList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//widget to represent user profile photo and username
class UserProfileInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final databaseService = Provider.of<DatabaseService>(context);

    return StreamBuilder<UserData>(
        stream: databaseService.userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                if (snapshot.data.profilePhotoURL == null)
                  Icon(
                    Icons.account_circle_outlined,
                    size: 175,
                    color: Colors.grey[600],
                  ),
                if (snapshot.data.profilePhotoURL != null)
                  CircleAvatar(
                    radius: 87.5,
                    backgroundImage:
                        NetworkImage(snapshot.data.profilePhotoURL),
                  ),
                SizedBox(height: 10.0),
                Text(
                  '${snapshot.data.username}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}

//widget to represent user statistic as rating, reviews and recipes
class UserStatistics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final databaseService = Provider.of<DatabaseService>(context);

    return StreamBuilder<UserData>(
        stream: databaseService.userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Recipes',
                      style: informationDataStyle,
                    ),
                    Text(
                      '${snapshot.data.recipeNumber}',
                      style: numberDataStyle,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Reviews',
                      style: informationDataStyle,
                    ),
                    Text(
                      '${snapshot.data.reviewNumber}',
                      style: numberDataStyle,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Rating',
                      style: informationDataStyle,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          '${snapshot.data.rating.toStringAsFixed(1)}',
                          style: numberDataStyle,
                        ),
                        Icon(
                          Icons.star_half,
                          color: mainAppColor,
                        ),
                      ],
                    ),
                  ],
                )
              ],
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}

//widget to show the user recipes
class UserRecipeList extends StatefulWidget {
  @override
  _UserRecipeListState createState() => _UserRecipeListState();
}

class _UserRecipeListState extends State<UserRecipeList> {
  @override
  Widget build(BuildContext context) {
    final databaseService = Provider.of<DatabaseService>(context);

    return StreamBuilder(
      stream: databaseService.getUserRecipes,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: snapshot.data.documents
                  .map<Widget>((document) => UserRecipeCard(
                      databaseService.recipeDataFromSnapshot(document)))
                  .toList(),
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
