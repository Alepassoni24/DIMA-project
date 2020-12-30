import 'package:dima_project/model/recipe_obj.dart';
import 'package:dima_project/screens/homeRecipes/recipe_card.dart';
import 'package:dima_project/services/database.dart';
import 'package:flutter/material.dart';
import 'package:dima_project/shared/constants.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<RecipeData> recipesList = List();
  final DatabaseService databaseService = new DatabaseService();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.atEdge &&
          scrollController.position.pixels != 0) {
        //TODO fetchNextDocuments();
      }
    });
  }

  RangeValues _currentRangeValues = const RangeValues(0, 240);
  final List<String> course = [
    'Any',
    'First course',
    'Second course',
    'Single course',
    'Side dish',
    'Dessert'
  ];
  final List<String> ordering = ['submissionTime', 'rating'];
  bool _isVegan = false;
  bool _isVegetarian = false;
  bool _isGlutenFree = false;
  bool _isLactoseFree = false;
  String _category = 'Any';
  String _orderBy = 'submissionTime';
  int _difficulty = 2;

  void _showFilterPanel() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Select maximum difficulty:'),
                    Row(
                      children: [
                        // Three chef hats to simbolize the difficulty
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: RawMaterialButton(
                            onPressed: () {
                              setState(() => _difficulty = 0);
                              setModalState(() {
                                _difficulty = 0;
                              });
                            },
                            shape: CircleBorder(),
                            child: Image(
                              image: AssetImage("assets/chef_hat.png"),
                              height: 40,
                              color: difficultyColors[_difficulty],
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: RawMaterialButton(
                            onPressed: () {
                              setState(() => _difficulty = 1);
                              setModalState(() {
                                _difficulty = 1;
                              });
                            },
                            shape: CircleBorder(),
                            child: Image(
                              image: AssetImage("assets/chef_hat.png"),
                              height: 40,
                              color: _difficulty >= 1
                                  ? difficultyColors[_difficulty]
                                  : difficultyBaseColor,
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: RawMaterialButton(
                            onPressed: () {
                              setState(() => _difficulty = 2);
                              setModalState(() {
                                _difficulty = 2;
                              });
                            },
                            shape: CircleBorder(),
                            child: Image(
                              image: AssetImage("assets/chef_hat.png"),
                              height: 40,
                              color: _difficulty >= 2
                                  ? difficultyColors[_difficulty]
                                  : difficultyBaseColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Select course:'),
                    DropdownButtonFormField(
                      value: _category,
                      items: course.map((course) {
                        return DropdownMenuItem(
                          value: course,
                          child: Text('$course'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _category = value);
                        setModalState(() {
                          _category = value;
                        });
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Preparing time range (minutes):'),
                    RangeSlider(
                      values: _currentRangeValues,
                      min: 0,
                      max: 240,
                      divisions: 240,
                      activeColor: Colors.orange[400],
                      inactiveColor: Colors.orange[100],
                      labels: RangeLabels(
                        _currentRangeValues.start.round().toString(),
                        _currentRangeValues.end.round().toString(),
                      ),
                      onChanged: (RangeValues values) {
                        setState(() {
                          _currentRangeValues = values;
                        });
                        setModalState(() {
                          _currentRangeValues = values;
                        });
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                            value: _isVegan,
                            activeColor: Colors.orange[400],
                            onChanged: (value) {
                              setState(() => _isVegan = value);
                              setModalState(() {
                                _isVegan = value;
                              });
                            }),
                        Text('Vegan'),
                        Checkbox(
                            value: _isVegetarian,
                            activeColor: Colors.orange[400],
                            onChanged: (value) {
                              setState(() => _isVegetarian = value);
                              setModalState(() {
                                _isVegetarian = value;
                              });
                            }),
                        Text('Vegetarian'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                            value: _isGlutenFree,
                            activeColor: Colors.orange[400],
                            onChanged: (value) {
                              setState(() => _isGlutenFree = value);
                              setModalState(() {
                                _isGlutenFree = value;
                              });
                            }),
                        Text('Gluten free'),
                        Checkbox(
                            value: _isLactoseFree,
                            activeColor: Colors.orange[400],
                            onChanged: (value) {
                              setState(() => _isLactoseFree = value);
                              setModalState(() {
                                _isLactoseFree = value;
                              });
                            }),
                        Text('Lactose free'),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Ordered by:'),
                    DropdownButtonFormField(
                      value: _orderBy,
                      items: ordering.map((ordering) {
                        return DropdownMenuItem(
                          value: ordering,
                          child: Text('$ordering'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _orderBy = value);
                        setModalState(() {
                          _orderBy = value;
                        });
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FlatButton(
                      color: Colors.orange[400],
                      onPressed: () {
                        Navigator.of(context).pop();
                        /*fetchFirstDocuments(
                            _orderBy,
                            _difficulty,
                            _currentRangeValues,
                            _category,
                            _isVegan,
                            _isVegetarian,
                            _isGlutenFree,
                            _isLactoseFree);*/
                      }, //TODO function to query
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.filter_alt,
                            color: Colors.grey[800],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              'Filter',
                              style: TextStyle(color: Colors.grey[800]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        backgroundColor: Colors.orange[400],
        elevation: 0.0,
        title: Text('Search for recipes'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt),
            onPressed: () => _showFilterPanel(),
          )
        ],
      ),
      body: recipesList.isEmpty
          ? Center(
              child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Press'),
                Icon(
                  Icons.filter_alt,
                  color: Colors.grey[700],
                ),
                Text('to filter recipes'),
              ],
            ))
          : ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              controller: scrollController,
              padding: const EdgeInsets.all(5),
              itemCount: recipesList.length,
              itemBuilder: (context, index) {
                return RecipeCard(recipesList[index]);
              },
            ),
    );
  }

  // Fetch first 10 documents
  Future<void> fetchFirstDocuments(
      String order,
      int maxDifficulty,
      RangeValues timing,
      String course,
      bool isVegan,
      bool isVegetarian,
      bool isGlutenFree,
      bool isLactoseFree) async {
    databaseService
        .getFilteredRecipe(order, maxDifficulty, timing, course, isVegan,
            isVegetarian, isGlutenFree, isLactoseFree)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        setState(() {
          recipesList.add(databaseService.recipeDataFromSnapshot(element));
        });
      });
    });
  }
}
