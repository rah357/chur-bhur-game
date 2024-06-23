import 'dart:async';
import 'dart:math' as math; // Add this import

import 'package:flame/components.dart';
import 'package:flame/events.dart'; // Add this import
import 'package:flame/game.dart';
import 'package:flutter/material.dart'; // And this import
import 'package:flutter/services.dart';
import 'package:simple_game/coin_piece.dart';
import './square.dart';

enum PlayState { welcome, playing, gameOver, wonBlue, wonRed }

class GameBoard extends FlameGame with TapCallbacks, KeyboardEvents {
  GameBoard() : super();

  final rand = math.Random();

  double get width => size.x;

  double get height => size.y;
  bool isBallAvailable = false;

  double interval = 100;
  double startSize = 350;
  double positionX = 210;
  double positionY = 400;
  // double positionX = ;
  // double positionY = 400;


  double coinCircleRadius = 20;
  List<Map<String, double>> outerSidePoint = [];

  List<Map<String, double>> addedCirclePointForPlayerFirst = [];
  List<Map<String, double>> addedCirclePointForPlayerSecond = [];

  List<CoinPiece> addedCoinForFirstPlayer = [];
  List<CoinPiece> addedCoinForSecondPlayer = [];

  List<CoinPiece> allCoinForMoving = [];

  double activePositionX = 0.0;
  double activePositionY = 0.0;

  int allAvailableCoin = 9;
  int bluePlayerCoin = 0;
  int redPlayerCoin = 0;

  bool isPlayerFirstTurn = true;
  List<CoinPiece> activeComponent = [];
  List<TextComponent?> textComponent = [];
  List<List<Map<String, double>>> gameGridArray = List.generate(
    7,
    (index) => List.generate(7, (index) => {}),
  );

  // related to three-coin
  List<Map<String, double>> removableCoinMapList = [];

  // rectangle-component for storing the line through the 3-dot connected
  // remove the line in gray color when the opponent coin is removed from board
  List<RectangleComponent> threeDotConnectedRectangleComponent = [];

  // tracking the coin which need to remove by drawing the circle over the coin
  // which can be picked(removed) by the current-player
  List<CoinPiece> removableCoinPiece = [];

  // existing three-dot-connected x and y coordinates
  // {x1, y1, x2, y2, x3, y3}
  List<Map<String, double?>> existingThreeDotConnected = [];

  //
  List<Map<String, int>> gameGridIndexForThreeDotConnect = [];
  List<Map<String, double>> playerFirstThreeDotCoordinates = [];
  List<Map<String, double>> playerSecondThreeDotCoordinates = [];

  int bluePlayerScore = 0;
  int redPlayerScore = 0;

  Map<double, Map<double, List<int>>> getRowColumn = {};

  late PlayState _playState; // Add from here...
  PlayState get playState => _playState;
  set playState(PlayState playState) {
    print("93 state called");
    print(playState);
    _playState = playState;
    switch (playState) {
      case PlayState.welcome:
      case PlayState.gameOver:
      case PlayState.wonBlue:
        overlays.remove(PlayState.wonBlue.name);

        overlays.add(playState.name);
      case PlayState.wonRed:
        overlays.remove(playState.name);
        overlays.remove(PlayState.gameOver.name);
        overlays.remove(PlayState.wonBlue.name);
      // TODO: Handle this case.
      case PlayState.playing:
      // TODO: Handle this case.
    }
  }

  void increaseTheBluePlayerScore() {
    bluePlayerScore++;
  }

  void increaseTheRedPlayerScore() {
    redPlayerScore++;
  }

  void increaseTheBluePlayerCoin() {
    bluePlayerCoin++;
  }

  void increaseTheRedPlayerCoin() {
    redPlayerCoin++;
  }

  void createPositionMap(List<List<Map<String, dynamic>>> array) {
    for (int i = 0; i < array.length; i++) {
      for (int j = 0; j < array[i].length; j++) {
        var element = array[i][j];
        if (element.containsKey('xPos') && element.containsKey('yPos')) {
          double xPos = element['xPos'];
          double yPos = element['yPos'];

          // If xPos key doesn't exist in getRowColumn, create a new map
          if (!getRowColumn.containsKey(xPos)) {
            getRowColumn[xPos] = {};
          }

          // Set the value for the yPos key in the inner map
          getRowColumn[xPos]![yPos] = [i, j];
        }
      }
    }
  }

