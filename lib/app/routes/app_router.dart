import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/onboarding/data/onboarding_repository.dart';
import '../../features/auth/login_page.dart';
import '../../features/auth/signup_page.dart';
import '../../features/auth/forgot_password_page.dart';
import '../../features/onboarding/onboarding_page.dart';
import '../../features/home/home_shell.dart';
import '../../features/home/home_page.dart';
// import '../../features/home/tabs.dart';
import '../../features/menu/presentation/menu_page.dart';
import '../../features/cart/presentation/cart_page.dart';
import '../../features/orders/presentation/orders_page.dart';
import '../../features/orders/presentation/checkout_page.dart';
import '../../features/profile/presentation/profile_page.dart';
import '../../features/auth/auth_controller.dart';

final routerProvider = Provider<GoRouter>((ref) {
  // We can listen to auth state here for redirection
  final authState = ref.watch(authStateProvider);
  final onboardingSeen =
      ref.watch(onboardingSeenProvider).asData?.value ?? false;

  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(path: '/signup', builder: (context, state) => const SignupPage()),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return HomeShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomePage(),
            redirect: (_, _) => '/home/menu',
          ),
          GoRoute(
            path: '/home/menu',
            builder: (context, state) => const MenuPage(),
          ),
          GoRoute(
            path: '/home/orders',
            builder: (context, state) => const OrdersPage(),
          ),
          GoRoute(
            path: '/home/cart',
            builder: (context, state) => const CartPage(),
          ),
          GoRoute(
            path: '/home/profile',
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),
      GoRoute(
        path: '/checkout',
        builder: (context, state) => const CheckoutPage(),
      ),
    ],
    redirect: (context, state) {
      final isLoading = authState.isLoading;
      final hasError = authState.hasError;
      final isAuthenticated = authState.asData?.value != null;

      final isLogin = state.uri.toString() == '/login';
      final isSignup = state.uri.toString() == '/signup';
      final isOnboarding = state.uri.toString() == '/onboarding';
      final isForgot = state.uri.toString() == '/forgot-password';

      if (isLoading || hasError) return null; // Do nothing while loading

      if (!onboardingSeen) {
        return '/onboarding';
      }

      if (!isAuthenticated) {
        if (isLogin || isSignup || isForgot) return null;
        return '/login';
      }

      if (isAuthenticated) {
        if (isLogin || isSignup || isOnboarding) return '/home/menu';
      }

      return null;
    },
  );
});
