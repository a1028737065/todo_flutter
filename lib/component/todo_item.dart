import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo/data_handle/model/item.dart';

class TodoItem extends StatefulWidget {
  TodoItem({
    Key key, 
    this.item, 
    this.delete, 
    this.updateStar, 
  }) : super(key: key);

  final Item item;
  final delete;
  final updateStar;
  get id => item.id;

  @override
  _TodoItemState createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  int _id;
  String _text;
  DateTime _time, _alertTime;
  Color _color;
  bool _star = false, _alert = false;

  @override
  void initState() {
    super.initState();

    var _data = widget.item.toMap();
    _id = _data['id'];
    _text = _data['text'];
    _time = DateTime.parse(_data['time']);
    _alertTime = DateTime.parse(_data['alert_time']);
    _alert = _data['alert'] == 1;
    _color = Color(int.parse(_data['color'].split('(0x')[1].split(')')[0], radix: 16));
    _star = _data['star'] == 1;
    setState(() {
      
    });
  }

  String _timeText(DateTime _t) {
    DateTime _nowTime = DateTime.now();
    DateTime _time = _t.add(_nowTime.timeZoneOffset);
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

  Widget _popupMenuItem (IconData _i, String _s) {
    return Row(
      children: <Widget>[
        Icon(_i),
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text('$_s'),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    DragDownDetails _pointer;
    return GestureDetector(
      child: ListTile(
        key: UniqueKey(),
        title: Text(
          '$_text',
          style: TextStyle(fontSize: ScreenUtil().setSp(34)),
        ),
        subtitle: Row(
          children: <Widget>[
            Text('${_timeText(_time)}'),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: _alert ? Row(
                children: <Widget>[
                  Icon(Icons.timer, color: Colors.grey[600], size: ScreenUtil().setSp(34),),
                  Text('${_timeText(_alertTime)}')
                ],
              ) : null,
            )
          ],
        ),
        leading: Container(
          width: 6,
          foregroundDecoration: BoxDecoration(color: _color),
        ),
        trailing: _star ? 
          Padding(
            padding: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
            child: Icon(Icons.star),
          ) : null,
        contentPadding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(10), horizontal: 0),
        onTap: () => {},
        onLongPress: () {
          showMenu(
            context: context, 
            position: RelativeRect.fromLTRB(_pointer.globalPosition.dx, _pointer.globalPosition.dy, _pointer.globalPosition.dx + 20, _pointer.globalPosition.dy + 20),
            items: <PopupMenuEntry>[
              PopupMenuItem(
                value: 'star',
                child: _star ? _popupMenuItem(Icons.star, '取消星标') : _popupMenuItem(Icons.star_border, '设置星标')
              ),
              PopupMenuDivider(),
              PopupMenuItem(
                value: 'delete',
                child: _popupMenuItem(Icons.delete_outline, '删除')
              ),
            ], 
          ).then((a) {
            if (a == 'delete') {
              widget.delete(_id);
            } else if (a == 'star') {
              Map<String, dynamic> _m = widget.item.toMap();
              _m['star'] = _star ? 0 : 1;
              Item _i = Item.fromMap(_m);
              widget.updateStar(_i);
            }
          });
        },
      ),
      onPanDown: (DragDownDetails e) {
        _pointer = e;
      },
    );
  }
}