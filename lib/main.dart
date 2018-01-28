import 'package:flutter/material.dart';
import 'shared/storage.dart';
import 'screens/to_do_list.dart';
import 'shared/item_list.dart';

main() async {
  Storage storage = new Storage();
  ItemList itemList = await storage.getToDoItemList("b23766f8-d4f5-4506-9262-1d408132f048");

  runApp(new MaterialApp(
    title: 'To Do List',
    theme: new ThemeData(brightness: Brightness.light),
    home: new ToDoList(
      listId: itemList.id,
      title: itemList.title,
      items: itemList.items,
    ),
  ));
}
