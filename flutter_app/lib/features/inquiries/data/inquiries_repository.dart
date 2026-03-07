import '../../../core/api_client.dart';
import '../domain/inquiry_model.dart';

class InquiriesRepository {
  Future<List<InquiryModel>> getInquiries(String mobileId) async {
    final response = await ApiClient.instance.get('/inquiries/$mobileId');
    final List inquiries = response.data;
    return inquiries.map((i) => InquiryModel.fromJson(i)).toList();
  }

  Future<InquiryModel> postInquiry({
    required String userId,
    required String mobileId,
    required String questionText,
  }) async {
    final response = await ApiClient.instance.post(
      '/inquiries',
      data: {
        'user_id': userId,
        'mobile_id': mobileId,
        'question_text': questionText,
      },
    );
    return InquiryModel.fromJson(response.data);
  }
}