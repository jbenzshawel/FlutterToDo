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
}