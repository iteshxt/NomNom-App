import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../data/order_repository.dart';
import '../models/order.dart';

class OrdersPage extends ConsumerWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(ordersProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Your Orders'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Active'),
              Tab(text: 'Past'),
            ],
          ),
        ),
        body: ordersAsync.when(
          data: (orders) {
            final activeOrders = orders
                .where(
                  (o) =>
                      o.status != OrderStatus.completed &&
                      o.status != OrderStatus.cancelled,
                )
                .toList();
            final pastOrders = orders
                .where(
                  (o) =>
                      o.status == OrderStatus.completed ||
                      o.status == OrderStatus.cancelled,
                )
                .toList();

            // Sort by Date DESC
            activeOrders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
            pastOrders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

            return TabBarView(
              children: [
                _OrderList(orders: activeOrders, isActive: true),
                _OrderList(orders: pastOrders, isActive: false),
              ],
            );
          },
          error: (err, stack) => Center(child: Text('Error: $err')),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}

class _OrderList extends ConsumerWidget {
  final List<Order> orders;
  final bool isActive;

  const _OrderList({required this.orders, required this.isActive});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (orders.isEmpty) {
      return Center(
        child: Text(
          isActive ? 'No active orders' : 'No past orders',
          style: const TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Order #${order.id}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    _buildStatusChip(order.status),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  DateFormat('MMM dd, yyyy - hh:mm a').format(order.createdAt),
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                const Divider(),
                ...order.items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${item.quantity}x ${item.menuItem.name}'),
                        Text('₹${item.totalPrice}'),
                      ],
                    ),
                  ),
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '₹${order.totalAmount}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                if (isActive) ...[
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Advance status for demo
                        final nextStatus = _getNextStatus(order.status);
                        ref
                            .read(orderRepositoryProvider)
                            .updateOrderStatus(order.id, nextStatus);
                      },
                      child: const Text('Advance Status (Demo)'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusChip(OrderStatus status) {
    Color color;
    switch (status) {
      case OrderStatus.pending:
        color = Colors.orange;
        break;
      case OrderStatus.preparing:
        color = Colors.blue;
        break;
      case OrderStatus.ready:
        color = Colors.green;
        break;
      case OrderStatus.completed:
        color = Colors.grey;
        break;
      case OrderStatus.cancelled:
        color = Colors.red;
        break;
    }
    return Chip(
      label: Text(
        status.name.toUpperCase(),
        style: const TextStyle(color: Colors.white, fontSize: 10),
      ),
      backgroundColor: color,
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
    );
  }

  OrderStatus _getNextStatus(OrderStatus current) {
    const statuses = OrderStatus.values;
    final index = statuses.indexOf(current);
    if (index < statuses.length - 1) {
      return statuses[index + 1];
    }
    return current;
  }
}
