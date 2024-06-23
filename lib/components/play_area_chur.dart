import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import './game_board.dart';

class PlayArea extends RectangleComponent with HasGameReference<GameBoard> {
  PlayArea()
      : super(
    paint: Paint()..color = const Color(0xff00ff00),
  );

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    size = Vector2(game.width, game.height);
  }
}
