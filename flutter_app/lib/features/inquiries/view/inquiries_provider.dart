import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/inquiries_repository.dart';
import '../domain/inquiry_model.dart';

final inquiriesRepositoryProvider = Provider<InquiriesRepository>((ref) {
  return InquiriesRepository();
});

// Fetches inquiries for a specific mobile
final inquiriesProvider = StateNotifierProvider.family
    .autoDispose<InquiriesNotifier, AsyncValue<List<InquiryModel>>, String>(
  (ref, mobileId) =>
      InquiriesNotifier(ref.read(inquiriesRepositoryProvider), mobileId),
);

class InquiriesNotifier
    extends StateNotifier<AsyncValue<List<InquiryModel>>> {
  final InquiriesRepository _repository;
  final String _mobileId;

  InquiriesNotifier(this._repository, this._mobileId)
      : super(const AsyncValue.loading()) {
    fetchInquiries();
  }

  Future<void> fetchInquiries() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _repository.getInquiries(_mobileId),
    );
  }

  Future<void> postInquiry({
    required String userId,
    required String questionText,
  }) async {
    try {
      final inquiry = await _repository.postInquiry(
        userId: userId,
        mobileId: _mobileId,
        questionText: questionText,
      );
      // Append new inquiry to existing list without refetching
      final current = state.value ?? [];
      state = AsyncValue.data([...current, inquiry]);
    } catch (e) {
      rethrow;
    }
  }
}