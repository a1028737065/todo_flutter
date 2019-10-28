import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:todo/data_handle/item_handler.dart';
import 'package:todo/data_handle/model/item.dart';

class CreatePage extends StatefulWidget {
  CreatePage({
    Key key, 
    this.addToMainPage,
  }) : super(key: key);

  final addToMainPage;

  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  TextEditingController _controller1, _controller2;
  DateTime _time, _alertTime;
  bool _isAlert = false;
  String _text, _commet;
  Color _selectedColor = Color(0xffffffff), _nowColor;

  //TODO:需优化为只传入t
  void _showTimePicker(int i, DateTime t) async {
    DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      onConfirm: (date) {
        setState(() {
          switch (i) {
            case 1:
              _time = date;
              break;
            case 2:
              _alertTime = date;
              break;
          }
        });
      }, 
      currentTime: t, 
      locale: LocaleType.zh,
    );
  }

  void _syncTime() {
    setState(() {
      _alertTime = _time;
    });
  }

  //TODO: 完善
  void _create() {
    String _timeStr = _time.subtract(_time.timeZoneOffset).toString();
    String _alertTimeStr = _alertTime.subtract(_time.timeZoneOffset).toString();
    Item _item = Item.fromMap({
      'text': _text,
      'time': _timeStr,
      'alert_time': _alertTimeStr,
      'alert': _isAlert == true ? 1 : 0,
      'star': 0,
      'commet': _commet,
      'color': _selectedColor.toString(),
    });

    var _itemHandler = new ItemHandler();
    _itemHandler.insert(_item).then((v) {
      widget.addToMainPage(_item);
      Navigator.pop(context);
    });
  }

  @override
  void initState() {
    super.initState();
    _time = DateTime.now();
    _alertTime = _time;
  }

  Widget _label(String text, int top) {
    return Container(
      padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(10),right: ScreenUtil().setWidth(20), top: ScreenUtil().setHeight(top), left: ScreenUtil().setWidth(24)),
      child: Text(
        '$text',
        style: TextStyle(fontSize: ScreenUtil().setSp(30), color: Colors.blue[400], fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _create,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _label('内容', 20),
            Padding(
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(24)),
              child: Container(
                width: ScreenUtil().setWidth(710),
                child: new TextField(
                  controller: _controller1,
                  decoration:  InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent)
                    ),
                    contentPadding: EdgeInsets.all(ScreenUtil().setSp(18)),
                  ),
                  minLines: 5,
                  maxLines: 5,
                  onChanged: (value) {
                    this._text = value;
                  },
                  style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                ),
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _label('事件时间', 50),
                Padding(
                  padding: EdgeInsets.only(left: ScreenUtil().setWidth(24)),
                  child: Container(
                    width: ScreenUtil().setWidth(380),
                    child: OutlineButton(
                      child: Text(
                        '${_time.year}-${_time.month.toString().padLeft(2,'0')}-${_time.day.toString().padLeft(2,'0')} ${_time.hour.toString().padLeft(2,'0')}:${_time.minute.toString().padLeft(2,'0')}', 
                        style: TextStyle(fontSize: ScreenUtil().setSp(27))
                      ),
                      onPressed: () => _showTimePicker(1, _time),
                      borderSide: BorderSide(color: Colors.indigo[100], width: 2),
                    ),
                  ),
                ),
              ],
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _label('颜色', 50),
                ListTile(
                  title: Text('选择'),
                  trailing: Container(
                    width: 28,
                    child: CircleAvatar(
                      backgroundColor: _selectedColor,
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('选择标签颜色'),
                          contentPadding: EdgeInsets.fromLTRB(10, 15, 10, 0),
                          content: Container(
                            height: ScreenUtil().setHeight(750),
                            child: MaterialColorPicker(
                              circleSize: ScreenUtil().setWidth(105),
                              onColorChange: (Color color) {
                                _nowColor = color;
                              }, 
                              selectedColor: _selectedColor
                            ),
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('确定'),
                              onPressed: () {
                                _selectedColor = _nowColor;
                                setState(() {});
                                Navigator.of(context).pop();
                              },
                            ), 
                          ],
                        );
                      }
                    );
                  }
                ),
              ],
            ),

            new Padding(
              padding: EdgeInsets.only(top: ScreenUtil().setHeight(20), left: ScreenUtil().setHeight(12),),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CheckboxListTile(
                    title: Text('开启提醒'),
                    value: _isAlert,
                    activeColor: Colors.blue,
                    onChanged: (bool value) {
                      setState(() {
                        _isAlert = value;
                      });
                    },
                  ),
                  Container(
                    width: ScreenUtil().setWidth(750),
                    child:Row(
                      children: <Widget>[
                        Container(
                          width: ScreenUtil().setWidth(380),
                          child: OutlineButton(
                          child: Text(
                              '${_alertTime.year}-${_alertTime.month.toString().padLeft(2,'0')}-${_alertTime.day.toString().padLeft(2,'0')} ${_alertTime.hour.toString().padLeft(2,'0')}:${_alertTime.minute.toString().padLeft(2,'0')}', 
                              style: TextStyle(fontSize: ScreenUtil().setSp(27))
                            ),
                            onPressed: _isAlert?() => _showTimePicker(2, _alertTime):null,
                            borderSide: BorderSide(color: Colors.indigo[100], width: 2),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                          child: FlatButton.icon(
                            icon: Icon(Icons.sync),
                            label: Text(
                              '设置为事件时间', 
                              style: TextStyle(fontSize: ScreenUtil().setSp(24))
                            ),
                            onPressed: _isAlert?() => _syncTime():null,
                          ),
                        ),
                      ],
                    )
                  ),
                ],
              )
            ),

            _label('备注', 60),
            Padding(
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(24)),
              child: Container(
                width: ScreenUtil().setWidth(710),
                child: new TextField(
                  controller: _controller2,
                  decoration:  InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent)
                    ),
                    contentPadding: EdgeInsets.all(ScreenUtil().setSp(20)),
                  ),
                  maxLines: 1,
                  onChanged: (value) {
                    this._commet = value;
                  },
                  style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                  textInputAction: TextInputAction.next,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}