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
          child: SizedBox(
            height: 44,
            child: Stack(
              children: [
                // Sliding Pill
                AnimatedAlign(
                  alignment: Alignment(
                    -1.0 +
                        (currentItem.index *
                            2 /
                            (BottomNavItem.values.length - 1)),
                    0.0,
                  ),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  child: FractionallySizedBox(
                    widthFactor:
                        1 / BottomNavItem.values.length, // Roughly 1/3 of space
                    child: Center(
                      child: Container(
                        width: double.infinity,
                        height: 44,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ),
                // Tab Items
                Row(
                  children: [
                    _buildNavItem(
                      context,
                      index: 0,
                      icon: Icons.restaurant_menu_rounded,
                      label: 'Menu',
                      currentItem: currentItem,
                      targetItem: BottomNavItem.menu,
                    ),
                    _buildNavItem(
                      context,
                      index: 1,
                      icon: Icons.receipt_long_rounded,
                      label: 'Orders',
                      currentItem: currentItem,
                      targetItem: BottomNavItem.orders,
                    ),
                    _buildNavItem(
                      context,
                      index: 2,
                      icon: Icons.person_rounded,
                      label: 'Profile',
                      currentItem: currentItem,
                      targetItem: BottomNavItem.profile,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    required IconData icon,
    required String label,
    required BottomNavItem currentItem,
    required BottomNavItem targetItem,
  }) {
    final isActive = currentItem == targetItem;

    return Expanded(
      child: GestureDetector(
        onTap: () => _handleTabTapped(index),
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.fastOutSlowIn,
            // Removed internal decoration and background
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: isActive ? Colors.white : Colors.grey[400],
                  size: 24,
                ),
                // Animate text visibility
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: SizedBox(
                    width: isActive ? null : 0,
                    child: Padding(
                      padding: EdgeInsets.only(left: isActive ? 8.0 : 0.0),
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
