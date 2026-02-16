import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../notifications/presentation/notification_listener_widget.dart';

class HomeShell extends StatelessWidget {
  final Widget child;

  const HomeShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListenerWidget(child: child),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _calculateSelectedIndex(context),
        onDestinationSelected: (index) => _onItemTapped(index, context),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu),
            label: 'Menu',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          NavigationDestination(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/home/menu')) return 0;
    if (location.startsWith('/home/orders')) return 1;
    if (location.startsWith('/home/cart')) return 2;
    if (location.startsWith('/home/profile')) return 3;
    return 0; // Default to Menu
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home/menu');
        break;
      case 1:
        context.go('/home/orders');
        break;
      case 2:
        context.go('/home/cart');
        break;
      case 3:
        context.go('/home/profile');
        break;
    }
  }
}
