import 'package:flutter/material.dart';
import '../../widgets/main_scaffold.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final token = ref.watch(authProvider);
    
    return MainScaffold(
      currentIndex: 4,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            if (token == null) ...[  // Not logged in state
              _buildAuthHeader(),
              const SizedBox(height: 30),
              _buildAuthOptions(context, ref),
            ] else ...[  // Logged in state
              _buildUserProfile(context, ref),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAuthHeader() {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[200],
            border: Border.all(color: Colors.blue, width: 2),
          ),
          child: const Icon(Icons.person_outline, size: 60, color: Colors.blue),
        ),
        const SizedBox(height: 20),
        const Text(
          'مرحباً بك في تطبيق وجبتي',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        const Text(
          'سجل الدخول أو أنشئ حساباً جديداً للاستمتاع بمميزات التطبيق',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildAuthOptions(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // Login Button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () => context.push('/login'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'تسجيل الدخول',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 15),
        // Signup Button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
            onPressed: () => context.push('/signup'),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.blue),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'إنشاء حساب جديد',
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Or continue as guest
        TextButton(
          onPressed: () {
            // Continue as guest
            context.go('/');
          },
          child: const Text(
            'متابعة كزائر',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildUserProfile(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // User Avatar
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue[50],
            border: Border.all(color: Colors.blue, width: 2),
          ),
          child: const Icon(Icons.person, size: 60, color: Colors.blue),
        ),
        const SizedBox(height: 20),
        
        // User Name
        const Text(
          'أهلاً بك',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        const Text(
          'user@example.com',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 30),
        
        // Profile Actions
        _buildProfileAction(
          icon: Icons.settings,
          title: 'الإعدادات',
          onTap: () => context.push('/settings'),
        ),
        const Divider(),
        _buildProfileAction(
          icon: Icons.favorite_border,
          title: 'المفضلة',
          onTap: () => context.push('/favorites'),
        ),
        const Divider(),
        _buildProfileAction(
          icon: Icons.history,
          title: 'سجل الطلبات',
          onTap: () {},
        ),
        const Divider(),
        const SizedBox(height: 30),
        
        // Logout Button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.logout, color: Colors.red),
            label: const Text(
              'تسجيل الخروج',
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
            onPressed: () {
              ref.read(authProvider.notifier).logout();
              context.go('/');
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.red),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileAction({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16),
        textAlign: TextAlign.right,
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }
}
