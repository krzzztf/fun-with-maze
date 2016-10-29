import 'maze/maze.dart';
import 'package:stagexl/stagexl.dart';

class ScreenMain extends Sprite {
  ScreenMain() : super() {
    Maze maze = new Maze(nbRows: 100, nbCols: 100, mazeWidth: 500, mazeHeight: 300)
      ..x = 10
      ..y = 10;
    addChild(maze);
  }
}