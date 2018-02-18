import 'package:flutter/material.dart';

class WidgetHelper {
  static Container textField(String label, TextEditingController controller) {
    return new Container(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
        child: new TextField(
            controller: controller,
            decoration: new InputDecoration(
              hintText: label,
            )
        )
    );
  }

  static Widget dialogTitleWithClose(String title) {
    return new Row(
      children: <Widget>[
        new Expanded(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              new Text(title)
            ],
          ),
        ),
        new CloseButton()
      ],
    );
  }

  static AlertDialog confirmDialogWithClose(BuildContext context, String title, String message, VoidCallback callback) {
    return new AlertDialog(
      title:  new Text(title),
      content: new Text(message),
      actions: <Widget>[
        new FlatButton(
          onPressed: callback,
          child: new Row(
            children: <Widget>[
              const Text('Yes'),
            ],
          ),
        ),
        new FlatButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: const Text('No'),
        ),
      ],
    );
  }
}