import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
// import 'package:uuid/uuid.dart'; // Unused
import '../../cart/application/cart_controller.dart';
import '../../auth/auth_controller.dart';
import '../data/order_repository.dart';
import '../models/order.dart';
import '../models/order_item.dart';

class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({super.key});

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  bool _isProcessing = false;

  Future<void> _placeOrder() async {
    final cart = ref.read(cartProvider);
    final user = ref.read(authStateProvider).asData?.value;

    if (cart.items.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Cart is empty')));
      return;
    }

    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('You must be logged in')));
      return;
    }

    setState(() => _isProcessing = true);

    try {
      // Create Order items from Cart items
      final orderItems = cart.items.map((cartItem) {
        return OrderItem(
          menuItem: cartItem.menuItem,
          quantity: cartItem.quantity,
          priceAtOrder: cartItem.menuItem.price,
        );
      }).toList();

      final order = Order(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // Mock ID
        userId: user.uid,
        outletId: cart.outletId!,
        items: orderItems,
        totalAmount: cart.totalAmount,
        status: OrderStatus.pending,
        createdAt: DateTime.now(),
      );

      await ref.read(orderRepositoryProvider).createOrder(order);
      ref.read(cartProvider.notifier).clear();

      if (mounted) {
        context.go('/home/orders'); // Navigate to orders tab
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order Placed Successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);

    if (cart.items.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Checkout')),
        body: const Center(child: Text('Your cart is empty')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  const Text(
                    'Order Summary',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ...cart.items.map(
                    (item) => ListTile(
                      title: Text(item.menuItem.name),
                      subtitle: Text('x${item.quantity}'),
                      trailing: Text('₹${item.totalPrice}'),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text(
                      'Total',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      '₹${cart.totalAmount}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Payment Method',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.radio_button_checked,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: const Text('UPI (Mock)'),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isProcessing ? null : _placeOrder,
                child: _isProcessing
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Pay & Place Order'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
