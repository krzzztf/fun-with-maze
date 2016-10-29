import 'maze_data.dart';
import '../tools/position_tools.dart';
import 'package:stagexl/stagexl.dart';

class Maze extends Sprite {
  num mazeWidth, mazeHeight;
  int nbRows, nbCols;
  num cellSize; //TODO : cellWidth & cellHeight
  num cellWidth;
  num cellHeight;
  List<List<CellData>> _displayData;
  MazeDataGenerator _mazeDataGen;

  Maze(
      {this.nbRows: 10, this.nbCols: 10, this.mazeWidth: 500, this.mazeHeight: 500})
      : super() {
    cellSize = mazeWidth / nbCols;
    cellWidth = mazeWidth / nbCols;
    cellHeight = mazeHeight / nbRows;

    _mazeDataGen = new MazeDataGenerator();
//    _mazeDataGen.addEventListener(MazeDataGenerator.DATA_READY, onDataReady);
    _mazeDataGen.createMazeData(nbRows, nbCols);
    _displayData = _mazeDataGen.dataArray;

//    _drawMaze();
//    _drawCircleMaze();
    _drawCircleMazeStrangeToUnderstand();
  }

  void _drawMaze() {
    num curX;
    num curY;
    List<CellData> curRow;
    int start = _mazeDataGen.random.nextInt(nbRows);
    int end = _mazeDataGen.random.nextInt(nbRows);

    // Starting Cell
//    graphics
//      ..clear()
//      ..beginPath()
//      ..moveTo(0, start * cellSize)
//      ..lineTo(0, start * cellSize + cellSize)
//      ..lineTo(cellSize, start * cellSize + cellSize)
//      ..lineTo(cellSize, start * cellSize)
//      ..lineTo(0, start * cellSize)
//      ..closePath()
//      ..fillColor(Color.Green);

    // Maze Borders
//    graphics
//      ..beginPath()
//      ..moveTo(mazeWidth, end * cellSize)
//      ..lineTo(mazeWidth, end * cellSize + cellSize)
//      ..lineTo(mazeWidth - cellSize, end * cellSize + cellSize)
//      ..lineTo(mazeWidth - cellSize, end * cellSize)
//      ..lineTo(mazeWidth, end * cellSize)
//      ..closePath()
//      ..fillColor(0xffff0000);

    graphics.beginPath();
    // Maze
    for (int i = 0; i < nbRows; i++) {
      curX = 0;
      curY = i * cellHeight;
      curRow = _displayData[i];

      graphics
        ..moveTo(curX, curY)
        ..lineTo(curX, curY + cellHeight);

      for (int j = 0; j < nbCols; j++) {
        curX = j * cellWidth;
//        _addDebugTxt(i.toString()+","+ j.toString(), curX + cellSize * 0.3, curY + cellSize*0.4);
        if (i == 0) {
          graphics
            ..moveTo(curX, curY)
            ..lineTo(curX + cellWidth, curY);
        }

        if (curRow[j].down) {
          graphics
            ..moveTo(curX, curY + cellHeight)
            ..lineTo(curX + cellWidth, curY + cellHeight);
        }

        if (curRow[j].right) {
          graphics
            ..moveTo(curX + cellWidth, curY)
            ..lineTo(curX + cellWidth, curY + cellHeight);
        }
      }
    }
    graphics
      ..strokeColor(0xff000000, 2)
      ..closePath();
  }

  void _addDebugTxt(String txt, num posX, num posY) {
    TextField tf = new TextField();
    tf.text = txt;
    tf.x = posX;
    tf.y = posY;
    addChild(tf);
  }

  void _drawCircleMaze() {
    num curX;
    num curY;
    List<CellData> curRow;

    int start = _mazeDataGen.random.nextInt(nbRows);
    int end = _mazeDataGen.random.nextInt(nbRows);

    graphics.beginPath();
    for (int i = 0; i < nbRows; i++) {
      curX = 0;
      curY = i * cellHeight;
      curRow = _displayData[i];

      Point startPointLeftBorder = PositionTools.squareToCircle(
          curX, curY, mazeWidth, mazeHeight);
      this.graphics.moveTo(startPointLeftBorder.x, startPointLeftBorder.y);
      Point endPointLeftBorder = PositionTools.squareToCircle(
          curX, curY + cellHeight, mazeWidth, mazeHeight);
      this.graphics.lineTo(endPointLeftBorder.x, endPointLeftBorder.y);

      for (int j = 0; j < nbCols; j++) {
        curX = j * cellWidth;

        if (i == 0) {
          Point startPointUpBorder = PositionTools.squareToCircle(
              curX, curY, mazeWidth, mazeHeight);
          this.graphics.moveTo(startPointUpBorder.x, startPointUpBorder.y);
          Point endPointUpBorder = PositionTools.squareToCircle(
              curX + cellWidth, curY, mazeWidth, mazeHeight);
          this.graphics.lineTo(endPointUpBorder.x, endPointUpBorder.y);
        }

        if (curRow[j].down) {
          Point startPointDown = PositionTools.squareToCircle(
              curX, curY + cellHeight, mazeWidth, mazeHeight);
          this.graphics.moveTo(startPointDown.x, startPointDown.y);
          Point endPointSouth = PositionTools.squareToCircle(
              curX + cellWidth, curY + cellHeight, mazeWidth, mazeHeight);
          this.graphics.lineTo(endPointSouth.x, endPointSouth.y);
        }

        if (curRow[j].right) {
          Point startPointRight = PositionTools.squareToCircle(
              curX + cellWidth, curY, mazeWidth, mazeHeight);
          this.graphics.moveTo(startPointRight.x, startPointRight.y);
          Point endPointEast = PositionTools.squareToCircle(
              curX + cellWidth, curY + cellHeight, mazeWidth, mazeHeight);
          this.graphics.lineTo(endPointEast.x, endPointEast.y);
        }
      }
    }
    graphics
      ..strokeColor(0xff000000, 2)
      ..closePath();
  }

