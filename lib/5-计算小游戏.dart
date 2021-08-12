import 'dart:async';
import 'dart:math';

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
  final StreamController _inputStreamController = StreamController.broadcast();
  final StreamController _scoreStreamController = StreamController.broadcast();
  int _score = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _inputStreamController.close();
    _scoreStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<Object>(
            stream: _scoreStreamController.stream.transform(TallyTransformer()),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text('分数：${snapshot.data}');
              }
              return Text('分数：$_score');
            }),
      ),
      body: Stack(
        children: [
          ...List.generate(
              5,
              (index) => Puzzle(
                    inputStream: _inputStreamController.stream,
                    scoreStreamController: _scoreStreamController,
                  )),
          Container(
            alignment: Alignment.bottomCenter,
            child: KeyPad(
              inputStreamController: _inputStreamController,
              scoreStreamController: _scoreStreamController,
            ),
          ),
        ],
      ),
    );
  }
}

class TallyTransformer implements StreamTransformer {
  final StreamController _streamController = StreamController();
  int sum = 0;

  @override
  Stream bind(Stream stream) {
    stream.listen((event) {
      sum += event;
      _streamController.add(sum);
    });
    return _streamController.stream;
  }

  @override
  StreamTransformer<RS, RT> cast<RS, RT>() => StreamTransformer.castFrom(this);
}

class Puzzle extends StatefulWidget {
  const Puzzle({Key key, this.inputStream, this.scoreStreamController})
      : super(key: key);
  final Stream inputStream;
  final StreamController scoreStreamController;

  @override
  _PuzzleState createState() => _PuzzleState();
}

class _PuzzleState extends State<Puzzle> with SingleTickerProviderStateMixin {
  int a;
  int b;
  double x;
  Color color;
  AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _reset(Random().nextDouble());
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _reset();
        widget.scoreStreamController.add(-3);
      }
    });

    widget.inputStream.listen((value) {
      if (value == (a + b)) {
        _reset();
        widget.scoreStreamController.add(5);
      }
    });
    super.initState();
  }

  void _reset([from = 0.0]) {
    a = Random().nextInt(5) + 1;
    b = Random().nextInt(5);
    x = Random().nextDouble() * 300;
    color = Colors.primaries[Random().nextInt(Colors.primaries.length)][200];
    _animationController.duration = Duration(
      milliseconds: 5000 + Random().nextInt(5000),
    );
    _animationController.forward(from: from);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (BuildContext context, Widget child) {
        return Positioned(
          top: 500 * _animationController.value - 100,
          left: x,
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.5),
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Text(
              '$a + $b',
              style: TextStyle(fontSize: 24),
            ),
          ),
        );
      },
    );
  }
}

class KeyPad extends StatelessWidget {
  KeyPad({
    Key key,
    this.inputStreamController,
    this.scoreStreamController,
  }) : super(key: key);

  final StreamController inputStreamController;
  final StreamController scoreStreamController;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      shrinkWrap: true,
      childAspectRatio: 2 / 1,
      padding: EdgeInsets.zero,
      children: List.generate(9, (index) {
        return ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(Colors.primaries[index])),
          onPressed: () {
            inputStreamController.add(index + 1);
            scoreStreamController.add(-2); // 狂按先减分
          },
          child: Text('${index + 1}', style: TextStyle(fontSize: 24)),
        );
      }),
    );
  }
}
