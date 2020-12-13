import 'package:dima_project/shared/add_image_button.dart';
import 'package:flutter/material.dart';

class WriteRecipeView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        backgroundColor: Colors.orange[400],
        elevation: 0,
        title: Text('Write a recipe'),
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
          children: [
            MainPhoto(),
            Divider(color: Colors.orange[900], thickness: 1.5, indent: 2.5, endIndent: 2.5),
            // TODO: Description
            Divider(color: Colors.orange[900], thickness: 1.5, indent: 2.5, endIndent: 2.5),
            // TODO: Time
            Divider(color: Colors.orange[900], thickness: 1.5, indent: 2.5, endIndent: 2.5),
            // TODO: Ingredients
            Divider(color: Colors.orange[900], thickness: 1.5, indent: 2.5, endIndent: 2.5),
            // TODO: Steps
          ]
        )
      )
    );
  }
}

class MainPhoto extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
      return AddImageButton(height: 300, elevation: 5, borderRadius: 5);
  }
}
