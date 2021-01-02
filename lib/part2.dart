import 'package:flutter/material.dart';

void main() {
  runApp(DragAndDropExample());
}

class DragAndDropExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: Text("Drag and Drop Example"),
          ),
          body: CheckerBoard()),
    );
  }
}

class CheckerBoard extends StatefulWidget {
  @override
  _CheckerBoardState createState() => _CheckerBoardState();
}

class _CheckerBoardState extends State<CheckerBoard> {
  final List<Widget> widgets = [];

  @override
  void initState() {
    super.initState();
    for (var x = 0; x < 8; x++) {
      for (var y = 0; y < 8; y++) {
        widgets.add(new Square(x: x, y: y));
      }
    }
    widgets.add(Checker());
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        physics: new NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(10),
        crossAxisCount: 8,
        children: widgets);
  }
}

class Square extends StatelessWidget {
  final int x;
  final int y;

  Color getColor() {
    if (x % 2 == y % 2) {
      return Colors.grey[800];
    }
    return Colors.grey[100];
  }

  const Square({Key key, this.x, this.y}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: getColor(),
    );
  }
}

class Checker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Draggable(
      feedback: Container(
        child: Icon(
          Icons.circle,
          color: Colors.red,
          size: 35,
        ),
      ),
      child: Container(
        child: Icon(
          Icons.circle,
          color: Colors.blue,
          size: 35,
        ),
      ),
    );
  }
}
