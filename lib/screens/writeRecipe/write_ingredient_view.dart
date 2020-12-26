import 'package:dima_project/model/recipe_obj.dart';
import 'package:dima_project/screens/writeRecipe/text_form_fields.dart';
import 'package:dima_project/shared/form_validators.dart';
import 'package:dima_project/shared/utils.dart';
import 'package:flutter/material.dart';

class WriteIngredientView extends StatelessWidget {

  final IngredientData ingredientData;
  final Function(int, String) setQuantity, setUnit, setName;

  WriteIngredientView(this.ingredientData, this.setQuantity, this.setUnit, this.setName);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Form for quantity
        Flexible(
          flex: 3,
          child: TextFormFieldShort("100", Utils.truncateDouble(ingredientData.quantity), (val) => setQuantity(ingredientData.id, val), NumberFieldValidator.validate),
          fit: FlexFit.tight,
        ),
        SizedBox(width: 10),
        // Form for unit
        Flexible(
          flex: 2,
          child: TextFormFieldShort("g", ingredientData.unit, (val) => setUnit(ingredientData.id, val), UnitFieldValidator.validate),
          fit: FlexFit.tight,
        ),
        SizedBox(width: 10),
        // Form for ingredient
        Flexible(
          flex: 12,
          child: TextFormFieldShort("flour", ingredientData.name, (val) => setName(ingredientData.id, val), IngredientFieldValidator.validate),
          fit: FlexFit.tight,
        ),
      ],
    );
  }
}
