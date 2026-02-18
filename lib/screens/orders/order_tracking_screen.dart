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
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Track Order'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: orderTrackingAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppTheme.primaryColor),
        ),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                'Something went wrong',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
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
                  Icon(Icons.search_off_rounded,
                      size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    'Order not found',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.go('/home'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Go Home'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Status Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryColor,
                          AppTheme.primaryColor.withValues(alpha: 0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'ORDER #${tracking.orderNumber}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          tracking.isReady
                              ? 'Your Order is Ready!'
                              : '${tracking.minutesRemaining} min',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tracking.isReady
                              ? 'Please pick it up at the counter'
                              : 'Estimated preparation time',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Timeline
                  _buildStatusTimeline(context, tracking),

                  const SizedBox(height: 40),

                  // Location Details
                  _buildSectionTitle('PICKUP LOCATION'),
                  const SizedBox(height: 16),
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
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color:
                                AppTheme.secondaryColor.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.storefront_rounded,
                            color: AppTheme.primaryColor,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tracking.outletName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                tracking.outletLocation ?? 'Main Campus',
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

                  // Order Summary
                  _buildSectionTitle('ORDER SUMMARY'),
                  const SizedBox(height: 16),
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
                    child: Column(
                      children: [
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: tracking.items.length,
                          separatorBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Divider(
                              height: 1,
                              color: Colors.grey[100],
                            ),
                          ),
                          itemBuilder: (context, index) {
                            final item = tracking.items[index];
                            return Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${item.quantity}x',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: AppTheme.primaryColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    item.itemName,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
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
                        const SizedBox(height: 20),
                        Divider(color: Colors.grey[200]),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Amount',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '₹${tracking.totalAmount.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Action Button
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
                                content:
                                    Text('Order picked up! Enjoy your meal!'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                            context.go('/home');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                          shadowColor: Colors.green.withValues(alpha: 0.4),
                        ),
                        child: const Text(
                          'I\'VE PICKED IT UP',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
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

  Widget _buildStatusTimeline(BuildContext context, Order tracking) {
    final statuses = [
      OrderStatus.confirmed,
      OrderStatus.preparing,
      OrderStatus.ready,
    ];

    int currentStep = 0;
    if (tracking.currentStatus == 'preparing') currentStep = 1;
    if (tracking.currentStatus == 'ready') currentStep = 2;
    if (tracking.currentStatus == 'fulfilled') currentStep = 3;

    return Row(
      children: [
        for (int i = 0; i < statuses.length; i++) ...[
          // Dot
          Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color:
                      i <= currentStep ? AppTheme.primaryColor : Colors.white,
                  border: Border.all(
                    color: i <= currentStep
                        ? AppTheme.primaryColor
                        : Colors.grey[300]!,
                    width: 2,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: i <= currentStep
                      ? [
                          BoxShadow(
                            color: AppTheme.primaryColor.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          )
                        ]
                      : null,
                ),
                child: Center(
                  child: Icon(
                    _getStatusIcon(statuses[i]),
                    size: 16,
                    color: i <= currentStep ? Colors.white : Colors.grey[300],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _getStatusLabel(statuses[i]),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: i <= currentStep ? Colors.black87 : Colors.grey[400],
                ),
              ),
            ],
          ),
          // Line
          if (i < statuses.length - 1)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Container(
                  height: 2,
                  color: i < currentStep
                      ? AppTheme.primaryColor
                      : Colors.grey[200],
                ),
              ),
            ),
        ],
      ],
    );
  }

  IconData _getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.confirmed:
        return Icons.check_rounded;
      case OrderStatus.preparing:
        return Icons.local_dining_rounded;
      case OrderStatus.ready:
        return Icons.shopping_bag_rounded;
      default:
        return Icons.circle;
    }
  }

  String _getStatusLabel(OrderStatus status) {
    switch (status) {
      case OrderStatus.confirmed:
        return 'Placed';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.ready:
        return 'Ready';
      default:
        return '';
    }
  }
}
