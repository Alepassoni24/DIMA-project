import 'package:dima_project/model/recipe_obj.dart';
import 'package:dima_project/services/database.dart';
import 'package:dima_project/shared/circle_number.dart';
import 'package:dima_project/shared/constants.dart';
import 'package:dima_project/shared/loading.dart';
import 'package:dima_project/shared/section_divider.dart';
import 'package:flutter/material.dart';

class StepsView extends StatelessWidget {
  final DatabaseService databaseService;
  final String recipeId;

  StepsView(this.databaseService, this.recipeId);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: databaseService.getRecipeSteps(recipeId),
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return Text('Something went wrong');
        if (snapshot.connectionState == ConnectionState.waiting)
          return Loading();
        
        return new Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Procedure:", style: subtitleStyle)
            ),
            SizedBox(height: 10),
            ...snapshot.data.documents.map<Widget>((document) =>
              StepView(databaseService.stepsDataFromSnapshot(document))).toList()
          ]
        );
      }
    );
  }
}

class StepView extends StatelessWidget {
  final StepData stepData;

  StepView(this.stepData);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CircleNumber(stepData.id),
            SizedBox(width: 5),
            Text(stepData.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
          ]
        ),
        SizedBox(height: 5),
        StepImage(stepData.imageURL),
        SizedBox(height: 5),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(stepData.description, style: TextStyle(fontSize: 18)),
        ),
        SectionDivider(),
        SizedBox(height: 1),
      ]
    );
  }
}

class StepImage extends StatelessWidget {
  final String imageURL;

  StepImage(this.imageURL);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        image: new DecorationImage(
          fit: BoxFit.cover,
          alignment: Alignment.center,
          image: new NetworkImage(imageURL),
        )
      ),
    );
  }
}
