class Item {
  int id;
  String text;
  String time;
  String alertTime;
  bool alert; //Map中该项为true ? 1 : 0
  bool star;
  String commet;
  String color;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'text': text,
      'time': time,
      'alert_time': alertTime,
      'alert': alert == true ? 1 : 0,
      'star': star == true ? 1 : 0,
      'commet': commet,
      'color': color,
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
    star = map['star'] == 1;
    commet = map['commet'];
    color = map['color'];
  }
}