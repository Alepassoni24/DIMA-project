import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  RangeValues _currentRangeValues = const RangeValues(0, 240);
  bool isVegan = false;
  bool isVegetarian = false;

  void _showFilterPanel() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RangeSlider(
                  values: _currentRangeValues,
                  min: 0,
                  max: 240,
                  divisions: 5,
                  labels: RangeLabels(
                    _currentRangeValues.start.round().toString(),
                    _currentRangeValues.end.round().toString(),
                  ),
                  onChanged: (RangeValues values) {
                    setState(() {
                      _currentRangeValues = values;
                    });
                  },
                ),
                Row(
                  children: [
                    Checkbox(
                        value: isVegan,
                        onChanged: (bool value) {
                          setState(() {
                            isVegan = value;
                          });
                        }),
                    Checkbox(
                        value: isVegetarian,
                        onChanged: (bool value) {
                          setState(() {
                            isVegetarian = value;
                          });
                        }),
                  ],
                ),
                FlatButton(
                  onPressed: () =>
                      Navigator.of(context).pop(), //TODO function to query
                  child: Row(
                    children: [
                      Icon(Icons.filter_alt),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          'Filter',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
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
