import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../providers/index.dart';
import '../../widgets/outlet_info_card.dart';
import '../../widgets/menu_item_card.dart';
import '../../widgets/custom_bottom_nav.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Set default outlet if not already selected
    Future.microtask(() {
      if (ref.read(selectedOutletProvider) == null) {
        ref.read(selectedOutletProvider.notifier).state = 'outlet_1';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final outletsAsync = ref.watch(outletsProvider);
    final selectedOutletId = ref.watch(selectedOutletProvider);
    final menuAsync = ref.watch(menuProvider);

    final authState = ref.watch(authStateProvider);
    final isGuest = ref.watch(isGuestModeProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text('UniBites'),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () => context.go('/home/profile'),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.2),
                backgroundImage: authState?.profilePhoto != null
                    ? NetworkImage(authState!.profilePhoto!)
                    : null,
                child: authState?.profilePhoto == null
                    ? Icon(
                        Icons.person_rounded,
                        color: AppTheme.primaryColor.withValues(alpha: 0.1),
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
      body: outletsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading outlets',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        data: (outlets) => Column(
          children: [
            // Outlet Selector
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Outlet',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.black.withValues(alpha: 0.05),
                    ),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      underline: const SizedBox(),
                      value: selectedOutletId,
                      items: outlets
                          .map(
                            (outlet) => DropdownMenuItem(
                              value: outlet.id,
                              child: Text(outlet.name),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          ref.read(selectedOutletProvider.notifier).state =
                              value;
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Outlet Info Card
            if (selectedOutletId != null)
              Builder(
                builder: (context) {
                  final selectedOutlet = outlets.firstWhere(
                      (o) => o.id == selectedOutletId,
                      orElse: () => outlets[0]);
                  return OutletInfoCard(
                    outlet: selectedOutlet,
                    onTap: () {
                      // Show full outlet details (future implementation)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${selectedOutlet.name} details'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  );
                },
              ),
            // Menu Items
            Expanded(
              child: menuAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stackTrace) => Center(
                  child: Text('Error loading menu: $error'),
                ),
                data: (items) {
                  if (items.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.restaurant_menu,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No items available',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return MenuItemCard(
                        item: item,
                        onTap: () {
                          // Check if guest user wants to proceed
                          if (isGuest) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    const Text('Login to view item details'),
                                duration: const Duration(seconds: 2),
                                action: SnackBarAction(
                                  label: 'Login',
                                  onPressed: () => context.go('/login'),
                                ),
                              ),
                            );
                          } else {
                            context.go('/home/item/${item.id}');
                          }
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(
        currentItem: BottomNavItem.menu,
      ),
    );
  }
}
