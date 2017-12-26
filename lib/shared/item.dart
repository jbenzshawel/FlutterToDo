class Item {
  String id;
  String title;
  String description;

  Item({this.id, this.title, this.description});  

  Map toJson() { 
    Map map = new Map();
    map["id"] = id;
    map["title"] = title;
    map["description"] = description;
    return map;
  }  
}
