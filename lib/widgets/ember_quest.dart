// import 'package:flame/game.dart';
// import './ember.dart';
//
// class EmberQuestGame extends FlameGame {
//   EmberQuestGame();
//   late EmberPlayer _ember;
//
//   @override
//   Future<void> onLoad() async {
//     await images.loadAll([
//       'block.png',
//       'ember.png',
//       'ground.png',
//       'heart_half.png',
//       'heart.png',
//       'star.png',
//       'water_enemy.png',
//     ]);
//     _ember = EmberPlayer(
//       position: Vector2(128, canvasSize.y - 70),
//     );
//     add(_ember);
//
//     initializeGame(true);
//   }
//
//   void initializeGame(bool loadHud) {
//     // Assume that size.x < 3200
//     final segmentsToLoad = (size.x / 640).ceil();
//     segmentsToLoad.clamp(0, segmentsToLoad.length);
//
//     for (var i = 0; i <= segmentsToLoad; i++) {
//       loadGameSegments(i, (640 * i).toDouble());
//     }
//
//     _ember = EmberPlayer(
//       position: Vector2(128, canvasSize.y - 128),
//     );
//     add(_ember);
//     if (loadHud) {
//       add(Hud());
//     }
//   }
//
//   void reset() {
//     starsCollected = 0;
//     health = 3;
//     initializeGame(false);
//   }}
//
