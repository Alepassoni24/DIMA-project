import 'package:dima_project/screens/homeRecipes/latestRecipes.dart';
import 'package:dima_project/screens/userProfile/user_profile.dart';
import 'package:dima_project/screens/writeRecipe/write_recipe_view.dart';
import 'package:flutter/material.dart';

// This is the stateful widget that the main application instantiates
class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

// This is the private State class that goes with Home
class HomeState extends State<Home> {
  int _pageIndex = 0;
  PageController _pageController;

  @override
  void initState(){
    super.initState();
    _pageController = PageController(initialPage: _pageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      body: PageView(
        children: _widgetOptions,
        onPageChanged: onPageChanged,
        controller: _pageController,
      ),
      bottomNavigationBar: getBottomNavigationBarItem(),
    );
  }

  static List<Widget> _widgetOptions = <Widget>[
    // Here we must insert the five widgets that characterize the app instead of the dummy Text widgets
    LatestRecipes(),
    Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        backgroundColor: Colors.orange[400],
        elevation: 0.0,
        title: Text('Search for recipes'),
      ),
    ),
    WriteRecipeView(),
    Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        backgroundColor: Colors.orange[400],
        elevation: 0.0,
        title: Text('Saved recipes'),
      ),
    ),
    UserProfilePage(),
  ];

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
      currentIndex: _pageIndex,
      selectedItemColor: Colors.amber[800],
      onTap: onTabTapped,
    );
  }

  void onPageChanged(int index) {
    setState(() {
      this._pageIndex = index;
    });
  }

  void onTabTapped(int index) {
    this._pageController.animateToPage(index, duration: const Duration(milliseconds: 500),curve: Curves.easeInOut);
  }
}
