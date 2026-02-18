import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme.dart';
import '../../providers/index.dart';
import '../../widgets/index.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // No hardcoded default, will be selected dynamically once outlets load
  }

  @override
  Widget build(BuildContext context) {
    final outletsAsync = ref.watch(outletsProvider);
    final selectedOutletId = ref.watch(selectedOutletProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final menuAsync = ref.watch(menuProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final hasItems = ref.watch(currentOrderProvider).items.isNotEmpty;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'UniBites',
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          outletsAsync.when(
            data: (outlets) => Container(
              margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppTheme.secondaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedOutletId,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded,
                      color: AppTheme.primaryColor, size: 20),
                  style: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                  onChanged: (value) {
                    if (value != null && value != selectedOutletId) {
                      ref.read(currentOrderProvider.notifier).clearOrder();
                      ref.read(selectedCategoryProvider.notifier).state = 'All';
                      ref.read(selectedOutletProvider.notifier).state = value;
                    }
                  },
                  items: outlets.map((outlet) {
                    return DropdownMenuItem<String>(
                      value: outlet.id,
                      child: Text(outlet.name),
                    );
                  }).toList(),
                ),
              ),
            ),
            loading: () => const _SkeletonPill(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: outletsAsync.when(
        skipLoadingOnRefresh: false,
        loading: () => const _HomeSkeleton(),
        error: (error, stackTrace) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height -
                AppBar().preferredSize.height -
                MediaQuery.of(context).padding.top,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Something went wrong',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => ref.invalidate(outletsProvider),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            ),
          ),
        ),
        data: (outlets) {
          if (outlets.isEmpty) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height -
                    AppBar().preferredSize.height -
                    MediaQuery.of(context).padding.top,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.store_outlined,
                          size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      const Text('No Outlets Found'),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => ref.invalidate(outletsProvider),
                        child: const Text('Refresh'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          // Select first outlet if none selected
          if (selectedOutletId == null && outlets.isNotEmpty) {
            Future.microtask(() {
              ref.read(selectedOutletProvider.notifier).state = outlets[0].id;
            });
          }

          return CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Outlet Info Card
                    if (selectedOutletId != null)
                      Builder(
                        builder: (context) {
                          final selectedOutlet = outlets.firstWhere(
                              (o) => o.id == selectedOutletId,
                              orElse: () => outlets[0]);
                          return OutletInfoCard(
                            outlet: selectedOutlet,
                            onTap: () {},
                          );
                        },
                      ),

                    // Categories Selector
                    categoriesAsync.when(
                      skipLoadingOnRefresh: false,
                      data: (categories) {
                        final allCategories = ['All', ...categories];
                        return Container(
                          height: 50,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: allCategories.length,
                            itemBuilder: (context, index) {
                              final category = allCategories[index];
                              final isSelected = selectedCategory == category;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ChoiceChip(
                                  label: Text(category),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    if (selected) {
                                      ref
                                          .read(
                                              selectedCategoryProvider.notifier)
                                          .state = category;
                                    }
                                  },
                                  selectedColor: AppTheme.primaryColor,
                                  labelStyle: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black87,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                  backgroundColor: Colors.grey[200],
                                  side: BorderSide.none,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                      loading: () => const _SkeletonCategories(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
              // Menu Items
              menuAsync.when(
                skipLoadingOnRefresh: false,
                loading: () => const SliverFillRemaining(
                  child: _SkeletonMenu(),
                ),
                error: (error, stackTrace) => const SliverFillRemaining(
                  child: Center(
                    child: Text('Menu items could not be loaded.'),
                  ),
                ),
                data: (items) {
                  final filteredItems = selectedCategory == 'All'
                      ? items
                      : items
                          .where((item) => item.category == selectedCategory)
                          .toList();

                  if (filteredItems.isEmpty) {
                    return const SliverFillRemaining(
                      child: Center(child: Text('No items in this category')),
                    );
                  }

                  return SliverPadding(
                    padding: EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 8,
                        bottom: hasItems ? 100 : 24),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.72,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return MenuItemCard(
                            item: filteredItems[index],
                            onTap: null,
                          );
                        },
                        childCount: filteredItems.length,
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SkeletonPill extends StatelessWidget {
  const _SkeletonPill();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 32,
      margin: const EdgeInsets.only(right: 16, top: 12, bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

class _HomeSkeleton extends StatelessWidget {
  const _HomeSkeleton();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Outlet Card Skeleton
        Container(
          height: 160,
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        const _SkeletonCategories(),
        const Expanded(child: _SkeletonMenu()),
      ],
    );
  }
}

class _SkeletonCategories extends StatelessWidget {
  const _SkeletonCategories();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 5,
        itemBuilder: (context, index) => Container(
          width: 80,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}

class _SkeletonMenu extends StatelessWidget {
  const _SkeletonMenu();
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 4,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) => Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
