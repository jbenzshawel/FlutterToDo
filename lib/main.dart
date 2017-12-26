import 'package:flutter/material.dart';
import 'shared/storage.dart';
import 'screens/to_do_list.dart';

main() async {
  Storage storage = new Storage();

  runApp(new MaterialApp(
    title: 'To Do List',
    theme: new ThemeData(brightness: Brightness.light),
    home: new ToDoList(
      items: await storage.getToDoItems(),
    ),
  ));
}
