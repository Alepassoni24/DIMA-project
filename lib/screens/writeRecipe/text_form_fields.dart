// Generic one line text form field
import 'package:dima_project/shared/constants.dart';
import 'package:flutter/material.dart';

class TextFormFieldShort extends StatefulWidget {
  final String hintText, initialValue;
  final Function(String) setText, validator;

  TextFormFieldShort(this.hintText, this.initialValue, this.setText, this.validator);

  @override
  TextFormFieldShortState createState() => new TextFormFieldShortState(this.hintText, this.initialValue, this.setText, this.validator);
}

class TextFormFieldShortState extends State<TextFormFieldShort> {
  final String hintText, initialValue;
  final Function(String) setText, validator;

  TextFormFieldShortState(this.hintText, this.initialValue, this.setText, this.validator);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 2.5, right: 2.5),
      child: TextFormField(
        decoration: textInputDecoration.copyWith(
          hintText: hintText,
          contentPadding: EdgeInsets.only(left: 2.5, right: 2.5),
        ),
        initialValue: initialValue,
        onChanged: setText,
        validator: validator,
      ),
    );
  }
}

// Generic multi line text form field
class TextFormFieldLong extends StatefulWidget {
  final String hintText, initialValue;
  final Function(String) setText, validator;

  TextFormFieldLong(this.hintText, this.initialValue, this.setText, this.validator);

  @override
  TextFormFieldLongState createState() => new TextFormFieldLongState(this.hintText, this.initialValue, this.setText, this.validator);
}

class TextFormFieldLongState extends State<TextFormFieldLong> {
  final String hintText, initialValue;
  final Function(String) setText, validator;

  TextFormFieldLongState(this.hintText, this.initialValue, this.setText, this.validator);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 2.5, right: 2.5),
      child: TextFormField(
        decoration: textInputDecoration.copyWith(
          hintText: hintText,
          contentPadding: EdgeInsets.only(left: 2.5, right: 2.5),
        ),
        keyboardType: TextInputType.multiline,
        maxLines: null,
        initialValue: initialValue,
        onChanged: setText,
        validator: validator,
      ),
    );
  }
}
