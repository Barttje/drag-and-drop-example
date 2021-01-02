import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        body: ChangeNotifierProvider(
          create: (context) => Board(),
          child: Consumer<Board>(builder: (context, state, child) {
            return GridView.count(
              physics: new NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(10),
              crossAxisCount: 8,
              children: state.grid(),
            );
          }),
        ),
      ),
    );
  }
}

class Square extends StatelessWidget {
  final int x;
  final int y;
  final int id;

  const Square({Key key, this.x, this.y, this.id}) : super(key: key);

  Color getColor() {
    if (x % 2 == y % 2) {
      return Colors.grey[800];
    }
    return Colors.grey[100];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Board>(builder: (context, state, child) {
      var current = state.getCurrent(id);
      return DragTarget(
        builder: (BuildContext context, List<dynamic> candidateData,
            List<dynamic> rejectedData) {
          return Container(
            child: current,
            color: getColor(),
          );
        },
        onWillAccept: (data) {
          return current == null || data == current.id;
        },
        onAccept: (int data) {
          state.finishMove(data, id);
        },
      );
    });
  }
}

class Checker extends StatelessWidget {
  final int id;

  const Checker({Key key, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Board>(builder: (context, state, child) {
      return Draggable(
        data: id,
        onDragStarted: () {
          state.startMove(id);
        },
        onDraggableCanceled: (a, b) {
          state.cancelMove(id);
        },
        feedback: Container(
          child: Icon(
            Icons.circle,
            color: Colors.brown[300],
            size: 35,
          ),
        ),
        child: Container(
          child: Icon(
            Icons.circle,
            color: Colors.brown[300],
            size: 35,
          ),
        ),
      );
    });
  }
}

class Board extends ChangeNotifier {
  List<PositionsOnBoard> _state = [];
  List<Square> _grid = [];
  List<Checker> _checkers = [];

  Board() {
    int id = 0;
    for (var x = 0; x < 8; x++) {
      for (var y = 0; y < 8; y++) {
        var tile = new Square(x: x, y: y, id: id);
        _grid.add(tile);
        id++;
      }
    }
    _checkers.add(Checker(id: 1));
    _state.add(PositionsOnBoard(1, 12));
  }

  List<Square> grid() => _grid.toList();

  Checker getCurrent(int gridId) {
    var position = _state.firstWhere((element) => element.squareId == gridId,
        orElse: () => null);
    if (position == null || position.dragged) {
      return null;
    }
    return _checkers.firstWhere((element) => element.id == position.checkerId);
  }

  startMove(int id) {
    _state.firstWhere((element) => element.checkerId == id).dragged = true;
    notifyListeners();
  }

  cancelMove(int id) {
    _state.firstWhere((element) => element.checkerId == id).dragged = false;
    notifyListeners();
  }

  finishMove(int id, int to) {
    _state.firstWhere((element) => element.checkerId == id).dragged = false;
    _state.firstWhere((element) => element.checkerId == id).squareId = to;
    notifyListeners();
  }
}

class PositionsOnBoard {
  int checkerId;
  int squareId;
  bool dragged = false;

  PositionsOnBoard(int checkerId, int gridId) {
    this.checkerId = checkerId;
    this.squareId = gridId;
  }
}
