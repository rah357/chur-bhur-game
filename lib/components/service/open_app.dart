//
// import 'dart:io';
//
// import 'package:external_app_launcher/external_app_launcher.dart';
// import 'package:flutter/material.dart';
// import 'package:installed_apps/installed_apps.dart';
//
// class OpenApp extends StatefulWidget {
//   const OpenApp({Key? key}) : super(key: key);
//
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<OpenApp> {
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   Color containerColor = Colors.red;
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Plugin example app'),
//         ),
//         body: Center(
//           child: SizedBox(
//             height: 200,
//             width: 150,
//             child: Column(
//               children: [
//                 ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue,
//                     ),
//                     onPressed: () async {
//                       // var openAppResult = await LaunchApp.openApp(
//                       //   androidPackageName: 'com.linkedin.android',
//                       // );
//
//                       var result = await Process.run('ls', ['-l']);
//                       print("Running process");
//                       print(result.pid);
//                       print("Running process");
//
//                       var openAppResult = await InstalledApps.openSettings(
//                          "com.linkedin.android"
//
//                         // p: 'com.linkedin.android',
//
//                       );
//
//                       print(
//
//                           'openAppResult => $openAppResult ${openAppResult.runtimeType}');
//                       // Enter thr package name of the App you want to open and for iOS add the URLscheme to the Info.plist file.
//                       // The second arguments decide wether the app redirects PlayStore or AppStore.
//                       // For testing purpose you can enter com.instagram.android
//                     },
//                     child: const Center(
//                       child: Text(
//                         "Open",
//                         textAlign: TextAlign.center,
//                       ),
//                     )),
//                 ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue,
//                     ),
//                     onPressed: () async {
//                       var isAppInstalledResult = await LaunchApp.isAppInstalled(
//                         // androidPackageName: 'com.whatsapp',
//                         // iosUrlScheme: 'pulsesecure://',
//                         androidPackageName: 'com.linkedin.android',
//
//                         // openStore: false
//                       );
//                       print(
//                           'isAppInstalledResult => $isAppInstalledResult ${isAppInstalledResult.runtimeType}');
//                     },
//                     child: const Center(
//                       child: Text(
//                         "Is app installed?",
//                         textAlign: TextAlign.center,
//                       ),
//                     )),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
// //
// // class OpenApp extends StatefulWidget {
// //   const OpenApp({super.key});
// //
// //   @override
// //   State<OpenApp> createState() => _OpenAppState();
// // }
// //
// // class _OpenAppState extends State<OpenApp> {
// //   @override
// //   Widget build(BuildContext context) async {
// //     List<AppInfo> apps = (await InstalledApps.getInstalledApps()).cast<AppInfo>(
// //
// //     );
// //
// //     bool excludeSystemApps = true,
// //         bool withIcon,
// //     String packageNamePrefix
// //
// //
// //     return const Placeholder();
// //   }
// // }
// //
// // class AppInfo {
// //
// //   AppInfo()
// //   String name;
// //   Uint8List? icon;
// //   String packageName;
// //   String versionName;
// //   int versionCode;
// //   BuiltWith builtWith;
// //   int installedTimestamp;
// // }
