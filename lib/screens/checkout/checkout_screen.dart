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
        appBar: AppBar(title: const Text('Checkout')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_cart_outlined,
                size: 48,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              const Text('Cart is empty'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/home'),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: outletAsync != null
            ? outletAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) =>
                    Center(child: Text('Error: $error')),
                data: (outlet) {
                  if (outlet == null) {
                    return const Center(child: Text('Outlet not found'));
                  }

                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Outlet Info
                        Text(
                          'Order From',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[200]!),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.restaurant_rounded,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      outlet.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      outlet.campusLocation,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(color: Colors.grey[600]),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.star_rounded,
                                            color: Colors.amber, size: 14),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${outlet.rating}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                  fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(width: 8),
                                        const Icon(Icons.access_time_rounded,
                                            color: Colors.grey, size: 14),
                                        const SizedBox(width: 4),
                                        Text(
                                          outlet.hoursOfOperation,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                  color: Colors.grey[600]),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Order Items
                        Text(
                          'Order Items',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            border: Border.all(color: Colors.grey[200]!),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: items.length,
                            separatorBuilder: (context, index) =>
                                const Divider(height: 24),
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.itemName,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                  fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${item.quantity} x ₹${item.price.toStringAsFixed(0)}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                  color: Colors.grey[600]),
                                        ),
                                        if (item.specialInstructions != null &&
                                            item.specialInstructions!
                                                .isNotEmpty)
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 4),
                                            child: Text(
                                              'Note: ${item.specialInstructions}',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                    fontStyle: FontStyle.italic,
                                                    color: AppTheme.primaryColor
                                                        .withValues(alpha: 0.7),
                                                  ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '₹${item.totalPrice.toStringAsFixed(0)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Order Summary
                        Text(
                          'Order Summary',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color:
                                AppTheme.primaryColor.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: AppTheme.primaryColor
                                    .withValues(alpha: 0.1)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Final Total',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                '₹${totalFinal.toStringAsFixed(0)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      color: AppTheme.primaryColor,
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Place Order Button
                        SizedBox(
                          width: double.infinity,
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
                                            .read(
                                                orderTrackingProvider.notifier)
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
                                              '/home/order-confirmation/${order.id}');
                                        }
                                      } catch (e) {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text('Error: $e'),
                                              duration:
                                                  const Duration(seconds: 2),
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
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Cannot place empty order')),
                                      );
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32),
                              ),
                              elevation: 4,
                              shadowColor:
                                  AppTheme.primaryColor.withValues(alpha: 0.3),
                            ),
                            child: _isProcessing
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2, color: Colors.white),
                                  )
                                : const Text('Confirm and Place Order'),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            : const SizedBox(),
      ),
    );
  }
}
