import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo/data_handle/model/item.dart';
import 'package:todo/page/edit_page.dart';

class TodoItem extends StatefulWidget {
  TodoItem({
    Key key,
    this.item,
    this.delete,
    this.update,
    this.notificationsPlugin,
  }) : super(key: key);

  final Item item;
  final delete;
  final update;
  final FlutterLocalNotificationsPlugin notificationsPlugin;
  get id => item.id;

  @override
  _TodoItemState createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem>
    with SingleTickerProviderStateMixin {
  int _id;
  String _text, _commet, _alert, _timeText, _alertTimeText;
  DateTime _time, _alertTime;
  Color _color;
  bool _star = false;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  createNoti() async {
    var scheduledNotificationDateTime = _alertTime;
    if (scheduledNotificationDateTime.isAfter(DateTime.now())) {
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          '1', '提醒', '在设定的时间提醒您',
          importance: Importance.Max,
          priority: Priority.High,
          ticker: 'to do alert');
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.schedule(
          _id,
          'TODO提醒：$_text',
          '备注：${_commet == '' ? '无' : _commet}',
          scheduledNotificationDateTime,
          platformChannelSpecifics);
    } else {
      cancelNoti();
    }
  }

  cancelNoti() async {
    flutterLocalNotificationsPlugin
        .pendingNotificationRequests()
        .then((v) async {
      if (v.isNotEmpty) {
        await flutterLocalNotificationsPlugin.cancel(_id);
      }
    });
  }

  @override
  void initState() {
    super.initState();

    var _data = widget.item.toMap();
    _id = _data['id'];
    _text = _data['text'];
    _time = DateTime.parse(_data['time']).add(DateTime.now().timeZoneOffset);
    _alertTime =
        DateTime.parse(_data['alert_time']).add(DateTime.now().timeZoneOffset);
    _alert = _data['alert'];
    _color = Color(
        int.parse(_data['color'].split('(0x')[1].split(')')[0], radix: 16));
    _star = _data['star'] == 1;
    _commet = _data['commet'];

    _timeText = _createTimeText(_time);
    _alertTimeText = _createAlertTimeText(_alertTime);

    flutterLocalNotificationsPlugin = widget.notificationsPlugin;
    if(_alert != '不提醒') {
      cancelNoti();
    }
  }

  // String get _timeText => _createTimeText(_time);
  // String get _alertTimeText => _createAlertTimeText(_alertTime);

  String _createTimeText(DateTime _t) {
    DateTime _nowTime = DateTime.now();
    String _temp = "";

    if (_t.year == _nowTime.year + 1) {
      _temp += "明年";
    } else if (_t.year != _nowTime.year + 1) {
      _temp += "${_t.year}年";
    }

    _temp += "${_t.month}月";

    int _td = _t.day;
    int _ntd = _nowTime.day;
    if (_t.year == _nowTime.year) {
      if (_td == _ntd - 1) {
        _temp = "昨天";
      } else if (_td == _ntd) {
        _temp = "今天";
      } else if (_td == _ntd + 1) {
        _temp = "明天";
      } else if (_td == _ntd + 2) {
        _temp = "后天";
      } else {
        _temp += "${_t.day}日";
      }
    } else {
      _temp += "${_t.day}日";
    }

    _temp +=
        " ${_t.hour.toString().padLeft(2, "0")}:${_t.minute.toString().padLeft(2, "0")}";
    return _temp;
  }

  String _createAlertTimeText(DateTime _t) {
    var _temp = _t;
    if (_alert != '单次' && _alert != '不提醒') {
      while (_temp.compareTo(DateTime.now()) == -1) {
        print('$_temp in while');
        switch (_alert) {
          case '每日':
            _temp = _temp.add(Duration(days: 1));
            break;
          case '每周':
            _temp = _temp.add(Duration(days: 7));
            break;
          case '每月':
            _temp = DateTime.parse(
                '${_temp.year}-${(_temp.month + 1).toString().padLeft(2, "0")}-${_temp.day.toString().padLeft(2, "0")} ${_temp.hour.toString().padLeft(2, "0")}:${_temp.minute.toString().padLeft(2, "0")}:00');
            break;
          case '每年':
            _temp = DateTime.parse(
                '${_temp.year + 1}-${_temp.month.toString().padLeft(2, "0")}-${_temp.day.toString().padLeft(2, "0")} ${_temp.hour.toString().padLeft(2, "0")}:${_temp.minute.toString().padLeft(2, "0")}:00');
            break;
        }
      }
      Future.delayed(
          _temp.difference(DateTime.now()), () => _createAlertTimeText(_temp));
    }

    _alertTime = _temp;
    flutterLocalNotificationsPlugin = widget.notificationsPlugin;
    createNoti();

    return _alert == '单次'
        ? _createTimeText(_temp)
        : '${_createTimeText(_temp)}  ($_alert)';
  }

