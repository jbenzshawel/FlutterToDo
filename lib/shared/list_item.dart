class ListItem {
  String id;
  String title;
  String description;
  bool complete = false;

  ListItem({this.id, this.title, this.description, this.complete});  

  ListItem.fromJson(Map json)
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
