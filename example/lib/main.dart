import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:native_resource/native_resource.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('app_name / CFBundleIdentifier '),
              FutureBuilder<String>(
                future: NativeResource().read(
                  androidResourceName: 'app_name',
                  iosPlistKey: 'CFBundleIdentifier',
                ),
                initialData: '',
                builder: (context, snapshot) {
                  return Text('${snapshot.data}');
                },
              ),
              SizedBox(height: 8),
              Text('sample_key / SampleKey (via Test.plist)'),
              FutureBuilder<String>(
                future: NativeResource().read(
                  androidResourceName: 'sample_key',
                  iosPlistKey: 'SampleKey',
                  iosPlistFile: 'Test',
                ),
                initialData: '',
                builder: (context, snapshot) {
                  return Text('${snapshot.data}');
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
