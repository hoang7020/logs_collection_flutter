import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_permissions/simple_permissions.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static const platform = const MethodChannel('samples.flutter.dev/android');

  String _batteryLevel = 'Unknown battery level.';
  String _logResult = "";

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  Future<void> _saveLogApp() async {
    try {
      final String result = await platform.invokeMethod("saveLogApp");
      _logResult = result;
    } on PlatformException catch (e) {
      _logResult = e.message;
    }
  }

  requestPermission() async {
    Permission p = Permission.WriteExternalStorage;
    final res = await SimplePermissions.requestPermission(p);
    print("permission request result is " + res.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Log Collection"),
        ),
        body: Column(
          children: <Widget>[
            Builder(
              builder: (ctx) => RaisedButton(
                onPressed: _getBatteryLevel,
                child: Text("Get Battery Level"),
              ),
            ),
            Text(_batteryLevel),
            Builder(
              builder: (ctx) => RaisedButton(
                onPressed: requestPermission,
                child: Text("Request Write Permission"),
              ),
            ),
            Builder(
              builder: (ctx) => RaisedButton(
                onPressed: _saveLogApp,
                child: Text("Save Logs Android"),
              ),
            ),
            Text(_logResult)
          ],
        ),
      ),
    );
  }
}
