import 'package:flutter/material.dart';
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

class _MainPageState extends State<MainPage> {
  List<Widget> _todoItemList = [];

  void reloadList() {
    var _itemHandler = new ItemHandler();
    _itemHandler.getAll().then((v) {
      List<Widget> _list = [];
      v.forEach((_i) => _list.add(TodoItem(key: UniqueKey(), item: _i)));

      setState(() {
        _todoItemList = _list;
      });
    });
  }

  void _newTODO() {
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new CreatePage(addToMainPage: _addToList,)),
    );
  }

  void _addToList(Item _i) {
    _todoItemList.add(TodoItem(key: UniqueKey(), item: _i));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    reloadList();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true)
          ..init(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('TODO'),
      ),
      body: Center(
        child: ListView.builder(
            itemCount: _todoItemList == null ? 0 : _todoItemList.length,
            itemBuilder: (BuildContext context,int index){
              return _todoItemList[index];
            },
          )
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: _newTODO,
        tooltip: 'New TODO',
        child: Icon(Icons.add),
      ),
    );
  }
}
