import 'package:dima_project/model/recipe_obj.dart';
import 'package:dima_project/screens/homeRecipes/recipe_card.dart';
import 'package:dima_project/services/database.dart';
import 'package:dima_project/shared/app_icons.dart';
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
    //adding a scroll controller in order to implement incremental sscrolling and query of recipes
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        fetchNextDocuments(
            _orderBy,
            _currentRangeValues,
            _category,
            _isVegan,
            _isVegetarian,
            _isGlutenFree,
            _isLactoseFree,
            recipesList.last.submissionTime,
            recipesList.last.rating);
      }
    });
  }

  //variable to represent maximum of the range time for a recipe
  double _currentRangeValues = 240;

  //list of courses available
  final List<String> course = [
    "Any",
    "First course",
    "Second course",
    "Single course",
    "Side dish",
    "Dessert"
  ];

  //list of possible ordering parameters
  final List<String> ordering = ["submissionTime", "rating"];

  //boolean value of dish categories
  bool _isVegan = false;
  bool _isVegetarian = false;
  bool _isGlutenFree = false;
  bool _isLactoseFree = false;

  //initial vale of filter variable
  String _category = "Any";
  String _orderBy = "submissionTime";
  int _difficulty = 2;

  //bottom panel in order to provide all the filter parameters selection
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
                          child: IconButton(
                            onPressed: () {
                              setState(() => _difficulty = 0);
                              setModalState(() {
                                _difficulty = 0;
                              });
                            },
                            iconSize: 30,
                            splashRadius: 35,
                            icon: Icon(
                              AppIcons.chef_hat,
                              color: difficultyColors[_difficulty],
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: IconButton(
                            onPressed: () {
                              setState(() => _difficulty = 1);
                              setModalState(() {
                                _difficulty = 1;
                              });
                            },
                            iconSize: 30,
                            splashRadius: 35,
                            icon: Icon(
                              AppIcons.chef_hat,
                              color: _difficulty >= 1
                                  ? difficultyColors[_difficulty]
                                  : difficultyBaseColor,
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: IconButton(
                            onPressed: () {
                              setState(() => _difficulty = 0);
                              setModalState(() {
                                _difficulty = 2;
                              });
                            },
                            iconSize: 30,
                            splashRadius: 35,
                            icon: Icon(
                              AppIcons.chef_hat,
                              color: _difficulty >= 2
                                  ? difficultyColors[_difficulty]
                                  : difficultyBaseColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    //selection of the course category
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
                    //slider of the maximum preparing time
                    Text('Preparing time range (minutes):'),
                    Slider(
                      value: _currentRangeValues,
                      min: 0,
                      max: 240,
                      divisions: 240,
                      activeColor: mainAppColor,
                      inactiveColor: Colors.orange[100],
                      label: _currentRangeValues.toString(),
                      onChanged: (value) {
                        setState(() {
                          _currentRangeValues = value;
                        });
                        setModalState(() {
                          _currentRangeValues = value;
                        });
                      },
                    ),
                    //check boxes for type of dishes
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                            value: _isVegan,
                            activeColor: mainAppColor,
                            onChanged: (value) {
                              setState(() => _isVegan = value);
                              setModalState(() {
                                _isVegan = value;
                              });
                            }),
                        Text('Vegan'),
                        Checkbox(
                            value: _isVegetarian,
                            activeColor: mainAppColor,
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
                            activeColor: mainAppColor,
                            onChanged: (value) {
                              setState(() => _isGlutenFree = value);
                              setModalState(() {
                                _isGlutenFree = value;
                              });
                            }),
                        Text('Gluten free'),
                        Checkbox(
                            value: _isLactoseFree,
                            activeColor: mainAppColor,
                            onChanged: (value) {
                              setState(() => _isLactoseFree = value);
                              setModalState(() {
                                _isLactoseFree = value;
                              });
                            }),
                        Text('Lactose free'),
                      ],
                    ),
                    SizedBox(height: 10),
                    //menu for ordering parameter
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
                    SizedBox(height: 10),
                    FlatButton(
                      color: mainAppColor,
                      shape: roundedBorder,
                      onPressed: () {
                        Navigator.of(context).pop();
                        fetchFirstDocuments(
                            _orderBy,
                            _currentRangeValues,
                            _category,
                            _isVegan,
                            _isVegetarian,
                            _isGlutenFree,
                            _isLactoseFree);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.filter_alt,
                            color: Colors.white,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              'Filter',
                              style: textButtonStyle,
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
      //the widget show a default message if no recipes are filtered
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

  // Fetch first 10 documents basing on filter parameter
  Future<void> fetchFirstDocuments(
      String order,
      double timing,
      String course,
      bool isVegan,
      bool isVegetarian,
      bool isGlutenFree,
      bool isLactoseFree) async {
    setState(() {
      recipesList.clear();
    });
    databaseService
        .getFilteredRecipe(
            order, course, isVegan, isVegetarian, isGlutenFree, isLactoseFree)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        RecipeData recipe = databaseService.recipeDataFromSnapshot(element);
        if (recipe.difficulty <= _difficulty && recipe.time <= timing) {
          setState(() {
            recipesList.add(recipe);
          });
        }
      });
    });
  }

//fetch 10 document when reached the end of the list
  Future<void> fetchNextDocuments(
      String order,
      double timing,
      String course,
      bool isVegan,
      bool isVegetarian,
      bool isGlutenFree,
      bool isLactoseFree,
      DateTime submissionTime,
      double rating) async {
    databaseService
        .getNextFilteredRecipes(order, course, isVegan, isVegetarian,
            isGlutenFree, isLactoseFree, submissionTime, rating)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        RecipeData recipe = databaseService.recipeDataFromSnapshot(element);
        if (recipe.difficulty <= _difficulty && recipe.time <= timing) {
          setState(() {
            recipesList.add(recipe);
          });
        }
      });
    });
  }
}
