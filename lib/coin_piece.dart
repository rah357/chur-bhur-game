import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import './components/game_board.dart';

class CoinPiece extends CircleComponent with HasGameReference<GameBoard>{
  double count = 1;
  bool isReached = false;
  CoinPiece({
    required super.position,
    required double radius,
    required Paint paint
  }) : super(
    radius: radius,
    anchor: Anchor.center,
    paint: paint
  );


  void moveCoin (double dx, Vector2 destination) {
    add(MoveToEffect(
      destination,
      EffectController(duration: 0.4),
    ));
  }
}