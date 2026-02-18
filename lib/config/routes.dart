import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../screens/index.dart';
import '../models/index.dart';
import '../providers/index.dart';
import '../widgets/scaffold_with_navbar.dart';

final routerProvider = Provider((ref) {
  final authState = ref.watch(authStateProvider);
  final isGuest = ref.watch(isGuestModeProvider);
  final onboardingCompleted = ref.watch(onboardingCompletedProvider);

  return GoRouter(
    initialLocation: onboardingCompleted ? '/home' : '/onboarding',
    redirect: (context, state) {
      final isLoggedIn = authState != null;
      final isOnboarding = state.uri.toString() == '/onboarding';
      final isAuth = state.uri.toString().startsWith('/login') ||
          state.uri.toString().startsWith('/signup') ||
          state.uri.toString().startsWith('/forgot-password');

      debugPrint(
        'Router: uri=${state.uri}, isLoggedIn=$isLoggedIn, isGuest=$isGuest, onboardingCompleted=$onboardingCompleted',
      );

      // If fully logged in, don't allow accessing onboarding or auth screens
      if (isLoggedIn && (isOnboarding || isAuth)) {
        debugPrint('Logged-in Redirect to /home');
        return '/home';
      }

      // If in guest mode, only block the onboarding screen
      if (isGuest && isOnboarding) {
        debugPrint('Guest Redirect to /home');
        return '/home';
      }

      // If onboarding is completed...
      if (onboardingCompleted) {
        // ...but user tries to access onboarding, redirect to home
        if (isOnboarding) {
          debugPrint('Onboarding Completed Redirect to /home');
          return '/home';
        }
        // otherwise allow access (to home, auth, orders, etc.)
        return null;
      }

      // If onboarding NOT completed, force onboarding unless already there
      if (!onboardingCompleted && !isOnboarding) {
        debugPrint('Onboarding Incomplete Redirect to /onboarding');
        return '/onboarding';
      }

      // If not logged in and not in guest mode, only allow auth screens (since onboarding is handled above)
      // NOTE: We now allow access if onboarding is completed (treated as effectively guest)
      if (!isLoggedIn &&
          !isGuest &&
          !isOnboarding &&
          !isAuth &&
          !onboardingCompleted) {
        debugPrint('Unauth Redirect to /login');
        return '/login';
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

      // Main App Shell with Bottom Navigation
      GoRoute(
        path: '/checkout',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return CheckoutScreen(
            outletId: extra?['outletId'] as String?,
            items: extra?['items'] as List<OrderItem>?,
            totalAmount: extra?['totalAmount'] as double?,
          );
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          // Branch Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
                routes: [],
              ),
            ],
          ),
          // Branch Orders
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/orders',
                builder: (context, state) => const OrderHistoryScreen(),
                routes: [
                  GoRoute(
                    path: 'tracking/:orderId',
                    builder: (context, state) {
                      final orderId = state.pathParameters['orderId']!;
                      return OrderTrackingScreen(orderId: orderId);
                    },
                  ),
                  GoRoute(
                    path: 'confirmation/:orderId',
                    builder: (context, state) {
                      final orderId = state.pathParameters['orderId']!;
                      return OrderConfirmationScreen(orderId: orderId);
                    },
                  ),
                ],
              ),
            ],
          ),
          // Branch Profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
});
