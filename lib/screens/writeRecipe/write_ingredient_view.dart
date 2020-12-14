import 'package:dima_project/screens/writeRecipe/write_recipe_view.dart';
import 'package:flutter/material.dart';

class WriteIngredientView extends StatelessWidget {

  final int id;
  final Function(int, String) setQuantity, setUnit, setName;

  WriteIngredientView(this.id, this.setQuantity, this.setUnit, this.setName);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 3,
          child: TextFormFieldShort("100", (val) => setQuantity(id, val)),
          fit: FlexFit.tight,
        ),
        SizedBox(width: 10), 
        Flexible(
          flex: 2,
          child: TextFormFieldShort("g", (val) => setUnit(id, val)),
          fit: FlexFit.tight,
        ),
        SizedBox(width: 10), 
        Flexible(
          flex: 12,
          child: TextFormFieldShort("flour", (val) => setName(id, val)),
          fit: FlexFit.tight,
        ),
      ],
    );
  }
}
