import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './data_handle/item_handler.dart';
import './page/main_page.dart';
import './data_handle/model/item.dart';

void main(){
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  
  ItemHandler _ii;
  Map<String, dynamic> iMap = {
    'id': 1,
    'text':'text1',
    'time': 'time1',
    'alertTime': 'ATime1',
    'alert': true,
    'commet': 'commet1',
    'category': 'category1'
  };
  Item item1 = Item.fromMap(iMap);
  // ii.insert(Item.fromMap({
  //   'text':'text2',
  //   'time': 'time2',
  //   'alertTime': 'ATime2',
  //   'alert': false,
  //   'commet': 'commet2',
  //   'category': 'category2'
  // }));
  _ii.insert(item1);
  _ii.getItem(1).then((v) => print(v.toMap()));

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
