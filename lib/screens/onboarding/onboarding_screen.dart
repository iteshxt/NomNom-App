import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../providers/index.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Discover Delicious Food',
      description:
          'Browse campus outlets, explore menus, and order your favorites in seconds.',
      image: 'assets/icons/icon.png',
      vectorImage: 'assets/icons/vector-1.png',
      buttonText: 'Next',
    ),
    OnboardingData(
      title: 'Order Ahead. Pick Up Fast',
      description:
          'Browse menus, pay in-app, and skip line. Your order will ready when you arrive.',
      icon: Icons.takeout_dining_outlined,
      vectorImage: 'assets/icons/vector-2.png',
      buttonText: 'Get Started',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return OnboardingPageContent(data: _pages[index]);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (_currentPage < _pages.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        // Mark onboarding as complete
                        await ref
                            .read(settingsServiceProvider)
                            .setOnboardingComplete();
                        ref.read(onboardingCompletedProvider.notifier).state =
                            true;

                        // Enable guest mode and navigate
                        ref.read(isGuestModeProvider.notifier).state = true;
                        if (context.mounted) {
                          context.go('/home');
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                    ),
                    child: Text(_pages[_currentPage].buttonText),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length, // Corrected to page count (2)
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          color: index == _currentPage
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final String? image;
  final String? vectorImage;
  final IconData? icon;
  final String buttonText;

  OnboardingData({
    required this.title,
    required this.description,
    this.image,
    this.vectorImage,
    this.icon,
    required this.buttonText,
  });
}

class OnboardingPageContent extends StatelessWidget {
  final OnboardingData data;

  const OnboardingPageContent({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 3), // Changed flex from 2 to 3
          // Illustration Stack
          SizedBox(
            height: 300, // Changed height from 280 to 300
            width: 300, // Changed width from 280 to 300
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Vector Background
                if (data.vectorImage != null)
                  Positioned.fill(
                    child: Image.asset(
                      data.vectorImage!,
                      fit: BoxFit.contain,
                    ),
                  ),
                // Inner Circle
                if (data.vectorImage == null)
                  Container(
                    height: 180,
                    width: 180,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                  ),
                // Main Image or Icon
                if (data.image != null && data.vectorImage == null)
                  Image.asset(
                    data.image!,
                    height: 120,
                    width: 120,
                    color: Colors.white,
                  )
                else if (data.icon != null)
                  Icon(
                    data.icon,
                    size: 110,
                    color: Colors.white,
                  ),
              ],
            ),
          ),
          const Spacer(),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -0.5, // Added letterSpacing
            ),
          ),
          const SizedBox(height: 20), // Changed height from 24 to 20
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white
                  .withValues(alpha: 0.85), // Changed alpha from 0.9 to 0.85
              height: 1.4, // Changed height from 1.5 to 1.4
              fontWeight: FontWeight.w500, // Added fontWeight
            ),
          ),
          const Spacer(flex: 3), // Changed flex from 2 to 3
        ],
      ),
    );
  }
}
