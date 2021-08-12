import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
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
  /// 创建数据流
  final Stream _stream = Stream.periodic(Duration(seconds: 1), (_) => 42);

  /// _streamController
  /// 只允许一个人监听，会缓存数据
  // final StreamController _streamController = StreamController();

  /// _streamController 广播
  /// 允许多个人监听，不会缓存数据
  final StreamController _streamController = StreamController.broadcast();

  /// 使用async* yield创建数据流
  Stream<DateTime> getTime() async* {
    while (true) {
      await Future.delayed(Duration(seconds: 1));
      yield DateTime.now();
    }
  }

  @override
  void initState() {
    super.initState();
    // _stream.listen((event) {
    //   print(event);
    // });

    // /// sink 添加事件
    // _streamController.sink.add(55);
    // /// stream.listen 监听事件
    // _streamController.stream.listen((event) {
    //   print(event);
    // });

    _streamController.stream.listen(
          (event) {
        print('event: $event');
      },
      onError: (err) => print('error'),
      onDone: () => print('done'),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _streamController.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: DefaultTextStyle(
            style: Theme.of(context).textTheme.headline4,
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _streamController.sink.add(10);
                  },
                  child: Text('10'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _streamController.sink.add(20);
                  },
                  child: Text('20'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _streamController.sink.add('hi');
                  },
                  child: Text('hi'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _streamController.sink.addError('oops');
                  },
                  child: Text('Error'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _streamController.sink.close();
                  },
                  child: Text('Close'),
                ),
                StreamBuilder(
                  // stream: _stream,
                  // stream: _streamController.stream,
                  // stream: _streamController.stream
                  //     .where((event) => event is int)
                  //     .map((event) => event * 2)
                  //     .distinct(),
                  /// distinct 去重，重复值不用重复渲染

                  stream: getTime(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    print('building');

                    /// snapshot.connectionState
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return Text('none: 没有数据');
                        break;
                      case ConnectionState.waiting:
                        return Text('waiting: 等待数据流');
                        break;
                      case ConnectionState.active:
                        if (snapshot.hasError) {
                          return Text('active: 错误${snapshot.error}');
                        } else {
                          return Text('active: 正常${snapshot.data}');
                        }
                        break;
                      case ConnectionState.done:
                        return Text('done: 数据流已经关闭');
                        break;
                    }

                    return Container();
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
