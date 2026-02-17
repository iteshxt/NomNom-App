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
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: _NavItem(
                  icon: Icons.restaurant_menu_rounded,
                  label: 'Menu',
                  isActive: currentItem == BottomNavItem.menu,
                  onTap: () => _handleTabTapped(0),
                ),
              ),
              Expanded(
                child: _NavItem(
                  icon: Icons.receipt_long_rounded,
                  label: 'Orders',
                  isActive: currentItem == BottomNavItem.orders,
                  onTap: () => _handleTabTapped(1),
                ),
              ),
              Expanded(
                child: _NavItem(
                  icon: Icons.person_rounded,
                  label: 'Profile',
                  isActive: currentItem == BottomNavItem.profile,
                  onTap: () => _handleTabTapped(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: isActive
                    ? BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      )
                    : null,
                child: Icon(
                  icon,
                  color: isActive ? AppTheme.primaryColor : Colors.grey[400],
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isActive ? AppTheme.primaryColor : Colors.grey[400],
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
          ),
        ],
      ),
    );
  }
}
