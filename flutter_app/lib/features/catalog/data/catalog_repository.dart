import '../../../core/api_client.dart';
import '../domain/mobile_model.dart';

class CatalogRepository {
  Future<List<MobileModel>> getMobiles({
    String? search,
    String? brand,
    double? minPrice,
    double? maxPrice,
    String? stockStatus,
  }) async {
    final queryParams = <String, dynamic>{};

    if (search != null && search.isNotEmpty) queryParams['search'] = search;
    if (brand != null && brand.isNotEmpty) queryParams['brand'] = brand;
    if (minPrice != null) queryParams['min_price'] = minPrice;
    if (maxPrice != null) queryParams['max_price'] = maxPrice;
    if (stockStatus != null && stockStatus.isNotEmpty) {
      queryParams['stock_status'] = stockStatus;
    }

    final response = await ApiClient.instance.get(
      '/mobiles',
      queryParameters: queryParams,
    );

    final List mobiles = response.data['mobiles'];
    return mobiles.map((m) => MobileModel.fromJson(m)).toList();
  }

  Future<MobileModel> getMobileById(String mobileId) async {
    final response = await ApiClient.instance.get('/mobiles/$mobileId');
    return MobileModel.fromJson(response.data);
  }
}