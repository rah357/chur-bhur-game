import 'dart:async';
import 'dart:io';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';

class RunningProcessesPage extends StatefulWidget {
  @override
  _RunningProcessesPageState createState() => _RunningProcessesPageState();
}

class _RunningProcessesPageState extends State<RunningProcessesPage> {
  String _processOutput = '';

  Future<void> _getRunningProcesses() async {
    try {
      Application? apps = await DeviceApps.getApp("com.google.android.gm");


      print(apps);
      // final ProcessResult result = await Process.run('ps', []);
      // for(Application app in apps) {
      //   print("===appnem = ===  "+app.appName);
      // }


      setState(() {
        // _processOutput = apps as String;
      });
    } catch (e) {
      setState(() {
        _processOutput = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home:Scaffold(
      appBar: AppBar(
        title: Text('Running Processes'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _getRunningProcesses,
              child: Text('Get Running Processes'),
            ),
            SizedBox(height: 20),
            Text(_processOutput),
          ],
        ),
      ),
    )
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: RunningProcessesPage(),
  ));
}
