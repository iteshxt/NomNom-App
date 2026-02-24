import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/index.dart';
import '../../config/theme.dart';
import '../../providers/index.dart';

class MenuItemCard extends ConsumerWidget {
  final MenuItem item;
  final VoidCallback? onTap;
  final bool showBadge;

  const MenuItemCard({
    required this.item,
    this.onTap,
    this.showBadge = true,
    super.key,
  });

  Color _getTagColor(String tag) {
    if (tag.toLowerCase().contains('veg') &&
        !tag.toLowerCase().contains('non')) {
      return Colors.green[700]!;
    } else if (tag.toLowerCase().contains('non-veg')) {
      return Colors.red[700]!;
    } else if (tag.toLowerCase().contains('best seller')) {
      return Colors.amber[700]!;
    }
    return AppTheme.primaryColor;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentOrder = ref.watch(currentOrderProvider);
    final outletId = ref.watch(selectedOutletProvider);

    // Find if this item is in the current order
    final orderItemIndex =
        currentOrder.items.indexWhere((i) => i.itemId == item.id);
    final orderItem =
        orderItemIndex != -1 ? currentOrder.items[orderItemIndex] : null;
    final quantity = orderItem?.quantity ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Section: Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Veg/Non-Veg - Removed from here
                  // Bestseller tag
                  if (item.tags.any((t) => t.toLowerCase().contains('best')))
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.amber[50],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Bestseller',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.amber[900],
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹${item.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Right Section: Image & Add Button
            Stack(
              alignment: Alignment.bottomCenter,
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    item.image,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 120,
                        height: 120,
                        color: Colors.grey[100],
                        child: Icon(
                          Icons.restaurant,
                          size: 32,
                          color: Colors.grey[400],
                        ),
                      );
                    },
                  ),
                ),
                // Veg/Non-Veg Badge (Moved here)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.circle,
                      size: 10,
                      color: _getTagColor(
                          item.tags.isNotEmpty ? item.tags.first : 'veg'),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -12, // Adjusted to be less aggressive than -18
                  child: SizedBox(
                    width: 92, // Fixed width to ensure consistent button size
                    child: item.availability
                        ? Center(
                            child: _buildQuantitySelector(
                                context, ref, quantity, outletId),
                          )
                        : Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Text(
                              'OFFLINE',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantitySelector(
      BuildContext context, WidgetRef ref, int quantity, String? outletId) {
    if (quantity == 0) {
      return SizedBox(
        height: 36,
        width: 92, // Explicit width to match counter
        child: ElevatedButton(
          onPressed: outletId == null
              ? null
              : () {
                  final orderItem = OrderItem(
                    menuItemId: item.id,
                    name: item.name,
                    price: item.price,
                    quantity: 1,
                    image: item.image,
                  );
                  ref
                      .read(currentOrderProvider.notifier)
                      .addItem(orderItem, outletId);
                },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero, // Remove padding to use fixed size
            backgroundColor: Colors.white,
            foregroundColor: AppTheme.primaryColor,
            elevation: 2,
            shadowColor: Colors.black.withValues(alpha: 0.1),
            side: BorderSide(
              color: AppTheme.primaryColor.withValues(alpha: 0.2),
              width: 1.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24), // Increased radius
            ),
          ),
          child: const Text(
            'ADD',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 13,
              letterSpacing: 0.5,
            ),
          ),
        ),
      );
    }

    return Container(
      height: 36,
      width: 92, // Explicit width
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(24), // Increased radius
        // Removed shadow to avoid double-box effect if wrapper exists, or clean look.
        // User complained about "viewed box... slightly visible".
        // It's likely the shadow contrast against the white background or the button itself.
        // I'll keep it clean.
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ActionButton(
            icon: Icons.remove,
            onTap: () {
              // Find the item to update
              final currentOrder = ref.read(currentOrderProvider);
              final orderItem =
                  currentOrder.items.firstWhere((i) => i.itemId == item.id);
              ref
                  .read(currentOrderProvider.notifier)
                  .updateQuantity(orderItem, quantity - 1);
            },
          ),
          Container(
            width: 32,
            alignment: Alignment.center,
            child: Text(
              quantity.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 15,
              ),
            ),
          ),
          _ActionButton(
            icon: Icons.add,
            onTap: () {
              final currentOrder = ref.read(currentOrderProvider);
              final orderItem =
                  currentOrder.items.firstWhere((i) => i.itemId == item.id);
              ref
                  .read(currentOrderProvider.notifier)
                  .updateQuantity(orderItem, quantity + 1);
            },
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ActionButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        alignment: Alignment.center,
        child: Icon(
          icon,
          color: Colors.white,
          size: 16,
        ),
      ),
    );
  }
}
