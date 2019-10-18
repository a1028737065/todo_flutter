import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TodoItem extends StatefulWidget {
  TodoItem({
    Key key, 
    this.alertTime,
  }) : super(key: key);

  final int alertTime;//UTC+00 Timestamp

  @override
  _TodoItemState createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  String _alertText;

  @override
  void initState() {
    super.initState();
  }

  String _timeText() {
    DateTime _nowTime = DateTime.now();
    DateTime _time = DateTime.fromMillisecondsSinceEpoch(widget.alertTime).add(_nowTime.timeZoneOffset);
    String _temp = "";

    if (_time.year == _nowTime.year + 1) {
      _temp += "明年";
    } else if (_time.year != _nowTime.year + 1) {
      _temp += "${_time.year}年";
    }

    _temp += "${_time.month}月";

    int _td = _time.day;
    int _ntd = _nowTime.day;
    if (_time.year == _nowTime.year) {
      if (_td == _ntd - 1) {
        _temp = "昨天";
      } else if (_td == _ntd) {
        _temp = "今天";
      } else if (_td == _ntd + 1) {
        _temp = "明天";
      } else if (_td == _ntd + 2) {
        _temp = "后天";
      } else {
        _temp += "${_time.day}日";
      }
    } else {
      _temp += "${_time.day}日";
    }

    _temp += " ${_time.hour.toString().padLeft(2,"0")}:${_time.minute.toString().padLeft(2,"0")}";
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
            'alertText  $_alertText',
            style: TextStyle(fontSize: ScreenUtil.getInstance().setSp(28)),
          ),
        ],
      ),  
    );
  }
}