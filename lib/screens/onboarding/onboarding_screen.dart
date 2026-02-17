import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to UniBites',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 20),
            Text(
              'Order from your favorite university outlets',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Get Started'),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                // Skip to guest browsing or login
                context.go('/login');
              },
              child: const Text('Skip'),
            ),
          ],
        ),
      ),
    );
  }
}
