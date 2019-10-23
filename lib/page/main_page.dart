import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../component/todo_item.dart';
import '../data_handle/item_handler.dart';
import '../data_handle/model/item.dart';
import '../page/create_page.dart';
import 'package:jpush_flutter/jpush_flutter.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<TodoItem> _todoItemList = [];
  Map<int, int> _idMap = {};
  bool _isLoading = true;
  var _itemHandler = new ItemHandler();

  void reloadList() {
    _isLoading = true;
    _itemHandler.getAll().then((v) {
      v.forEach((_i) {
        _todoItemList.add(TodoItem(key: UniqueKey(), item: _i, delete: _deleteTODO,));
      });
      _updateKey();
      setState(() {});
      _isLoading = false;
    });
  }

  void _newTODO() {
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new CreatePage(addToMainPage: _addTODO,)),
    );
  }

  void _addTODO(Item _i) {
    _todoItemList.add(TodoItem(key: UniqueKey(), item: _i, delete: _deleteTODO,));
    _updateKey();
    setState(() {});
  }

  void _deleteTODO(int _id) {
    _itemHandler.delete(_id);
    _todoItemList.removeAt(_idMap[_id]);
    _updateKey();
    setState(() {});
  }

  void _updateKey() {
    _idMap = {};
    for (int _i = 0; _i < _todoItemList.length; _i++) {
      _idMap.putIfAbsent(_todoItemList[_i].id, () => _i);
    }
  }
  
  // final JPush jpush = new JPush();
  @override
  void initState() {
    super.initState();
    reloadList();
    
    // var fireDate = DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch + 3000);
    // var localNotification = LocalNotification(
    //   id: 234,
    //   title: 'notification title',
    //   buildId: 1,
    //   content: 'notification content',
    //   fireTime: fireDate,
    //   subtitle: 'notification subtitle', // 该参数只有在 iOS 有效
    //   badge: 5, // 该参数只有在 iOS 有效
    //   extra: {"fa": "0"} // 设置 extras ，extras 需要是 Map<String, String>
    //   );
    // jpush.sendLocalNotification(localNotification).then((res) {});
  }

  var tipsStyle  = TextStyle(
    color: Color.fromRGBO(0, 0, 0, 0.6),
  );

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334, allowFontScaling: true)
      ..init(context);

    
    return Scaffold(
      appBar: AppBar(
        title: Text('TODO'),
      ),
      body: Center(
        child: !_isLoading ?
        (_todoItemList.isNotEmpty ? 
        ListView.builder(
            itemCount: _todoItemList == null ? 0 : _todoItemList.length,
            itemBuilder: (BuildContext context,int index){
              return _todoItemList[index];
            },
          ) : 
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('列表里还没有 TODO 哦', style: tipsStyle,),
              Text('点击右下角的加号来新增一个吧', style: tipsStyle,),
            ],
          )) : 
          CircularProgressIndicator()
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: _newTODO,
        tooltip: 'New TODO',
        child: Icon(Icons.add),
      ),
    );
  }
}
