import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../models/index.dart';
import '../../providers/index.dart';

class OrderTrackingScreen extends ConsumerStatefulWidget {
  final String orderId;

  const OrderTrackingScreen({
    super.key,
    required this.orderId,
  });

  @override
  ConsumerState<OrderTrackingScreen> createState() =>
      _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends ConsumerState<OrderTrackingScreen> {
  @override
  Widget build(BuildContext context) {
    final orderTrackingAsync =
        ref.watch(specificOrderTrackingProvider(widget.orderId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Tracking'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: orderTrackingAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/home'),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
        data: (tracking) {
          if (tracking == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info_outline, size: 48, color: Colors.blue[400]),
                  const SizedBox(height: 16),
                  const Text('Order not found'),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.go('/home'),
                    child: const Text('Go Home'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with Order Status
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order #${tracking.orderNumber}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _statusLabelFromString(tracking.currentStatus),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                        // Time Remaining
                        if (tracking.minutesRemaining > 0)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                color: Colors.blue[600],
                                size: 28,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '~${tracking.minutesRemaining} min',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Colors.blue[600],
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          )
                        else
                          Icon(
                            Icons.check_circle,
                            color: Colors.green[600],
                            size: 32,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Status Timeline
                  Text(
                    'Order Status',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _buildStatusTimeline(context, tracking),
                  const SizedBox(height: 32),
                  // Outlet Details Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pickup Location',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              color: AppTheme.primaryColor,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tracking.outletName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    tracking.outletLocation ??
                                        'Campus Location',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Order Summary
                  if (tracking.items.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order Items',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            border: Border.all(color: Colors.grey[200]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: tracking.items.length,
                            itemBuilder: (context, index) {
                              final item = tracking.items[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${item.quantity}x ${item.itemName}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '₹${item.totalPrice.toStringAsFixed(0)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Total
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Amount',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              '₹${tracking.totalAmount.toStringAsFixed(0)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  const SizedBox(height: 32),
                  // CTA Buttons
                  if (tracking.isReady)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          await ref
                              .read(orderTrackingProvider.notifier)
                              .markAsPickedUp(widget.orderId);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Order marked as picked up! Thank you for ordering.'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                            context.go('/home');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: Colors.green[400],
                        ),
                        child: const Text('I\'ve Picked It Up'),
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        border: Border.all(color: Colors.blue[200]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.blue[600],
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'We\'ll notify you when your order is ready for pickup!',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: Colors.blue[600]),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusTimeline(BuildContext context, Order tracking) {
    final statuses = [
      OrderStatus.confirmed,
      OrderStatus.preparing,
      OrderStatus.ready,
      OrderStatus.fulfilled,
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          statuses.length,
          (index) {
            final status = statuses[index];
            final statusIndexInList = statuses.indexOf(status);
            final currentStatusIndex = statuses.indexWhere(
              (s) => s.toString().split('.').last == tracking.currentStatus,
            );

            final isCompleted = statusIndexInList < currentStatusIndex ||
                tracking.currentStatus == 'fulfilled' &&
                    status == OrderStatus.fulfilled;
            final isCurrent = statusIndexInList == currentStatusIndex &&
                tracking.currentStatus != 'fulfilled';

            return Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      // Leading Line
                      if (index != 0)
                        Expanded(
                          child: Container(
                            height: 2,
                            color: statusIndexInList <= currentStatusIndex
                                ? AppTheme.primaryColor
                                : Colors.grey[300],
                          ),
                        ),
                      // Dot
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isCompleted ||
                                  (isCurrent &&
                                      tracking.currentStatus != 'fulfilled')
                              ? (isCompleted
                                  ? Colors.green[500]
                                  : AppTheme.primaryColor)
                              : Colors.grey[300],
                          border: isCurrent
                              ? Border.all(
                                  color: AppTheme.primaryColor
                                      .withValues(alpha: 0.2),
                                  width: 4)
                              : null,
                        ),
                        child: Center(
                          child: isCompleted
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 14,
                                )
                              : null,
                        ),
                      ),
                      // Trailing Line
                      if (index != statuses.length - 1)
                        Expanded(
                          child: Container(
                            height: 2,
                            color: statusIndexInList < currentStatusIndex
                                ? AppTheme.primaryColor
                                : Colors.grey[300],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _statusLabel(status).replaceAll('Your Order', ''),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 10,
                          fontWeight: isCurrent || isCompleted
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: isCurrent
                              ? AppTheme.primaryColor
                              : isCompleted
                                  ? Colors.green[700]
                                  : Colors.grey[600],
                        ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String _statusLabel(OrderStatus status) {
    switch (status) {
      case OrderStatus.confirmed:
        return 'Order Confirmed';
      case OrderStatus.preparing:
        return 'Preparing Your Order';
      case OrderStatus.ready:
        return 'Ready for Pickup';
      case OrderStatus.fulfilled:
        return 'Order Picked Up';
    }
  }

  String _statusLabelFromString(String status) {
    switch (status) {
      case 'confirmed':
        return 'Order Confirmed';
      case 'preparing':
        return 'Preparing Your Order';
      case 'ready':
        return 'Ready for Pickup';
      case 'fulfilled':
        return 'Order Picked Up';
      default:
        return 'Unknown Status';
    }
  }
}
