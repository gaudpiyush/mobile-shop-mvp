import '../../../core/api_client.dart';

class LeadsRepository {
  Future<void> registerInterest({
    required String userId,
    required String mobileId,
  }) async {
    await ApiClient.instance.post(
      '/leads',
      data: {
        'user_id': userId,
        'mobile_id': mobileId,
      },
    );
  }

  Future<List<String>> getUserLeadMobileIds(String userId) async {
    final response = await ApiClient.instance.get('/leads/me/$userId');
    final List leads = response.data;
    // Return just the mobile IDs so UI can check if interest is registered
    return leads.map((l) => l['mobile_id'] as String).toList();
  }
}