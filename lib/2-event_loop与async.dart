import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  /// 知识点一

  // /// event
  // Future.delayed(Duration(seconds: 1), () => print('event 3'));
  // Future(() => print('event 1'));
  // Future.delayed(Duration.zero, () => print('event 2'));
  //
  // /// microtask
  // scheduleMicrotask(() => print('microtask 1'));
  // Future.microtask(() => print('microtask 2'));
  //
  // /// 在已经完成的Future上执行then会被添加到microtask
  // Future.value(123).then((value) => print('microtask 3'));
  //
  // /// 主进程
  // print('main 1');
  // Future.sync(() => print('sync 1'));
  // Future.value(getName());
  // print('main 2');

  /// 知识点二

  /// 一个普通的等待中的Future，在完成的瞬间then会直接执行
  Future.delayed(Duration(seconds: 1), () => print('delayed')).then((value) {
    scheduleMicrotask(() => print('micro'));
    print('then');
  }).then((value) => print('then 2'));


  /// 知识点三
  Future<String> getFuture() {
    return Future.error(Exception('something went wrong'));
  }
  
  getFuture().then((value) => print(value))
  .catchError((err) => print(err))
  .whenComplete(() => print('complete'));
  
  runApp(MyApp());
}

String getName() {
  print('get name');
  return 'Bon';
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(children: [
          Image.asset('assets/1.jpg'),
          Image.asset('assets/2.jpg'),
        ]),
      ),
    );
  }
}
