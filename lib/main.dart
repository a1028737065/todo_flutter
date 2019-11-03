import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './page/main_page.dart';

void main() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]); //锁定屏幕方向为竖屏，防止旋转屏幕导致页面布局出错
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
