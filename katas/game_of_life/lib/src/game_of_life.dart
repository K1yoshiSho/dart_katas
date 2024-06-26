import 'package:collection/collection.dart';

import 'cell.dart';
import 'grid_parser.dart';

class GameOfLife {
  static const int defaultMaxGenerations = 100;

  final int _height;
  final int _width;
  final GridParser _gridParser = GridParser();
  final List<List<List<Cell>>> _grids = [];

  GameOfLife({
    required List<List<String>> initialGrid,
  })  : _height = initialGrid.length,
        _width = initialGrid.first.length {
    List<List<Cell>> initialCellGrid = _gridParser.parseStringGrid(initialGrid);

    _grids.add(initialCellGrid);
  }

  List<List<String>> get lastGrid => _gridParser.cellGridToStringGrid(_grids.last);

  List<List<List<String>>> get allGrids {
    final List<List<List<String>>> stringGrids = [];

    for (final List<List<Cell>> grid in _grids) {
      stringGrids.add(_gridParser.cellGridToStringGrid(grid));
    }

    return stringGrids;
  }

  void play({
    int maxGenerations = defaultMaxGenerations,
  }) {
    int currentGeneration = 0;
    List<List<Cell>> nextGrid = [];
    List<List<Cell>> baseGrid = [];

    do {
      List<List<Cell>> baseGrid = _grids.last;
      nextGrid = _applyRules(baseGrid);

      _grids.add(nextGrid);

      currentGeneration++;
    } while (_shouldGenerateNextGen(
      nextGrid,
      baseGrid,
      currentGeneration,
      maxGenerations,
    ));

    _grids.removeLast();
  }

  bool _isGridNotEqual(
    List<List<Cell>> gridLeft,
    List<List<Cell>> gridRight,
  ) =>
      !DeepCollectionEquality().equals(gridLeft, gridRight);

  bool _shouldGenerateNextGen(
    List<List<Cell>> nextGrid,
    List<List<Cell>> baseGrid,
    int currentGeneration,
    int maxGenerations,
  ) =>
      _isGridNotEqual(nextGrid, baseGrid) && currentGeneration < maxGenerations;

  List<List<Cell>> _applyRules(
    List<List<Cell>> baseGrid,
  ) {
    final List<List<Cell>> nextGrid = _gridParser.emptyCellGrid(_height, _width);

    // int errorCounter = 0;
    _gridParser.heightWidthLooper(_height, _width, (int heightIndex, int widthIndex) {
      final Cell currentCell = baseGrid[heightIndex][widthIndex];
      int totalAliveNeighbors = 0;

      _vicinityLooper(heightIndex, widthIndex, (int neighborHeightIndex, int neighborWidthIndex) {
        try {
          final Cell neighborCell = baseGrid[neighborHeightIndex][neighborWidthIndex];
          if (neighborCell.isAlive) {
            totalAliveNeighbors++;
          }
        } catch (e) {
          // errorCounter++;
        }
      });

      if (_willLive(currentCell.isAlive, totalAliveNeighbors)) {
        nextGrid[heightIndex][widthIndex].status = Status.alive;
      }
    });

    return nextGrid;
  }

  _vicinityLooper(
    int heightIndex,
    int widthIndex,
    Function(int neighborHeightIndex, int neighborWidthIndex) function,
  ) {
    for (int heightStep = -1; heightStep <= 1; heightStep++) {
      for (int widthStep = -1; widthStep <= 1; widthStep++) {
        if (_isNotTheCellItself(heightStep, widthStep)) {
          final int neighborHeightIndex = heightIndex + heightStep;
          final int neighborWidthIndex = widthIndex + widthStep;
          function(neighborHeightIndex, neighborWidthIndex);
        }
      }
    }
  }

  bool _isNotTheCellItself(heightStep, widthStep) => !(heightStep == 0 && widthStep == 0);

  bool _willLive(
    bool isAlive,
    int totalAliveNeighbors,
  ) {
    if (ruleUnderpopulation(isAlive, totalAliveNeighbors))
      return false;
    else if (ruleOverpopulation(isAlive, totalAliveNeighbors))
      return false;
    else if (ruleSurvive(isAlive, totalAliveNeighbors))
      return true;
    else if (ruleComeToLife(isAlive, totalAliveNeighbors))
      return true;
    else
      return false;
  }

  bool ruleUnderpopulation(bool isAlive, int totalAliveNeighbors) => isAlive && totalAliveNeighbors < 2;

  bool ruleOverpopulation(bool isAlive, int totalAliveNeighbors) => isAlive && totalAliveNeighbors > 3;

  bool ruleSurvive(bool isAlive, int totalAliveNeighbors) => isAlive && (totalAliveNeighbors == 2 || totalAliveNeighbors == 3);

  bool ruleComeToLife(bool isAlive, int totalAliveNeighbors) => !isAlive && totalAliveNeighbors == 3;
}
