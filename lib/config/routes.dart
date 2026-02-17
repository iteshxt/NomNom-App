import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../screens/index.dart';
import '../providers/index.dart';

final routerProvider = Provider((ref) {
  final authState = ref.watch(authStateProvider);
  final isGuest = ref.watch(isGuestModeProvider);

  return GoRouter(
    initialLocation: '/onboarding',
    redirect: (context, state) {
      final isLoggedIn = authState != null;
      final isOnboarding = state.uri.toString() == '/onboarding';
      final isAuth = state.uri.toString().startsWith('/login') ||
          state.uri.toString().startsWith('/signup') ||
          state.uri.toString().startsWith('/forgot-password');

      debugPrint(
        'Router: uri=${state.uri}, isLoggedIn=$isLoggedIn, isGuest=$isGuest',
      );

      // If logged in or in guest mode, don't allow accessing onboarding or auth screens
      if ((isLoggedIn || isGuest) && (isOnboarding || isAuth)) {
        debugPrint('Post-Auth Redirect to /home');
        return '/home';
      }

      // If not logged in and not in guest mode, only allow onboarding and auth screens
      if (!isLoggedIn && !isGuest && !isOnboarding && !isAuth) {
        debugPrint('Unauth Redirect to /onboarding');
        return '/onboarding';
      }

      return null;
    },
    routes: [
      // Onboarding
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Auth Routes
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      // Home & Outlets
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
        routes: [
          // Item Detail
          GoRoute(
            path: 'item/:itemId',
            builder: (context, state) {
              final itemId = state.pathParameters['itemId']!;
              return ItemDetailScreen(itemId: itemId);
            },
          ),

          // Checkout
          GoRoute(
            path: 'checkout',
            builder: (context, state) => const CheckoutScreen(),
          ),

          // Order Confirmation
          GoRoute(
            path: 'order-confirmation/:orderId',
            builder: (context, state) {
              final orderId = state.pathParameters['orderId']!;
              return OrderConfirmationScreen(orderId: orderId);
            },
          ),

          // Order Tracking
          GoRoute(
            path: 'order-tracking/:orderId',
            builder: (context, state) {
              final orderId = state.pathParameters['orderId']!;
              return OrderTrackingScreen(orderId: orderId);
            },
          ),

          // Order History
          GoRoute(
            path: 'orders',
            builder: (context, state) => const OrderHistoryScreen(),
          ),

          // Profile
          GoRoute(
            path: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
});
