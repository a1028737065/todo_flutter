import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './page/main_page.dart';
import 'data_handle/item_handler.dart';
import 'data_handle/model/item.dart';

void main(){
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  
  var _itemHandler = new ItemHandler();
  _itemHandler.deleteALL();
  _itemHandler.insert(Item.fromMap({
    'id': 9,
    'text': '这是text1',
    'time': '2019-10-19 04:12:00.000',
    'alert_time': '2019-10-19 04:12:00.000',
    'alert': 1,
    'commet': '这是commet',
    'category': '这是category',
  }));
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}
