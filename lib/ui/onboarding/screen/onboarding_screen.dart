import 'dart:math' as math;

import 'package:flutter/material.dart';


class _AppColors {
  static const parchment = Color(0xFFF3D9AC); 
  static const gold = Color(0xFFC49A45); 
  static const goldSoft = Color(0x8CC49A45); 
  static const dark = Color(0xFF10181A); 
  static const outer = Color(0xFF14100A); 
  static const title = Color(0xFF3B2A17); 
  static const body = Color(0xFF6B5A44); 
  static const dotOff = Color(0xFFD9BE8C); 
}
class _OnboardingPage {
  const _OnboardingPage({
    required this.image,
    required this.title,
    required this.description,
  });

  final String image;
  final String title;
  final String description;
}

const _pages = [
  _OnboardingPage(
    image: 'assets/img/onboardinge (1).jpeg',
    title: 'Your Journey\nStarts Here',
    description:
        'Get real-time updates on your entry status, travel details and more — all in one place.',
  ),
  _OnboardingPage(
    image: 'assets/img/onboardinge (2).jpeg',
    title: 'Scan & Track',
    description:
        'Use the built-in scanner to check your status or scan your document QR code.',
  ),
  _OnboardingPage(
    
    image: 'assets/img/onboardinge (3).jpeg',
    title: 'Travel Smarter',
    description:
        'Track your trips, manage reservations and get all your travel information in one app.',
        
  ),
];
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, this.onFinish});
  final VoidCallback? onFinish;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  bool get _isLast => _index == _pages.length - 1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_isLast) {
      widget.onFinish?.call();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _backOrSkip() {
    if (_index == 0) {
      widget.onFinish?.call();
    } else {
      _controller.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _AppColors.outer,
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(12),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: _AppColors.parchment,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: _AppColors.gold, width: 1.5),
          ),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _pages.length,
                  onPageChanged: (i) => setState(() => _index = i),
                  itemBuilder: (_, i) => _PageContent(page: _pages[i]),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: i == _index ? 24 : 8,
                    decoration: BoxDecoration(
                      color: i == _index ? const Color.fromARGB(255, 17, 13, 8) : _AppColors.dotOff,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _next,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                      foregroundColor: _AppColors.gold,
                      elevation: 20,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _isLast ? 'Get Started' : 'Next',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, size: 18),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              TextButton(
                onPressed: _backOrSkip,
                style: TextButton.styleFrom(foregroundColor: _AppColors.body),
                child: Text(
                  _index == 0 ? 'Skip' : 'Back',
                  style: const TextStyle(fontWeight: FontWeight.bold,)
                ),
              ),
              const SizedBox(height: 6),
            ],
          ),
        ),
      ),
    );
  }
}
class _PageContent extends StatelessWidget {
  const _PageContent({required this.page});
  final _OnboardingPage page;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 28, 28, 0),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: _AppColors.parchment,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: _AppColors.gold, width: 1.2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(page.image, fit: BoxFit.contain),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          Text(
            page.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Georgia',
              fontFamilyFallback: ['serif'],
              fontSize: 30,
              fontWeight: FontWeight.w600,
              height: 1.2,
              color: _AppColors.title,
            ),
          ),
          const SizedBox(height: 12),

          const _GoldDivider(),
          const SizedBox(height: 12),

          // الوصف
          Text(
            page.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              color: _AppColors.body,
            ),
          ),
        ],
      ),
    );
  }
}

class _GoldDivider extends StatelessWidget {
  const _GoldDivider();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: Row(
        children: [
          const Expanded(child: Divider(color: _AppColors.gold, thickness: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Transform.rotate(
              angle: math.pi / 4,
              child: Container(width: 8, height: 8, color: _AppColors.gold),
            ),
          ),
           Expanded(child: Divider(color: _AppColors.gold, thickness: 1)),
        ],
      ),
    );
  }
}

