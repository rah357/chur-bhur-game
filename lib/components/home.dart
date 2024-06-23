import 'package:flutter/material.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Map routeData = {};
  @override
  Widget build(BuildContext context) {

      routeData = ModalRoute.of(context)?.settings.arguments as Map;
      print(routeData);

      String bgImage = routeData['isDayTime'] ? 'day.jpg' : 'night.jpg';



    return Scaffold(
      body: SafeArea(child: 
      Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/$bgImage"),
            fit: BoxFit.cover
          )
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 120.0, 0.0, 0.0),
          child: Column(
            children: [
              TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, "/location");
                  },
                  icon: Icon(Icons.edit_location),
                label: Text("Edit Location"),
              ),
              SizedBox(height: 20.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text(routeData['location'], style: TextStyle(
                  fontSize: 28.0,
                  letterSpacing: 2.0
                ),
                ),
              ],),
              SizedBox(height: 8.0,),
              Text(routeData['time'], style: TextStyle(
                  fontSize: 66.0
              ),),
              TextButton(onPressed: () {
                Navigator.pushNamed(context, "/location");
              }, child: Text("Choose Location"))
            ],
        
          ),
        ),
      )),
    );
  }
}
