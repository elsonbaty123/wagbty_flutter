import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class UserNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  static const String _userKey = 'user_data';

  UserNotifier() : super(const AsyncValue.loading()) {
    _loadUser();
  }

  // Load user from SharedPreferences
  Future<void> _loadUser() async {
    try {
      state = const AsyncValue.loading();
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);
      
      if (userJson != null) {
        // In a real app, you would parse the JSON and create a UserModel
        // For now, we'll use a placeholder
        final user = UserModel(
          id: '1',
          name: 'مستخدم جديد',
          email: 'user@example.com',
          phoneNumber: '+966501234567',
        );
        state = AsyncValue.data(user);
      } else {
        state = const AsyncValue.data(null);
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  // Update user profile
  Future<void> updateProfile(UserModel updatedUser) async {
    try {
      state = const AsyncValue.loading();
      // In a real app, you would make an API call to update the user
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, updatedUser.toJson().toString());
      
      state = AsyncValue.data(updatedUser);
      return;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }

  // Add a new address
  Future<void> addAddress(UserAddress address) async {
    try {
      final user = state.value;
      if (user == null) return;
      
      final updatedUser = user.copyWith(
        addresses: [...user.addresses, address],
      );
      
      await updateProfile(updatedUser);
    } catch (e) {
      rethrow;
    }
  }

  // Update an existing address
  Future<void> updateAddress(UserAddress address) async {
    try {
      final user = state.value;
      if (user == null) return;
      
      final updatedAddresses = user.addresses.map((addr) {
        return addr.id == address.id ? address : addr;
      }).toList();
      
      final updatedUser = user.copyWith(
        addresses: updatedAddresses,
      );
      
      await updateProfile(updatedUser);
    } catch (e) {
      rethrow;
    }
  }

  // Delete an address
  Future<void> deleteAddress(String addressId) async {
    try {
      final user = state.value;
      if (user == null) return;
      
      final updatedAddresses = user.addresses
          .where((addr) => addr.id != addressId)
          .toList();
      
      final updatedUser = user.copyWith(
        addresses: updatedAddresses,
      );
      
      await updateProfile(updatedUser);
    } catch (e) {
      rethrow;
    }
  }

  // Set default address
  Future<void> setDefaultAddress(String addressId) async {
    try {
      final user = state.value;
      if (user == null) return;
      
      final updatedAddresses = user.addresses.map((addr) {
        return addr.copyWith(
          isDefault: addr.id == addressId,
        );
      }).toList();
      
      final updatedUser = user.copyWith(
        addresses: updatedAddresses,
      );
      
      await updateProfile(updatedUser);
    } catch (e) {
      rethrow;
    }
  }

  // Clear user data (logout)
  Future<void> clearUser() async {
    try {
      state = const AsyncValue.loading();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }
}

// Provider
final userProvider = StateNotifierProvider<UserNotifier, AsyncValue<UserModel?>>(
  (ref) => UserNotifier(),
);

// Provider for the current user (simplified access)
final currentUserProvider = Provider<UserModel?>((ref) {
  final userState = ref.watch(userProvider);
  return userState.value;
});
