import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'catalog_provider.dart';
import 'mobile_detail_screen.dart';
import '../../auth/view/auth_provider.dart';

class CatalogScreen extends ConsumerWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mobilesState = ref.watch(mobilesProvider);
    final filter = ref.watch(catalogFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile Shop'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authStateProvider.notifier).signOut(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and filter bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search field
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search by brand or model...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onChanged: (value) => ref
                      .read(catalogFilterProvider.notifier)
                      .updateSearch(value),
                ),
                const SizedBox(height: 12),
                // Filter chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _FilterChip(
                        label: 'All',
                        selected: filter.stockStatus.isEmpty,
                        onTap: () => ref
                            .read(catalogFilterProvider.notifier)
                            .updateStockStatus(''),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Available',
                        selected: filter.stockStatus == 'available',
                        onTap: () => ref
                            .read(catalogFilterProvider.notifier)
                            .updateStockStatus('available'),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Out of Stock',
                        selected: filter.stockStatus == 'out_of_stock',
                        onTap: () => ref
                            .read(catalogFilterProvider.notifier)
                            .updateStockStatus('out_of_stock'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Mobiles list
          Expanded(
            child: mobilesState.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Failed to load mobiles: $error'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          ref.refresh(mobilesProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              data: (mobiles) => mobiles.isEmpty
                  ? const Center(child: Text('No mobiles found'))
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        // Responsive grid — 1 col on mobile, 2+ on wider screens
                        final crossAxisCount =
                            constraints.maxWidth > 600 ? 2 : 1;
                        return GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 2.5,
                          ),
                          itemCount: mobiles.length,
                          itemBuilder: (context, index) {
                            final mobile = mobiles[index];
                            return Card(
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => MobileDetailScreen(
                                      mobileId: mobile.id,
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.phone_android,
                                          size: 40, color: Colors.indigo),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${mobile.brand} ${mobile.model}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '₹${mobile.price.toStringAsFixed(0)}',
                                              style: const TextStyle(
                                                color: Colors.indigo,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: mobile.stockStatus ==
                                                  'available'
                                              ? Colors.green[50]
                                              : Colors.red[50],
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          mobile.stockStatus == 'available'
                                              ? 'Available'
                                              : 'Out of Stock',
                                          style: TextStyle(
                                            color: mobile.stockStatus ==
                                                    'available'
                                                ? Colors.green[700]
                                                : Colors.red[700],
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Colors.indigo : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.grey[700],
            fontWeight:
                selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}