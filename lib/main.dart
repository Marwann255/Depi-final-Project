import 'package:camera/camera.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pharoh_lense/core/router/app_routes.dart';
import 'package:pharoh_lense/core/theme/app_theme.dart';
import 'package:pharoh_lense/firebase_options.dart';
import 'package:pharoh_lense/ui/home/screen/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate(
    providerAndroid: kDebugMode
        ? const AndroidDebugProvider(
            debugToken: 'a25e3036-75a2-4461-9efa-b250d21dfeb6',
          )
        : const AndroidPlayIntegrityProvider(),
    providerApple: kDebugMode
        ? const AppleDebugProvider()
        : const AppleAppAttestProvider(),
  );
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
      debugShowCheckedModeBanner: false,
      title: "Pharoh Lense",
      routes: AppRoutes.routes,
      home: const HomeScreen(),
      // darkTheme: AppTheme.darkTheme,
      theme: AppTheme.darkTheme,
    );
  }
}
