import 'package:flutter/material.dart';
import 'package:pharoh_lense/core/utils/app_assets.dart';

class ChatbotScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff161310),
        appBar: AppBar(
          backgroundColor: Color(0xff161310),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios, color: Color(0xffd4af37)),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * .15),
              Center(
                child: Column(
                  children: [
                    Image.asset(AppAssets.chatbotIconx15),
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xffd4af37), Color(0xff6e5b1d)],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ).createShader(bounds),
                      child: Text(
                        'Your Tour Guide',
                        style: TextStyle(fontSize: 32, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(16),
                    ),
                    color: Color(0xff282420),
                    child: Padding(
                      padding: const EdgeInsetsGeometry.all(12),
                      child: Text(
                        'Quick Action',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 80),
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(16),
                    ),
                    color: Color(0xff282420),
                    child: Padding(
                      padding: const EdgeInsetsGeometry.all(12),
                      child: Text(
                        'Quick Action',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(16),
                    ),
                    color: Color(0xff282420),
                    child: Padding(
                      padding: const EdgeInsetsGeometry.all(12),
                      child: Text(
                        'Quick Action',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 80),
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(16),
                    ),
                    color: Color(0xff282420),
                    child: Padding(
                      padding: const EdgeInsetsGeometry.all(12),
                      child: Text(
                        'Quick Action',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * .1),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .78,
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Ask your Guide',
                        hintStyle: TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: Color(0xff282420),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      // maxLength: 50,
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    height: 45,
                    width: 45,
                    child: CircleAvatar(
                      backgroundColor: Color(0xffd4af37),
                      child: Image.asset(AppAssets.snedIcon),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
