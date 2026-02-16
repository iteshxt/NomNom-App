import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/menu_repository.dart';
// Models inferred from repository
import 'menu_controller.dart';
import '../../cart/application/cart_controller.dart';

class MenuPage extends ConsumerWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final outletsAsync = ref.watch(outletsProvider);
    final selectedOutletId = ref.watch(selectedOutletIdProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('UniBite'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: outletsAsync.when(
            data: (outlets) {
              if (outlets.isEmpty) return const SizedBox.shrink();

              // Auto-select first outlet if none selected
              if (selectedOutletId == null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ref
                      .read(selectedOutletIdProvider.notifier)
                      .select(outlets.first.id);
                });
              }

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: outlets.map((outlet) {
                    final isSelected = outlet.id == selectedOutletId;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FilterChip(
                        selected: isSelected,
                        label: Text(outlet.name),
                        onSelected: (selected) {
                          if (selected) {
                            ref
                                .read(selectedOutletIdProvider.notifier)
                                .select(outlet.id);
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),
              );
            },
            error: (err, stack) => Text('Error: $err'),
            loading: () => const LinearProgressIndicator(),
          ),
        ),
      ),
      body: selectedOutletId == null
          ? const Center(child: CircularProgressIndicator())
          : Consumer(
              builder: (context, ref, child) {
                final menuAsync = ref.watch(menuProvider(selectedOutletId));
                return menuAsync.when(
                  data: (items) {
                    if (items.isEmpty) {
                      return const Center(child: Text("No items available"));
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Image placeholder
                              Container(
                                height: 150,
                                width: double.infinity,
                                color: Colors.grey.shade300,
                                child: Image.network(
                                  item.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (ctx, _, _) => const Icon(
                                    Icons.fastfood,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          item.name,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleLarge,
                                        ),
                                        Text(
                                          '₹${item.price}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                color: Theme.of(
                                                  context,
                                                ).primaryColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.description,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: Colors.grey.shade600,
                                          ),
                                    ),
                                    const SizedBox(height: 12),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: FilledButton.icon(
                                        onPressed: () {
                                          ref
                                              .read(cartProvider.notifier)
                                              .addItem(item);
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                '${item.name} added to cart',
                                              ),
                                              duration: const Duration(
                                                seconds: 1,
                                              ),
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.add),
                                        label: const Text("Add"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  error: (err, stack) => Center(child: Text('Error: $err')),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                );
              },
            ),
    );
  }
}
