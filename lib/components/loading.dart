import 'package:flutter/material.dart';
import 'package:simple_game/components/service/world_time.dart';


class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  var time = "loading....";


  void setupWorldTime() async {
    WorldTime worldTime = WorldTime(location: "India", flag: "india.jpg", url: "Asia/Kolkata");
    await worldTime.getTime();
    Navigator.pushNamed(context, "/home", arguments: {
      'location': worldTime.location,
      'flag': worldTime.flag,
      'time': worldTime.time,
      'isDayTime': worldTime.isDayTime
    });
  }

  @override
  void initState() {
    print(">>>>>>>>>>>> invoked initState()");
    super.initState();
    setupWorldTime();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        // child: SpinKitDualRing(
        //   color: Colors.white,
        //   size: 50.0,
        // ),
      )
    );
  }
}
