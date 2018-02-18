import 'package:flutter/material.dart';
import 'shared/storage.dart';
import 'shared/to_do_list.dart';
import 'screens/to_do_list_widget.dart';
import 'screens/to_do_home_widget.dart';

class ToDoApp extends StatefulWidget {
  final Storage storage;

  ToDoApp({Key key, storage}) 
    : storage = storage,
      super(key : key);

  @override
  ToDoAppState createState() => new ToDoAppState();
}

class ToDoAppState extends State<ToDoApp> {

  Route<Null> _getToDoRoute(RouteSettings settings) {
    final List<String> path = settings.name.split('/');
    
    if (path[1].startsWith('list:')) {
      final String listId = path[1].substring(5);

      ToDoList toDoList = widget.storage.toDoListCache[listId];

      return new MaterialPageRoute<Null>(
        settings: settings,
        builder: (BuildContext context) => new ToDoListWidget(
          listId: listId,
          title: toDoList.title,
          items: toDoList.items,
          storage: widget.storage,
        )
      );
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    List<ToDoList> toDoItems = widget.storage.toDoListCache.values.toList();

    return new MaterialApp(
      title: 'To Do List',
      theme: new ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.purple.shade400
      ),
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => new ToDoHomeWidget(toDoItems: toDoItems, storage: widget.storage),
      },
      onGenerateRoute: _getToDoRoute,
    );
  }
}

main() async {
  Storage storage = new Storage();
  await storage.getToDoLists();

  runApp(new ToDoApp(storage: storage));
}
