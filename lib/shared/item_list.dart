import 'item.dart';

class ItemList {
  String id;
  String title;
  List<Item> items;

  ItemList({this.id, this.title, this.items});

  Map toJson() { 
    Map map = new Map();
    map["id"] = id;
    map["title"] = title;
    map["items"] = items;
    return map;
  }
}