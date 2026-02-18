import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/index.dart';
import '../../config/theme.dart';
import 'order_summary_sheet.dart';

class ViewOrderPill extends ConsumerWidget {
  const ViewOrderPill({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentOrder = ref.watch(currentOrderProvider);
    final outletAsync = currentOrder.outletId != null
        ? ref.watch(outletProvider(currentOrder.outletId!))
        : null;

    if (currentOrder.itemCount == 0) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        gradient: const LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.accentColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(32),
          onTap: () => _showOrderSummary(context, ref),
          child: Container(
            height: 72,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${currentOrder.itemCount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      outletAsync?.when(
                            data: (outlet) => Text(
                              outlet?.name ?? 'UNI BITES',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 13,
                                letterSpacing: 0.5,
                              ),
                            ),
                            loading: () => const Text('Loading...',
                                style: TextStyle(color: Colors.white70)),
                            error: (_, __) => const Text('UNI BITE',
                                style: TextStyle(color: Colors.white)),
                          ) ??
                          const Text('UNI BITES',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                      Text(
                        currentOrder.items.map((e) => e.itemName).join(', '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '₹${currentOrder.totalAmount.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showOrderSummary(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Consumer(
        builder: (context, ref, _) {
          final currentOrder = ref.watch(currentOrderProvider);
          if (currentOrder.itemCount == 0) {
            // ignore: use_build_context_synchronously
            Future.microtask(() => Navigator.pop(context));
            return const SizedBox.shrink();
          }

          return OrderSummarySheet(
            items: currentOrder.items,
            totalAmount: currentOrder.totalAmount,
            onUpdateQuantity: (item, qty) {
              ref.read(currentOrderProvider.notifier).updateQuantity(item, qty);
            },
            onProceed: () {
              Navigator.pop(context);
              final authState = ref.read(authStateProvider);
              if (authState == null) {
                // If guest, redirect to login
                context.push('/login');
              } else {
                context.push('/checkout', extra: {
                  'outletId': currentOrder.outletId,
                  'items': currentOrder.items,
                  'totalAmount': currentOrder.totalAmount,
                });
              }
            },
          );
        },
      ),
    );
  }
}
