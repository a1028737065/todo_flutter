import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:todo/data_handle/item_handler.dart';
import 'package:todo/data_handle/model/item.dart';

class EditPage extends StatefulWidget {
  EditPage({Key key, this.item, this.update}) : super(key: key);

  final Item item;
  final update;

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  int _id, _star;
  TextEditingController _controller1, _controller2;
  DateTime _time, _alertTime;
  bool _isAlert = false;
  String _text, _commet;
  Color _selectedColor, _nowColor;

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

  void _save() {
    DateTime _nowTime = DateTime.now();
    String _timeStr = _time.subtract(_nowTime.timeZoneOffset).toString();
    String _alertTimeStr =
        _alertTime.subtract(_nowTime.timeZoneOffset).toString();
    Map<String, dynamic> _m = {
      'id': _id,
      'text': _text == null ? widget.item.toMap()['text'] : _text,
      'time': _timeStr,
      'alert_time': _alertTimeStr,
      'alert': _isAlert == true ? 1 : 0,
      'star': _star,
      'commet': _commet == null ? widget.item.toMap()['commet'] : _commet,
      'color': _selectedColor.toString(),
    };
    Item _item = Item.fromMap(_m);

    var _itemHandler = new ItemHandler();
    _itemHandler.update(_item).then((v) {
      widget.update(_item);
      Navigator.pop(context);
    });
  }

  @override
  void initState() {
    super.initState();

    Map<String, dynamic> _data = widget.item.toMap();
    _controller1 =
        TextEditingController.fromValue(TextEditingValue(text: _data['text']));
    _controller2 = TextEditingController.fromValue(
        TextEditingValue(text: _data['commet'] == null ? '' : _data['commet']));
    _time = DateTime.parse(_data['time']).add(DateTime.now().timeZoneOffset);
    _alertTime =
        DateTime.parse(_data['alert_time']).add(DateTime.now().timeZoneOffset);
    _isAlert = _data['alert'] == 1;
    _commet = _data['commet'];
    _selectedColor = Color(
        int.parse(_data['color'].split('(0x')[1].split(')')[0], radix: 16));
    _nowColor = _selectedColor;
    _id = _data['id'];
    _star = _data['star'];

    setState(() {});
  }

  Widget _label(String text, int top) {
    return Container(
      padding: EdgeInsets.only(
          bottom: ScreenUtil().setHeight(10),
          right: ScreenUtil().setWidth(20),
          top: ScreenUtil().setHeight(top),
          left: ScreenUtil().setWidth(24)),
      child: Text(
        '$text',
        style: TextStyle(
            fontSize: ScreenUtil().setSp(30),
            color: Colors.blue[400],
            fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
            tooltip: '返回',
          ),
          title: Text('编辑'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.save),
              onPressed: _text != '' ? _save : null,
              tooltip: _text != '' ? '保存' : '内容不能为空哦',
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
                    decoration: InputDecoration(
                      errorText: _text == '' ? '内容不能为空哦' : null,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent)),
                      contentPadding: EdgeInsets.all(ScreenUtil().setSp(18)),
                    ),
                    autofocus: true,
                    textInputAction: TextInputAction.done,
                    maxLines: 1,
                    maxLength: 32,
                    onChanged: (value) {
                      if (_text == '' && value != '') {
                        setState(() {
                          this._text = value;
                        });
                      } else if (_text != '' && value == '') {
                        setState(() {
                          this._text = value;
                        });
                      } else {
                        this._text = value;
                      }
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
                            '${_time.year}-${_time.month.toString().padLeft(2, '0')}-${_time.day.toString().padLeft(2, '0')} ${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}',
                            style: TextStyle(fontSize: ScreenUtil().setSp(27))),
                        onPressed: () => _showTimePicker(1, _time),
                        borderSide:
                            BorderSide(color: Colors.indigo[100], width: 2),
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
                                contentPadding:
                                    EdgeInsets.fromLTRB(10, 15, 10, 0),
                                content: Container(
                                  height: ScreenUtil().setHeight(750),
                                  child: MaterialColorPicker(
                                      circleSize: ScreenUtil().setWidth(105),
                                      onColorChange: (Color color) {
                                        _nowColor = color;
                                      },
                                      selectedColor: _selectedColor),
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
                            });
                      }),
                ],
              ),
              new Padding(
                  padding: EdgeInsets.only(
                    top: ScreenUtil().setHeight(20),
                    left: ScreenUtil().setHeight(12),
                  ),
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
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: ScreenUtil().setWidth(380),
                                child: OutlineButton(
                                  child: Text(
                                      '${_alertTime.year}-${_alertTime.month.toString().padLeft(2, '0')}-${_alertTime.day.toString().padLeft(2, '0')} ${_alertTime.hour.toString().padLeft(2, '0')}:${_alertTime.minute.toString().padLeft(2, '0')}',
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(27))),
                                  onPressed: _isAlert
                                      ? () => _showTimePicker(2, _alertTime)
                                      : null,
                                  borderSide: BorderSide(
                                      color: Colors.indigo[100], width: 2),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: ScreenUtil().setWidth(20)),
                                child: FlatButton.icon(
                                  icon: Icon(Icons.sync),
                                  label: Text('设置为事件时间',
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(24))),
                                  onPressed:
                                      _isAlert ? () => _syncTime() : null,
                                ),
                              ),
                            ],
                          )),
                    ],
                  )),
              _label('备注', 60),
              Padding(
                padding: EdgeInsets.only(left: ScreenUtil().setWidth(24)),
                child: Container(
                  width: ScreenUtil().setWidth(710),
                  child: new TextField(
                    controller: _controller2,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent)),
                      contentPadding: EdgeInsets.all(ScreenUtil().setSp(20)),
                    ),
                    minLines: 1,
                    maxLines: 5,
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
      ),
    );
  }
}
