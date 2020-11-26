import 'package:flutter/material.dart';

class WarningAlert extends StatefulWidget {
  String warning;

  @override
  _WarningAlertState createState() => _WarningAlertState(warning: warning);

  WarningAlert({this.warning});
}

class _WarningAlertState extends State<StatefulWidget> {
  String warning;
  _WarningAlertState({this.warning});
  @override
  Widget build(BuildContext context) {
    if (warning != null) {
      return Container(
        color: Colors.amber,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.error_outline),
            ),
            Expanded(child: Text(warning)),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  setState(() => warning = null);
                },
              ),
            ),
          ],
        ),
      );
    }
    return SizedBox(
      height: 0,
    );
  }
}
