import 'package:flutter/material.dart';
import 'package:simple_game/components/service/world_time.dart';

class ChooseLocation extends StatefulWidget {
  const ChooseLocation({super.key});

  @override
  State<ChooseLocation> createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {

  List<WorldTime> locations = [
    WorldTime(location: "India", flag: "india.jpg", url: "Asia/Kolkata"),
  WorldTime(location: "India", flag: "india.jpg", url: "Asia/Kolkata"),
  WorldTime(location: "India", flag: "india.jpg", url: "Asia/Kolkata"),
  WorldTime(location: "India", flag: "india.jpg", url: "Asia/Kolkata"),
  WorldTime(location: "India", flag: "india.jpg", url: "Asia/Kolkata"),
  WorldTime(location: "India", flag: "india.jpg", url: "Asia/Kolkata"),
  WorldTime(location: "India", flag: "india.jpg", url: "Asia/Kolkata"),
  WorldTime(location: "India", flag: "india.jpg", url: "Asia/Kolkata"),
  ];
  int counter = 0;

  void getData() async {
    String userName = "yoshi";

    String bio = "bio";

    print("$userName biodata is $bio");

  }
  
  
  @override
  void initState() {
    super.initState();
    getData();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Choose A location",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: ListView.builder(
        itemCount: locations.length,
        itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0 ),
          child: Card(child: ListTile(
            onTap: () {
              Navigator.pop(context);
            },
            title: Text(locations[index].location),
            leading: CircleAvatar(
              backgroundImage: AssetImage("assets/day.jpg"),
            ),
            // trailing: ,
          ),),
        );

        },
      ),
    );
  }
}
