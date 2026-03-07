import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/catalog_repository.dart';
import '../domain/mobile_model.dart';

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  return CatalogRepository();
});

// Holds search and filter state
class CatalogFilter {
  final String search;
  final String brand;
  final double? minPrice;
  final double? maxPrice;
  final String stockStatus;

  const CatalogFilter({
    this.search = '',
    this.brand = '',
    this.minPrice,
    this.maxPrice,
    this.stockStatus = '',
  });

  CatalogFilter copyWith({
    String? search,
    String? brand,
    double? minPrice,
    double? maxPrice,
    String? stockStatus,
  }) =>
      CatalogFilter(
        search: search ?? this.search,
        brand: brand ?? this.brand,
        minPrice: minPrice ?? this.minPrice,
        maxPrice: maxPrice ?? this.maxPrice,
        stockStatus: stockStatus ?? this.stockStatus,
      );
}

final catalogFilterProvider =
    StateNotifierProvider<CatalogFilterNotifier, CatalogFilter>(
  (ref) => CatalogFilterNotifier(),
);

class CatalogFilterNotifier extends StateNotifier<CatalogFilter> {
  CatalogFilterNotifier() : super(const CatalogFilter());

  void updateSearch(String search) =>
      state = state.copyWith(search: search);

  void updateBrand(String brand) =>
      state = state.copyWith(brand: brand);

  void updateStockStatus(String stockStatus) =>
      state = state.copyWith(stockStatus: stockStatus);

  void clearFilters() => state = const CatalogFilter();
}

// Fetches mobiles whenever filter changes
final mobilesProvider =
    FutureProvider.autoDispose<List<MobileModel>>((ref) async {
  final filter = ref.watch(catalogFilterProvider);
  final repository = ref.read(catalogRepositoryProvider);

  return repository.getMobiles(
    search: filter.search,
    brand: filter.brand,
    minPrice: filter.minPrice,
    maxPrice: filter.maxPrice,
    stockStatus: filter.stockStatus,
  );
});

// Single mobile detail
final mobileDetailProvider =
    FutureProvider.autoDispose.family<MobileModel, String>((ref, mobileId) {
  final repository = ref.read(catalogRepositoryProvider);
  return repository.getMobileById(mobileId);
});