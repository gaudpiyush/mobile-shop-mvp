import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_provider.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.phone_android, size: 80, color: Colors.indigo),
              const SizedBox(height: 24),
              const Text(
                'Mobile Shop',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Browse and discover the latest mobile phones',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 48),

              // Error message
              if (authState.hasError)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    'Sign-in failed. Please try again.',
                    style: TextStyle(color: Colors.red[600]),
                  ),
                ),

              // Google Sign-In Button
              authState.isLoading
                  ? const CircularProgressIndicator()
                  : OutlinedButton.icon(
                      onPressed: () {
                        ref.read(authStateProvider.notifier).signInWithGoogle();
                      },
                      icon: Image.network(
                        'https://developers.google.com/identity/images/g-logo.png',
                        height: 20,
                      ),
                      label: const Text('Continue with Google'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 14),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}