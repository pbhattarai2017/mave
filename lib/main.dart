import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

import './pages/login.dart';
import 'dart:io';

main() {
  // debugPaintSizeEnabled = true;
  // debugPaintPointersEnabled = true;
  runApp(MaveApp());
}

class MaveApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MaveAppState();
  }
}

class _MaveAppState extends State<MaveApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mave',
      home: LoginPage(),
    );
  }
}

Future<void> getPath() async {
  Directory dir = await getApplicationDocumentsDirectory();
  return dir.path;
}
