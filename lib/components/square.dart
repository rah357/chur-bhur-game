import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import '../game2/config.dart';

class Square extends PositionComponent with TapCallbacks{
  Square({
    required super.position,
    required super.size,
  }) : super(
    anchor: Anchor.center,
  );

  double interval = 100;
  double startSize = 350;
  double positionX = 0;
  double positionY = 0;
  double coinCircleRadius = 15;

  List<Map<String, double>> addedCirclePoint = [];


  final _paint = Paint()
    ..color = const Color(0xff1e6091)
    ..style = PaintingStyle.fill;

  @override
  void render(Canvas canvas) {
    // add(RectangleComponent(
    //     position: Vector2(400, 500),
    //     size: Vector2.array([100, 200]),
    //     angle: 0,
    //     anchor: Anchor.center,
    //     paint: BasicPalette.blue.paint()
    // ));



    super.render(canvas);

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

  }

  // @override
  // void onDragUpdate(DragUpdateEvent event) {
  //   super.onDragUpdate(event);
  //   position.x = (position.x + event.localDelta.x)
  //       .clamp(width / 2, game.width - width / 2);
  // }


  void moveBy(double dx) {
    // add(MoveToEffect(
    //   Vector2(
    //     (position.x + dx).clamp(width / 2, game.width - width / 2),
    //     position.y,
    //   ),
    //   EffectController(duration: 0.1),
    // ));
  }
}
