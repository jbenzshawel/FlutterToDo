class Item {
  const Item({this.id, this.title, this.description});
  final String id;
  final String title;
  final String description;

  Map toJson() { 
    Map map = new Map();
    map["id"] = id;
    map["title"] = title;
    map["description"] = description;
    return map;
  }  
}