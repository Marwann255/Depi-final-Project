import 'package:flutter/material.dart';
import '../../auth/login/screen/login_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  static const _gold = Color(0xFFD2A927);

  void _continue(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => LoginScreen()),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17120D),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/img/download (1) 1.png',
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
           DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color(0xCC100D09)],
                stops: [0.55, 1],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
               
                 Spacer(),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(30, 24, 30, 18),
                  decoration: const BoxDecoration(
                    color: Color(0xFF17120F),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(54),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'See the Ancient World\nThrough Neural Eyes',
                        style: TextStyle(
                          color: _gold,
                          fontFamily: 'Georgia',
                          fontSize: 21,
                          height: 1.4,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                       SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () => _continue(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _gold,
                            foregroundColor: Colors.black,
                            shape: const StadiumBorder(),
                            elevation: 0,
                          ),
                          child: const Text(
                            "Let's Start",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


