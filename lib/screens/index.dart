import 'package:flutter/material.dart';

// Onboarding
export 'onboarding/onboarding_screen.dart';

// Auth
export 'auth/login_screen.dart';
export 'auth/signup_screen.dart';
export 'auth/forgot_password_screen.dart';

// Home
export 'home/home_screen.dart';

// Menu & Items

// Cart & Checkout
export 'checkout/checkout_screen.dart';

// Orders
export 'orders/order_confirmation_screen.dart';
export 'orders/order_tracking_screen.dart';
export 'orders/order_history_screen.dart';

// Profile
export 'profile/profile_screen.dart';

// 404 Not Found
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Not Found')),
      body: const Center(
        child: Text('Page not found'),
      ),
    );
  }
}
