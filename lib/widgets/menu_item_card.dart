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

  String _getTagDisplay() {
    if (item.tags.isEmpty) return '';
    final tag = item.tags.first;
    return tag[0].toUpperCase() + tag.substring(1);
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

    return Card(
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image container
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.network(
                  item.image,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 120,
                      color: Colors.grey[100],
                      child: Icon(
                        Icons.restaurant,
                        size: 40,
                        color: Colors.grey[400],
                      ),
                    );
                  },
                ),
              ),
              // Availability overlay
              if (!item.availability)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'NOT AVAILABLE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              // Tag badge
              if (showBadge && item.tags.isNotEmpty)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _getTagDisplay(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: Text(
                      item.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                        height: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '₹${item.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                      if (item.availability)
                        _buildQuantitySelector(context, ref, quantity, outletId)
                      else
                        const Text(
                          'OFFLINE',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector(
      BuildContext context, WidgetRef ref, int quantity, String? outletId) {
    if (quantity == 0) {
      return SizedBox(
        height: 32,
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
            padding: const EdgeInsets.symmetric(horizontal: 16),
            backgroundColor: AppTheme.secondaryColor,
            foregroundColor: AppTheme.primaryColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'ADD',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
          ),
        ),
      );
    }

    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(8),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              quantity.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 14,
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
