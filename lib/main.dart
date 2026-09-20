import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:pharoh_lense/ui/home/tabs/scanner/screen/scanner_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  // final firstCamera = cameras.first;
  runApp(MyApp(camera: cameras.isEmpty ? null : cameras.first));
}

class MyApp extends StatelessWidget {
  final CameraDescription? camera;
  const MyApp({super.key, required this.camera});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Pharoh Lense",
      home: ScannerScreen(camera: camera!),
    );
  }
}
