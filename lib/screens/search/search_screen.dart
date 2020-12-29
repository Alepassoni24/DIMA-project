import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  RangeValues _currentRangeValues = const RangeValues(0, 240);
  final List<String> course = [
    'Any',
    'First course',
    'Second course',
    'Single course',
    'Side dish',
    'Dessert'
  ];
  bool _isVegan = false;
  bool _isVegetarian = false;
  bool _isGlutenFree = false;
  bool _isLactoseFree = false;
  String _category;

  void _showFilterPanel() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Select course:'),
                  DropdownButtonFormField(
                    value: _category ?? 'Any',
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
                  Text('Preparing time (min):'),
                  RangeSlider(
                    values: _currentRangeValues,
                    min: 0,
                    max: 240,
                    divisions: 240,
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
                          onChanged: (value) {
                            setState(() => _isVegan = value);
                            setModalState(() {
                              _isVegan = value;
                            });
                          }),
                      Text('Vegan'),
                      Checkbox(
                          value: _isVegetarian,
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
                          onChanged: (value) {
                            setState(() => _isGlutenFree = value);
                            setModalState(() {
                              _isGlutenFree = value;
                            });
                          }),
                      Text('Gluten free'),
                      Checkbox(
                          value: _isLactoseFree,
                          onChanged: (value) {
                            setState(() => _isLactoseFree = value);
                            setModalState(() {
                              _isLactoseFree = value;
                            });
                          }),
                      Text('Lactose free'),
                    ],
                  ),
                  FlatButton(
                    color: Colors.orange[400],
                    onPressed: () =>
                        Navigator.of(context).pop(), //TODO function to query
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
    );
  }
}
