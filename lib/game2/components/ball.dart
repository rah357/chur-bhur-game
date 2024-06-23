import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';                           // Add this import
import 'package:flutter/material.dart';
import 'package:simple_game/game2/components/components.dart';
import '../brick_breaker.dart';                                 // And this import
import 'brick.dart';                                            // Add this import


class Ball extends CircleComponent with CollisionCallbacks, HasGameReference<BrickBreaker>{
  Ball({
    required this.velocity,
    required super.position,
    required double radius,
    required this.difficultyModifier,                           // Add this parameter
  }) : super(
      radius: radius,
      anchor: Anchor.center,
      paint: Paint()
        ..color = const Color(0xff1e6091)
        ..style = PaintingStyle.fill,
      children: [CircleHitbox()]
  );

  final Vector2 velocity;
  final double difficultyModifier;                              // Add this member


  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;
  }




  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is PlayArea) {
      if (intersectionPoints.first.y <= 0) {
        velocity.y = -velocity.y;
      } else if (intersectionPoints.first.x <= 0) {
        velocity.x = -velocity.x;
      } else if (intersectionPoints.first.x >= game.width) {
        velocity.x = -velocity.x;
      } else if (intersectionPoints.first.y >= game.height) {
        add(RemoveEffect(                                       // Modify from here...
          delay: 0.35,
            onComplete: () {                                    // Modify from here
              game.playState = PlayState.gameOver;
            }
        ));
      }
    } else if (other is Bat) {
      velocity.y = -velocity.y;
      velocity.x = velocity.x +
          (position.x - other.position.x) / other.size.x * game.width * 0.3;
    } else if (other is Brick) {                                // Modify from here...
      if (position.y < other.position.y - other.size.y / 2) {
        velocity.y = -velocity.y;
      } else if (position.y > other.position.y + other.size.y / 2) {
        velocity.y = -velocity.y;
      } else if (position.x < other.position.x) {
        velocity.x = -velocity.x;
      } else if (position.x > other.position.x) {
        velocity.x = -velocity.x;
      }
      velocity.setFrom(velocity * difficultyModifier);          // To here.
    }

  }
}
