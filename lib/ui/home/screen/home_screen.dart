import 'package:flutter/material.dart';
import 'package:pharoh_lense/core/theme/app_colors.dart';
import 'package:pharoh_lense/core/widgets/bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.DarkbackgroundColor,
      bottomNavigationBar: const BottomNavBar(),
      body: Center(
        child: Text(
          'Home Screen',
          style: TextStyle(
            color: AppColors.DarkprimaryColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
