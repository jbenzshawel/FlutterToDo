class Item {
  String id;
  String title;
  String description;
  bool complete = false;

  Item({this.id, this.title, this.description, this.complete});  

  Map toJson() { 
    Map map = new Map();
    map["id"] = id;
    map["title"] = title;
    map["description"] = description;
    map["complete"] = complete;
    return map;
  }  
}
