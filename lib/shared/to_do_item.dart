import 'list_item.dart';

class ToDoItem {
  String id;
  String title;
  List<ListItem> items;

  ToDoItem({this.id, this.title, this.items});

  Map toJson() { 
    Map map = new Map();
    map["id"] = id;
    map["title"] = title;
    map["items"] = items;
    return map;
  }
}