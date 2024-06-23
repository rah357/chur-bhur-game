import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import '../coin_piece.dart';

class SquareBoard extends FlameGame with TapCallbacks {
  double interval = 120;
  double startSize = 370;
  double positionX = 0;
  double positionY = 0;
  double coinCircleRadius = 15;

  List<Map<String, double>> addedCirclePoint = [];


  @override
  Future<void> onLoad() async {


    List<double> rectList = [
      startSize,
      startSize - interval,
      startSize - (2 * interval)
    ];
    double width = 5;

    Paint paint = BasicPalette.white.paint();
    for(int i = 0; i < rectList.length; i++) {
      double size = rectList[i];

      add(RectangleComponent(
          position: Vector2(positionX, positionY + size / 2),
          size: Vector2.array([size, width]),
          angle: 0,
          anchor: Anchor.center,
          paint: paint
      ));

      add(RectangleComponent(
          position: Vector2(positionX - size / 2, positionY),
          size: Vector2.array([width, size]),
          angle: 0,
          anchor: Anchor.center,
          paint: paint
      ));

      add(RectangleComponent(
          position: Vector2(positionX + size / 2, positionY),
          size: Vector2.array([width, size]),
          angle: 0,
          anchor: Anchor.center,
          paint: paint
      ));

      add(RectangleComponent(
          position: Vector2(positionX, positionY - size / 2),
          size: Vector2.array([size, width]),
          angle: 0,
          anchor: Anchor.center,
          paint: paint
      ));
    }



    // bridge-between rectangle

    // bottom-up
    add(RectangleComponent(
        position: Vector2(positionX, positionY + (startSize - interval) / 2),
        size: Vector2.array([5, interval]),
        angle: 0,
        anchor: Anchor.center,
        paint: paint
    ));

    add(RectangleComponent(
        position: Vector2(positionX, positionY -  (startSize - interval) / 2),
        size: Vector2.array([5, interval]),
        angle: 0,
        anchor: Anchor.center,
        paint: paint
    ));


    // left-right bridge-line
    add(RectangleComponent(
        position: Vector2(positionX - (startSize - interval) / 2, positionY),
        size: Vector2.array([interval, 5]),
        angle: 0,
        anchor: Anchor.center,
        paint: paint
    ));

    add(RectangleComponent(
        position: Vector2(positionX + (startSize - interval) / 2, positionY),
        size: Vector2.array([interval, 5]),
        angle: 0,
        anchor: Anchor.center,
        paint: paint
    ));

    // add(TapTarget());
  }

  @override
  void onTapUp(TapUpEvent event) {

    print("onTapUp");
    // Do something in response to a tap event
  }

  List<Map<String, double>> getClickablePoint(double positionX,
      double positionY, double startSize) {
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


  @override
  void onTapDown(TapDownEvent event) {

    double coinCircleX = event.localPosition.x;
    double coinCircleY = event.localPosition.y;

    List<double> rectSizeList = [
      startSize,
      startSize - interval,
      startSize - (2 * interval)
    ];


    List<Map<String, double>> outerSidePoint = getClickablePoint(positionX,
        positionY, startSize
    );

    outerSidePoint.addAll(getClickablePoint(positionX, positionY,
        rectSizeList[1]));
    outerSidePoint.addAll(getClickablePoint(positionX, positionY,
        rectSizeList[2]));

    for(int i = 0; i < outerSidePoint.length; i++) {
      double? currentX = outerSidePoint[i]["xPos"];
      double? currentY = outerSidePoint[i]["yPos"];

      double minX = currentX! - coinCircleRadius;
      double minY = currentY! - coinCircleRadius;
      double maxX = currentX! + coinCircleRadius;
      double maxY = currentY! + coinCircleRadius;


      if(minX <= coinCircleX && maxX >= coinCircleX && minY <= coinCircleY && maxY >= coinCircleY
          && addedCirclePoint.length <= 3
      ) {
        addedCirclePoint.add({"xPos": currentX, "yPos": currentY});
        add(
            CoinPiece(
                position: Vector2(currentX, currentY),
                radius: coinCircleRadius,
              paint:     Paint()
                ..color = const Color(0xff085596)
                ..style = PaintingStyle.fill,

            )
        );
        // world.children.query<CoinPiece>().first.moveCoin();
      } else {
        // world.children.query<CoinPiece>().first.moveCoin();
      }

    }



    // add(HoverTarget(event.canvasPosition));
  }

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);
  }
}
