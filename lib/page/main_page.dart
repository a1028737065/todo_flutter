import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animated_stream_list/animated_stream_list.dart';
import '../component/todo_item.dart';
import '../data_handle/item_handler.dart';
import '../data_handle/model/item.dart';
import '../page/create_page.dart';
import '../data_handle/todos_bloc.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with AutomaticKeepAliveClientMixin<MainPage> {
  ItemBloc _itemBloc;
  bool _isLoading = true, _listIsEmpty = true;
  var _itemHandler = new ItemHandler();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  ScrollController _listViewController = new ScrollController();

  Widget _todoItem(Item _i) => TodoItem(
        key: UniqueKey(),
        item: _i,
        delete: _deleteTODO,
        update: _update,
        notificationsPlugin: flutterLocalNotificationsPlugin,
      );

  void reloadList() {
    List<Item> _temp = [];
    _itemHandler.getAll().then((v) {
      v.forEach((_i) {
        _temp.insert(0, _i);
      });
      _itemBloc.addItem(_temp);
      _getIsEmpty();
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _toCreate() {
    Navigator.push(
      context,
      new MaterialPageRoute(
          builder: (context) => new CreatePage(
                addToMainPage: _addTODO,
              )),
    );
  }

  void _addTODO(Item _i) {
      if (_itemBloc.isEmpty()) {
        _itemBloc = new ItemBloc();
        _itemBloc.addItem([_i]);
        _getIsEmpty();
      } else {
        _listViewController
            .animateTo(0.0,
                duration: Duration(milliseconds: 300), curve: Curves.ease)
            .then((v) {
          _itemBloc.addItem([_i]);
          _getIsEmpty();
        });
      }
  }

  void _deleteTODO(int _id) {
    _itemHandler.delete(_id).then((v) {
      _itemBloc.removeItem(_id);
      Future.delayed(Duration(milliseconds: 750), () => _getIsEmpty());
    });
  }

  void _update(Item _i) {
    Future.delayed(Duration(milliseconds: 200), () {
      _itemHandler.update(_i).then((a) {
        _itemHandler.getItem(_i.id).then((_i) {
          _itemBloc.updateItem(_i);
        });
      });
    });
  }

  void _getIsEmpty() {
    print('display: ${!_itemBloc.isEmpty()}');
    setState(() {
      _listIsEmpty = _itemBloc.isEmpty();
    });
  }

  @override
  void initState() {
    super.initState();
    _itemBloc = ItemBloc();
    reloadList();
  }

  Widget _animatedView(Stream<List<Item>> todoListStream) {
    
    return new AnimatedStreamList<Item>(      
      streamList: todoListStream, 
      scrollController: _listViewController,
      itemBuilder: (Item item, int index, BuildContext context, Animation<double> animation) =>      
        _createItemWidget(item, index, animation),      
      itemRemovedBuilder: (Item item, int index, BuildContext context, Animation<double> animation) =>  
        _createRemovedItemWidget(item, animation), 
    ); 
  }

  Widget _createItemWidget(Item item, int index, Animation<double> animation) {
    return SizeTransition(
      axis: Axis.vertical,
      sizeFactor: animation,
      child: _todoItem(item)
    );
  }

  Widget _createRemovedItemWidget(Item item, Animation<double> animation) {
    return SizeTransition(
      axis: Axis.vertical,
      sizeFactor: animation,
      child: _todoItem(item)
    );
  }

  var tipsStyle = TextStyle(
    color: Color.fromRGBO(0, 0, 0, 0.6),
  );

  @override
  Widget build(BuildContext context) {
    super.build(context);

    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true)
          ..init(context);
    DateTime _lastPressedAt;

    return Scaffold(
      appBar: AppBar(
        title: Text('TODO'),
      ),
      body: Builder(
        builder: (context) => WillPopScope(
            child: Center(
                child: !_isLoading
                    ? (!_listIsEmpty ? 
                        _animatedView(_itemBloc.itemListStream)
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                '列表里还没有 TODO 哦',
                                style: tipsStyle,
                              ),
                              Text(
                                '点击右下角的加号来新增一个吧',
                                style: tipsStyle,
                              ),
                            ],
                          ))
                    : CircularProgressIndicator()),
            onWillPop: () async {
              if (_lastPressedAt == null ||
                  DateTime.now().difference(_lastPressedAt) >
                      Duration(milliseconds: 1500)) {
                _lastPressedAt = DateTime.now();
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("再点一次退出！"),
                  duration: Duration(milliseconds: 1500),
                ));
                return false;
              }
              return true;
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toCreate,
        tooltip: 'New TODO',
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _listViewController.dispose();
    _itemBloc.dispose();
    super.dispose();
  }

  @override
  // keep widget alive
  bool get wantKeepAlive => true;
}
