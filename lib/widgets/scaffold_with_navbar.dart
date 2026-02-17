import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'custom_bottom_nav.dart';
import 'view_order_pill.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final hidePillRoutes = [
      '/home/checkout',
      '/home/order-tracking',
      '/home/order-confirmation'
    ];
    final shouldHidePill =
        hidePillRoutes.any((route) => location.startsWith(route));

    return Scaffold(
      body: Stack(
        children: [
          navigationShell,
          if (!shouldHidePill)
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: ViewOrderPill(),
            ),
        ],
      ),
      bottomNavigationBar: CustomBottomNav(
        currentItem: _getIndexToItem(navigationShell.currentIndex),
        onTabTapped: (index) => _onTap(context, index),
      ),
    );
  }

  BottomNavItem _getIndexToItem(int index) {
    switch (index) {
      case 0:
        return BottomNavItem.menu;
      case 1:
        return BottomNavItem.orders;
      case 2:
        return BottomNavItem.profile;
      default:
        return BottomNavItem.menu;
    }
  }

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
