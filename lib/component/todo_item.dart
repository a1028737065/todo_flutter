import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo/data_handle/model/item.dart';

class TodoItem extends StatefulWidget {
  TodoItem({
    Key key, 
    this.item,
  }) : super(key: key);

  final Item item;//UTC+00 Timestamp

  @override
  _TodoItemState createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  int _id;
  String _text;
  DateTime _time;
  DateTime _alertTime;
  bool _isAlert;
  String _commet;
  String _category;

  @override
  void initState() {
    super.initState();

    var _m = widget.item.toMap();
    _id = _m['id'];
    _text = _m['text'];
    _time = DateTime.parse(_m['time']);
    _alertTime = DateTime.parse(_m['alert_time']);
    _isAlert = _m['alert'] == 1 ? true : false;
    _commet = _m['commet'];
    _category = _m['category'];
  }

  String _timeText() {
    DateTime _nowTime = DateTime.now();
    DateTime _time1 = _time.add(_nowTime.timeZoneOffset);
    String _temp = "";

    if (_time1.year == _nowTime.year + 1) {
      _temp += "明年";
    } else if (_time1.year != _nowTime.year + 1) {
      _temp += "${_time1.year}年";
    }

    _temp += "${_time1.month}月";

    int _td = _time1.day;
    int _ntd = _nowTime.day;
    if (_time1.year == _nowTime.year) {
      if (_td == _ntd - 1) {
        _temp = "昨天";
      } else if (_td == _ntd) {
        _temp = "今天";
      } else if (_td == _ntd + 1) {
        _temp = "明天";
      } else if (_td == _ntd + 2) {
        _temp = "后天";
      } else {
        _temp += "${_time1.day}日";
      }
    } else {
      _temp += "${_time1.day}日";
    }

    _temp += " ${_time1.hour.toString().padLeft(2,"0")}:${_time1.minute.toString().padLeft(2,"0")}";
    return _temp;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5.0),
      padding: const EdgeInsets.only(top: 12, bottom: 12, left: 20),
      color: Colors.blue[100],
      width: ScreenUtil.getInstance().setWidth(375),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '${_timeText()}',
            style: TextStyle(fontSize: ScreenUtil.getInstance().setSp(36)),
          ),
          Text(
            'alertText  $_text',
            style: TextStyle(fontSize: ScreenUtil.getInstance().setSp(28)),
          ),
        ],
      ),  
    );
  }
}