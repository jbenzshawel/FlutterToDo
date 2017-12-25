import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'shared/storage.dart';
import 'shared/item.dart';
import 'screens/to_do_list.dart';

main() async {
  Storage storage = new Storage();
  Uuid uuid = new Uuid();
  List<Item> toDoItems = await storage.getToDoItems();

  toDoItems.add(new Item(
    id: uuid.v1(), 
    title: 'Add multiple screens', 
    description: 'Update functionality to handle more than one to do list'
    )
  );

  storage.updateStorage(toDoItems);

  runApp(new MaterialApp(
    title: 'To Do List',
    theme: new ThemeData(brightness: Brightness.light),
    home: new ToDoList(
      items: toDoItems,
    ),
  ));
}