  @override
  void startGame() {
    positionX = width / 2;
    positionY = height / 2;


    print("-----145 startGame");
    if (playState == PlayState.playing) return;
    print("-----149 startGame");

    world.removeAll(world.children);
    print("-----152 startGame");

    playState = PlayState.playing;
    print("-----155 startGame");

    // camera.viewfinder.anchor = Anchor.topLeft;
    // world.add(PlayArea());

    add(Square(position: Vector2(positionX, positionY), size: Vector2.all(0)));

    List<double> rectSizeList = [
      startSize,
      startSize - interval,
      startSize - (2 * interval)
    ];

    outerSidePoint = getClickablePoint(positionX, positionY, startSize);

    int outerSidePointIndex = 0;
    gameGridArray[0][0] = outerSidePoint[outerSidePointIndex];
    outerSidePoint[outerSidePointIndex] = {
      ...outerSidePoint[outerSidePointIndex],
      "row": 0,
      "col": 0,
      "isPlayerFirst": 0.0
    };
    outerSidePointIndex++;

    gameGridArray[0][3] = outerSidePoint[outerSidePointIndex];
    outerSidePoint[outerSidePointIndex] = {
      ...outerSidePoint[outerSidePointIndex],
      "row": 0,
      "col": 3,
      "isPlayerFirst": 0.0
    };
    outerSidePointIndex++;

    gameGridArray[0][6] = outerSidePoint[outerSidePointIndex];
    outerSidePoint[outerSidePointIndex] = {
      ...outerSidePoint[outerSidePointIndex],
      "row": 0,
      "col": 6,
      "isPlayerFirst": 0.0
    };
    outerSidePointIndex++;

    gameGridArray[3][6] = outerSidePoint[outerSidePointIndex];
    outerSidePoint[outerSidePointIndex] = {
      ...outerSidePoint[outerSidePointIndex],
      "row": 3,
      "col": 6,
      "isPlayerFirst": 0.0
    };
    outerSidePointIndex++;

    gameGridArray[6][6] = outerSidePoint[outerSidePointIndex];
    outerSidePoint[outerSidePointIndex] = {
      ...outerSidePoint[outerSidePointIndex],
      "row": 6,
      "col": 6,
      "isPlayerFirst": 0.0
    };
    outerSidePointIndex++;

    gameGridArray[6][3] = outerSidePoint[outerSidePointIndex];
    outerSidePoint[outerSidePointIndex] = {
      ...outerSidePoint[outerSidePointIndex],
      "row": 6,
      "col": 3,
      "isPlayerFirst": 0.0
    };
    outerSidePointIndex++;

    gameGridArray[6][0] = outerSidePoint[outerSidePointIndex];
    outerSidePoint[outerSidePointIndex] = {
      ...outerSidePoint[outerSidePointIndex],
      "row": 6,
      "col": 0,
      "isPlayerFirst": 0.0
    };
    outerSidePointIndex++;

    gameGridArray[3][0] = outerSidePoint[outerSidePointIndex];
    outerSidePoint[outerSidePointIndex] = {
      ...outerSidePoint[outerSidePointIndex],
      "row": 3,
      "col": 0,
      "isPlayerFirst": 0.0
    };
    outerSidePointIndex++;

    outerSidePoint
        .addAll(getClickablePoint(positionX, positionY, rectSizeList[1]));

    gameGridArray[1][1] = outerSidePoint[outerSidePointIndex];
    outerSidePoint[outerSidePointIndex] = {
      ...outerSidePoint[outerSidePointIndex],
      "row": 1,
      "col": 1,
      "isPlayerFirst": 0.0
    };
    outerSidePointIndex++;

    gameGridArray[1][3] = outerSidePoint[outerSidePointIndex];
    outerSidePoint[outerSidePointIndex] = {
      ...outerSidePoint[outerSidePointIndex],
      "row": 1,
      "col": 3,
      "isPlayerFirst": 0.0
    };
    outerSidePointIndex++;

    gameGridArray[1][5] = outerSidePoint[outerSidePointIndex];
    outerSidePoint[outerSidePointIndex] = {
      ...outerSidePoint[outerSidePointIndex],
      "row": 1,
      "col": 5,
      "isPlayerFirst": 0.0
    };
    outerSidePointIndex++;

    gameGridArray[3][5] = outerSidePoint[outerSidePointIndex];
    outerSidePoint[outerSidePointIndex] = {
      ...outerSidePoint[outerSidePointIndex],
      "row": 3,
      "col": 5,
      "isPlayerFirst": 0.0
    };
    outerSidePointIndex++;

    gameGridArray[5][5] = outerSidePoint[outerSidePointIndex];
    outerSidePoint[outerSidePointIndex] = {
      ...outerSidePoint[outerSidePointIndex],
      "row": 5,
      "col": 5,
      "isPlayerFirst": 0.0
    };
    outerSidePointIndex++;

    gameGridArray[5][3] = outerSidePoint[outerSidePointIndex];
    outerSidePoint[outerSidePointIndex] = {
      ...outerSidePoint[outerSidePointIndex],
      "row": 5,
      "col": 3,
      "isPlayerFirst": 0.0
    };
    outerSidePointIndex++;

    gameGridArray[5][1] = outerSidePoint[outerSidePointIndex];
    outerSidePoint[outerSidePointIndex] = {
      ...outerSidePoint[outerSidePointIndex],
      "row": 5,
      "col": 1,
      "isPlayerFirst": 0.0
    };
    outerSidePointIndex++;

    gameGridArray[3][1] = outerSidePoint[outerSidePointIndex];
    outerSidePoint[outerSidePointIndex] = {
      ...outerSidePoint[outerSidePointIndex],
      "row": 3,
      "col": 1,
      "isPlayerFirst": 0.0
    };
    outerSidePointIndex++;

    outerSidePoint
        .addAll(getClickablePoint(positionX, positionY, rectSizeList[2]));

    gameGridArray[2][2] = outerSidePoint[outerSidePointIndex];
    outerSidePoint[outerSidePointIndex] = {
      ...outerSidePoint[outerSidePointIndex],
      "row": 2,
      "col": 2,
      "isPlayerFirst": 0.0
    };
    outerSidePointIndex++;

    gameGridArray[2][3] = outerSidePoint[outerSidePointIndex];
    outerSidePoint[outerSidePointIndex] = {
      ...outerSidePoint[outerSidePointIndex],
      "row": 2,
      "col": 3,
      "isPlayerFirst": 0.0
    };
    outerSidePointIndex++;

    gameGridArray[2][4] = outerSidePoint[outerSidePointIndex];
    outerSidePoint[outerSidePointIndex] = {
      ...outerSidePoint[outerSidePointIndex],
      "row": 2,
      "col": 4,
      "isPlayerFirst": 0.0
    };
    outerSidePointIndex++;

    gameGridArray[3][4] = outerSidePoint[outerSidePointIndex];
    outerSidePoint[outerSidePointIndex] = {
      ...outerSidePoint[outerSidePointIndex],
      "row": 3,
      "col": 4,
      "isPlayerFirst": 0.0
    };
    outerSidePointIndex++;

    gameGridArray[4][4] = outerSidePoint[outerSidePointIndex];
    outerSidePoint[outerSidePointIndex] = {
      ...outerSidePoint[outerSidePointIndex],
      "row": 4,
      "col": 4,
      "isPlayerFirst": 0.0
    };
    outerSidePointIndex++;

    gameGridArray[4][3] = outerSidePoint[outerSidePointIndex];
    outerSidePoint[outerSidePointIndex] = {
      ...outerSidePoint[outerSidePointIndex],
      "row": 4,
      "col": 3,
      "isPlayerFirst": 0.0
    };
    outerSidePointIndex++;

    gameGridArray[4][2] = outerSidePoint[outerSidePointIndex];
    outerSidePoint[outerSidePointIndex] = {
      ...outerSidePoint[outerSidePointIndex],
      "row": 4,
      "col": 2,
      "isPlayerFirst": 0.0
    };
    outerSidePointIndex++;

    gameGridArray[3][2] = outerSidePoint[outerSidePointIndex];
    outerSidePoint[outerSidePointIndex] = {
      ...outerSidePoint[outerSidePointIndex],
      "row": 3,
      "col": 2,
      "isPlayerFirst": 0.0
    };
    outerSidePointIndex++;

    gameGridArray[3][3] = {"isNull": 1, "isPlayerFirst": 0.0};

    createPositionMap(gameGridArray);
  }

