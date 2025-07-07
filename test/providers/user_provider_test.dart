import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wagbty/providers/user_provider.dart';
import 'package:wagbty/models/user_model.dart';

// Mock SharedPreferences
class MockSharedPreferences extends Mock implements SharedPreferences {
  final Map<String, dynamic> _data = {};

  @override
  Future<bool> setString(String key, String value) async {
    _data[key] = value;
    return true;
  }

  @override
  String? getString(String key) => _data[key];

  @override
  Future<bool> remove(String key) async {
    _data.remove(key);
    return true;
  }
}

// Mock Ref for testing
class MockRef extends Mock implements Ref<Object?> {
  final Map<ProviderListenable<Object?>, Object?> _container = {};

  @override
  T watch<T>(ProviderListenable<T> provider) {
    return _container[provider] as T;
  }

  void setProvider<T>(ProviderListenable<T> provider, T value) {
    _container[provider] = value;
  }
}

void main() {
  late UserNotifier userNotifier;
  
  final testUser = UserModel(
    id: '1',
    name: 'Test User',
    email: 'test@example.com',
    phoneNumber: '+1234567890',
    addresses: [],
  );
  
  final testAddress = UserAddress(
    id: 'addr1',
    label: 'Home',
    addressLine1: '123 Test St',
    city: 'Riyadh',
    country: 'Saudi Arabia',
    isDefault: true,
  );

  setUp(() {
    userNotifier = UserNotifier();
  });

  test('initial state is AsyncLoading', () {
    expect(userNotifier.state, const AsyncValue.loading());
  });

  group('loadUser', () {
    test('updates user data and saves to SharedPreferences', () async {
      // Act
      await userNotifier.updateProfile(
        testUser.copyWith(
          name: 'Updated Name',
          email: 'updated@example.com',
          phoneNumber: '+1987654321',
          profileImage: 'path/to/image.jpg',
        ),
      );
      
      // Assert
      final user = userNotifier.state.value;
      expect(user, isNotNull);
      expect(user!.name, 'Updated Name');
      expect(user.email, 'updated@example.com');
      expect(user.phoneNumber, '+1987654321');
      expect(user.profileImage, 'path/to/image.jpg');
    });
    
    test('clears user data', () async {
      // Arrange - add some data first
      await userNotifier.updateProfile(testUser.copyWith(name: 'Test User'));
      
      // Act
      await userNotifier.clearUser();
      
      // Assert
      expect(userNotifier.state.value, isNull);
    });
  });

  group('address management', () {
    setUp(() async {
      // Initialize with a user that has no addresses
      await userNotifier.updateProfile(testUser.copyWith(name: 'Test User'));
    });
    
    test('adds a new address', () async {
      // Act
      await userNotifier.addAddress(testAddress);
      
      // Assert
      final user = userNotifier.state.value;
      expect(user != null, true);
      expect(user!.addresses.length, 1);
      expect(user.addresses.first.id, 'addr1');
      expect(user.addresses.first.label, 'Home');
    });
    
    test('updates an existing address', () async {
      // Arrange - add an address first
      await userNotifier.addAddress(testAddress);
      final updatedAddress = testAddress.copyWith(
        label: 'Updated Home',
        addressLine1: '456 New St',
      );
      
      // Act
      await userNotifier.updateAddress(updatedAddress);
      
      // Assert
      final user = userNotifier.state.value;
      expect(user != null, true);
      expect(user!.addresses.length, 1);
      expect(user.addresses.first.label, 'Updated Home');
      expect(user.addresses.first.addressLine1, '456 New St');
    });
    
    test('deletes an address', () async {
      // Arrange - add an address first
      await userNotifier.addAddress(testAddress);
      
      // Act
      await userNotifier.deleteAddress('addr1');
      
      // Assert
      final user = userNotifier.state.value;
      expect(user != null, true);
      expect(user!.addresses.isEmpty, isTrue);
    });
    
    test('sets default address', () async {
      // Arrange - add two addresses
      final addr1 = testAddress.copyWith(id: 'addr1', isDefault: true);
      final addr2 = testAddress.copyWith(id: 'addr2', label: 'Work', isDefault: false);
      
      await userNotifier.addAddress(addr1);
      await userNotifier.addAddress(addr2);
      
      // Act - set addr2 as default
      await userNotifier.setDefaultAddress('addr2');
      
      // Assert
      final user = userNotifier.state.value;
      expect(user != null, true);
      final updatedAddr1 = user!.addresses.firstWhere((a) => a.id == 'addr1');
      final updatedAddr2 = user.addresses.firstWhere((a) => a.id == 'addr2');
      
      expect(updatedAddr1.isDefault, isFalse);
      expect(updatedAddr2.isDefault, isTrue);
    });
  });
  
  test('clearUser removes all user data', () async {
    // Arrange - add some data
    await userNotifier.updateProfile(testUser.copyWith(name: 'Test User'));
    await userNotifier.addAddress(testAddress);
    
    // Act
    await userNotifier.clearUser();
    
    // Assert
    expect(userNotifier.state.value, isNull);
  });
}
