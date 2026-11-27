import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:pharoh_lense/core/router/route_name.dart';
import 'package:pharoh_lense/core/theme/app_colors.dart';
import 'package:pharoh_lense/ui/home/screen/home_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _bottomNavIndex = 0; // moved inside the State class

  // Same order as the icons below. Replace with your real screens.
  static const List<Widget> _screens = [
    // HomeScreen(),
    // TrainsTab(),
    // TicketsTab(),
    // ProfileTab(),
  ];

  static const List<IconData> _icons = [
    Icons.home,
    Icons.train_rounded,
    Icons.airplane_ticket_rounded,
    Icons.person,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _bottomNavIndex, children: _screens),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, RouteName.scanner),
        backgroundColor: AppColors.DarkprimaryColor,
        child: const Icon(Icons.camera_alt, color: Colors.black),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        activeColor: AppColors.DarksecondaryColor,
        backgroundColor: AppColors.DarksurfaceColor,
        icons: _icons,
        iconSize: 28,
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.defaultEdge,
        onTap: (index) => setState(() => _bottomNavIndex = index),
      ),
    );
  }
}
