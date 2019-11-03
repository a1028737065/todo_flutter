import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../component/todo_item.dart';
import '../data_handle/item_handler.dart';
import '../data_handle/model/item.dart';
import '../page/create_page.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with AutomaticKeepAliveClientMixin<MainPage> {
  List<TodoItem> _todoItemList = [];
  Map<int, int> _idMap = {};
  bool _isLoading = true;
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
    _itemHandler.getAll().then((v) {
      v.forEach((_i) {
        _todoItemList.insert(0, _todoItem(_i));
      });
      _updateKey();
      _isLoading = false;
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
    Future.delayed(Duration(milliseconds: 250), () {
      _listViewController
          .animateTo(0.0,
              duration: Duration(milliseconds: 300), curve: Curves.ease)
          .then((v) {
        _todoItemList.insert(0, _todoItem(_i));
        _updateKey();
      });
    });
  }

  void _deleteTODO(int _id) {
    _itemHandler.delete(_id);
    _todoItemList.removeAt(_idMap[_id]);
    _updateKey();
  }

  void _update(Item _i) {
    Future.delayed(Duration(milliseconds: 200), () {
      _itemHandler.update(_i).then((a) {
        _itemHandler.getItem(_i.id).then((_i) {
          _todoItemList[_idMap[_i.id]] = _todoItem(_i);
          _updateKey();
        });
      });
    });
  }

  void _updateKey() {
    _idMap = {};
    for (int _i = 0; _i < _todoItemList.length; _i++) {
      _idMap.putIfAbsent(_todoItemList[_i].id, () => _i);
    }
    setState(() {});
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    // await Navigator.push(
    //   context,
    //   new MaterialPageRoute(builder: (context) => new SecondScreen(payload)),
    // );
  }

  //IOS only
  Future<void> onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    //Sample on https://github.com/MaikuB/flutter_local_notifications
  }

  @override
  void initState() {
    super.initState();
    reloadList();

    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
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
    const Widget _divider = Divider(height: 2);
    DateTime _lastPressedAt;

    return Scaffold(
      appBar: AppBar(
        title: Text('TODO'),
      ),
      body: Builder(
        builder: (context) => WillPopScope(
            child: Center(
                child: !_isLoading
                    ? (_todoItemList.isNotEmpty
                        ? ListView.separated(
                            controller: _listViewController,
                            itemCount: _todoItemList == null
                                ? 0
                                : _todoItemList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return _todoItemList[index];
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return _divider;
                            },
                          )
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
    super.dispose();
  }

  @override
  // keep widget alive
  bool get wantKeepAlive => true;
}
