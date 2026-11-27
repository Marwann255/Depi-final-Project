import 'package:flutter/material.dart';
import 'package:pharoh_lense/core/router/route_name.dart';
import 'package:pharoh_lense/ui/home/screen/home_screen.dart';
import 'package:pharoh_lense/ui/home/tabs/scanner/screen/chatbot_screen.dart';
import 'package:pharoh_lense/ui/home/tabs/scanner/screen/device_camera_screen.dart';

abstract class AppRoutes {
  static Map<String, Widget Function(BuildContext)> routes = {
    RouteName.home: (_) => const HomeScreen(),
    RouteName.chatbot: (_) => const ChatbotScreen(),
    RouteName.scanner: (_) => const ScannerScreen(),
  };
}
