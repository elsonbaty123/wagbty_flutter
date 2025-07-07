import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';
import '../../providers/user_provider.dart';
import '../../widgets/main_scaffold.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  String? _profileImagePath;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserProvider);
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneController = TextEditingController(text: user?.phoneNumber ?? '');
    _profileImagePath = user?.profileImage;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _profileImagePath = image.path;
        });
      }
    } catch (e) {
      // Handle exceptions
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final user = ref.read(currentUserProvider);
    if (user == null) return;

    setState(() => _isLoading = true);

    try {
      final updatedUser = user.copyWith(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        profileImage: _profileImagePath,
      );
      await ref.read(userProvider.notifier).updateProfile(updatedUser);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تحديث الملف الشخصي بنجاح')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final user = ref.watch(currentUserProvider);

    return MainScaffold(
      currentIndex: 4,
      appBar: AppBar(
        title: const Text('تعديل الملف الشخصي'),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
      body: user == null
          ? _buildLoadingState(colorScheme)
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildProfileImage(),
                    const SizedBox(height: 24),
                    _buildNameField(),
                    const SizedBox(height: 16),
                    _buildEmailField(),
                    const SizedBox(height: 16),
                    _buildPhoneField(),
                    const SizedBox(height: 24),
                    _buildSaveButton(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(labelText: 'الاسم'),
      validator: (value) => (value?.isEmpty ?? true) ? 'الرجاء إدخال الاسم' : null,
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: const InputDecoration(labelText: 'البريد الإلكتروني'),
      keyboardType: TextInputType.emailAddress,
      validator: (value) => (value?.isEmpty ?? true) ? 'الرجاء إدخال البريد الإلكتروني' : null,
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      decoration: const InputDecoration(labelText: 'رقم الجوال'),
      keyboardType: TextInputType.phone,
      validator: (value) => (value?.isEmpty ?? true) ? 'الرجاء إدخال رقم الجوال' : null,
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _saveProfile,
      child: const Text('حفظ التغييرات'),
    );
  }

  Widget _buildProfileImage() {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          backgroundImage: _profileImagePath != null
              ? FileImage(File(_profileImagePath!))
              : null,
          child: _profileImagePath == null
              ? const Icon(Icons.person, size: 60)
              : null,
        ),
        Positioned(
          bottom: 0,
          right: 100,
          child: IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: _pickImage,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState(ColorScheme colorScheme) {
    return Shimmer.fromColors(
      baseColor: colorScheme.surfaceContainerHighest,
      highlightColor: colorScheme.onSurface.withAlpha(26), // 0.1 * 255 = 25.5
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CircleAvatar(radius: 60),
            const SizedBox(height: 24),
            _buildShimmerBox(height: 50),
            const SizedBox(height: 16),
            _buildShimmerBox(height: 50),
            const SizedBox(height: 16),
            _buildShimmerBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerBox({required double height, double? width}) {
    return Container(
      height: height,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
