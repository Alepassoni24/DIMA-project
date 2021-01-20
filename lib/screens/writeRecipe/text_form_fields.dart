// Generic one line text form field
import 'package:dima_project/shared/constants.dart';
import 'package:flutter/material.dart';

class TextFormFieldShort extends StatelessWidget {
  final String hintText, initialValue;
  final Function(String) setText, validator;
  final TextInputType keyboardType;

  TextFormFieldShort(
      this.hintText, this.initialValue, this.setText, this.validator,
      {this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 2.5, right: 2.5),
      child: TextFormField(
        decoration: textInputDecoration.copyWith(
          hintText: hintText,
          contentPadding: EdgeInsets.only(left: 2.5, right: 2.5),
        ),
        keyboardType: keyboardType,
        initialValue: initialValue,
        onChanged: setText,
        validator: validator,
      ),
    );
  }
}

// Generic multi line text form field
class TextFormFieldLong extends StatelessWidget {
  final String hintText, initialValue;
  final Function(String) setText, validator;

  TextFormFieldLong(
      this.hintText, this.initialValue, this.setText, this.validator);

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
