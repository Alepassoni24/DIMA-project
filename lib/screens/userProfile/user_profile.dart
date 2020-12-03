import 'package:dima_project/model/user_obj.dart';
import 'package:dima_project/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  Widget build(BuildContext context) {
    //variable to provide database instance to each ancestors
    final user = Provider.of<UserObj>(context);
    final databaseService = new DatabaseService(uid: user.uid);
    return Provider<DatabaseService>.value(
      value: databaseService,
      child: Scaffold(
        backgroundColor: Colors.orange[50],
        appBar: AppBar(
          backgroundColor: Colors.orange[400],
          title: Text('User profile page'),
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: null,
            )
          ],
        ),
        body: Center(
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 25.0,
                ),
                UserProfileInfo(),
                SizedBox(
                  height: 10.0,
                ),
                Divider(
                  color: Colors.orange[400],
                  thickness: 1.5,
                  indent: 15,
                  endIndent: 15,
                ),
                UserStatistics(),
                Divider(
                  color: Colors.orange[400],
                  thickness: 1.5,
                  indent: 15,
                  endIndent: 15,
                ),
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
                Icon(
                  Icons.account_circle_outlined,
                  size: 175,
                  color: Colors.grey[600],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  '${snapshot.data.username}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
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
                  children: [
                    Text(
                      'Recipes',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 17,
                      ),
                    ),
                    Text(
                      '${snapshot.data.recipeNumber}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Reviews',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 17,
                      ),
                    ),
                    Text(
                      '${snapshot.data.reviewNumber}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Rating',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 17,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          '${snapshot.data.rating}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 20,
                          ),
                        ),
                        Icon(
                          Icons.star_half,
                          color: Colors.orange[400],
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
    return ListView();
  }
}