  @override // Add from here...
  KeyEventResult onKeyEvent(
      RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    super.onKeyEvent(event, keysPressed);
    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowLeft:
      case LogicalKeyboardKey.arrowRight:
      case LogicalKeyboardKey.space:
        print("clicked space");
        // remove everything and show tap to play
        // removeAll(children);
        removeAll(children.query<CoinPiece>());
        removeAll(children.query<Square>());
        removeAll(children.query<TextComponent>());
        removeAll(children.query<RectangleComponent>());
        playState = PlayState.welcome;
    }
    return KeyEventResult.handled;
  }

  @override
  void onTapUp(TapUpEvent event) {
    print("408------onTapUp");
    print(event.localPosition);
    // Do something in response to a tap event
  }

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    playState = PlayState.welcome; // Add from here...
  }

  List<Map<String, double>> getClickablePoint(
      double positionX, double positionY, double startSize) {
    List<Map<String, double>> clickablePointCoordinates = [
      {"xPos": positionX - startSize / 2, "yPos": positionY - startSize / 2},
      {"xPos": positionX, "yPos": positionY - startSize / 2},
      {"xPos": positionX + startSize / 2, "yPos": positionY - startSize / 2},
      {"xPos": positionX + startSize / 2, "yPos": positionY},
      {"xPos": positionX + startSize / 2, "yPos": positionY + startSize / 2},
      {"xPos": positionX, "yPos": positionY + startSize / 2},
      {"xPos": positionX - startSize / 2, "yPos": positionY + startSize / 2},
      {"xPos": positionX - startSize / 2, "yPos": positionY},
    ];
    return clickablePointCoordinates;
  }

  bool isPositionFilled(double currentX, double currentY) {
    List<int>? currentRowAndCol = getRowColumn[currentX]![currentY];
    if (gameGridArray[currentRowAndCol![0]][currentRowAndCol[1]]
                ["isPlayerFirst"] ==
            null ||
        double.parse(gameGridArray[currentRowAndCol![0]][currentRowAndCol[1]]
                    ["isPlayerFirst"]
                .toString()) ==
            0.0) {
      return false;
    }
    return true;
  }

  int findMatchedPositionForCoinPiece(
      List<CoinPiece> list, double x, double y) {
    for (int index = 0; index < list.length; index++) {
      if (list[index].x.round() == x.round() &&
          list[index].y.round() == y.round()) {
        return index;
      }
    }
    return -1;
  }

  int findMatchedPositionForRectangleComponent(
      List<RectangleComponent> list, double x, double y) {
    for (int index = 0; index < list.length; index++) {
      if (list[index].x.round() == x.round() &&
          list[index].y.round() == y.round()) {
        return index;
      }
    }
    return -1;
  }

  int findMatchedPositionForCoordinates(
      List<Map<String, double>> list, double x, double y) {
    for (int index = 0; index < list.length; index++) {
      print(list[index]["xPos"]);
      if (list[index]["xPos"] == x && list[index]["yPos"] == y) {
        return index;
      }
    }
    return -1;
  }

  void addCoinToGridArray(
      List<List<Map<String, double>>> gameGridArray,
      List<Map<String, double>> allAvailablePoints,
      double x,
      double y,
      bool isPlayerFirst) {
    // first find the index in the outerSidePoint(clickable point) array
    int foundIndex =
        findMatchedPositionForCoordinates(allAvailablePoints, x, y);

    // based on the array fetch the index element in grid-array
    double currentGridRowDble = allAvailablePoints[foundIndex]["row"] as double;
    double currentGridColDble = allAvailablePoints[foundIndex]["col"] as double;

    int currentGridRow = currentGridRowDble.toInt();
    int currentGridCol = currentGridColDble.toInt();

    gameGridArray[currentGridRow][currentGridCol] = {
      ...gameGridArray[currentGridRow][currentGridCol],
      "isPlayerFirst": isPlayerFirst ? 1.0 : 2.0,
    };
  }

  List<Map<String, double>> getNearestCoordinates(
      List<Map<String, double>> list, double x, double y) {
    List<Map<String, double>> result = [];

    // first find the index in the outerSidePoint(clickable point) array
    int foundIndex = findMatchedPositionForCoordinates(list, x, y);

    // based on the array fetch the index element in grid-array
    double currentGridRowDble = list[foundIndex]["row"] as double;
    double currentGridColDble = list[foundIndex]["col"] as double;

    int currentGridRow = currentGridRowDble.toInt();
    int currentGridCol = currentGridColDble.toInt();

    print(outerSidePoint);
    print("Current index");
    print(currentGridRow);
    print(currentGridCol);

    // search in the top and add to result until the xPos is notNull
    int top = currentGridRow - 1;
    while (top >= 0) {
      if (gameGridArray[top][currentGridCol]["isNull"] != null) {
        break;
      }
      if (gameGridArray[top][currentGridCol]["xPos"] != null) {
        result.add({...gameGridArray[top][currentGridCol]});
        break;
      }
      top--;
    }

    print("after top");
    print(result);

    // search for bottom
    int bottom = currentGridRow + 1;
    while (bottom <= 6) {
      if (gameGridArray[bottom][currentGridCol]["isNull"] != null) {
        break;
      }
      if (gameGridArray[bottom][currentGridCol]["xPos"] != null) {
        result.add({...gameGridArray[bottom][currentGridCol]});
        break;
      }
      bottom++;
    }

    print("after bottom");
    print(result);

    // for bottom
    int left = currentGridCol - 1;
    while (left >= 0) {
      if (gameGridArray[currentGridRow][left]["isNull"] != null) {
        break;
      }

      if (gameGridArray[currentGridRow][left]["xPos"] != null) {
        result.add({...gameGridArray[currentGridRow][left]});
        break;
      }
      left--;
    }

    print("after left");
    print(result);

    // for right
    int right = currentGridCol + 1;
    while (right <= 6) {
      if (gameGridArray[currentGridRow][right]["isNull"] != null) {
        break;
      }
      if (gameGridArray[currentGridRow][right]["xPos"] != null) {
        result.add({...gameGridArray[currentGridRow][right]});
        break;
      }
      right++;
    }

    print("after right");
    print(result);

    print(gameGridArray);
    print("active-x and active y");
    print(activePositionX);
    print(activePositionY);
    print("current x and current y");
    print(x);
    print(y);
    print("result destination for the point");
    print(result);

    return result;
  }

  void addPointIfThreeDotConnected(
      List<List<Map<String, double>>> gameGridArray,
      double x,
      double y,
      bool isPlayerFirst) {
    double playerType = isPlayerFirst ? 1.0 : 2.0;

    List<Map<String, double?>> threeDotFirstLastCoordinates = [];
    List<Map<String, double>> threeDotCoordinates = [];

    for (int i = 0; i < gameGridArray.length; i++) {
      threeDotCoordinates = [];
      for (int j = 0; j < gameGridArray[0].length; j++) {
        if (i == 3 && j == 3) {
          if (threeDotCoordinates.length == 3) {
            threeDotFirstLastCoordinates.add({
              "x1": threeDotCoordinates[0]["xPos"],
              "y1": threeDotCoordinates[0]["yPos"],
              "x2": threeDotCoordinates[2]["xPos"],
              "y2": threeDotCoordinates[2]["yPos"],
              "x3": threeDotCoordinates[1]["xPos"],
              "y3": threeDotCoordinates[1]["yPos"],
            });
            gameGridIndexForThreeDotConnect.add({"row": i, "col": j});
          }
          threeDotCoordinates = [];
        }

        if (gameGridArray[i][j]["isPlayerFirst"] == playerType) {
          threeDotCoordinates.add({...gameGridArray[i][j]});
        }
      }
      if (threeDotCoordinates.length == 3) {
        threeDotFirstLastCoordinates.add({
          "x1": threeDotCoordinates[0]["xPos"],
          "y1": threeDotCoordinates[0]["yPos"],
          "x2": threeDotCoordinates[2]["xPos"],
          "y2": threeDotCoordinates[2]["yPos"],
          "x3": threeDotCoordinates[1]["xPos"],
          "y3": threeDotCoordinates[1]["yPos"],
        });
      }
    }

    print("after the row-wise is checked");
    print(threeDotFirstLastCoordinates);

    // if (threeDotFirstLastCoordinates.isEmpty) {
    for (int i = 0; i < gameGridArray.length; i++) {
      threeDotCoordinates = [];
      for (int j = 0; j < gameGridArray[0].length; j++) {
        if (i == 3 && j == 3) {
          if (threeDotCoordinates.length == 3) {
            threeDotFirstLastCoordinates.add({
              "x1": threeDotCoordinates[0]["xPos"],
              "y1": threeDotCoordinates[0]["yPos"],
              "x2": threeDotCoordinates[2]["xPos"],
              "y2": threeDotCoordinates[2]["yPos"],
              "x3": threeDotCoordinates[1]["xPos"],
              "y3": threeDotCoordinates[1]["yPos"],
            });
            gameGridIndexForThreeDotConnect.add({"row": i, "col": j});
          }
          threeDotCoordinates = [];
        }

        if (gameGridArray[j][i]["isPlayerFirst"] == playerType) {
          threeDotCoordinates.add({...gameGridArray[j][i]});
        }
      }

      print(threeDotCoordinates);

      if (threeDotCoordinates.length == 3) {
        threeDotFirstLastCoordinates.add({
          "x1": threeDotCoordinates[0]["xPos"],
          "y1": threeDotCoordinates[0]["yPos"],
          "x2": threeDotCoordinates[2]["xPos"],
          "y2": threeDotCoordinates[2]["yPos"],
          "x3": threeDotCoordinates[1]["xPos"],
          "y3": threeDotCoordinates[1]["yPos"],
        });
      }
    }
    // }

    print("after the column-wise is checked");
    print(threeDotFirstLastCoordinates);

    if (threeDotFirstLastCoordinates.isNotEmpty) {
      // threeDotCoordinates

      print("three dot-connected");
      print(threeDotFirstLastCoordinates);

      print("existingThreeDotConnected");
      print(existingThreeDotConnected);

      // add the line to the point in first and last position
      threeDotFirstLastCoordinates.forEach((firstLastCord) {
        // if the new-three-dot-connected is already exist then don't
        // create the opponent-player-circle and three-dot

        bool isThreeDotConnectExist = existingThreeDotConnected.any((element) =>
            element["x1"] == firstLastCord["x1"] &&
            element["y1"] == firstLastCord["y1"] &&
            element["x2"] == firstLastCord["x2"] &&
            element["y2"] == firstLastCord["y2"]);

        print("isThreeDotConnectExist: $isThreeDotConnectExist");

        if (!isThreeDotConnectExist) {
          if (allAvailableCoin - bluePlayerScore <= 3) {
            playState = PlayState.wonBlue;
          } else if (allAvailableCoin - redPlayerScore <= 3) {
            playState = PlayState.wonBlue;
          }

          RectangleComponent component = RectangleComponent(
            position:
                Vector2(firstLastCord["x1"]! - 2.5, firstLastCord["y1"]! - 2.5),
            size: Vector2((firstLastCord["x2"]! - firstLastCord["x1"]!) + 5,
                (firstLastCord["y2"]! - firstLastCord["y1"]!) + 5),
            paint: Paint()
              ..color = const Color(0xff48fa02)
              ..style = PaintingStyle.fill,
          );

          // add x and y coordinates to prevent to not-pickup the three-dot
          // connected coin if the coin > 3
          if (isPlayerFirstTurn) {
            playerFirstThreeDotCoordinates.addAll(threeDotCoordinates);
          } else {
            playerSecondThreeDotCoordinates.addAll(threeDotCoordinates);
          }

          threeDotConnectedRectangleComponent.add(component);
          existingThreeDotConnected.addAll(threeDotFirstLastCoordinates);

          // .add(
          // {
          //   "x1" : threeDotCoordinates[0]!["xPos"],
          //   "y1" : threeDotCoordinates[0]!["yPos"],
          //   "x2" : threeDotCoordinates[2]!["xPos"],
          //   "y2" : threeDotCoordinates[2]!["yPos"],
          // });
          add(component);

          // round-circle to color for the opposite-player-coin
          double opponentPlayer = !isPlayerFirstTurn ? 1.0 : 2.0;

          for (int i = 0; i < gameGridArray.length; i++) {
            for (int j = 0; j < gameGridArray[0].length; j++) {
              if (i == 3 && j == 3) {
                continue;
              }

              if (gameGridArray[i][j]["isPlayerFirst"] == opponentPlayer) {
                // store the opponent-circle
                removableCoinMapList.add({...gameGridArray[i][j]});

                CoinPiece coinPiece = CoinPiece(
                  position: Vector2(gameGridArray[i][j]["xPos"]!,
                      gameGridArray[i][j]["yPos"]!),
                  radius: coinCircleRadius - 10,
                  paint: Paint()
                    ..color = const Color(0xffffde00)
                    ..style = PaintingStyle.fill,
                );
                add(coinPiece);
                removableCoinPiece.add(coinPiece);
              }
            }
          }
        }
      });
    }
  }

  void clearState() {
    outerSidePoint = [];
    addedCirclePointForPlayerFirst = [];
    addedCirclePointForPlayerSecond = [];
    addedCoinForFirstPlayer = [];
    addedCoinForSecondPlayer = [];
    allCoinForMoving = [];
    activePositionX = 0.0;
    activePositionY = 0.0;
    allAvailableCoin = 9;
    bluePlayerCoin = 0;
    redPlayerCoin = 0;
    isPlayerFirstTurn = true;
    activeComponent = [];
    textComponent = [];
    gameGridArray = List.generate(
      7,
      (index) => List.generate(7, (index) => {}),
    );
    removableCoinMapList = [];
    threeDotConnectedRectangleComponent = [];
    removableCoinPiece = [];
    existingThreeDotConnected = [];
    gameGridIndexForThreeDotConnect = [];
    playerFirstThreeDotCoordinates = [];
    playerSecondThreeDotCoordinates = [];
    bluePlayerScore = 0;
    redPlayerScore = 0;
    getRowColumn = {};
  }

  @override
  void onTapDown(TapDownEvent event) async {
    print("-------onTapDown---");
    print(playState);

    if (playState == PlayState.welcome) {
      startGame();
      overlays.remove(PlayState.welcome.name);
    } else if (playState == PlayState.wonBlue ||
        playState == PlayState.wonRed) {
      removeAll(children.query<CoinPiece>());
      removeAll(children.query<Square>());
      removeAll(children.query<TextComponent>());
      removeAll(children.query<RectangleComponent>());
      clearState();

      playState = PlayState.welcome;
      startGame();
    }

    print("-------onTapDown 783---");

    // if (playState == PlayState.playing) return;

    double coinCircleX = event.localPosition.x;
    double coinCircleY = event.localPosition.y;

    for (int i = 0; i < outerSidePoint.length; i++) {
      double? currentX = outerSidePoint[i]["xPos"];
      double? currentY = outerSidePoint[i]["yPos"];

      double minX = currentX! - coinCircleRadius + 10;
      double minY = currentY! - coinCircleRadius + 10;
      double maxX = currentX! + coinCircleRadius + 10;
      double maxY = currentY! + coinCircleRadius + 10;

      if (minX <= coinCircleX &&
          maxX >= coinCircleX &&
          minY <= coinCircleY &&
          maxY >= coinCircleY) {
        // check the point is not placed before
        // check the currentX, currentY is not present in none of the players

        bool positionAlreadyFilled = isPositionFilled(currentX, currentY);

        // int findingIndexForSecondPlayer = findMatchedPositionForCoinPiece(addedCoinForSecondPlayer, currentX, currentY);
        // int findingIndexForFirstPlayer = findMatchedPositionForCoinPiece(addedCoinForFirstPlayer, currentX, currentY);

        print("positionAlreadyFilled:  $positionAlreadyFilled");
        if (positionAlreadyFilled == false) {
          // if the location is not field and all-coin got over
          if (isPlayerFirstTurn == true) {
            // blue player-turn

            // if the blue-coins are available and three-dot not connected
            if (bluePlayerCoin < allAvailableCoin &&
                removableCoinMapList.isEmpty) {
              // if the blue player has coin and the blue player has three-dot
              // then without removing opponent-player coin the blue-player
              // can't put more coin

              CoinPiece coinPiece = CoinPiece(
                position: Vector2(currentX, currentY),
                radius: coinCircleRadius,
                paint: Paint()
                  ..color = const Color(0xff085596)
                  ..style = PaintingStyle.fill,
              );

              allCoinForMoving.add(coinPiece);
              add(coinPiece);

              addedCirclePointForPlayerFirst
                  .add({"xPos": currentX, "yPos": currentY});

              addedCoinForFirstPlayer.add(coinPiece);

              // add the point to the grid-array
              addCoinToGridArray(gameGridArray, outerSidePoint, currentX,
                  currentY, isPlayerFirstTurn);

              print("after adding the point");
              print(gameGridArray);

              bluePlayerCoin++;

              // check if the three-dot connected
              addPointIfThreeDotConnected(
                  gameGridArray, currentX, currentY, isPlayerFirstTurn);
              // then make color three dot
              // then make green to opposite player to pick-up coin

              // if any coin is available to remove then the turn will change only
              // after the opponent player's coin is removed
              if (removableCoinMapList.length > 0) {
                // keep the blue-player-continue
                isPlayerFirstTurn = true;
              } else {
                // change the player-turn to red
                isPlayerFirstTurn = false;
              }
            } else {
              // code for move player-first coin-piece
              // first fetch the circle(CoinPiece-object) for first-player

              // check the clicked location can be moved or not
              // if the location can moved just move

              print("currentX : ${currentX}");
              print("currentY : ${currentY}");
              print("activePositionX : ${activePositionX}");
              print("activePositionY : ${activePositionY}");

              print("inside the ready to move the blue player");
              addedCoinForFirstPlayer.forEach((element) {
                print(element.x);
                print(element.y);
              });

              int findIndex = findMatchedPositionForCoinPiece(
                  addedCoinForFirstPlayer, activePositionX, activePositionY);
              print(findIndex);
              if (findIndex > -1) {
                // now need to check the destination is in the right-position for blue-player and
                // the coin can be moved to the location
                List<Map<String, double>> nearestCoordinates =
                    getNearestCoordinates(
                        outerSidePoint, activePositionX, activePositionY);

                int isCorrectCoordinates = findMatchedPositionForCoordinates(
                    nearestCoordinates, currentX, currentY);

                // search in the grid-array in top, bottom, left, right direction
                if (isCorrectCoordinates > -1) {
                  print(
                      "901 before addedCoinForFirstPlayer ${addedCoinForFirstPlayer[0].y}");
                  addedCoinForFirstPlayer[findIndex]
                      .moveCoin(0.10, Vector2(currentX, currentY));

                  for (int k = 0; k < existingThreeDotConnected.length; k++) {
                    if ((existingThreeDotConnected[k]["x1"] ==
                                activePositionX &&
                            existingThreeDotConnected[k]
                                    ["y1"] ==
                                activePositionY) ||
                        (existingThreeDotConnected[k]["x2"] ==
                                activePositionX &&
                            existingThreeDotConnected[k]["y2"] ==
                                activePositionY) ||
                        (existingThreeDotConnected[k]["x3"] ==
                                activePositionX &&
                            existingThreeDotConnected[k]["y3"] ==
                                activePositionY)) {
                      print("Remove k : $k");
                      existingThreeDotConnected.removeAt(k);
                    }
                  }

                  print(
                      "904 after addedCoinForFirstPlayer ${addedCoinForFirstPlayer[0].y}");

                  int findCoordinateIndex = findMatchedPositionForCoordinates(
                      addedCirclePointForPlayerFirst,
                      activePositionX,
                      activePositionY);

                  addedCirclePointForPlayerFirst[findCoordinateIndex] = {
                    "xPos": currentX,
                    "yPos": currentY
                  };

                  for (int i = 0; i < activeComponent.length; i++) {
                    remove(activeComponent[i]);
                  }

                  // check if the three-dot connected
                  // then make color three dot
                  // then make green to opposite player to pick-up coin
                  List<int>? currentRowAndCol =
                      getRowColumn[currentX]![currentY];
                  List<int>? preRowAndCol =
                      getRowColumn[activePositionX]![activePositionY];

                  print("preRowAndCol");
                  print(preRowAndCol);
                  print("currentRowAndCol");
                  print(currentRowAndCol);

                  print("933 before gameGridArray");
                  print(gameGridArray);
                  gameGridArray[preRowAndCol![0]][preRowAndCol[1]]
                      ["isPlayerFirst"] = 0.0;
                  gameGridArray[currentRowAndCol![0]][currentRowAndCol[1]]
                      ["isPlayerFirst"] = isPlayerFirstTurn ? 1.0 : 2.0;

                  print("940 after gameGridArray");
                  print(gameGridArray);

                  addPointIfThreeDotConnected(
                      gameGridArray, currentX, currentY, isPlayerFirstTurn);

                  // if any coin is available to remove then the turn will change only
                  // after the opponent player's coin is removed
                  if (removableCoinMapList.length > 0) {
                    // keep the blue-player-continue
                    isPlayerFirstTurn = true;
                    redPlayerCoin++;
                  } else {
                    // change the player-turn to red
                    isPlayerFirstTurn = false;
                  }

                  // remove the active circle
                  activeComponent.clear();

                  activePositionX = activePositionY = 0.0;
                }
              }
            }
          } else {
            // red player-turn
            if (redPlayerCoin < allAvailableCoin &&
                removableCoinMapList.isEmpty) {
              CoinPiece coinPiece = CoinPiece(
                position: Vector2(currentX, currentY),
                radius: coinCircleRadius,
                paint: Paint()
                  ..color = const Color(0xffff0000)
                  ..style = PaintingStyle.fill,
              );

              allCoinForMoving.add(coinPiece);
              add(coinPiece);

              addedCirclePointForPlayerSecond
                  .add({"xPos": currentX, "yPos": currentY});
              addedCoinForSecondPlayer.add(coinPiece);
              // add the point to the grid-array
              addCoinToGridArray(gameGridArray, outerSidePoint, currentX,
                  currentY, isPlayerFirstTurn);

              // check if the three-dot connected
              // then make color three dot
              // then make green to opposite player to pick-up coin
              addPointIfThreeDotConnected(
                  gameGridArray, currentX, currentY, isPlayerFirstTurn);

              // if any coin is available to remove then the turn will change only
              // after the opponent player's coin is removed
              if (removableCoinMapList.length > 0) {
                // keep the red-player-continue
                isPlayerFirstTurn = false;
              } else {
                // change the player-turn to blue
                isPlayerFirstTurn = true;
              }
              redPlayerCoin++;
            } else {
              // code for move pf coin-piece

              print(currentX);
              print(currentY);
              print("inside the ready to move the red player");
              print(addedCoinForSecondPlayer);

              int findIndex = findMatchedPositionForCoinPiece(
                  addedCoinForSecondPlayer, activePositionX, activePositionY);
              print(findIndex);
              if (findIndex > -1) {
                // now need to check the destination is in the right-position for red-player and
                // the coin can be moved to the location
                List<Map<String, double>> nearestCoordinates =
                    getNearestCoordinates(
                        outerSidePoint, activePositionX, activePositionY);

                int isCorrectCoordinates = findMatchedPositionForCoordinates(
                    nearestCoordinates, currentX, currentY);

                if (isCorrectCoordinates > -1) {
                  addedCoinForSecondPlayer[findIndex]
                      .moveCoin(0.10, Vector2(currentX, currentY));

                  for (int k = 0; k < existingThreeDotConnected.length; k++) {
                    if ((existingThreeDotConnected[k]["x1"] ==
                                activePositionX &&
                            existingThreeDotConnected[k]
                                    ["y1"] ==
                                activePositionY) ||
                        (existingThreeDotConnected[k]["x2"] ==
                                activePositionX &&
                            existingThreeDotConnected[k]["y2"] ==
                                activePositionY) ||
                        (existingThreeDotConnected[k]["x3"] ==
                                activePositionX &&
                            existingThreeDotConnected[k]["y3"] ==
                                activePositionY)) {
                      print("Remove k : $k");
                      existingThreeDotConnected.removeAt(k);
                    }
                  }

                  int findCoordinateIndex = findMatchedPositionForCoordinates(
                      addedCirclePointForPlayerSecond,
                      activePositionX,
                      activePositionY);

                  addedCirclePointForPlayerSecond[findCoordinateIndex] = {
                    "xPos": currentX,
                    "yPos": currentY
                  };

                  for (int i = 0; i < activeComponent.length; i++) {
                    remove(activeComponent[i]);
                  }

                  // check if the three-dot connected
                  // then make color three dot
                  // then make green to opposite player to pick-up coin
                  List<int>? currentRowAndCol =
                      getRowColumn[currentX]![currentY];
                  List<int>? preRowAndCol =
                      getRowColumn[activePositionX]![activePositionY];

                  print("1047 preRowAndCol");
                  print(preRowAndCol);
                  print("1049 currentRowAndCol");
                  print(currentRowAndCol);

                  print("1053 before gameGridArray");
                  print(gameGridArray);
                  gameGridArray[preRowAndCol![0]][preRowAndCol[1]]
                      ["isPlayerFirst"] = 0.0;
                  gameGridArray[currentRowAndCol![0]][currentRowAndCol[1]]
                      ["isPlayerFirst"] = isPlayerFirstTurn ? 1.0 : 2.0;

                  print("1058 after gameGridArray");
                  print(gameGridArray);

                  addPointIfThreeDotConnected(
                      gameGridArray, currentX, currentY, isPlayerFirstTurn);

                  activeComponent.clear();

                  // remove the active circle
                  activePositionX = activePositionY = 0.0;

                  if (removableCoinMapList.isNotEmpty) {
                    isPlayerFirstTurn = false;
                  } else {
                    isPlayerFirstTurn = true;
                  }
                }
              }
            }
          }
        } else {
          // if the position is already filled
          // there can be three cases
          // case 1: red-player turn
          // case 2: blue player-turn and clicking the blue-player-because
          // to move the coin
          // case 3: to remove the coin of opponent-player and
          // get the position access and draw the big circle around position
          //

          // if the turn is for player blue don't touch the player
          // for red and vice-versa

          print("888 isPlayerFirstTurn : $isPlayerFirstTurn");
          if (isPlayerFirstTurn == true) {
            // if the turn is for blue-player

            print(
                "removableCoinMapList.isNotEmpty : ${removableCoinMapList.isNotEmpty}");
            if (removableCoinMapList.isNotEmpty) {
              // red-player-coin are ready to remove

              // check the removing coin is available or not
              int removingSecondPlayerIndex = findMatchedPositionForCoinPiece(
                  addedCoinForSecondPlayer, currentX, currentY);

              print(
                  "1035 removingSecondPlayerIndex: ${removingSecondPlayerIndex}");

              // checking the removing index belongs to second player
              bool isRemovingSecondPlayerCoin = removableCoinMapList.any(
                  (position) =>
                      position["xPos"] == currentX &&
                      position["yPos"] == currentY);

              print(
                  "1043 isRemovingSecondPlayerCoin: ${isRemovingSecondPlayerCoin}");

              if (removingSecondPlayerIndex > -1 &&
                  isRemovingSecondPlayerCoin) {
                print(
                    "1048 playerSecondThreeDotCoordinates : ${playerSecondThreeDotCoordinates.length}");
                print(playerSecondThreeDotCoordinates);

                if (playerSecondThreeDotCoordinates.length > 3) {
                  int existingThreeDotCoordinatesIndex =
                      findMatchedPositionForCoordinates(
                          playerSecondThreeDotCoordinates, currentX, currentY);

                  print(
                      "1057 existingThreeDotCoordinatesIndex : ${existingThreeDotCoordinatesIndex}");

                  if (existingThreeDotCoordinatesIndex > -1) {
                    break;
                  }

                  int indexForPositionCoordinates =
                      findMatchedPositionForCoordinates(
                          addedCirclePointForPlayerSecond, currentX, currentY);

                  addedCirclePointForPlayerSecond
                      .removeAt(indexForPositionCoordinates);

                  print("currentx");
                  print(currentX);
                  print("currenty");
                  print(currentY);
                  print("addedCoinForSecondPlayer");
                  print(addedCoinForSecondPlayer);
                  remove(addedCoinForSecondPlayer[removingSecondPlayerIndex]);
                  addedCoinForSecondPlayer.removeAt(removingSecondPlayerIndex);
                  removableCoinMapList.clear();

                  List<int>? pixelPositionToRowAndCol =
                      getRowColumn[currentX]![currentY];
                  gameGridArray[pixelPositionToRowAndCol![0]]
                      [pixelPositionToRowAndCol![1]] = {
                    "xPos": currentX,
                    "yPos": currentY
                  };
                  print("1067 after removing the game-grid");
                  print(gameGridArray);
                  remove(threeDotConnectedRectangleComponent[
                      threeDotConnectedRectangleComponent.length - 1]);

                  print(
                      "1093 existingThreeDotConnected : ${existingThreeDotConnected.length}");
                  print(existingThreeDotConnected);
                  for (int k = 0; k < existingThreeDotConnected.length; k++) {
                    if ((existingThreeDotConnected[k]["x1"] == currentX &&
                            existingThreeDotConnected[k]["y1"] == currentY) ||
                        (existingThreeDotConnected[k]["x2"] == currentX &&
                            existingThreeDotConnected[k]["y2"] == currentY) ||
                        (existingThreeDotConnected[k]["x3"] == currentX &&
                            existingThreeDotConnected[k]["y3"] == currentY)) {
                      print("Remove k : $k");
                      existingThreeDotConnected.removeAt(k);
                    }
                  }

                  // remove all removable-coin-piece-indicator
                  for (int j = 0; j < removableCoinPiece.length; j++) {
                    remove(removableCoinPiece[j]);
                  }
                  removableCoinPiece.clear();
                  // increase the score for blue-player
                  increaseTheBluePlayerScore();

                  isPlayerFirstTurn = false;
                } else {
                  int indexForPositionCoordinates =
                      findMatchedPositionForCoordinates(
                          addedCirclePointForPlayerSecond, currentX, currentY);

                  addedCirclePointForPlayerSecond
                      .removeAt(indexForPositionCoordinates);

                  print("currentx");
                  print(currentX);
                  print("currenty");
                  print(currentY);
                  print("addedCoinForSecondPlayer");
                  print(addedCoinForSecondPlayer);
                  remove(addedCoinForSecondPlayer[removingSecondPlayerIndex]);
                  addedCoinForSecondPlayer.removeAt(removingSecondPlayerIndex);
                  removableCoinMapList.clear();

                  List<int>? pixelPositionToRowAndCol =
                      getRowColumn[currentX]![currentY];
                  gameGridArray[pixelPositionToRowAndCol![0]]
                      [pixelPositionToRowAndCol![1]] = {
                    "xPos": currentX,
                    "yPos": currentY
                  };
                  print("after removing the game-grid");
                  print(gameGridArray);
                  remove(threeDotConnectedRectangleComponent[
                      threeDotConnectedRectangleComponent.length - 1]);

                  // remove all removable-coin-piece-indicator
                  for (int j = 0; j < removableCoinPiece.length; j++) {
                    remove(removableCoinPiece[j]);
                  }
                  removableCoinPiece.clear();
                  // increase the score for blue-player
                  increaseTheBluePlayerScore();

                  // remove the existingThreeDotConnected for red-player
                  print(
                      "1160 before existingThreeDotConnected : ${existingThreeDotConnected.length}");
                  print(existingThreeDotConnected);
                  for (int k = 0; k < existingThreeDotConnected.length; k++) {
                    if ((existingThreeDotConnected[k]["x1"] == currentX &&
                            existingThreeDotConnected[k]["y1"] == currentY) ||
                        (existingThreeDotConnected[k]["x2"] == currentX &&
                            existingThreeDotConnected[k]["y2"] == currentY) ||
                        (existingThreeDotConnected[k]["x3"] == currentX &&
                            existingThreeDotConnected[k]["y3"] == currentY)) {
                      print("Remove k : $k");
                      existingThreeDotConnected.removeAt(k);
                    }
                  }

                  isPlayerFirstTurn = false;
                }
              }
            } else {
              bool isMatching = addedCirclePointForPlayerFirst.any((position) =>
                  position["xPos"] == currentX && position["yPos"] == currentY);

              // the clicked coin is available in the list of first-player
              if (isMatching == true) {
                // if the active-component is empty then no any element is selected
                // else some element is chosen and the stroke circle is rendered
                if (activeComponent.isEmpty && removableCoinMapList.isEmpty) {
                  // if three-dot are not connected and the around-circle is
                  // also not available
                  activePositionX = currentX;
                  activePositionY = currentY;
                  double j = 0.1;
                  for (int i = 1; i < 25; i++) {
                    CoinPiece coinPieceSurround = CoinPiece(
                        position: Vector2(currentX, currentY),
                        radius: coinCircleRadius + j,
                        paint: Paint()
                          ..style = PaintingStyle.stroke
                          ..color = const Color(0xff05f505));
                    add(coinPieceSurround);
                    activeComponent.add(coinPieceSurround);
                    j += 0.1;
                  }
                } else if (removableCoinMapList.isNotEmpty) {
                  // three-dot connected
                  // remove the clicked-coin
                } else {
                  activePositionX = 0.0;
                  activePositionY = 0.0;
                  for (int i = 0; i < activeComponent.length; i++) {
                    remove(activeComponent[i]);
                  }
                  activeComponent.clear();

                  // code for removing the toggle active-component-circle
                  // double j = 0.1;
                  // for (int i = 1; i < 25; i++) {
                  //   CoinPiece coinPiece = CoinPiece(
                  //       position: Vector2(currentX, currentY),
                  //       radius: coinCircleRadius + j,
                  //       paint: Paint()
                  //         ..style = PaintingStyle.stroke
                  //         ..color = const Color(0xff05f505)
                  //   );
                  //   add(coinPiece);
                  //   activeComponent.add(coinPiece);
                  //   j += 0.1;
                  // }
                }
              }
            }
          } else if (isPlayerFirstTurn == false) {
            print(
                "1209 removableCoinMapList.isNotEmpty ${removableCoinMapList.isNotEmpty}");
            if (removableCoinMapList.isNotEmpty) {
              // blue-player-coin are ready to remove

              // check the removing coin is available or not
              int removingFirstPlayerIndex = findMatchedPositionForCoinPiece(
                  addedCoinForFirstPlayer, currentX, currentY);
              print(
                  "1223 removingFirstPlayerIndex: ${removingFirstPlayerIndex}");

              // checking the removing index belongs to first player
              bool isRemovingFirstPlayerCoin = removableCoinMapList.any(
                  (position) =>
                      position["xPos"] == currentX &&
                      position["yPos"] == currentY);

              print("isRemovingFirstPlayerCoin: ${isRemovingFirstPlayerCoin}");
              if (removingFirstPlayerIndex > -1 && isRemovingFirstPlayerCoin) {
                int indexForPositionCoordinates =
                    findMatchedPositionForCoordinates(
                        addedCirclePointForPlayerFirst, currentX, currentY);
                addedCirclePointForPlayerFirst
                    .removeAt(indexForPositionCoordinates);

                print("1241 currentx : $currentX");
                print("1242 currenty : $currentY");
                print(
                    "1243 addedCoinForFirstPlayer : $addedCoinForSecondPlayer");
                remove(addedCoinForFirstPlayer[removingFirstPlayerIndex]);
                addedCoinForFirstPlayer.removeAt(removingFirstPlayerIndex);
                removableCoinMapList.clear();

                List<int>? pixelPositionToRowAndCol =
                    getRowColumn[currentX]![currentY];
                gameGridArray[pixelPositionToRowAndCol![0]]
                    [pixelPositionToRowAndCol![1]] = {
                  "xPos": currentX,
                  "yPos": currentY
                };
                print("1255 after removing the game-grid");
                print(gameGridArray);
                remove(threeDotConnectedRectangleComponent[
                    threeDotConnectedRectangleComponent.length - 1]);

                // remove entry for existing x and y positions
                print(
                    "1261 before existingThreeDotConnected : $existingThreeDotConnected.length");
                print(existingThreeDotConnected);
                for (int k = 0; k < existingThreeDotConnected.length; k++) {
                  if ((existingThreeDotConnected[k]["x1"] == currentX &&
                          existingThreeDotConnected[k]["y1"] == currentY) ||
                      (existingThreeDotConnected[k]["x2"] == currentX &&
                          existingThreeDotConnected[k]["y2"] == currentY) ||
                      (existingThreeDotConnected[k]["x3"] == currentX &&
                          existingThreeDotConnected[k]["y3"] == currentY)) {
                    print("1272 Remove k : $k");
                    existingThreeDotConnected.removeAt(k);
                  }
                }
                print(
                    "1276 before existingThreeDotConnected : ${existingThreeDotConnected.length}");
                print(existingThreeDotConnected);

                // remove all removable-coin-piece-indicator
                for (int j = 0; j < removableCoinPiece.length; j++) {
                  remove(removableCoinPiece[j]);
                }
                removableCoinPiece.clear();
                // increase the score for blue-player
                increaseTheRedPlayerScore();

                isPlayerFirstTurn = true;
              }
            } else {
              bool isMatching = addedCirclePointForPlayerSecond.any(
                  (position) =>
                      position["xPos"] == currentX &&
                      position["yPos"] == currentY);

              if (isMatching == true) {
                // if the active-component is empty then no any element is selected
                // else some element is chosen and the stroke circle is rendered
                if (activeComponent.isEmpty) {
                  activePositionX = currentX;
                  activePositionY = currentY;
                  double j = 0.1;
                  for (int i = 1; i < 25; i++) {
                    CoinPiece coinPiece = CoinPiece(
                        position: Vector2(currentX, currentY),
                        radius: coinCircleRadius + j,
                        paint: Paint()
                          ..style = PaintingStyle.stroke
                          ..color = const Color(0xff05f505));
                    add(coinPiece);
                    activeComponent.add(coinPiece);
                    j += 0.1;
                  }
                } else {
                  activePositionX = 0.0;
                  activePositionY = 0.0;
                  for (int i = 0; i < activeComponent.length; i++) {
                    remove(activeComponent[i]);
                  }
                  activeComponent.clear();

                  // code for removing the toggle active-component-circle
                  // double j = 0.1;
                  // for (int i = 1; i < 25; i++) {
                  //   CoinPiece coinPiece = CoinPiece(
                  //       position: Vector2(currentX, currentY),
                  //       radius: coinCircleRadius + j,
                  //       paint: Paint()
                  //         ..style = PaintingStyle.stroke
                  //         ..color = const Color(0xff05f505)
                  //   );
                  //   add(coinPiece);
                  //   activeComponent.add(coinPiece);
                  //   j += 0.1;
                  // }
                }
              }
            }
          }
        }
        break;
      } else {
        // do-nothing if clicked outside of square-point
      }
    }

    print("textComponent : ${textComponent.length}");
    if (textComponent.isNotEmpty) {
      textComponent.forEach((element) {
        remove(element!);
      });
      textComponent.clear();
    }

    if (redPlayerCoin == allAvailableCoin) {
      textComponent.add(TextComponent(
          position: Vector2(positionX - 150, positionY - 390),
          text: " All Coin are placed "
              "\n Now move the coin"
          // "\n available coin: ${allAvailableCoin - bluePlayerCoin}",
          ));

      textComponent.add(TextComponent(
          position: Vector2(positionX + 150, positionY + 400),
          text: " All Coin are placed "
              "\n Now move the coin",
          angle: 3.14
          // "\n available coin: ${allAvailableCoin - bluePlayerCoin}",
          ));
    }

    textComponent.add(TextComponent(
        position: Vector2(positionX - 150, positionY - 320),
        text: "\nPlayer Turn : ${isPlayerFirstTurn == true ? "blue" : "red"}"
            "\n blue: score :${bluePlayerScore} and coin : ${bluePlayerCoin}"
            "\n red:  score : ${redPlayerScore} and coin : ${redPlayerCoin}"
        // "\n available coin: ${allAvailableCoin - bluePlayerCoin}",
        ));

    textComponent.add(TextComponent(
        position: Vector2(positionX + 150, positionY + 300),
        text: "Player Turn : ${isPlayerFirstTurn == true ? "blue" : "red"}"
            "\n blue: score :${bluePlayerScore} and coin : ${bluePlayerCoin}"
            "\n red:  score : ${redPlayerScore} and coin : ${redPlayerCoin}",
        // "\n available coin: ${allAvailableCoin - redPlayerCoin}",
        angle: 3.14));

    textComponent.forEach((element) {
      add(element!);
    });
  }
}
