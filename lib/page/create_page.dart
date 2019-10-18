import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:todo/data_handle/item_handler.dart';
import 'package:todo/data_handle/model/item.dart';

class CreatePage extends StatefulWidget {
  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  TextEditingController _controller1, _controller2;
  DateTime _time, _alertTime;
  String _category; //初始化为分类第一个
  bool _isAlert = false;
  String _text;
  String _commet;

  TextStyle _labelStyle = TextStyle(fontSize: ScreenUtil().setSp(30), color: Colors.blue[400], fontWeight: FontWeight.bold);

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
    var itemHandler = ItemHandler();
    int _id;
    String _dateTimeStr, _alertTimeStr;

    _dateTimeStr = _time.toString();
    _alertTimeStr = _alertTime.toString();
  }

  @override
  void initState() {
    super.initState();
    _time = DateTime.now();
    _alertTime = _time;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          new IconButton(
            icon: Icon(Icons.save),
            onPressed: _create,
          )
        ],
      ),
      body: new Padding(
        padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Padding(
              padding: EdgeInsets.only(top: ScreenUtil().setHeight(8), bottom: ScreenUtil().setHeight(8), left: ScreenUtil().setHeight(12),),
              child: Text(
                '内容',
                style: _labelStyle,
              ),
            ),

            new Container(
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

            new Padding(
              padding: EdgeInsets.only(top: ScreenUtil().setHeight(8), left: ScreenUtil().setHeight(12),),
              child: new Row(
                children: <Widget>[
                  Container(
                    width: ScreenUtil().setWidth(145),
                    child: Text(
                      '事件时间',
                      style: _labelStyle,
                    ),
                  ),
                  Container(
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
                ],
              )
            ),

            new Padding(
              padding: EdgeInsets.only(top: ScreenUtil().setHeight(8), left: ScreenUtil().setHeight(12),),
              child: new Row(
                children: <Widget>[
                  Container(
                    width: ScreenUtil().setWidth(100),
                    child: Text(
                      '分类',
                      style: _labelStyle,
                    ),
                  ),
                  Container(
                    child: new DropdownButton<String>(
                      hint: Text(r'      选择一个分类   '),
                      value: _category,
                      onChanged: (String newValue) {
                        setState(() {
                          _category = newValue;
                        });
                      },
                      items: <String>['One', 'Two', 'Fre', 'Four', 'Four1', 'Four2', 'Four3', 'Four4', 'Four5', 'Four7', 'Four62']//不能重复
                        .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        })
                        .toList(),
                      iconSize: 30,
                    ),
                  ),
                ],
              )
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
                        OutlineButton(
                          child: Text(
                            '${_alertTime.year}-${_alertTime.month.toString().padLeft(2,'0')}-${_alertTime.day.toString().padLeft(2,'0')} ${_alertTime.hour.toString().padLeft(2,'0')}:${_alertTime.minute.toString().padLeft(2,'0')}', 
                            style: TextStyle(fontSize: ScreenUtil().setSp(27))
                          ),
                          onPressed: _isAlert?() => _showTimePicker(2, _alertTime):null,
                          borderSide: BorderSide(color: Colors.indigo[100], width: 2),
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

            new Padding(
              padding: EdgeInsets.only(top: ScreenUtil().setHeight(50), bottom: ScreenUtil().setHeight(12), left: ScreenUtil().setHeight(12),),
              child: Text(
                '备注',
                style: _labelStyle,
              ),
            ),

            new Container(
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
          ],
        ),
      ),
    );
  }
}

