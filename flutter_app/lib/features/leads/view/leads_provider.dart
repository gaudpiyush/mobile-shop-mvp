import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/leads_repository.dart';

final leadsRepositoryProvider = Provider<LeadsRepository>((ref) {
  return LeadsRepository();
});

// Holds list of mobile IDs user has registered interest in
final userLeadsProvider =
    StateNotifierProvider<UserLeadsNotifier, AsyncValue<List<String>>>(
  (ref) => UserLeadsNotifier(ref.read(leadsRepositoryProvider)),
);

class UserLeadsNotifier extends StateNotifier<AsyncValue<List<String>>> {
  final LeadsRepository _repository;

  UserLeadsNotifier(this._repository) : super(const AsyncValue.data([]));

  Future<void> fetchUserLeads(String userId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _repository.getUserLeadMobileIds(userId),
    );
  }

  Future<void> registerInterest({
    required String userId,
    required String mobileId,
  }) async {
    try {
      await _repository.registerInterest(
        userId: userId,
        mobileId: mobileId,
      );
      // Add to local state without refetching
      final current = state.value ?? [];
      state = AsyncValue.data([...current, mobileId]);
    } catch (e) {
      // Keep existing state, let UI handle error
      rethrow;
    }
  }

  bool hasRegisteredInterest(String mobileId) {
    return state.value?.contains(mobileId) ?? false;
  }
}