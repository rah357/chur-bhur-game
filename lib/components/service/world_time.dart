import 'package:http/http.dart';
import 'dart:convert';

class WorldTime {
  String location;
  String? time;
  String flag;
  String url;
  bool? isDayTime;


  WorldTime({required this.location, required this.flag, required this.url});

  Future<void> getTime() async {
    print(">>>>>>>>>>>>> invoked getTime()");
    try {
      final response = await get(Uri.parse("http://worldtimeapi.org/api/timezone/Asia/Kolkata"));
      print(response);
      Map jsonData = jsonDecode(response.body);
      print(jsonData);
      String dateTime = jsonData['datetime'];
      String offSet = jsonData['utc_offset'].toString().substring(1, 3);
      DateTime currentDateTime = DateTime.parse(dateTime);
      currentDateTime = currentDateTime.add(Duration(hours: int.parse(offSet)));
      time = currentDateTime.toString();

      // time = DateFormat.jm().format(currentDateTime);
      print(time);

      isDayTime = currentDateTime.hour > 6 && currentDateTime.hour < 20 ?
            true : false;

      print(">>>>>>>>>>>>> invoked completed getTime()");
    } catch(error) {
      print("Error caught is = $error");
      time = "Can't load the time now";
    }
  }
}

