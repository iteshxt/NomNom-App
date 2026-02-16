import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'data/onboarding_repository.dart';

class OnboardingPage extends ConsumerWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: PageView(
        children: [
          _buildPage(
            context,
            ref,
            title: "Skip the Queue",
            description:
                "Order your favorite food from campus outlets without waiting.",
            color: Colors.orange.shade100,
          ),
          _buildPage(
            context,
            ref,
            title: "Real-time Tracking",
            description:
                "Know exactly when your food is being prepared and ready for pickup.",
            color: Colors.green.shade100,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPage(
    BuildContext context,
    WidgetRef ref, {
    required String title,
    required String description,
    required Color color,
    bool isLast = false,
  }) {
    return Container(
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.fastfood, size: 100),
          const SizedBox(height: 32),
          Text(title, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: 48),
          if (isLast)
            FilledButton(
              onPressed: () async {
                print("DEBUG: Get Started clicked");
                try {
                  print("DEBUG: Calling setOnboardingSeen");
                  await ref
                      .read(onboardingRepositoryProvider)
                      .setOnboardingSeen();
                  print("DEBUG: setOnboardingSeen completed");
                  if (context.mounted) {
                    print("DEBUG: Navigating to /login");
                    context.go('/login');
                  } else {
                    print("DEBUG: Context not mounted");
                  }
                } catch (e, st) {
                  print("DEBUG: Error in Onboarding: $e\n$st");
                }
              },
              child: const Text("Get Started"),
            ),
        ],
      ),
    );
  }
}
