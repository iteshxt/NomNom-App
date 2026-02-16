import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../orders/data/order_repository.dart';
import '../../orders/models/order.dart';

class NotificationListenerWidget extends ConsumerStatefulWidget {
  final Widget child;
  const NotificationListenerWidget({super.key, required this.child});

  @override
  ConsumerState<NotificationListenerWidget> createState() =>
      _NotificationListenerWidgetState();
}

class _NotificationListenerWidgetState
    extends ConsumerState<NotificationListenerWidget> {
  // Keep track of orders we've already notified about for 'ready' state
  final Set<String> _notifiedReadyOrderIds = {};

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<List<Order>>>(ordersProvider, (previous, next) {
      next.whenData((orders) {
        for (final order in orders) {
          if (order.status == OrderStatus.ready &&
              !_notifiedReadyOrderIds.contains(order.id)) {
            _notifiedReadyOrderIds.add(order.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Order #${order.id} is READY for pickup!'),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 5),
                action: SnackBarAction(
                  label: 'VIEW',
                  textColor: Colors.white,
                  onPressed: () {
                    // Navigate to orders? (Already there if context allows, or handled by router)
                    // For now just dismiss
                  },
                ),
              ),
            );
          }
        }
      });
    });

    return widget.child;
  }
}
