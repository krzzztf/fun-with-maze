import 'dart:math';

class CellData {
  bool visited;
  bool up;
  bool right;
  bool down;
  bool left;
  int row;
  int col;
  List<String> neighbors;

  CellData() :
        visited = false, up = true, right = true,
        down = true, left = true, neighbors = new List<String>();
}

class MazeDataGenerator {
  int nbRows, nbCols;
  int numVisited;
  int cellsTotal;
  List<List<CellData>> _dataArray;
  List<List<CellData>> get dataArray => _dataArray;
  List<List<int>> visitedList;
  Random random;

  MazeDataGenerator() : random = new Random();

  createMazeData(nbRows, nbCols) {
    this.nbRows = nbRows;
    this.nbCols = nbCols;

    int curRow;
    int curCol;
    int randNeighbor;
    CellData curCell;
    List<int> backArray;

    cellsTotal = nbRows * nbCols;
    numVisited = 0;
    visitedList = [];
    _dataArray = new List<List<CellData>>(nbCols);

    for (int i = 0; i < nbRows; i++)
    {
      _dataArray[i] = new List<CellData>(nbRows);
      for (int j = 0; j < nbCols; j++)
      {
        _dataArray[i][j] = new CellData();
        _dataArray[i][j].row = i;
        _dataArray[i][j].col = j;
      }
    }

    curRow = random.nextInt(nbRows);
    curCol = random.nextInt(nbCols);
    visitedList.add([curRow, curCol]);
    curCell = _dataArray[curRow][curCol];
    curCell.visited = true;
    numVisited += 1;

    while (numVisited < cellsTotal)
    {
      curCell.neighbors = [];
      if (curRow - 1 >= 0 && _dataArray[curRow - 1][curCol].visited == false)
      {
        curCell.neighbors.add("up");
      }

      if (curRow + 1 < nbRows && _dataArray[curRow + 1][curCol].visited == false)
      {
        curCell.neighbors.add("down");
      }

      if (curCol - 1 >= 0 && _dataArray[curRow][curCol - 1].visited == false)
      {
        curCell.neighbors.add("left");
      }

      if (curCol + 1 < nbCols && _dataArray[curRow][curCol + 1].visited == false)
      {
        curCell.neighbors.add("right");
      }

      if (curCell.neighbors.length > 0)
      {
        randNeighbor = random.nextInt(curCell.neighbors.length);

        if (curCell.neighbors[randNeighbor] == "up")
        {
          curCell.up = false;
          curCell = _dataArray[curRow - 1][curCol];
          curCell.down = false;
          curCell.visited = true;
          curRow = curCell.row;
          curCol = curCell.col;
          numVisited += 1;
          visitedList.add([curRow, curCol]);
        }
        else if (curCell.neighbors[randNeighbor] == "down")
        {

          curCell.down = false;
          curCell = _dataArray[curRow + 1][curCol];
          curCell.up = false;
          curCell.visited = true;
          curRow = curCell.row;
          curCol = curCell.col;
          numVisited += 1;
          visitedList.add([curRow, curCol]);
        }
        else if (curCell.neighbors[randNeighbor] == "left")
        {
          curCell.left = false;
          curCell = _dataArray[curRow][curCol - 1];
          curCell.right = false;
          curCell.visited = true;
          curRow = curCell.row;
          curCol = curCell.col;
          numVisited += 1;
          visitedList.add([curRow, curCol]);
        }
        else if (curCell.neighbors[randNeighbor] == "right")
        {
          curCell.right = false;
          curCell = _dataArray[curRow][curCol + 1];
          curCell.left = false;
          curCell.visited = true;
          curRow = curCell.row;
          curCol = curCell.col;
          numVisited += 1;
          visitedList.add([curRow, curCol]);
        }
      }
      else
      {
        backArray = visitedList.removeLast();
        curRow = backArray[0];
        curCol = backArray[1];
        curCell = _dataArray[curRow][curCol];
      }
    }

//    if (numVisited == cellsTotal)
//    {
//      dispatchEvent(new Event(MazeDataGenerator.DATA_READY));
//    }
  }
}