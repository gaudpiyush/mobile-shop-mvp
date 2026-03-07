import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'catalog_provider.dart';
import '../../leads/view/leads_provider.dart';
import '../../inquiries/view/inquiries_screen.dart';
import '../../auth/view/auth_provider.dart';

class MobileDetailScreen extends ConsumerWidget {
  final String mobileId;

  const MobileDetailScreen({super.key, required this.mobileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mobileState = ref.watch(mobileDetailProvider(mobileId));
    final authState = ref.watch(authStateProvider);
    final leadsState = ref.watch(userLeadsProvider);
    final user = authState.value;

    return Scaffold(
      appBar: AppBar(title: const Text('Mobile Details')),
      body: mobileState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (mobile) {
          final hasInterest = leadsState.value?.contains(mobileId) ?? false;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mobile header
                  Center(
                    child: Column(
                      children: [
                        const Icon(Icons.phone_android,
                            size: 100, color: Colors.indigo),
                        const SizedBox(height: 16),
                        Text(
                          '${mobile.brand} ${mobile.model}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '₹${mobile.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.indigo,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: mobile.stockStatus == 'available'
                                ? Colors.green[50]
                                : Colors.red[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            mobile.stockStatus == 'available'
                                ? 'In Stock'
                                : 'Out of Stock',
                            style: TextStyle(
                              color: mobile.stockStatus == 'available'
                                  ? Colors.green[700]
                                  : Colors.red[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Specs section
                  const Text(
                    'Specifications',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _SpecRow(label: 'RAM', value: mobile.specs.ram),
                          _SpecRow(
                              label: 'Storage', value: mobile.specs.storage),
                          _SpecRow(
                              label: 'Camera', value: mobile.specs.camera),
                          _SpecRow(
                              label: 'Battery', value: mobile.specs.battery),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Register Interest button
                  if (user != null)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: hasInterest
                            ? null
                            : () async {
                                try {
                                  await ref
                                      .read(userLeadsProvider.notifier)
                                      .registerInterest(
                                        userId: user.uid,
                                        mobileId: mobileId,
                                      );
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Interest registered!'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }
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
                        icon: Icon(hasInterest
                            ? Icons.check
                            : Icons.favorite_border),
                        label: Text(hasInterest
                            ? 'Interest Registered'
                            : 'Register Interest'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor:
                              hasInterest ? Colors.grey : Colors.indigo,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),

                  const SizedBox(height: 16),

                  // Inquiries section
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              InquiriesScreen(mobileId: mobileId),
                        ),
                      ),
                      icon: const Icon(Icons.question_answer_outlined),
                      label: const Text('View / Ask Questions'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SpecRow extends StatelessWidget {
  final String label;
  final String value;

  const _SpecRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 14)),
        ],
      ),
    );
  }
}