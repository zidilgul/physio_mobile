import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:physio/pages/doktor_main.dart';
import 'package:physio/pages/egzersiz_atama.dart';
import 'package:physio/pages/egzersiz_gecmisi.dart';
import 'package:physio/pages/egzersizlerim.dart';
import 'package:physio/pages/login.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(Physio());
}

class Physio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}


