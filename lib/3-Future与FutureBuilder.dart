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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: FutureBuilder(
            // future: Future.delayed(Duration(seconds: 1), () => 456),
            future: Future.delayed(Duration(seconds: 1), () => throw ('oops')),
            initialData: 72,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              /// snapshot的4种状态
              // if(snapshot.connectionState == ConnectionState.waiting) {
              //   return CircularProgressIndicator();
              // }
              //
              // if(snapshot.connectionState == ConnectionState.done) {
              //   if(snapshot.hasError) {
              //     return Icon(Icons.error, size: 80,);
              //   }
              //   return Text('${snapshot.data}', style: TextStyle(fontSize: 72),);
              // }
              // throw ('should not happen');

              /// 上面的变体
              if (snapshot.hasError) {
                return Icon(Icons.error, size: 80);
              }

              if (snapshot.hasData) {
                return Text('${snapshot.data}', style: TextStyle(fontSize: 72));
              }

              return CircularProgressIndicator();
            },
          ),
        ));
  }
}
