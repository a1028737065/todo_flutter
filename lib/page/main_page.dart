import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../component/todo_item.dart';
import '../page/create_page.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // List<String> _sort = ['全部'];
  // int _nowSort = 0;
  List<Widget> _todoItemList = [
    TodoItem(key: UniqueKey(), alertTime: 1570762512000,), //示例时间 2019-10-11 10:55:12
    TodoItem(key: UniqueKey(), alertTime: 1570446277000,), //示例时间 2019-10-07 19:04:37
  ];

  void _newTODO() {
    Navigator.push(context, new MaterialPageRoute(builder: (context) => new CreatePage()),);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334, allowFontScaling: true)..init(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('TODO'),
      ),
      body: Center(
        child:ListView(
          children: _todoItemList,
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
