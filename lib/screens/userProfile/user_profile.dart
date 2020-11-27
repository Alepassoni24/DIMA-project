import 'package:dima_project/services/database.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  Widget build(BuildContext context) {
    print('build profile page');
    return Scaffold(
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
    );
  }
}

//widget to represent user profile photo and username
class UserProfileInfo extends StatelessWidget {
  final DatabaseService databaseService = new DatabaseService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        //TODO modify what the db retrieve
        stream: databaseService.getLastRecipes(10),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text('Something went wrong');
          if (snapshot.connectionState == ConnectionState.waiting)
            return Text("Loading");

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
                'Username',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
        });
  }
}

//widget to represent user statistic as rating, reviews and recipes
class UserStatistics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
              '###',
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
              '###',
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
              'Recipes',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 17,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  '0.0',
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
