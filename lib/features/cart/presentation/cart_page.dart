import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../application/cart_controller.dart';
// import '../models/cart_item.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        actions: [
          if (cart.items.isNotEmpty)
            IconButton(
              onPressed: () {
                ref.read(cartProvider.notifier).clear();
              },
              icon: const Icon(Icons.delete_outline),
            ),
        ],
      ),
      body: cart.items.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Your cart is empty',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return Dismissible(
                        key: Key(item.menuItem.id),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) {
                          // This only removes logically if fully swiped?
                          // Better to use background and confirm or just let notifier handle it
                          // For now simple swipe
                          // Actually we need to remove all quantity or just one? Usually swipe = delete item.
                        },
                        confirmDismiss: (_) async {
                          ref
                              .read(cartProvider.notifier)
                              .removeItem(item.menuItem.id);
                          // If quantity > 1, it decreases. If 1, it removes.
                          // However, Dismissible expects the item to be removed from tree.
                          // If quantity > 1, it won't be removed, so Dismissible might glitch.
                          // Better not use Dismissible for quantity decrement without handling.
                          return false;
                        },
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: ListTile(
                          leading: Image.network(
                            item.menuItem.imageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) =>
                                const Icon(Icons.fastfood),
                          ),
                          title: Text(item.menuItem.name),
                          subtitle: Text(
                            '₹${item.menuItem.price} x ${item.quantity}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '₹${item.totalPrice}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () {
                                  ref
                                      .read(cartProvider.notifier)
                                      .removeItem(item.menuItem.id);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () {
                                  ref
                                      .read(cartProvider.notifier)
                                      .addItem(item.menuItem);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '₹${cart.totalAmount}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () {
                            // Checkout
                            GoRouter.of(context).push('/checkout');
                          },
                          child: const Text('Proceed to Payment'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
