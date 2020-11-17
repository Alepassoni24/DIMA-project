import 'package:dima_project/screens/recipes/latestRecipes.dart';
import 'package:dima_project/services/auth.dart';
import 'package:flutter/material.dart';

// This is the stateful widget that the main application instantiates
class Home extends StatefulWidget {
  //value to manage the authentication particulr sign out phase, would be moved if sign out function is implemented somewhere else

  @override
  HomeState createState() => HomeState();
}

// This is the private State class that goes with Home
class HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        backgroundColor: Colors.orange[400],
        elevation: 0.0,
        title: Text('Home'),
        actions: [
          FlatButton(
              onPressed: () {
                _auth.signOut();
              },
              child: Text('Sign out'))
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: getBottomNavigationBarItem(),
    );
  }

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static List<Widget> _widgetOptions = <Widget>[
    // Here we must insert the five widgets that characterize the app instead of the dummy Text widgets
    LatestRecipes(),
    Text(
      'Search for recipes',
      style: optionStyle,
    ),
    Text(
      'Write a recipe',
      style: optionStyle,
    ),
    Text(
      'Saved recipes',
      style: optionStyle,
    ),
    Text(
      'Account and settings',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  BottomNavigationBar getBottomNavigationBarItem() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search_outlined),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_outlined),
          label: 'Write',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark_outline),
          label: 'Saved',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle_outlined),
          label: 'Account',
        ),
      ],
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.amber[800],
      onTap: _onItemTapped,
    );
  }
}
