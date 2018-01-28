class Item {
  String id;
  String title;
  String description;
  bool complete = false;

  Item({this.id, this.title, this.description, this.complete});  

  Item.fromJson(Map json)
    : id = json["id"], title = json["title"], description = json ["description"], complete = json["complete"];
    
  Map toJson() { 
    Map map = new Map();
    map["id"] = id;
    map["title"] = title;
    map["description"] = description;
    map["complete"] = complete;
    return map;
  }
}
