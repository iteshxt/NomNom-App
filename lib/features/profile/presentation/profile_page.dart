import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../auth/auth_controller.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).asData?.value;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: user == null
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    child: Icon(Icons.person, size: 50),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.displayName ?? 'User',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user.email ?? '',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 32),
                  ListTile(
                    leading: const Icon(Icons.history),
                    title: const Text('Order History'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      context.go('/home/orders');
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () async {
                      await ref.read(authControllerProvider.notifier).logout();
                      // Router listener should redirect to login
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
