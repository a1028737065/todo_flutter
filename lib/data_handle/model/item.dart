class Item {
  int id;
  String text;
  String time;
  String alertTime;
  bool alert; //Map中该项为true ? 1 : 0
  String commet;
  String category;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'text': text,
      'time': time,
      'alert_time': alertTime,
      'alert': alert == true ? 1 : 0,
      'commet': commet,
      'category': category,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  Item();

  Item.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    text = map['text'];
    time = map['time'];
    alertTime = map['alert_time'];
    alert = map['alert'] == 1;
    commet = map['commet'];
    category = map['category'];
  }

  Item.fromSql(Map<String, dynamic> map) {
    id = map['id'];
    text = map['text'];
    time = map['time'];
    alertTime = map['alert_time'];
    alert = map['alert'] == '1'; //从数据库中读取的Integer会变为String
    commet = map['commet'];
    category = map['category'];
  }
}