import 'package:flutter/material.dart';
import '../../config/theme.dart';

enum BottomNavItem {
  menu,
  orders,
  profile,
}

class CustomBottomNav extends StatelessWidget {
  final BottomNavItem currentItem;
  final Function(int)? onTabTapped;

  const CustomBottomNav({
    required this.currentItem,
    this.onTabTapped,
    super.key,
  });

  void _handleTabTapped(int index) {
    if (onTabTapped != null) {
      onTabTapped!(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildAnimatedNavItem(
                context,
                index: 0,
                icon: Icons.restaurant_menu_rounded,
                label: 'Menu',
                currentItem: currentItem,
                targetItem: BottomNavItem.menu,
              ),
              _buildAnimatedNavItem(
                context,
                index: 1,
                icon: Icons.receipt_long_rounded,
                label: 'Orders',
                currentItem: currentItem,
                targetItem: BottomNavItem.orders,
              ),
              _buildAnimatedNavItem(
                context,
                index: 2,
                icon: Icons.person_rounded,
                label: 'Profile',
                currentItem: currentItem,
                targetItem: BottomNavItem.profile,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedNavItem(
    BuildContext context, {
    required int index,
    required IconData icon,
    required String label,
    required BottomNavItem currentItem,
    required BottomNavItem targetItem,
  }) {
    final isActive = currentItem == targetItem;

    return GestureDetector(
      onTap: () => _handleTabTapped(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
        padding: isActive
            ? const EdgeInsets.symmetric(horizontal: 20, vertical: 10)
            : const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.secondaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? AppTheme.primaryColor : Colors.grey[400],
              size: 24,
            ),
            if (isActive) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
