import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';

import '../../models/index.dart';
import '../../providers/index.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  final String? outletId;
  final List<OrderItem>? items;
  final double? totalAmount;

  const CheckoutScreen({
    super.key,
    this.outletId,
    this.items,
    this.totalAmount,
  });

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    // Fallback or use passed arguments
    final items = widget.items ?? [];
    final total = widget.totalAmount ?? 0.0;
    final outletId = widget.outletId ?? ref.watch(selectedOutletProvider);

    final authState = ref.watch(authStateProvider);
    final outletAsync =
        outletId != null ? ref.watch(outletProvider(outletId)) : null;

    final totalFinal = total;

    if (items.isEmpty) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          title: const Text('Checkout'),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 26,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_cart_outlined,
                size: 64,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 16),
              Text(
                'Your cart is empty',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[400],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/home'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 26,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: outletAsync != null
            ? outletAsync.when(
                loading: () => const Center(
                    child: CircularProgressIndicator(
                        color: AppTheme.primaryColor)),
                error: (error, stackTrace) =>
                    Center(child: Text('Error: $error')),
                data: (outlet) {
                  if (outlet == null) {
                    return const Center(child: Text('Outlet not found'));
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Outlet Info Card
                      _buildSectionHeader('ORDER FROM'),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppTheme.secondaryColor
                                    .withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.storefront_rounded,
                                color: AppTheme.primaryColor,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    outlet.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    outlet.campusLocation,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[500],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Order Items
                      _buildSectionHeader('YOUR ITEMS'),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(20),
                          itemCount: items.length,
                          separatorBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Divider(height: 1, color: Colors.grey[100]),
                          ),
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    '${item.quantity}x',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.primaryColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.itemName,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      if (item.specialInstructions != null &&
                                          item.specialInstructions!.isNotEmpty)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4),
                                          child: Text(
                                            item.specialInstructions!,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontStyle: FontStyle.italic,
                                              color: Colors.grey[500],
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '₹${item.totalPrice.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Order Summary
                      _buildSectionHeader('PAYMENT SUMMARY'),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Grand Total',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              '₹${totalFinal.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: AppTheme.primaryColor,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 48),

                      // Place Order Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isProcessing
                              ? null
                              : () async {
                                  setState(() => _isProcessing = true);

                                  // Use local variables
                                  final items = widget.items ?? [];
                                  final total = widget.totalAmount ?? 0.0;
                                  final outletId = widget.outletId ??
                                      ref.read(selectedOutletProvider);
                                  final totalFinal = total;

                                  if (authState != null &&
                                      outletId != null &&
                                      items.isNotEmpty) {
                                    try {
                                      final orderItems =
                                          items.cast<OrderItem>();

                                      // Create order
                                      final order = await ref
                                          .read(orderTrackingProvider.notifier)
                                          .createOrder(
                                            userId: authState.id,
                                            outletId: outletId,
                                            items: orderItems,
                                            total: totalFinal,
                                            estimatedPickupTime: 20,
                                          );

                                      // Trigger immediate refresh of order history
                                      ref
                                          .read(orderHistoryTriggerProvider
                                              .notifier)
                                          .state++;

                                      // Clear current order (if using currentOrderProvider)
                                      ref
                                          .read(currentOrderProvider.notifier)
                                          .clearOrder();

                                      if (context.mounted) {
                                        context.go(
                                            '/orders/confirmation/${order.id}');
                                      }
                                    } catch (e) {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text('Error: $e'),
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            backgroundColor: Colors.red[400],
                                          ),
                                        );
                                      }
                                    } finally {
                                      if (mounted) {
                                        setState(() => _isProcessing = false);
                                      }
                                    }
                                  } else {
                                    setState(() => _isProcessing = false);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('Cannot place empty order')),
                                    );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 8,
                            shadowColor:
                                AppTheme.primaryColor.withValues(alpha: 0.4),
                          ),
                          child: _isProcessing
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2.5, color: Colors.white),
                                )
                              : const Text(
                                  'Place Order',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  );
                },
              )
            : const SizedBox(),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w900,
        color: Colors.grey,
        letterSpacing: 1.2,
      ),
    );
  }
}
