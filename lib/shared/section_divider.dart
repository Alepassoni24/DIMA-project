import 'package:flutter/material.dart';

// Generic divider to separate sections inside a widget
class SectionDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
        color: Colors.orange[400], thickness: 1.5, indent: 2.5, endIndent: 2.5);
  }
}
