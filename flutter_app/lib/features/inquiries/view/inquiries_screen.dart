import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'inquiries_provider.dart';
import '../../auth/view/auth_provider.dart';

class InquiriesScreen extends ConsumerWidget {
  final String mobileId;

  const InquiriesScreen({super.key, required this.mobileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inquiriesState = ref.watch(inquiriesProvider(mobileId));
    final user = ref.watch(authStateProvider).value;
    final questionController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Questions & Answers')),
      body: Column(
        children: [
          // Inquiries list
          Expanded(
            child: inquiriesState.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (error, _) =>
                  Center(child: Text('Error: $error')),
              data: (inquiries) => inquiries.isEmpty
                  ? const Center(
                      child: Text('No questions yet. Be the first to ask!'),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: inquiries.length,
                      itemBuilder: (context, index) {
                        final inquiry = inquiries[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Question
                                Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.person_outline,
                                        size: 18, color: Colors.grey),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(inquiry.questionText),
                                    ),
                                  ],
                                ),
                                // Vendor reply if exists
                                if (inquiry.vendorReply != null) ...[
                                  const Divider(height: 24),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.store_outlined,
                                          size: 18, color: Colors.indigo),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          inquiry.vendorReply!,
                                          style: const TextStyle(
                                              color: Colors.indigo),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),

          // Post question input
          if (user != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: questionController,
                      decoration: InputDecoration(
                        hintText: 'Ask a question...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton.filled(
                    onPressed: () async {
                      final text = questionController.text.trim();
                      if (text.isEmpty) return;

                      try {
                        await ref
                            .read(inquiriesProvider(mobileId).notifier)
                            .postInquiry(
                              userId: user.uid,
                              questionText: text,
                            );
                        questionController.clear();
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.send),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}