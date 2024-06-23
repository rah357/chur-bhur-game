import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import "./../components/game_board.dart";

// import '../config.dart';
class ThreeDotGameApp extends StatelessWidget {
  const ThreeDotGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          useMaterial3: true,
          textTheme: GoogleFonts.pressStart2pTextTheme().apply(
            bodyColor: const Color(0xff184e77),
            displayColor: const Color(0xff184e77),
          )),
      home: Scaffold(
        // appBar: AppBar(
        //   title: Text("Chur Bhur game"),
        // ),
        body: Container(
          // decoration: const BoxDecoration(
          //   gradient: LinearGradient(
          //     begin: Alignment.topCenter,
          //     end: Alignment.bottomCenter,
          //     colors: [
          //       Color(0xffa9d6e5),
          //       Color(0xfff2e8cf),
          //     ],
          //   ),
          // ),
          child: GameWidget.controlled(
            gameFactory: GameBoard.new,
            overlayBuilderMap: {
              PlayState.welcome.name: (context, game) => Center(
                      child:
                  //     ElevatedButton(
                  //   onPressed: () {
                  //     // Add your onPressed logic here
                  //   },
                  //   child:
                  //   Column(
                  //     children: [
                  //       Text('Learn Ho To play'),
                  //       Text('Learn Ho To play'),
                  //     ],
                  //   ),
                  // )

                      Text(
                        'Click Below',
                        style: Theme.of(context).textTheme.headlineLarge,
                        textAlign: TextAlign.center,
                      ),
                      ),
              // PlayState.welcome.name: (context, game) => Center(
              //     child: ElevatedButton(
              //       onPressed: () {
              //         // Add your onPressed logic here
              //       },
              //       child: Text('Learn How To play'),
              //     )
              //
              //   // Text(
              //   //   'Click Below',
              //   //   style: Theme.of(context).textTheme.headlineLarge,
              //   //   textAlign: TextAlign.center,
              //   // ),
              // ),
              PlayState.gameOver.name: (context, game) => Center(
                    child: Text(
                      'G A M E   O V E R',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
              PlayState.wonBlue.name: (context, game) => Center(
                    child: Text(
                      'B L U E  W O N ! ! !',
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(
                            color: Theme.of(context).colorScheme.onError,
                          ),
                    ),
                  ),
              PlayState.wonRed.name: (context, game) => Center(
                    child: Text(
                      'R E D   W O N ! ! !',
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(
                            color: Theme.of(context).colorScheme.onError,
                          ),
                    ),
                  ),
            },
          ),
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     debugShowCheckedModeBanner: false,
  //     theme: ThemeData(
  //       useMaterial3: true,
  //       textTheme: GoogleFonts.pressStart2pTextTheme().apply(
  //         bodyColor: const Color(0xff184e77),
  //         displayColor: const Color(0xff184e77),
  //       ),
  //     ),
  //     home: Scaffold(
  //       // appBar: AppBar(
  //       //   title: Text("Chur Bhur"),
  //       // ),
  //       body: Container(
  //         decoration: const BoxDecoration(
  //           gradient: LinearGradient(
  //             begin: Alignment.topCenter,
  //             end: Alignment.bottomCenter,
  //             colors: [
  //               Color(0xffa9d6e5),
  //               Color(0xfff2e8cf),
  //             ],
  //           ),
  //         ),
  //         child: SafeArea(
  //           child: Padding(
  //             padding: const EdgeInsets.all(0),
  //             child: Center(
  //               child: FittedBox(
  //                 child: SizedBox(
  //                   width: MediaQuery.of(context).size.width,
  //                   height: MediaQuery.of(context).size.height,
  //                   child: Column(
  //                     children: [
  //                       ElevatedButton(
  //                         style: ElevatedButton.styleFrom(
  //                           minimumSize: Size.fromHeight(40), // fromHeight use double.infinity as width and 40 is the height
  //                         ),
  //                         onPressed: () {},
  //                         child: Text('Text Of Button'),
  //                       ),
  //                       ElevatedButton(
  //                         style: ElevatedButton.styleFrom(
  //                           minimumSize: Size.fromHeight(40), // fromHeight use double.infinity as width and 40 is the height
  //                         ),
  //                         onPressed: () {},
  //                         child: Text('Text Of Button'),
  //                       ),
  //                       ElevatedButton(
  //                         style: ElevatedButton.styleFrom(
  //                           minimumSize: Size.fromHeight(40), // fromHeight use double.infinity as width and 40 is the height
  //                         ),
  //                         onPressed: () {},
  //                         child: Text('Text Of Button'),
  //                       ),
  //                       ElevatedButton(
  //                         style: ElevatedButton.styleFrom(
  //                           minimumSize: Size.fromHeight(40), // fromHeight use double.infinity as width and 40 is the height
  //                         ),
  //                         onPressed: () {},
  //                         child: Text('Text Of Button'),
  //                       ),
  //                       // GameWidget.controlled(
  //                       //   gameFactory: GameBoard.new,
  //                       //   overlayBuilderMap: {
  //                       //     PlayState.welcome.name: (context, game) => Center(
  //                       //             child: Text(
  //                       //           'Click Below',
  //                       //           style: Theme.of(context).textTheme.headlineLarge,
  //                       //               textAlign: TextAlign.center,
  //                       //         )),
  //                       //     PlayState.gameOver.name: (context, game) => Center(
  //                       //           child: Text(
  //                       //             'G A M E   O V E R',
  //                       //             style:
  //                       //                 Theme.of(context).textTheme.headlineLarge,
  //                       //           ),
  //                       //         ),
  //                       //     PlayState.wonBlue.name: (context, game) => Center(
  //                       //           child: Text(
  //                       //             'B L U E  W O N ! ! !',
  //                       //             style:
  //                       //             Theme.of(context).textTheme.headlineLarge?.copyWith(
  //                       //               color:  Theme.of(context).colorScheme.onError,
  //                       //             ),
  //                       //           ),
  //                       //         ),
  //                       //     PlayState.wonRed.name: (context, game) => Center(
  //                       //       child: Text(
  //                       //         'R E D   W O N ! ! !',
  //                       //         style:
  //                       //         Theme.of(context).textTheme.headlineLarge?.copyWith(
  //                       //           color:  Theme.of(context).colorScheme.onError,
  //                       //         ),
  //                       //
  //                       //       ),
  //                       //     ),
  //                       //
  //                       //   },
  //                       // ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
