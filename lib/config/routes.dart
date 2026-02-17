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

      // Main App Shell with Bottom Navigation
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
                routes: [
                  GoRoute(
                    path: 'checkout',
                    builder: (context, state) {
                      final extra = state.extra as Map<String, dynamic>?;
                      return CheckoutScreen(
                        outletId: extra?['outletId'] as String?,
                        items: extra?['items'] as List<OrderItem>?,
                        totalAmount: extra?['totalAmount'] as double?,
                      );
                    },
                  ),
                  GoRoute(
                    path: 'order-confirmation/:orderId',
                    builder: (context, state) {
                      final orderId = state.pathParameters['orderId']!;
                      return OrderConfirmationScreen(orderId: orderId);
                    },
                  ),
                  GoRoute(
                    path: 'order-tracking/:orderId',
                    builder: (context, state) {
                      final orderId = state.pathParameters['orderId']!;
                      return OrderTrackingScreen(orderId: orderId);
                    },
                  ),
                ],
              ),
            ],
          ),
          // Branch Orders
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/orders',
                builder: (context, state) => const OrderHistoryScreen(),
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