  // avec labyrinthe rectangulaire
  void _drawCircleMazeStrangeToUnderstand() {
    num curX;
    num curY;
    List<CellData> curRow;

    graphics.beginPath();
    for (int i = 0; i < nbRows; i++) {
      curX = 0;
      curY = i * cellSize;
      curRow = _displayData[i];

      Point startPointLeftBorder = PositionTools.squareToCircle(
          curX, curY, mazeWidth, mazeHeight);
      this.graphics.moveTo(startPointLeftBorder.x, startPointLeftBorder.y);
      Point endPointLeftBorder = PositionTools.squareToCircle(
          curX, curY + cellSize, mazeWidth, mazeHeight);
      this.graphics.lineTo(endPointLeftBorder.x, endPointLeftBorder.y);

      for (int j = 0; j < nbCols; j++) {
        curX = j * cellSize;

        if (i == 0) {
          Point startPointUpBorder = PositionTools.squareToCircle(
              curX, curY, mazeWidth, mazeHeight);
          this.graphics.moveTo(startPointUpBorder.x, startPointUpBorder.y);
          Point endPointUpBorder = PositionTools.squareToCircle(
              curX + cellSize, curY, mazeWidth, mazeHeight);
          this.graphics.lineTo(endPointUpBorder.x, endPointUpBorder.y);
        }

        if (curRow[j].down) {
          Point startPointDown = PositionTools.squareToCircle(
              curX, curY + cellSize, mazeWidth, mazeHeight);
          this.graphics.moveTo(startPointDown.x, startPointDown.y);
          Point endPointSouth = PositionTools.squareToCircle(
              curX + cellSize, curY + cellSize, mazeWidth, mazeHeight);
          this.graphics.lineTo(endPointSouth.x, endPointSouth.y);
        }

        if (curRow[j].right) {
          Point startPointRight = PositionTools.squareToCircle(
              curX + cellSize, curY, mazeWidth, mazeHeight);
          this.graphics.moveTo(startPointRight.x, startPointRight.y);
          Point endPointEast = PositionTools.squareToCircle(
              curX + cellSize, curY + cellSize, mazeWidth, mazeHeight);
          this.graphics.lineTo(endPointEast.x, endPointEast.y);
        }
      }
    }
    graphics
      ..strokeColor(0xff000000, 2)
      ..closePath();
  }

  void _drawCircleMazeStrangeToUnderstand2(num upOffset, num rightOffset,
      num downOffset, num leftOffset) {
    num curX;
    num curY;
    List<CellData> curRow;

    graphics.beginPath();
    for (int i = 0; i < nbRows; i++) {
      curX = -leftOffset;
      curY = i * cellSize;
      curRow = _displayData[i];

      Point startPointLeftBorder = PositionTools.squareToCircle(
          curX, curY - cellSize, mazeWidth, mazeHeight);
      this.graphics.moveTo(startPointLeftBorder.x, startPointLeftBorder.y);
      Point endPointLeftBorder = PositionTools.squareToCircle(
          curX, curY + cellSize, mazeWidth, mazeHeight);
      this.graphics.lineTo(endPointLeftBorder.x, endPointLeftBorder.y);

      for (int j = 0; j < nbCols; j++) {
        curX = j * cellSize;

        if (i == 0) {
          Point startPointUpBorder = PositionTools.squareToCircle(
              curX, curY, mazeWidth, mazeHeight);
          this.graphics.moveTo(startPointUpBorder.x, startPointUpBorder.y);
          Point endPointUpBorder = PositionTools.squareToCircle(
              curX + cellSize, curY, mazeWidth, mazeHeight);
          this.graphics.lineTo(endPointUpBorder.x, endPointUpBorder.y);
        }

        if (curRow[j].down) {
          Point startPointDown = PositionTools.squareToCircle(
              curX, curY + cellSize, mazeWidth, mazeHeight);
          this.graphics.moveTo(startPointDown.x, startPointDown.y);
          Point endPointSouth = PositionTools.squareToCircle(
              curX + cellSize, curY + cellSize, mazeWidth, mazeHeight);
          this.graphics.lineTo(endPointSouth.x, endPointSouth.y);
        }

        if (curRow[j].right) {
          Point startPointRight = PositionTools.squareToCircle(
              curX + cellSize, curY, mazeWidth, mazeHeight);
          this.graphics.moveTo(startPointRight.x, startPointRight.y);
          Point endPointEast = PositionTools.squareToCircle(
              curX + cellSize, curY + cellSize, mazeWidth, mazeHeight);
          this.graphics.lineTo(endPointEast.x, endPointEast.y);
        }
      }
    }
    graphics
      ..strokeColor(0xff000000, 2)
      ..closePath();
  }
}