  Widget _label(String _t) {
    return Padding(
      padding: EdgeInsets.only(right: 25),
      child: Text(_t,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          )),
    );
  }

  Widget _space({int i = 45}) {
    return Padding(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(i)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: widget.key,
      actionPane: SlidableBehindActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        color: Colors.white,
        child: ListTile(
          leading: Container(
            padding: EdgeInsets.only(left: 0),
            width: 5,
            foregroundDecoration: BoxDecoration(color: _color),
          ),
          title: Text(
            _text,
            style: TextStyle(fontSize: 20),
          ),
          subtitle: Row(
            children: <Widget>[
              Text(_timeText),
              Padding(
                padding: EdgeInsets.only(left: 20),
              ),
              _alert != '不提醒'
                  ? Icon(
                      Icons.timer,
                      size: 22,
                      color: Colors.grey[700],
                    )
                  : Text(''),
              _alert != '不提醒'
                  ? Expanded(
                      child: Text(
                        _alertTimeText,
                      ),
                    )
                  : Text('')
            ],
          ),
          trailing: _star
              ? Icon(Icons.star, size: 24)
              : Opacity(
                  opacity: 0,
                  child: Icon(Icons.star, size: 24),
                ),
        ),
      ),
      actions: <Widget>[
        IconSlideAction(
          caption: 'Detail',
          color: Colors.blue,
          icon: Icons.note,
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Row(
                      children: <Widget>[
                        Text('详细'),
                        Container(
                          margin: EdgeInsets.only(left: 20),
                          width: 22,
                          child: CircleAvatar(
                            backgroundColor: _color,
                          ),
                        ),
                      ],
                    ),
                    content: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _label('内容'),
                          _space(i: 15),
                          Text(
                            '$_text ',
                            softWrap: true,
                          ),
                          _space(),
                          Row(
                            children: <Widget>[
                              _label('时间'),
                              Text(
                                '${_time.year}-${_time.month.toString().padLeft(2, '0')}-${_time.day.toString().padLeft(2, '0')} ${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}',
                              )
                            ],
                          ),
                          _space(),
                          Row(
                            children: <Widget>[
                              _label('提醒'),
                              _alert != '不提醒'
                                  ? Text(
                                      '${_alertTime.year}-${_alertTime.month.toString().padLeft(2, '0')}-${_alertTime.day.toString().padLeft(2, '0')} ${_alertTime.hour.toString().padLeft(2, '0')}:${_alertTime.minute.toString().padLeft(2, '0')}')
                                  : Text('无',
                                      style: TextStyle(color: Colors.grey))
                            ],
                          ),
                          _space(),
                          _label('备注'),
                          _space(i: 15),
                          _commet != ''
                              ? Text('$_commet')
                              : Text('没有备注',
                                  style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('修改'),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new EditPage(
                                      item: widget.item,
                                      update: widget.update,
                                    )),
                          );
                        },
                      )
                    ],
                  );
                });
          },
        ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: _star ? 'Cancel Star' : 'Star',
          color: Colors.yellow,
          icon: _star ? Icons.star_border : Icons.star,
          onTap: () {
            Map<String, dynamic> _m = widget.item.toMap();
            _m['star'] = _star ? 0 : 1;
            Item _i = Item.fromMap(_m);
            widget.update(_i);
          },
        ),
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          closeOnTap: false,
          onTap: () {
            widget.delete(_id);
          },
        ),
      ],
    );
  }
}
